#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "funcs.h"
#include <math.h>
#include <time.h>

#define PI2 6.2832

void dofilt(ImageF * in_re, ImageF * in_im,ImageF * mask, ImageF * out_re, ImageF * out_im) {
    int i,j;
             
  
  #pragma omp for
    for (i=0; i<out_re->rows; i++) {
        for(j=0; j<out_re->cols; j++) {

            out_re->data[i*out_re->cols+j]= in_re->data[i*in_re->cols+j] * mask->data[i*mask->cols+j]; //multiplica parte real por mask data
            out_im->data[i*out_im->cols+j]= in_im->data[i*in_im->cols+j] * mask->data[i*mask->cols+j]; //multiplica parte imaginaria por mask data
            //parte dentro de data[*] foi a lógica usada pelo professor em baixo
        }
    }
    }


ImageF * genlpfmask(int rows,int cols) {
    ImageF * filter;
    int i,j;

    /* allocating image*/
    filter=(ImageF*)malloc(sizeof(ImageF));
    filter->cols= cols;
    filter->rows=rows;
    filter->widthStep=cols*sizeof(double);

    filter->data=(double *)malloc(filter->rows*filter->cols*sizeof(double));


    // i= rows, linhas  j= colunas
    int Cesq=cols/4;
    int Cdir=3*cols/4;
    int Lcima= rows/4;
    int Lbaixo= 3*rows/4;

    for (i=0; i<rows; i++) {
        for(j=0; j<cols; j++) {
             if( (i<Lcima && j<Cesq) || (i<Lcima &&  j>Cdir) ||(i>Lbaixo && j<Cesq) || (i>Lbaixo  && j>Cdir)) {
                filter->data[i*filter->cols+j]= 1;
            }
            else {
                filter->data[i*filter->cols+j]=0;
            }
        }
    }


    return filter;
}

void fti (ImageF * in_re, ImageF * in_img, ImageF * out_re, ImageF * out_img, int inverse) {
  int m, n;
  int M = in_re->rows;
  int N = in_re->cols;

  int k, l;
  int K = out_re->rows;
  int L = out_re->cols;

  double arg;
  if (inverse == 0) {
    arg = -PI2;
  }
  else {
    arg = PI2;
  }

  ImageF * aux_re;
  ImageF * aux_img;

  aux_re=(ImageF*)malloc(sizeof(ImageF));
  aux_re->cols= L;
  aux_re->rows= K;
  aux_re->data=(double *)malloc(K*L*sizeof(double));
  aux_re->widthStep= L * sizeof(double);

  aux_img=(ImageF*)malloc(sizeof(ImageF));
  aux_img->cols= L;
  aux_img->rows= K;
  aux_img->data=(double *)malloc(K*L*sizeof(double));
  aux_img->widthStep= L*sizeof(double);

  // Calcular a FFT por linhas
  // m = linha actual
  // l = elemento a calcular
  // n = iteração
 
  for (m = 0; m < M; m++) {
    for (l = 0; l < L; l++) {
		aux_re->data [m*L+l] = 0.0;
		aux_img->data [m*L+l] = 0.0;
      for (n = 0; n < N; n++) {
        aux_re->data[m*L+l] += in_re->data[m*L+n] * cos(arg * l * n/ N) - in_img->data[m*L+n] * sin(arg * l * n/ N);
        aux_img->data[m*L+l] += in_img->data[m*L+n] * cos(arg * l * n/ N) + in_re->data[m*L+n] * sin(arg * l * n/ N);
      }
    }
}
  
  // FAZER A TRANSPOSTA
  ImageF * trans_re;
  ImageF * trans_img;

  trans_re=(ImageF*)malloc(sizeof(ImageF));
  trans_re->cols= K;
  trans_re->rows= L;
  trans_re->data=(double *)malloc(K*L*sizeof(double));
  trans_re->widthStep= K * sizeof(double);

  trans_img=(ImageF*)malloc(sizeof(ImageF));
  trans_img->cols= K;
  trans_img->rows= L;
  trans_img->data=(double *)malloc(K*L*sizeof(double));
  trans_img->widthStep= K*sizeof(double);

  ImageF * aux_trans_re;
  ImageF * aux_trans_img;

  aux_trans_re=(ImageF*)malloc(sizeof(ImageF));
  aux_trans_re->cols= K;
  aux_trans_re->rows= L;
  aux_trans_re->data=(double *)malloc(K*L*sizeof(double));
  aux_trans_re->widthStep= K * sizeof(double);

  aux_trans_img=(ImageF*)malloc(sizeof(ImageF));
  aux_trans_img->cols= K;
  aux_trans_img->rows= L;
  aux_trans_img->data=(double *)malloc(K*L*sizeof(double));
  aux_trans_img->widthStep= K*sizeof(double);

for (int i=0; i<aux_re->rows; i++) {
        for(int j=0; j<aux_re->cols; j++) {
        trans_re->data[j*trans_re->cols+i]= aux_re->data[i*aux_re->cols+j];
        trans_img->data[j*trans_img->cols+i]= aux_img->data[i*aux_img->cols+j];
        }
    }

 M = trans_re->rows;
 N = trans_re->cols;
 L = trans_re->cols;

for (m = 0; m < M; m++) {
   for (l = 0; l < L; l++) {
		aux_trans_re->data [m*L+l] = 0.0;
		aux_trans_img->data [m*L+l] = 0.0;
	  for (n = 0; n < N; n++) {
        aux_trans_re->data[m*L+l] += trans_re->data[m*L+n] * cos(arg * l * n/ N) - trans_img->data[m*L+n] * sin(arg * l * n/ N);
        aux_trans_img->data[m*L+l] += trans_img->data[m*L+n] * cos(arg * l * n/ N) + trans_re->data[m*L+n] * sin(arg * l * n/ N);
      }
    }
}



// transposta novamente para voltar ao sitio
for (int i=0; i<aux_trans_re->rows; i++) {
        for(int j=0; j<aux_trans_re->cols; j++) {
        out_re->data[j*out_re->cols+i]= aux_trans_re->data[i*aux_trans_re->cols+j];
        out_img->data[j*out_img->cols+i]= aux_trans_img->data[i*aux_trans_img->cols+j];
        }
    }

  free(aux_trans_re);
  free(aux_trans_img);

  free(aux_re);
	free(aux_img);
  
	free(trans_re);
	free(trans_img);
}

int main(int argc, char**argv){
	clock_t begin = clock();
    char fnamein[255];
    char fnameout[255];

    Image * imgin=NULL;
    Image * imgout=NULL;
    ImageF *imginf=NULL;
    ImageF * imgoutf=NULL;

    if (argc!=3){
        printf("Uso: %s <imagem_in.bmp> <imagem_flt.bmp>\n",argv[0]);
        exit(1);
    }

    strcpy(fnamein,argv[1]);
    strcpy(fnameout,argv[2]);
    imgin=loadPBM(fnamein);
    imgout=(Image *)malloc(sizeof(Image));
    imgout->rows=imgin->rows;
    imgout->cols=imgin->cols;
    imgout->widthStep=imgin->widthStep;
    imgout->data=(unsigned char*)malloc(imgout->rows*imgout->cols);

    imginf=(ImageF*)malloc(sizeof(ImageF));
    imginf->rows=imgin->rows;
    imginf->cols=imgin->cols;
    imginf->widthStep=imginf->cols*sizeof(double);
    imginf->data=(double *)malloc(imginf->rows*imginf->cols*sizeof(double));

    imgoutf=(ImageF*)malloc(sizeof(ImageF));
    imgoutf->rows=imgin->rows;
    imgoutf->cols=imgin->cols;
    imgoutf->widthStep=imgoutf->cols*sizeof(double);
    imgoutf->data=(double *)malloc(imgoutf->rows*imgoutf->cols*sizeof(double));

    int i,j;

    // copiar imagem para uma nova em formato double
    for (i=0;i<imgin->rows;i++){
        for(j=0;j<imgin->cols;j++)
            imginf->data[i*imginf->cols+j]=imgin->data[i*imgin->cols+j];
    }

    /** processamento **/
    ImageF 	*in_re 		= (ImageF *)malloc(sizeof(ImageF)),
	   		*in_img 	= (ImageF *)malloc(sizeof(ImageF)),
	   		*out_re 	= (ImageF *)malloc(sizeof(ImageF)),
	   		*out_img 	= (ImageF *)malloc(sizeof(ImageF));

    // in_re
    in_re->rows = imgin->rows;
    in_re->cols = imgin->cols;
    in_re->widthStep = in_re->cols * sizeof(double);
    in_re->data = (double *)malloc(in_re->rows * in_re->cols * sizeof(double));

    // in_img
    in_img->rows = imgin->rows;
    in_img->cols = imgin->cols;
    in_img->widthStep = in_img->cols * sizeof(double);
    in_img->data = (double *)malloc(in_img->rows * in_img->cols * sizeof(double));

    // out_re
    out_re->rows = imgout->rows;
    out_re->cols = imgout->cols;
    out_re->widthStep = out_re->cols * sizeof(double);
    out_re->data = (double *)malloc(out_re->rows * out_re->cols * sizeof(double));

    // out_img
    out_img->rows = imgout->rows;
    out_img->cols = imgout->cols;
    out_img->widthStep = out_img->cols * sizeof(double);
    out_img->data = (double *)malloc(out_img->rows * out_img->cols * sizeof(double));

    for (i = 0; i < in_re->rows; i++)
    {
		for (j = 0; j < in_re->cols; j++)
		{
			in_re->data[i * in_re->cols + j] = imginf->data[i * imginf->cols + j];
			in_img->data[i * in_re->cols + j] = 0.0;
		}
    }

    /** cria mascara **/
    // imgoutf = genlpfmask(in_re->rows, in_re->cols);

    ImageF *mask = genlpfmask(in_re->rows, in_re->cols);
    /** calcula dft da imagem */
    fti(in_re, in_img, out_re, out_img, 0);
    /** multiplica pela mascara */
    dofilt(out_re, out_img, mask, out_re, out_img);
    /** calcula dft inversa da imagem filtrada */
    fti(out_re, out_img, in_re, in_img, 1);
    /** copia para imagem de saida imgout */

	  for (i = 0; i < in_re->rows; i++) {
		    for (j = 0; j < in_re->cols; j++) {
			       imgoutf->data[i*imgout->cols+j] = in_re->data[i * in_re->cols + j]/(in_re->cols*in_re->rows);
        }
    }

    /** A seguir é apenas um exemplo que deve ser retirado e substituido pela chamadas às funções a escrever */
    /* Só para testar. Comentar quando incluir o seu código*/
    //teste(imginf, imgoutf);
					//converte de imgoutf para imgout (imagef para image)
              


    for (i=0;i<imgoutf->rows;i++){
        for(j=0;j<imgoutf->cols;j++){
           double val;
            val=imgoutf->data[i*imgoutf->cols+j];

            if (val<0)
                val=0.0;
            else if (val>255)
                val=255.0;
            imgout->data[i*imgout->cols+j] = (unsigned char)val;
        }
    }

    savePBM(fnameout,imgout);
    clock_t end = clock();
    double gasto = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("Tempo Gasto na execução do programa: %lf\n", gasto);
    
    
    return 0;
    }
