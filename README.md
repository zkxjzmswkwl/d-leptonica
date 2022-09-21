# wip/works on my machine

I'm sure this is far from perfect, but, for now, it works on my machine. I'll update these/maintain them as they break.

Due to the structure of the library and likely some user error on my end, these typedefs had to be replaced prior to generating bindings.

```cpp
typedef intptr_t l_intptr_t;
typedef uintptr_t l_uintptr_t;
typedef int                     l_ok;    /*!< return type 0 if OK, 1 on error */
typedef signed char             l_int8;     /*!< signed 8-bit value */
typedef unsigned char           l_uint8;    /*!< unsigned 8-bit value */
typedef short                   l_int16;    /*!< signed 16-bit value */
typedef unsigned short          l_uint16;   /*!< unsigned 16-bit value */
typedef int                     l_int32;    /*!< signed 32-bit value */
typedef unsigned int            l_uint32;   /*!< unsigned 32-bit value */
typedef float                   l_float32;  /*!< 32-bit floating point value */
typedef double                  l_float64;  /*!< 64-bit floating point value */
#ifdef COMPILER_MSVC
typedef __int64                 l_int64;    /*!< signed 64-bit value */
typedef unsigned __int64        l_uint64;   /*!< unsigned 64-bit value */
#else
typedef long long               l_int64;    /*!< signed 64-bit value */
typedef unsigned long long      l_uint64;   /*!< unsigned 64-bit value */
#endif  /* COMPILER_MSVC */
```

Worth noting that `FILE*` was replaced with `void*`. Works fine.
