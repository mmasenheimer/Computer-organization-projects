#! /usr/bin/env perl


# MIPS INSTRUCTION CHECKER
#
# Searches through STDIN to verify that the file is entirely made up of valid
# instructions (and not pseudo-instruction).  It reads each line, removes
# comments, collapses whitespace, removes labels, discards blank lines
# (including lines that *became* blank when everything else was removed), and
# then verifies that what is left is a valid instruction.
#
# There are several formats that must be recognized:
#      R-format (3 operand)
#      2 register and integer (addi, sll, etc.)
#      BEQ / BNE
#      J / JAL
#      JR
#      LA
#      SYSCALL
#      .data / .text
#      .globl
#      .word / .half / .byte
#      .asciiz / .ascii


# CONFIG OPTIONS
#
# As the semester progresses, we will turn on support for new instructions,
# which are not allowed earlier in the semester.
$allow_unsigned_addsub = 1;
$allow_muldiv          = 0;
$allow_lui             = 0;
$allow_jr              = 1;
$allow_mfhilo          = 0;
$allow_var_shift       = 0;
$allow_bit_count       = 0;


foreach $line (<STDIN>)
{
	# get rid of any comment that might exist.  The s/foo/bar/g regular
	# expression form is for substitution; in this case, we replace
	# anything that looks like a comment with an empty string.
	$line =~ s/#.*//g;

	# remove leading and trailing whitespace, includine newlines.
	# Thanks to
	#     https://perlmaven.com/trim
	# for the elegant regexp.
	$line =~ s/^\s+|\s+$//g;

	# collapse all whitespace down to single spaces.
	$line =~ s/\s+/ /g;

	# remove labels from the front of any line.
	$line =~ s/^\s*[a-zA-Z0-9_]+\s*:\s*//;


	# accept blank lines
	if ($line eq "")
	{
		next;
	}


	# accept lines which are simple assembler directives
	if ($line =~ m/^[.](text|data)/)
	{
		next;
	}

	if ($line =~ m/^[.]globl\s+[a-zA-Z0-9_]+$/)
	{
		next;
	}

	if ($line =~ m/^[.](word|half|byte)\s+(-?[0-9]+|0x[0-9a-fA-F]+|[a-zA-Z0-9_]+|'([^']|\\.)')$/)
	{
		next;
	}

	# UPDATE: MARS doesn't require a space before the leading double-quote
	#         in an .asciiz line.  So I made it optional.
	if ($line =~ m/^[.]asciiz? ?".*"$/)
	{
		next;
	}


	# This pattern matches all R-format instructions (except for shift)
	if ($line =~ m/^([a-z]+) \$[a-z0-9]+ ?, ?\$[a-z0-9]+ ?, ?\$[a-z0-9]+$/)
	{
		# is the instruction one of the ones we recognize?
		$inst = $1;

		if ($inst =~ m/^(add|sub|slt|and|or|nor|xor)$/)
		{
			next;
		}

		if ($allow_unsigned_addsub && $inst =~ m/^(addu|subu)$/)
		{
			next;
		}

		if ($allow_muldiv && $inst eq "mul")
		{
				next;
		}

		if ($allow_var_shift && $inst =~ m/^(srav|srlv|sllv)$/)
		{
			next;
		}
	}

	# recognize all of the conditional branch instructions
	if ($line =~ m/^(beq|bne) \$[a-z0-9]+ ?, ?\$[a-z0-9]+ ?, ?[a-zA-Z0-9_]+$/)
	{
		next;
	}

	# recognize all of the I-format (immediate value) instructions, PLUS
	# the shift instructions.
	if ($line =~ m/^(addiu?|slti|andi|ori|xori|sll|srl|sra) \$[a-z0-9]+ ?, ?\$[a-z0-9]+ ?, ?(-?[0-9]{1,5}|0x[0-9a-fA-F]{1,4}|'([^']|\\.)')/)
	{
		next;
	}

	# recognize the LA instruction here - since it's a real oddball
	if ($line =~ m/^la \$[a-z0-9]+ ?, ?[a-zA-Z0-9_]+$/)
	{
		next;
	}

	# so is lui, if we're hoenst!
	if ($allow_lui && $line =~ m/^lui \$[a-z0-9]+ ?, ?(-?[0-9]{1,5}|0x[0-9a-fA-F]{1,4})/)
	{
		next;
	}

	# we've added support for mult/div; we'll handle mfhi/mflo later,
	# along with jr
	#
	# Update: also support clo,clz
	if ($allow_muldiv && $line =~ m/^([a-z]+) \$[a-z0-9]+ ?, ?\$[a-z0-9]+/)
	{
		# is the instruction one of the ones we recognize?
		$inst = $1;

		if ($allow_muldiv && $inst =~ m/mul|div/)
		{
			next;
		}

		if ($allow_bit_count && $inst =~ m/cl(o|z)/)
		{
			next;
		}
	}

	# recognize all load/store instructions.
	if ($line =~ m/^[ls][whb] \$[a-z0-9]+ ?, ?(-?[0-9]+|0x[0-9a-fA-F]+) ?\( ?\$[a-z0-9]+ ?\)$/)
	{
		next;
	}

	# recognize all of the j-format instructions
	if ($line =~ m/^(j|jal) [a-zA-Z0-9_]+$/)
	{
		next;
	}

	# recognize JR - and also MFHI,MFLO - all of which only take a single
	# register parameter.
	if ($line =~ m/^([a-z]+) \$[a-z0-9]+$/)
	{
		$inst = $1;

		if ($allow_jr && $inst eq "jr")
		{
			next;
		}

		if ($allow_mfhilo && $inst =~ m/^(mfhi|mflo)$/)
		{
			next;
		}
	}

	# recognize syscall - the only non-parameterized instruction
	if ($line eq "syscall")
	{
		next;
	}


	print "ERROR: UNRECOGNIZED LINE: '$line'\n";


	# handle very common mixed-up formats: 
	#    LW <la-params>
	#    LA <lw-params>
	#    LW <missing offset>
        #    ADD <ADDI-type-args>
        #    ADDI <ADD-type-args>
	if ($line =~ m/^[ls][whb] \$[a-z0-9]+ ?, ?[a-zA-Z0-9_]+$/)
	{
		print "   (You used a load/store instruction, but gave the proper parameters for an LA instruction.)\n";
		print "       LA - load the address of a label into a register\n";
		print "       LW - read a value from memory\n";
	}

	if ($line =~ m/^la \$[a-z0-9]+ ?, ?(-?[0-9]+|0x[0-9a-fA-F]+) ?\( ?\$[a-z0-9]+ ?\)$/)
	{
		print "   (You used the LA instruction, but gave the proper parameters for an load/store instruction.)\n";
		print "       LA - load the address of a label into a register\n";
		print "       LW - read a value from memory\n";
	}

	if ($line =~ m/^[ls][whb] ?(-?[0-9]+|0x[0-9a-fA-F]+) ?\( ?\$[a-z0-9]+ ?\)$/)
	{
		print "    (All load/store operations require an offset, as well as the base register.)\n";
		print "        EXAMPLE:  lw  \$t0, 0(\$t3)\n";
	}

	if ($line =~ m/^add \$[a-z0-9]+ ?, ?\$[a-z0-9]+ ?, ?(-?[0-9]{1,5}|0x[0-9a-fA-F]{1,4}|'([^']|\\.)')/)
	{
		print "   (You used the ADD instruction, but gave the proper parameters for an ADDI.)\n";
	}

	if ($line =~ m/^addi \$[a-z0-9]+ ?, ?\$[a-z0-9]+ ?, ?\$[a-z0-9]+$/)
	{
		print "   (You used the ADDI instruction, but gave the proper parameters for an ADD.)\n";
	}
}


