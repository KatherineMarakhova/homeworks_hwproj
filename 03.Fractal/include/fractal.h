#ifndef _FRACTAL_H_
#define _FRACTAL_H_

#include "image.h"

/**
 * @brief Draws empty fractal, assuming image is clean
 *
 * @param picture 
 */

typedef enum {
  SIERPINSKI_CARPET,
  MANDELBROT_SET,
} fractal_type;

void fractal(image_p picture, fractal_type type);

#endif // _FRACTAL_H_
