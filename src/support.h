// Copyright (c) 2016, Richard G. FitzJohn

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:

//     Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.

//     Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the
//     distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include <stdbool.h>
#include <R.h>
#include <Rinternals.h>

typedef enum return_as {
  AS_RAW,
  AS_STRING,
  AS_ANY
} return_as;

size_t get_key(SEXP key, const char **key_data);
size_t get_value(SEXP value, const char **value_data);
size_t get_keys(SEXP keys, const char ***key_data, size_t **key_len);
size_t get_starts_with(SEXP starts_with, const char **starts_with_data);

bool is_raw_string(const char* str, size_t len, return_as as);
SEXP raw_string_to_sexp(const char *str, size_t len, return_as as);
bool scalar_logical(SEXP x);
return_as to_return_as(SEXP x);
size_t scalar_size(SEXP x);
const char * scalar_character(SEXP x);
