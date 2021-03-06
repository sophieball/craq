/* $Id: test_barrett.C 3943 2009-01-16 23:46:20Z max $ */

/*
 *
 * Copyright (C) 1998 David Mazieres (dm@uun.org)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 *
 */


#include "crypt.h"
#include "modalg.h"

int
main (int argc, char **argv)
{
  random_update ();

  bigint m, r, s1, s2;
  barrett b;

  for (int i = 120; i < 162; i++) {
    m = random_bigint (i);
    m.setbit (0, 1);
    b.set (m);
    for (int j = i - 33; j <= 2 * i; j++) {
      r = random_bigint (j);
      s1 = mod (r, m);
      s2 = b.reduce (r);
      if (s1 != s2) {
	int sz = mpz_sizeinbase (&s1, 16);
	panic << "r = " << r << "\n"
	      << "     " << s1 << "\n  != " << s2 << "\n"
	      << "    ["
	      << strbuf ("%*s", sz, bigint (abs (s1 - s2)).cstr ())
	      << "]\n";
      }
    }
  }

  return 0;
}
