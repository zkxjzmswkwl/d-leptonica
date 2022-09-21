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
import array;
import pix;

extern (C):

/*!
 * \file jbclass.h
 *
 *       JbClasser
 *       JbData
 */

/*!
 * <pre>
 * The JbClasser struct holds all the data accumulated during the
 * classification process that can be used for a compressed
 * jbig2-type representation of a set of images.  This is created
 * in an initialization process and added to as the selected components
 * on each successive page are analyzed.
 * </pre>
 */
struct JbClasser
{
  struct Sarray;
  Sarray* safiles; /*!< input page image file names          */
  int method; /*!< JB_RANKHAUS, JB_CORRELATION          */
  int components; /*!< JB_CONN_COMPS, JB_CHARACTERS or      */
  /*!< JB_WORDS                             */
  int maxwidth; /*!< max component width allowed          */
  int maxheight; /*!< max component height allowed         */
  int npages; /*!< number of pages already processed    */
  int baseindex; /*!< number components already processed  */
  /*!< on fully processed pages             */
  struct Numa;
  Numa* nacomps; /*!< number of components on each page    */
  int sizehaus; /*!< size of square struct elem for haus  */
  float rankhaus; /*!< rank val of haus match, each way     */
  float thresh; /*!< thresh value for correlation score   */
  float weightfactor; /*!< corrects thresh value for heaver     */
  /*!< components; use 0 for no correction  */
  Numa* naarea; /*!< w * h of each template, without      */
  /*!< extra border pixels                  */
  int w; /*!< max width of original src images     */
  int h; /*!< max height of original src images    */
  int nclass; /*!< current number of classes            */
  int keep_pixaa; /*!< If zero, pixaa isn't filled          */
  struct Pixaa;
  Pixaa* pixaa; /*!< instances for each class; unbordered */
  struct Pixa;
  Pixa* pixat; /*!< templates for each class; bordered   */
  /*!< and not dilated                      */
  Pixa* pixatd; /*!< templates for each class; bordered   */
  /*!< and dilated                          */
  struct L_DnaHash;
  L_DnaHash* dahash; /*!< Hash table to find templates by size */
  Numa* nafgt; /*!< fg areas of undilated templates;     */
  /*!< only used for rank < 1.0             */
  struct Pta;
  Pta* ptac; /*!< centroids of all bordered cc         */
  Pta* ptact; /*!< centroids of all bordered template cc */
  Numa* naclass; /*!< array of class ids for each component */
  Numa* napage; /*!< array of page nums for each component */
  Pta* ptaul; /*!< array of UL corners at which the     */
  /*!< template is to be placed for each    */
  /*!< component                            */
  Pta* ptall; /*!< similar to ptaul, but for LL corners */
}

alias JBCLASSER = JbClasser;

/*!
 * <pre>
 * The JbData struct holds all the data required for
 * the compressed jbig-type representation of a set of images.
 * The data can be written to file, read back, and used
 * to regenerate an approximate version of the original,
 * which differs in two ways from the original:
 *   (1) It uses a template image for each c.c. instead of the
 *       original instance, for each occurrence on each page.
 *   (2) It discards components with either a height or width larger
 *       than the maximuma, given here by the lattice dimensions
 *       used for storing the templates.
 * </pre>
 */
struct JbData
{
  struct Pix;
  Pix* pix; /*!< template composite for all classes    */
  int npages; /*!< number of pages                       */
  int w; /*!< max width of original page images     */
  int h; /*!< max height of original page images    */
  int nclass; /*!< number of classes                     */
  int latticew; /*!< lattice width for template composite  */
  int latticeh; /*!< lattice height for template composite */
  Numa* naclass; /*!< array of class ids for each component */
  Numa* napage; /*!< array of page nums for each component */
  Pta* ptaul; /*!< array of UL corners at which the      */
  /*!< template is to be placed for each     */
  /*!< component                             */
}

alias JBDATA = JbData;

/*! JB Classifier */
enum
{
  JB_RANKHAUS = 0,
  JB_CORRELATION = 1
}

/*! For jbGetComponents(): type of component to extract from images */
/*! JB Component */
enum
{
  JB_CONN_COMPS = 0,
  JB_CHARACTERS = 1,
  JB_WORDS = 2
}

/*! These parameters are used for naming the two files
 * in which the jbig2-like compressed data is stored.  */
enum JB_TEMPLATE_EXT = ".templates.png";
enum JB_DATA_EXT = ".data";

/* LEPTONICA_JBCLASS_H */
