#include "fcntl.h"
#include "stdbool.h"
#include "limits.h"
#include "types.h"
#include "user.h"

void debug_panic (const char *file, int line, const char *function,
                  const char *message, ...)
{
  // va_list args;
  printf (1, "Kernel PANIC at %s:%d in %s(): ", file, line, function);

  // va_start (args, message);
  // vprintf (message, args);
  printf (1, "\n");
  // va_end (args);
  exit();
}
