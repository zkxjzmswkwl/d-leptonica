// SPDX-License-Identifier: Apache-2.0
// File:        capi.h
// Description: C-API TessBaseAPI
//
// (C) Copyright 2012, Google Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import core.stdc.stdio;

extern (C):

alias BOOL = int;
enum TRUE = 1;
enum FALSE = 0;

struct TessResultRenderer;
struct TessBaseAPI;
struct TessPageIterator;
struct TessResultIterator;
struct TessMutableIterator;
struct TessChoiceIterator;

enum TessOcrEngineMode
{
  OEM_TESSERACT_ONLY = 0,
  OEM_LSTM_ONLY = 1,
  OEM_TESSERACT_LSTM_COMBINED = 2,
  OEM_DEFAULT = 3
}

enum TessPageSegMode
{
  PSM_OSD_ONLY = 0,
  PSM_AUTO_OSD = 1,
  PSM_AUTO_ONLY = 2,
  PSM_AUTO = 3,
  PSM_SINGLE_COLUMN = 4,
  PSM_SINGLE_BLOCK_VERT_TEXT = 5,
  PSM_SINGLE_BLOCK = 6,
  PSM_SINGLE_LINE = 7,
  PSM_SINGLE_WORD = 8,
  PSM_CIRCLE_WORD = 9,
  PSM_SINGLE_CHAR = 10,
  PSM_SPARSE_TEXT = 11,
  PSM_SPARSE_TEXT_OSD = 12,
  PSM_RAW_LINE = 13,
  PSM_COUNT = 14
}

enum TessPageIteratorLevel
{
  RIL_BLOCK = 0,
  RIL_PARA = 1,
  RIL_TEXTLINE = 2,
  RIL_WORD = 3,
  RIL_SYMBOL = 4
}

enum TessPolyBlockType
{
  PT_UNKNOWN = 0,
  PT_FLOWING_TEXT = 1,
  PT_HEADING_TEXT = 2,
  PT_PULLOUT_TEXT = 3,
  PT_EQUATION = 4,
  PT_INLINE_EQUATION = 5,
  PT_TABLE = 6,
  PT_VERTICAL_TEXT = 7,
  PT_CAPTION_TEXT = 8,
  PT_FLOWING_IMAGE = 9,
  PT_HEADING_IMAGE = 10,
  PT_PULLOUT_IMAGE = 11,
  PT_HORZ_LINE = 12,
  PT_VERT_LINE = 13,
  PT_NOISE = 14,
  PT_COUNT = 15
}

enum TessOrientation
{
  ORIENTATION_PAGE_UP = 0,
  ORIENTATION_PAGE_RIGHT = 1,
  ORIENTATION_PAGE_DOWN = 2,
  ORIENTATION_PAGE_LEFT = 3
}

enum TessParagraphJustification
{
  JUSTIFICATION_UNKNOWN = 0,
  JUSTIFICATION_LEFT = 1,
  JUSTIFICATION_CENTER = 2,
  JUSTIFICATION_RIGHT = 3
}

enum TessWritingDirection
{
  WRITING_DIRECTION_LEFT_TO_RIGHT = 0,
  WRITING_DIRECTION_RIGHT_TO_LEFT = 1,
  WRITING_DIRECTION_TOP_TO_BOTTOM = 2
}

enum TessTextlineOrder
{
  TEXTLINE_ORDER_LEFT_TO_RIGHT = 0,
  TEXTLINE_ORDER_RIGHT_TO_LEFT = 1,
  TEXTLINE_ORDER_TOP_TO_BOTTOM = 2
}

struct ETEXT_DESC;

alias TessCancelFunc = bool function(void* cancel_this, int words);
alias TessProgressFunc = bool function(
  ETEXT_DESC* ths,
  int left,
  int right,
  int top,
  int bottom);

struct Pix;
struct Boxa;
struct Pixa;

/* General free functions */

const(char)* TessVersion();
void TessDeleteText(const(char)* text);
void TessDeleteTextArray(char** arr);
void TessDeleteIntArray(const(int)* arr);

/* Renderer API */
TessResultRenderer* TessTextRendererCreate(const(char)* outputbase);
TessResultRenderer* TessHOcrRendererCreate(const(char)* outputbase);
TessResultRenderer* TessHOcrRendererCreate2(
  const(char)* outputbase,
  int font_info);
TessResultRenderer* TessAltoRendererCreate(const(char)* outputbase);
TessResultRenderer* TessTsvRendererCreate(const(char)* outputbase);
TessResultRenderer* TessPDFRendererCreate(
  const(char)* outputbase,
  const(char)* datadir,
  int textonly);
TessResultRenderer* TessUnlvRendererCreate(const(char)* outputbase);
TessResultRenderer* TessBoxTextRendererCreate(const(char)* outputbase);
TessResultRenderer* TessLSTMBoxRendererCreate(const(char)* outputbase);
TessResultRenderer* TessWordStrBoxRendererCreate(const(char)* outputbase);

void TessDeleteResultRenderer(TessResultRenderer* renderer);
void TessResultRendererInsert(
  TessResultRenderer* renderer,
  TessResultRenderer* next);
TessResultRenderer* TessResultRendererNext(TessResultRenderer* renderer);
int TessResultRendererBeginDocument(
  TessResultRenderer* renderer,
  const(char)* title);
int TessResultRendererAddImage(TessResultRenderer* renderer, TessBaseAPI* api);
int TessResultRendererEndDocument(TessResultRenderer* renderer);

const(char)* TessResultRendererExtention(TessResultRenderer* renderer);
const(char)* TessResultRendererTitle(TessResultRenderer* renderer);
int TessResultRendererImageNum(TessResultRenderer* renderer);

/* Base API */

TessBaseAPI* TessBaseAPICreate();
void TessBaseAPIDelete(TessBaseAPI* handle);

size_t TessBaseAPIGetOpenCLDevice(TessBaseAPI* handle, void** device);

void TessBaseAPISetInputName(TessBaseAPI* handle, const(char)* name);
const(char)* TessBaseAPIGetInputName(TessBaseAPI* handle);

void TessBaseAPISetInputImage(TessBaseAPI* handle, Pix* pix);
Pix* TessBaseAPIGetInputImage(TessBaseAPI* handle);

int TessBaseAPIGetSourceYResolution(TessBaseAPI* handle);
const(char)* TessBaseAPIGetDatapath(TessBaseAPI* handle);

void TessBaseAPISetOutputName(TessBaseAPI* handle, const(char)* name);

int TessBaseAPISetVariable(
  TessBaseAPI* handle,
  const(char)* name,
  const(char)* value);
int TessBaseAPISetDebugVariable(
  TessBaseAPI* handle,
  const(char)* name,
  const(char)* value);

int TessBaseAPIGetIntVariable(
  const(TessBaseAPI)* handle,
  const(char)* name,
  int* value);
int TessBaseAPIGetBoolVariable(
  const(TessBaseAPI)* handle,
  const(char)* name,
  int* value);
int TessBaseAPIGetDoubleVariable(
  const(TessBaseAPI)* handle,
  const(char)* name,
  double* value);
const(char)* TessBaseAPIGetStringVariable(
  const(TessBaseAPI)* handle,
  const(char)* name);

void TessBaseAPIPrintVariables(const(TessBaseAPI)* handle, FILE* fp);
int TessBaseAPIPrintVariablesToFile(
  const(TessBaseAPI)* handle,
  const(char)* filename);

int TessBaseAPIInit1(
  TessBaseAPI* handle,
  const(char)* datapath,
  const(char)* language,
  TessOcrEngineMode oem,
  char** configs,
  int configs_size);
int TessBaseAPIInit2(
  TessBaseAPI* handle,
  const(char)* datapath,
  const(char)* language,
  TessOcrEngineMode oem);
int TessBaseAPIInit3(
  TessBaseAPI* handle,
  const(char)* datapath,
  const(char)* language);

int TessBaseAPIInit4(
  TessBaseAPI* handle,
  const(char)* datapath,
  const(char)* language,
  TessOcrEngineMode mode,
  char** configs,
  int configs_size,
  char** vars_vec,
  char** vars_values,
  size_t vars_vec_size,
  int set_only_non_debug_params);

int TessBaseAPIInit5(
  TessBaseAPI* handle,
  const(char)* data,
  int data_size,
  const(char)* language,
  TessOcrEngineMode mode,
  char** configs,
  int configs_size,
  char** vars_vec,
  char** vars_values,
  size_t vars_vec_size,
  int set_only_non_debug_params);

const(char)* TessBaseAPIGetInitLanguagesAsString(const(TessBaseAPI)* handle);
char** TessBaseAPIGetLoadedLanguagesAsVector(const(TessBaseAPI)* handle);
char** TessBaseAPIGetAvailableLanguagesAsVector(const(TessBaseAPI)* handle);

void TessBaseAPIInitForAnalysePage(TessBaseAPI* handle);

void TessBaseAPIReadConfigFile(TessBaseAPI* handle, const(char)* filename);
void TessBaseAPIReadDebugConfigFile(
  TessBaseAPI* handle,
  const(char)* filename);

void TessBaseAPISetPageSegMode(TessBaseAPI* handle, TessPageSegMode mode);
TessPageSegMode TessBaseAPIGetPageSegMode(const(TessBaseAPI)* handle);

char* TessBaseAPIRect(
  TessBaseAPI* handle,
  const(ubyte)* imagedata,
  int bytes_per_pixel,
  int bytes_per_line,
  int left,
  int top,
  int width,
  int height);

void TessBaseAPIClearAdaptiveClassifier(TessBaseAPI* handle);

void TessBaseAPISetImage(
  TessBaseAPI* handle,
  const(ubyte)* imagedata,
  int width,
  int height,
  int bytes_per_pixel,
  int bytes_per_line);
void TessBaseAPISetImage2(TessBaseAPI* handle, Pix* pix);

void TessBaseAPISetSourceResolution(TessBaseAPI* handle, int ppi);

void TessBaseAPISetRectangle(
  TessBaseAPI* handle,
  int left,
  int top,
  int width,
  int height);

Pix* TessBaseAPIGetThresholdedImage(TessBaseAPI* handle);
Boxa* TessBaseAPIGetRegions(TessBaseAPI* handle, Pixa** pixa);
Boxa* TessBaseAPIGetTextlines(
  TessBaseAPI* handle,
  Pixa** pixa,
  int** blockids);
Boxa* TessBaseAPIGetTextlines1(
  TessBaseAPI* handle,
  int raw_image,
  int raw_padding,
  Pixa** pixa,
  int** blockids,
  int** paraids);
Boxa* TessBaseAPIGetStrips(TessBaseAPI* handle, Pixa** pixa, int** blockids);
Boxa* TessBaseAPIGetWords(TessBaseAPI* handle, Pixa** pixa);
Boxa* TessBaseAPIGetConnectedComponents(TessBaseAPI* handle, Pixa** cc);
Boxa* TessBaseAPIGetComponentImages(
  TessBaseAPI* handle,
  TessPageIteratorLevel level,
  int text_only,
  Pixa** pixa,
  int** blockids);
Boxa* TessBaseAPIGetComponentImages1(
  TessBaseAPI* handle,
  TessPageIteratorLevel level,
  int text_only,
  int raw_image,
  int raw_padding,
  Pixa** pixa,
  int** blockids,
  int** paraids);

int TessBaseAPIGetThresholdedImageScaleFactor(const(TessBaseAPI)* handle);

TessPageIterator* TessBaseAPIAnalyseLayout(TessBaseAPI* handle);

int TessBaseAPIRecognize(TessBaseAPI* handle, ETEXT_DESC* monitor);

int TessBaseAPIProcessPages(
  TessBaseAPI* handle,
  const(char)* filename,
  const(char)* retry_config,
  int timeout_millisec,
  TessResultRenderer* renderer);
int TessBaseAPIProcessPage(
  TessBaseAPI* handle,
  Pix* pix,
  int page_index,
  const(char)* filename,
  const(char)* retry_config,
  int timeout_millisec,
  TessResultRenderer* renderer);

TessResultIterator* TessBaseAPIGetIterator(TessBaseAPI* handle);
TessMutableIterator* TessBaseAPIGetMutableIterator(TessBaseAPI* handle);

char* TessBaseAPIGetUTF8Text(TessBaseAPI* handle);
char* TessBaseAPIGetHOCRText(TessBaseAPI* handle, int page_number);

char* TessBaseAPIGetAltoText(TessBaseAPI* handle, int page_number);
char* TessBaseAPIGetTsvText(TessBaseAPI* handle, int page_number);

char* TessBaseAPIGetBoxText(TessBaseAPI* handle, int page_number);
char* TessBaseAPIGetLSTMBoxText(TessBaseAPI* handle, int page_number);
char* TessBaseAPIGetWordStrBoxText(TessBaseAPI* handle, int page_number);

char* TessBaseAPIGetUNLVText(TessBaseAPI* handle);
int TessBaseAPIMeanTextConf(TessBaseAPI* handle);

int* TessBaseAPIAllWordConfidences(TessBaseAPI* handle);

int TessBaseAPIAdaptToWordStr(
  TessBaseAPI* handle,
  TessPageSegMode mode,
  const(char)* wordstr);
// #ifndef DISABLED_LEGACY_ENGINE

void TessBaseAPIClear(TessBaseAPI* handle);
void TessBaseAPIEnd(TessBaseAPI* handle);

int TessBaseAPIIsValidWord(TessBaseAPI* handle, const(char)* word);
int TessBaseAPIGetTextDirection(
  TessBaseAPI* handle,
  int* out_offset,
  float* out_slope);

const(char)* TessBaseAPIGetUnichar(TessBaseAPI* handle, int unichar_id);

void TessBaseAPIClearPersistentCache(TessBaseAPI* handle);

// Call TessDeleteText(*best_script_name) to free memory allocated by this
// function
int TessBaseAPIDetectOrientationScript(
  TessBaseAPI* handle,
  int* orient_deg,
  float* orient_conf,
  const(char*)* script_name,
  float* script_conf);
// #ifndef DISABLED_LEGACY_ENGINE

void TessBaseAPISetMinOrientationMargin(TessBaseAPI* handle, double margin);

int TessBaseAPINumDawgs(const(TessBaseAPI)* handle);

TessOcrEngineMode TessBaseAPIOem(const(TessBaseAPI)* handle);

void TessBaseGetBlockTextOrientations(
  TessBaseAPI* handle,
  int** block_orientation,
  bool** vertical_writing);

/* Page iterator */

void TessPageIteratorDelete(TessPageIterator* handle);

TessPageIterator* TessPageIteratorCopy(const(TessPageIterator)* handle);

void TessPageIteratorBegin(TessPageIterator* handle);

int TessPageIteratorNext(
  TessPageIterator* handle,
  TessPageIteratorLevel level);

int TessPageIteratorIsAtBeginningOf(
  const(TessPageIterator)* handle,
  TessPageIteratorLevel level);

int TessPageIteratorIsAtFinalElement(
  const(TessPageIterator)* handle,
  TessPageIteratorLevel level,
  TessPageIteratorLevel element);

int TessPageIteratorBoundingBox(
  const(TessPageIterator)* handle,
  TessPageIteratorLevel level,
  int* left,
  int* top,
  int* right,
  int* bottom);

TessPolyBlockType TessPageIteratorBlockType(const(TessPageIterator)* handle);

Pix* TessPageIteratorGetBinaryImage(
  const(TessPageIterator)* handle,
  TessPageIteratorLevel level);

Pix* TessPageIteratorGetImage(
  const(TessPageIterator)* handle,
  TessPageIteratorLevel level,
  int padding,
  Pix* original_image,
  int* left,
  int* top);

int TessPageIteratorBaseline(
  const(TessPageIterator)* handle,
  TessPageIteratorLevel level,
  int* x1,
  int* y1,
  int* x2,
  int* y2);

void TessPageIteratorOrientation(
  TessPageIterator* handle,
  TessOrientation* orientation,
  TessWritingDirection* writing_direction,
  TessTextlineOrder* textline_order,
  float* deskew_angle);

void TessPageIteratorParagraphInfo(
  TessPageIterator* handle,
  TessParagraphJustification* justification,
  int* is_list_item,
  int* is_crown,
  int* first_line_indent);

/* Result iterator */

void TessResultIteratorDelete(TessResultIterator* handle);
TessResultIterator* TessResultIteratorCopy(const(TessResultIterator)* handle);
TessPageIterator* TessResultIteratorGetPageIterator(
  TessResultIterator* handle);
const(TessPageIterator)* TessResultIteratorGetPageIteratorConst(
  const(TessResultIterator)* handle);
TessChoiceIterator* TessResultIteratorGetChoiceIterator(
  const(TessResultIterator)* handle);

int TessResultIteratorNext(
  TessResultIterator* handle,
  TessPageIteratorLevel level);
char* TessResultIteratorGetUTF8Text(
  const(TessResultIterator)* handle,
  TessPageIteratorLevel level);
float TessResultIteratorConfidence(
  const(TessResultIterator)* handle,
  TessPageIteratorLevel level);
const(char)* TessResultIteratorWordRecognitionLanguage(
  const(TessResultIterator)* handle);
const(char)* TessResultIteratorWordFontAttributes(
  const(TessResultIterator)* handle,
  int* is_bold,
  int* is_italic,
  int* is_underlined,
  int* is_monospace,
  int* is_serif,
  int* is_smallcaps,
  int* pointsize,
  int* font_id);

int TessResultIteratorWordIsFromDictionary(const(TessResultIterator)* handle);
int TessResultIteratorWordIsNumeric(const(TessResultIterator)* handle);
int TessResultIteratorSymbolIsSuperscript(const(TessResultIterator)* handle);
int TessResultIteratorSymbolIsSubscript(const(TessResultIterator)* handle);
int TessResultIteratorSymbolIsDropcap(const(TessResultIterator)* handle);

void TessChoiceIteratorDelete(TessChoiceIterator* handle);
int TessChoiceIteratorNext(TessChoiceIterator* handle);
const(char)* TessChoiceIteratorGetUTF8Text(const(TessChoiceIterator)* handle);
float TessChoiceIteratorConfidence(const(TessChoiceIterator)* handle);

/* Progress monitor */

ETEXT_DESC* TessMonitorCreate();
void TessMonitorDelete(ETEXT_DESC* monitor);
void TessMonitorSetCancelFunc(ETEXT_DESC* monitor, TessCancelFunc cancelFunc);
void TessMonitorSetCancelThis(ETEXT_DESC* monitor, void* cancelThis);
void* TessMonitorGetCancelThis(ETEXT_DESC* monitor);
void TessMonitorSetProgressFunc(
  ETEXT_DESC* monitor,
  TessProgressFunc progressFunc);
int TessMonitorGetProgress(ETEXT_DESC* monitor);
void TessMonitorSetDeadlineMSecs(ETEXT_DESC* monitor, int deadline);

// API_CAPI_H_
