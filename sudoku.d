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
 * \file sudoku.h
 *
 * <pre>
 *    The L_Sudoku holds all the information of the current state.
 *
 *    The input to sudokuCreate() is a file with any number of lines
 *    starting with '#', followed by 9 lines consisting of 9 numbers
 *    in each line.  These have the known values and use 0 for the unknowns.
 *    Blank lines are ignored.
 *
 *    The %locs array holds the indices of the unknowns, numbered
 *    left-to-right and top-to-bottom from 0 to 80.  The array size
 *    is initialized to %num.  %current is the index into the %locs
 *    array of the current guess: locs[current].
 *
 *    The %state array is used to determine the validity of each guess.
 *    It is of size 81, and is initialized by setting the unknowns to 0
 *    and the knowns to their input values.
 * </pre>
 */

struct L_Sudoku
{
    int num; /*!< number of unknowns                     */
    int* locs; /*!< location of unknowns                   */
    int current; /*!< index into %locs of current location   */
    int* init; /*!< initial state, with 0 representing     */
    /*!< the unknowns                           */
    int* state; /*!< present state, including inits and     */
    /*!< guesses of unknowns up to %current     */
    int nguess; /*!< shows current number of guesses        */
    int finished; /*!< set to 1 when solved                   */
    int failure; /*!< set to 1 if no solution is possible    */
}

alias L_SUDOKU = L_Sudoku;

/*! For printing out array data */
/*! Sudoku Output */
enum
{
    L_SUDOKU_INIT = 0,
    L_SUDOKU_STATE = 1
}

/* SUDOKU_H_INCLUDED */
