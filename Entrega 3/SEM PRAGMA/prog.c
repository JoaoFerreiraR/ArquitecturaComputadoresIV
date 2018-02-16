#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "funcs.h"
#include <math.h>

#define PI2 6.28




void dofilt(ImageF * in_re, ImageF * out_re,ImageF * in_im, ImageF * out_im, ImageF * mask) {
    int i,j;

    for (i=0; i<out_re->rows; i++) {
        for(j=0; j<out_re->cols; j++) {

            out_re->data[i*out_re->cols+j]= in_re->data[i*in_re->cols+j] * mask->data[i*mask->cols+j]; //multiplica parte real por mask data
            out_im->data[i*out_im->cols+j]= in_im->data[i*in_im->cols+j] * mask->data[i*mask->cols+j]; //multiplica parte imaginaria por mask data
            //parte dentro de data[*] foi a lógica usada pelo professor em baixo
        }
    }
    }


Image * imageFtoImage( ImageF * F) {

    Image * image;
    int i, j;
    image= NULL;
    image->rows = F->rows;
    image->cols = F->cols;
    image->widthStep = F->rows * F->cols;
    image->data=(unsigned char*)malloc(image->rows*image->cols);

  
    for (i=0; i<F->rows; i++) {
        for(j=0; j<F->cols; j++) {
            double val;
            val=F->data[i*F->cols+j];

            if (val<0)
                val=0.0;
            else if (val>255)
                val=255.0;
            image->data[i*image->cols+j]=(unsigned char)val;
        }
    }
    
    return image;
       
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
             if( (i<Lcima && j<Cesq) || (i<Lcima &&  j>Cdir) ||(i<Lbaixo && j<Cesq) || (i<Lbaixo  && j>Cdir)) {
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
  double arg;
  if (inverse == 0) {
    arg = -PI2;
  }
  else {
    arg = PI2;
  }

  int i,k,n,j;
  ImageF * aux_re;
  ImageF * aux_img;

  aux_re=(ImageF*)malloc(sizeof(ImageF));
  aux_re->cols= in_re->cols;
  aux_re->rows= in_re->rows;
  aux_re->widthStep= in_re->cols*sizeof(double);
  aux_re->data=(double *)malloc(in_re->rows*in_re->cols*sizeof(double));

  aux_img=(ImageF*)malloc(sizeof(ImageF));
  aux_img->cols= in_re->cols;
  aux_img->rows= in_re->rows;
  aux_img->widthStep= in_re->cols*sizeof(double);
  aux_img->data=(double *)malloc(in_re->rows*in_re->cols*sizeof(double));



  /* Calcular a FFT por linhas */
  for (i = 0; i <= in_re->rows; i++) {
    for (k = 0; k < in_re->cols; k++) {
      aux_re->data [i*in_re->cols] = 0.0;
      aux_img->data [i*in_re->cols] = 0.0;

      for(n = 0; n < in_re->cols; n++) {
        aux_re->data [i*in_re->cols+k] += in_re->data [i*in_re->cols+n] * cos (n * k * arg / in_re->cols);
        aux_img->data [i*in_re->cols+k] -= in_img->data [i*in_re->cols+n] * sin (n * k * arg / in_re->cols);
      }
    }
  }

  /* Calcular a FFT por colunas */
  for (i = 0; i <= in_re->cols; i++) {
	     
    for (k = 0; k < in_re->rows; k++) {
      out_re->data [i*in_re->rows] = 0.0;
      out_img->data [i*in_re->rows] = 0.0;
      for(n = 0; n < in_re->cols; n++) {
        out_re->data [i*in_re->cols+k] += aux_re->data [i*in_re->cols+n] * cos (n * k * arg / in_re->cols);
        out_img->data [i*in_re->cols+k] += aux_img->data [i*in_re->cols+n] * cos (n * k * arg / in_re->cols);
      }
    }
  }

  /* multiplicar! */
  for (i=0; i<out_re->rows; i++) {
	        
      for(j=0; j<out_re->cols; j++) {
          out_re->data[i*out_re->cols+j]= in_re->data[i*in_re->cols+j] * out_re->data[i*in_re->cols+j]; //multiplica parte real por mask data
          out_img->data[i*out_img->cols+j]= in_img->data[i*in_img->cols+j] * out_img->data[i*in_img->cols+j]; //multiplica parte imaginaria por mask data
          //parte dentro de data[*] foi a lógica usada pelo professor em baixo
      }
  }
  
  
  for (i=0; i<out_re->rows; i++) {
	        
      for(j=0; j<out_re->cols; j++) {
		  printf( "Valores : %lf \n  ", out_img->data[i*out_img->cols+j]);
		  
	  }}
}



int main(int argc, char**argv){
    
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
    ImageF *mask = genlpfmask(in_re->rows, in_re->cols);
	printf("1\n");
    /** calcula dft da imagem */
    fti(in_re, in_img, out_re, out_img, 0);
	printf("2\n");
    /** multiplica pela mascara */
    dofilt(out_re, out_img, mask, out_re, out_img);
printf("3\n");
    /** calcula dft inversa da imagem filtrada */
    fti(out_re, out_img, in_re, in_img, 1);
printf("4\n");
    /** copia para imagem de saida imgout */
	for (i = 0; i < in_re->rows; i++)
    {
		for (j = 0; j < in_re->cols; j++)
		{
			imgout->data[i * imgout->cols + j] = in_re->data[i * in_re->cols + j];
		}
    }
    printf("5\n");
    /** A seguir é apenas um exemplo que deve ser retirado e substituido pela chamadas às funções a escrever */
    /* Só para testar. Comentar quando incluir o seu código*/
    //teste(imginf, imgoutf);

    for (i=0;i<imgoutf->rows;i++){
        for(j=0;j<imgoutf->cols;j++){
           double val;
            val=imgoutf->data[i*imgoutf->cols+j];
            
            if (val<0)
                val=0.0;
            else if (val>255)
                val=255.0;
            imgout->data[i*imgout->cols+j]=(unsigned char)val;
            
        }
    }
    savePBM(fnameout,imgout);
    return 0;
    }

