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
 * \file recog.h
 *
 * <pre>
 *     This is a simple utility for training and recognizing individual
 *     machine-printed text characters.  It is designed to be adapted
 *     to a particular set of character images; e.g., from a book.
 *
 *     There are two methods of training the recognizer.  In the most
 *     simple, a set of bitmaps has been labeled by some means, such
 *     a generic OCR program.  This is input either one template at a time
 *     or as a pixa of templates, to a function that creates a recog.
 *     If in a pixa, the text string label must be embedded in the
 *     text field of each pix.
 *
 *     If labeled data is not available, we start with a bootstrap
 *     recognizer (BSR) that has labeled data from a variety of sources.
 *     These images are scaled, typically to a fixed height, and then
 *     fed similarly scaled unlabeled images from the source (e.g., book),
 *     and the BSR attempts to identify them.  All images that have
 *     a high enough correlation score with one of the templates in the
 *     BSR are emitted in a pixa, which now holds unscaled and labeled
 *     templates from the source.  This is the generator for a book adapted
 *     recognizer (BAR).
 *
 *     The pixa should always be thought of as the primary structure.
 *     It is the generator for the recog, because a recog is built
 *     from a pixa of unscaled images.
 *
 *     New image templates can be added to a recog as long as it is
 *     in training mode.  Once training is finished, to add templates
 *     it is necessary to extract the generating pixa, add templates
 *     to that pixa, and make a new recog.  Similarly, we do not
 *     join two recog; instead, we simply join their generating pixa,
 *     and make a recog from that.
 *
 *     To remove outliers from a pixa of labeled pix, make a recog,
 *     determine the outliers, and generate a new pixa with the
 *     outliers removed.  The outliers are determined by building
 *     special templates for each character set that are scaled averages
 *     of the individual templates.  Then a correlation score is found
 *     between each template and the averaged templates.  There are
 *     two implementations; outliers are determined as either:
 *      (1) a template having a correlation score with its class average
 *          that is below a threshold, or
 *      (2) a template having a correlation score with its class average
 *          that is smaller than the correlation score with the average
 *          of another class.
 *     Outliers are removed from the generating pixa.  Scaled averaging
 *     is only performed for determining outliers and for splitting
 *     characters; it is never used in a trained recognizer for identifying
 *     unlabeled samples.
 *
 *     Two methods using averaged templates are provided for splitting
 *     touching characters:
 *      (1) greedy matching
 *      (2) document image decoding (DID)
 *     The DID method is the default.  It is about 5x faster and
 *     possibly more accurate.
 *
 *     Once a BAR has been made, unlabeled sample images are identified
 *     by finding the individual template in the BAR with highest
 *     correlation.  The input images and images in the BAR can be
 *     represented in two ways:
 *      (1) as scanned, binarized to 1 bpp
 *      (2) as a width-normalized outline formed by thinning to a
 *          skeleton and then dilating by a fixed amount.
 *
 *     The recog can be serialized to file and read back.  The serialized
 *     version holds the templates used for correlation (which may have
 *     been modified by scaling and turning into lines from the unscaled
 *     templates), plus, for arbitrary character sets, the UTF8
 *     representation and the lookup table mapping from the character
 *     representation to index.
 *
 *     Why do we not use averaged templates for recognition?
 *     Letterforms can take on significantly different shapes (eg.,
 *     the letters 'a' and 'g'), and it makes no sense to average these.
 *     The previous version of this utility allowed multiple recognizers
 *     to exist, but this is an unnecessary complication if recognition
 *     is done on all samples instead of on averages.
 * </pre>
 */

enum RECOG_VERSION_NUMBER = 2;

struct L_Recog
{
  int scalew; /*!< scale all examples to this width;      */
  /*!< use 0 prevent horizontal scaling       */
  int scaleh; /*!< scale all examples to this height;     */
  /*!< use 0 prevent vertical scaling         */
  int linew; /*!< use a value > 0 to convert the bitmap  */
  /*!< to lines of fixed width; 0 to skip     */
  int templ_use; /*!< template use: use either the average   */
  /*!< or all temmplates (L_USE_AVERAGE or    */
  /*!< L_USE_ALL)                             */
  int maxarraysize; /*!< initialize container arrays to this    */
  int setsize; /*!< size of character set                  */
  int threshold; /*!< for binarizing if depth > 1            */
  int maxyshift; /*!< vertical jiggle on nominal centroid    */
  /*!< alignment; typically 0 or 1            */
  int charset_type; /*!< one of L_ARABIC_NUMERALS, etc.         */
  int charset_size; /*!< expected number of classes in charset  */
  int min_nopad; /*!< min number of samples without padding  */
  int num_samples; /*!< number of training samples             */
  int minwidth_u; /*!< min width averaged unscaled templates  */
  int maxwidth_u; /*!< max width averaged unscaled templates  */
  int minheight_u; /*!< min height averaged unscaled templates */
  int maxheight_u; /*!< max height averaged unscaled templates */
  int minwidth; /*!< min width averaged scaled templates    */
  int maxwidth; /*!< max width averaged scaled templates    */
  int ave_done; /*!< set to 1 when averaged bitmaps are made */
  int train_done; /*!< set to 1 when training is complete or  */
  /*!< identification has started             */
  float max_wh_ratio; /*!< max width/height ratio to split        */
  float max_ht_ratio; /*!< max of max/min template height ratio   */
  int min_splitw; /*!< min component width kept in splitting  */
  int max_splith; /*!< max component height kept in splitting */
  struct Sarray;
  Sarray* sa_text; /*!< text array for arbitrary char set      */
  struct L_Dna;
  L_Dna* dna_tochar; /*!< index-to-char lut for arbitrary charset */
  int* centtab; /*!< table for finding centroids            */
  int* sumtab; /*!< table for finding pixel sums           */
  struct Pixaa;
  Pixaa* pixaa_u; /*!< all unscaled templates for each class  */
  struct Ptaa;
  Ptaa* ptaa_u; /*!< centroids of all unscaled templates    */
  struct Numaa;
  Numaa* naasum_u; /*!< area of all unscaled templates         */
  Pixaa* pixaa; /*!< all (scaled) templates for each class  */
  Ptaa* ptaa; /*!< centroids of all (scaledl) templates   */
  Numaa* naasum; /*!< area of all (scaled) templates         */
  struct Pixa;
  Pixa* pixa_u; /*!< averaged unscaled templates per class  */
  struct Pta;
  Pta* pta_u; /*!< centroids of unscaled ave. templates   */
  struct Numa;
  Numa* nasum_u; /*!< area of unscaled averaged templates    */
  Pixa* pixa; /*!< averaged (scaled) templates per class  */
  Pta* pta; /*!< centroids of (scaled) ave. templates   */
  Numa* nasum; /*!< area of (scaled) averaged templates    */
  Pixa* pixa_tr; /*!< all input training images              */
  Pixa* pixadb_ave; /*!< unscaled and scaled averaged bitmaps   */
  Pixa* pixa_id; /*!< input images for identifying           */
  struct Pix;
  Pix* pixdb_ave; /*!< debug: best match of input against ave. */
  Pix* pixdb_range; /*!< debug: best matches within range       */
  Pixa* pixadb_boot; /*!< debug: bootstrap training results      */
  Pixa* pixadb_split; /*!< debug: splitting results               */
  struct L_Bmf;
  L_Bmf* bmf; /*!< bmf fonts                              */
  int bmf_size; /*!< font size of bmf; default is 6 pt      */
  L_Rdid* did; /*!< temp data used for image decoding      */
  L_Rch* rch; /*!< temp data used for holding best char   */
  L_Rcha* rcha; /*!< temp data used for array of best chars */
}

alias L_RECOG = L_Recog;

/*!
 *  Data returned from correlation matching on a single character
 */
struct L_Rch
{
  int index; /*!< index of best template                   */
  float score; /*!< correlation score of best template       */
  char* text; /*!< character string of best template        */
  int sample; /*!< index of best sample (within the best    */
  /*!< template class, if all samples are used) */
  int xloc; /*!< x-location of template (delx + shiftx)   */
  int yloc; /*!< y-location of template (dely + shifty)   */
  int width; /*!< width of best template                   */
}

alias L_RCH = L_Rch;

/*!
 *  Data returned from correlation matching on an array of characters
 */
struct L_Rcha
{
  Numa* naindex; /*!< indices of best templates                */
  Numa* nascore; /*!< correlation scores of best templates     */
  Sarray* satext; /*!< character strings of best templates      */
  Numa* nasample; /*!< indices of best samples                  */
  Numa* naxloc; /*!< x-locations of templates (delx + shiftx) */
  Numa* nayloc; /*!< y-locations of templates (dely + shifty) */
  Numa* nawidth; /*!< widths of best templates                 */
}

alias L_RCHA = L_Rcha;

/*!
 *  Data used for decoding a line of characters.
 */
struct L_Rdid
{
  Pix* pixs; /*!< clone of pix to be decoded             */
  int** counta; /*!< count array for each averaged template */
  int** delya; /*!< best y-shift array per average template */
  int narray; /*!< number of averaged templates           */
  int size; /*!< size of count array (width of pixs)    */
  int* setwidth; /*!< setwidths for each template            */
  Numa* nasum; /*!< pixel count in pixs by column          */
  Numa* namoment; /*!< first moment of pixels in pixs by cols */
  int fullarrays; /*!< 1 if full arrays are made; 0 otherwise */
  float* beta; /*!< channel coeffs for template fg term    */
  float* gamma; /*!< channel coeffs for bit-and term        */
  float* trellisscore; /*!< score on trellis                       */
  int* trellistempl; /*!< template on trellis (for backtrack)    */
  Numa* natempl; /*!< indices of best path templates         */
  Numa* naxloc; /*!< x locations of best path templates     */
  Numa* nadely; /*!< y locations of best path templates     */
  Numa* nawidth; /*!< widths of best path templates          */
  struct Boxa;
  Boxa* boxa; /*!< Viterbi result for splitting input pixs */
  Numa* nascore; /*!< correlation scores: best path templates */
  Numa* natempl_r; /*!< indices of best rescored templates     */
  Numa* nasample_r; /*!< samples of best scored templates       */
  Numa* naxloc_r; /*!< x locations of best rescoredtemplates  */
  Numa* nadely_r; /*!< y locations of best rescoredtemplates  */
  Numa* nawidth_r; /*!< widths of best rescoredtemplates       */
  Numa* nascore_r; /*!< correlation scores: rescored templates */
}

alias L_RDID = L_Rdid;

/*-------------------------------------------------------------------------*
 *             Flags for describing limited character sets                 *
 *-------------------------------------------------------------------------*/
/*! Character Set */
enum
{
  L_UNKNOWN = 0, /*!< character set type is not specified      */
  L_ARABIC_NUMERALS = 1, /*!< 10 digits                                */
  L_LC_ROMAN_NUMERALS = 2, /*!< 7 lower-case letters (i,v,x,l,c,d,m)     */
  L_UC_ROMAN_NUMERALS = 3, /*!< 7 upper-case letters (I,V,X,L,C,D,M)     */
  L_LC_ALPHA = 4, /*!< 26 lower-case letters                    */
  L_UC_ALPHA = 5 /*!< 26 upper-case letters                    */
}

/*-------------------------------------------------------------------------*
 *      Flags for selecting between using average and all templates:       *
 *                           recog->templ_use                              *
 *-------------------------------------------------------------------------*/
/*! Template Select */
enum
{
  L_USE_ALL_TEMPLATES = 0, /*!< use all templates; default            */
  L_USE_AVERAGE_TEMPLATES = 1 /*!< use average templates; special cases  */
}

/* LEPTONICA_RECOG_H */
