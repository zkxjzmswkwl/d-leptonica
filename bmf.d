/*====================================================================*
 -  Copyright (C) 2001 Leptonica.  All rights reserved.
 -
 -  Redistribution and use in source and binary forms, with or without
 -  modification, are permitted provided that the following conditions
 -  are met:
 -  1. Redistributions of source code must retain the above copyright
 -     notice, this list of conditions and the following disclaimer.
 -  2. Redistributions in binary form must reproduce the above
 -     copyright notice, this list of conditions and the following
 -     disclaimer in the documentation and/or other materials
 -     provided with the distribution.
 -
 -  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 -  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 -  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 -  A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL ANY
 -  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 -  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 -  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 -  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 -  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 -  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 -  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *====================================================================*/

extern (C):

/*!
 * \file bmf.h
 *
 *     Simple data structure to hold bitmap fonts and related data
 */

/*! Constants for deciding when text block is divided into paragraphs */
/*! Split Text */
enum
{
    SPLIT_ON_LEADING_WHITE = 1, /*!< tab or space at beginning of line   */
    SPLIT_ON_BLANK_LINE = 2, /*!< newline with optional white space   */
    SPLIT_ON_BOTH = 3 /*!< leading white space or newline      */
}

/*! Data structure to hold bitmap fonts and related data */
struct L_Bmf
{
    struct Pixa;
    Pixa* pixa; /*!< pixa of bitmaps for 93 characters        */
    int size; /*!< font size (in points at 300 ppi)         */
    char* directory; /*!< directory containing font bitmaps        */
    int baseline1; /*!< baseline offset for ascii 33 - 57        */
    int baseline2; /*!< baseline offset for ascii 58 - 91        */
    int baseline3; /*!< baseline offset for ascii 93 - 126       */
    int lineheight; /*!< max height of line of chars              */
    int kernwidth; /*!< pixel dist between char bitmaps          */
    int spacewidth; /*!< pixel dist between word bitmaps          */
    int vertlinesep; /*!< extra vertical space between text lines  */
    int* fonttab; /*!< table mapping ascii --> font index       */
    int* baselinetab; /*!< table mapping ascii --> baseline offset  */
    int* widthtab; /*!< table mapping ascii --> char width       */
}

alias L_BMF = L_Bmf;

/* LEPTONICA_BMF_H */
