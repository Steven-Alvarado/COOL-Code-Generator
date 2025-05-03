                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Bool..vtable
Bool..vtable:			## virtual function table for Bool
						.quad string1
						.quad Bool..new
						.quad Object.abort
						.quad Object.copy
						.quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO..vtable
IO..vtable:			## virtual function table for IO
						.quad string2
						.quad IO..new
						.quad Object.abort
						.quad Object.copy
						.quad Object.type_name
						.quad IO.in_int
						.quad IO.in_string
						.quad IO.out_int
						.quad IO.out_string
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Int..vtable
Int..vtable:			## virtual function table for Int
						.quad string3
						.quad Int..new
						.quad Object.abort
						.quad Object.copy
						.quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main..vtable
Main..vtable:			## virtual function table for Main
						.quad string4
						.quad Main..new
						.quad Object.abort
						.quad Object.copy
						.quad Object.type_name
						.quad IO.in_int
						.quad IO.in_string
						.quad IO.out_int
						.quad IO.out_string
						.quad Main.main
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object..vtable
Object..vtable:			## virtual function table for Object
						.quad string5
						.quad Object..new
						.quad Object.abort
						.quad Object.copy
						.quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String..vtable
String..vtable:			## virtual function table for String
						.quad string6
						.quad String..new
						.quad Object.abort
						.quad Object.copy
						.quad Object.type_name
						.quad String.concat
						.quad String.length
						.quad String.substr
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Bool..new
Bool..new:              ## constructor for Bool
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $4, %r12
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $0, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $Bool..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field (raw content) (Int)
                        movq $0, %r13
                        movq %r13, 24(%r12)
                        ## self[3] (raw content) initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO..new
IO..new:                ## constructor for IO
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $3, %r12
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $10, %r14
                        movq %r14, 0(%r12)
                        movq $3, %r14
                        movq %r14, 8(%r12)
                        movq $IO..vtable, %r14
                        movq %r14, 16(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Int..new
Int..new:               ## constructor for Int
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $4, %r12
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $1, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $Int..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field (raw content) (Int)
                        movq $0, %r13
                        movq %r13, 24(%r12)
                        ## self[3] (raw content) initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
          ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main..new
Main..new:          ## constructor for Main
          pushq %rbp
          movq %rsp, %rbp
          ## stack room for temporaries: 0
          movq $0, %r14
          subq %r14, %rsp
          ## return address handling
          movq $3, %r12
			## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
			## store class tag, object size and vtable pointer
          movq $11, %r14
          movq %r14, 0(%r12)
          movq $3, %r14
          movq %r14, 8(%r12)
          movq $Main..vtable, %r14
          movq %r14, 16(%r12)
                        ## initialize attributes
          movq %r12, %r13
          ## return address handling
          movq %rbp, %rsp
          popq %rbp
          ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object..new
Object..new:            ## constructor for Object
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $3, %r12
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $12, %r14
                        movq %r14, 0(%r12)
                        movq $3, %r14
                        movq %r14, 8(%r12)
                        movq $Object..vtable, %r14
                        movq %r14, 16(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String..new
String..new:            ## constructor for String
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $4, %r12
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $3, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $String..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field (raw content) (String)
                        movq $the.empty.string, %r13
                        movq %r13, 24(%r12)
                        ## self[3] (raw content) initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.abort
Object.abort:           ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        movq $string7, %r13
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			call cooloutstr
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movl $0, %edi
			call exit
.globl Object.abort.end
Object.abort.end:       ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.copy
Object.copy:            ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        movq 8(%r12), %r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $8, %rsi
			movq %r14, %rdi
			call calloc
			movq %rax, %r13
                        pushq %r13
.globl l1
l1:                     cmpq $0, %r14
			je l2
                        movq 0(%r12), %r15
                        movq %r15, 0(%r13)
                        movq $8, %r15
                        addq %r15, %r12
                        addq %r15, %r13
                        movq $1, %r15
                        subq %r15, %r14
                        jmp l1
.globl l2
l2:                     ## done with Object.copy loop
                        popq %r13
.globl Object.copy.end
Object.copy.end:        ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.type_name
Object.type_name:       ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## obtain vtable for self object
                        movq 16(%r12), %r14
                        ## look up type name at offset 0 in vtable
                        movq 0(%r14), %r14
                        movq %r14, 24(%r13)
.globl Object.type_name.end
Object.type_name.end:   ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
          ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.in_int
IO.in_int:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			call coolinint
			movq %rax, %r13
                        movq %r13, 24(%r14)
                        movq %r14, %r13
.globl IO.in_int.end
IO.in_int.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.in_string
IO.in_string:           ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			call coolgetstr 
			movq %rax, %r13
                        movq %r13, 24(%r14)
                        movq %r14, %r13
.globl IO.in_string.end
IO.in_string.end:       ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.out_int
IO.out_int:             ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument x (Int)
                        ## method body begins
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r13
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq $percent.d, %rdi
			movl %r13d, %eax
			cdqe
			movq %rax, %rsi
			movl $0, %eax
			call printf
                        movq %r12, %r13
.globl IO.out_int.end
IO.out_int.end:         ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.out_string
IO.out_string:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument x (String)
                        ## method body begins
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r13
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			call cooloutstr
                        movq %r12, %r13
.globl IO.out_string.end
IO.out_string.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
						## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.main
Main.main:              ## method definition
						pushq %rbp
						movq %rsp, %rbp
						movq 16(%rbp), %r12
						## stack room for temporaries: 325
						movq $2608, %r14
						subq %r14, %rsp
						## return address handling
						## method body begins
                        ## Basic block: BB0
                        ## fp[1] holds local a (Int)
                        ##t$1 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -16(%rbp)
                        ## fp[2] holds local b (Int)
                        ##t$2 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -24(%rbp)
                        ## fp[3] holds local s (String)
                        ##t$3 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -32(%rbp)
                        ## fp[4] holds local c (Int)
                        ##t$4 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -40(%rbp)
                        ## fp[5] holds local d (Int)
                        ##t$5 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -48(%rbp)
                        ## fp[6] holds local e (Int)
                        ##t$6 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -56(%rbp)
                        ## fp[7] holds local f (Int)
                        ##t$7 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -64(%rbp)
                        ## fp[8] holds local g (Int)
                        ##t$8 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -72(%rbp)
                        ## fp[9] holds local h (Int)
                        ##t$9 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -80(%rbp)
                        ## fp[10] holds local i (Int)
                        ##t$10 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -88(%rbp)
                        ## fp[11] holds local j (Int)
                        ##t$11 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -96(%rbp)
                        ## fp[12] holds local k (Bool)
                        ##t$12 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -104(%rbp)
                        ## fp[13] holds local l (Bool)
                        ##t$13 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -112(%rbp)
                        ## fp[14] holds local m (Bool)
                        ##t$14 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -120(%rbp)
                        ## fp[15] holds local o (Bool)
                        ##t$15 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -128(%rbp)
                        ## fp[16] holds local p (String)
                        ##t$16 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -136(%rbp)
                        ## fp[17] holds local s (String)
                        ##t$17 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -144(%rbp)
                        ## fp[18] holds local t (String)
                        ##t$18 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -152(%rbp)
                        ## fp[19] holds local u (String)
                        ##t$19 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -160(%rbp)
                        ## new String t$0 <- "Enter number: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string8 holds "Enter number: "
                        movq $string8, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -8(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$0 (pointer)
                        movq -8(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## in_int(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up in_int() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$1 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -16(%rbp)
                        ## (temp <- temp): t$1 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -16(%rbp)
                        ## (temp <- temp): t$2 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## t$3 <- -t$2
                        movq -24(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -32(%rbp)
                        ## new int t$4 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -40(%rbp)
                        ## new int t$5 <- 1
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -48(%rbp)
                        ## t$6 <- t$4 / t$5
                        movq -48(%rbp), %r13
                        cmpq $0, %r13
           jne main_l0_div_ok
                        movq $string12, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l0_div_ok
main_l0_div_ok:        ## division is okay 
                        movq -40(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -56(%rbp)
                        ## t$7 <- t$3 - t$6
                        movq -32(%rbp), %r13
                        movq -56(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -64(%rbp)
                        ## new int t$8 <- 100
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $100, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -72(%rbp)
                        ## new int t$9 <- 7
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -80(%rbp)
                        ## t$10 <- -t$9
                        movq -80(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -88(%rbp)
                        ## t$11 <- t$8 * t$10
                        movq -72(%rbp), %r13
                        movq -88(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -96(%rbp)
                        ## new int t$12 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -104(%rbp)
                        ## t$13 <- t$11 * t$12
                        movq -96(%rbp), %r13
                        movq -104(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -112(%rbp)
                        ## t$14 <- t$7 + t$13
                        movq -64(%rbp), %r13
                        movq -112(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -120(%rbp)
                        ## (temp <- temp): t$2 <- t$14
                        movq -120(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$15 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -128(%rbp)
                        ## (temp <- temp): t$16 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -136(%rbp)
                        ## (temp <- temp): t$17 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -144(%rbp)
                        ## t$18 <- t$16 - t$17
                        movq -136(%rbp), %r13
                        movq -144(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -152(%rbp)
                        ## new int t$19 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -160(%rbp)
                        ## new int t$20 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -168(%rbp)
                        ## t$21 <- -t$20
                        movq -168(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -176(%rbp)
                        ## t$22 <- t$19 * t$21
                        movq -160(%rbp), %r13
                        movq -176(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -184(%rbp)
                        ## t$23 <- t$18 + t$22
                        movq -152(%rbp), %r13
                        movq -184(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -192(%rbp)
                        ## new int t$24 <- 8
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -200(%rbp)
                        ## new int t$25 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -208(%rbp)
                        ## t$26 <- t$24 / t$25
                        movq -208(%rbp), %r13
                        cmpq $0, %r13
           jne main_l1_div_ok
                        movq $string13, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l1_div_ok
main_l1_div_ok:        ## division is okay 
                        movq -200(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -216(%rbp)
                        ## t$27 <- t$23 - t$26
                        movq -192(%rbp), %r13
                        movq -216(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -224(%rbp)
                        ## (temp <- temp): t$4 <- t$27
                        movq -224(%rbp), %r13
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$28 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -232(%rbp)
                        ## new int t$29 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -240(%rbp)
                        ## new int t$30 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -248(%rbp)
                        ## t$31 <- t$29 / t$30
                        movq -248(%rbp), %r13
                        cmpq $0, %r13
           jne main_l2_div_ok
                        movq $string14, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l2_div_ok
main_l2_div_ok:        ## division is okay 
                        movq -240(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -256(%rbp)
                        ## new int t$32 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -264(%rbp)
                        ## t$33 <- -t$32
                        movq -264(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -272(%rbp)
                        ## t$34 <- t$31 * t$33
                        movq -256(%rbp), %r13
                        movq -272(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -280(%rbp)
                        ## new int t$35 <- 9
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $9, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -288(%rbp)
                        ## t$36 <- t$34 - t$35
                        movq -280(%rbp), %r13
                        movq -288(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -296(%rbp)
                        ## (temp <- temp): t$37 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -304(%rbp)
                        ## (temp <- temp): t$38 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -312(%rbp)
                        ## t$39 <- t$37 * t$38
                        movq -304(%rbp), %r13
                        movq -312(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -320(%rbp)
                        ## t$40 <- t$36 + t$39
                        movq -296(%rbp), %r13
                        movq -320(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -328(%rbp)
                        ## (temp <- temp): t$5 <- t$40
                        movq -328(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ## (temp <- temp): t$41 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -336(%rbp)
                        ## (temp <- temp): t$42 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -344(%rbp)
                        ## (temp <- temp): t$43 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -352(%rbp)
                        ## (temp <- temp): t$44 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -360(%rbp)
                        ## t$45 <- t$43 * t$44
                        movq -352(%rbp), %r13
                        movq -360(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -368(%rbp)
                        ## t$46 <- t$42 + t$45
                        movq -344(%rbp), %r13
                        movq -368(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -376(%rbp)
                        ## (temp <- temp): t$47 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -384(%rbp)
                        ## t$48 <- -t$47
                        movq -384(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -392(%rbp)
                        ## new int t$49 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -400(%rbp)
                        ## t$50 <- t$48 / t$49
                        movq -400(%rbp), %r13
                        cmpq $0, %r13
           jne main_l3_div_ok
                        movq $string15, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l3_div_ok
main_l3_div_ok:        ## division is okay 
                        movq -392(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -408(%rbp)
                        ## t$51 <- t$46 - t$50
                        movq -376(%rbp), %r13
                        movq -408(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -416(%rbp)
                        ## new int t$52 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -424(%rbp)
                        ## new int t$53 <- 11
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $11, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -432(%rbp)
                        ## t$54 <- t$52 * t$53
                        movq -424(%rbp), %r13
                        movq -432(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -440(%rbp)
                        ## (temp <- temp): t$55 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -448(%rbp)
                        ## t$56 <- -t$55
                        movq -448(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -456(%rbp)
                        ## t$57 <- t$54 * t$56
                        movq -440(%rbp), %r13
                        movq -456(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -464(%rbp)
                        ## t$58 <- t$51 + t$57
                        movq -416(%rbp), %r13
                        movq -464(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -472(%rbp)
                        ## (temp <- temp): t$6 <- t$58
                        movq -472(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$59 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -480(%rbp)
                        ## (temp <- temp): t$60 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -488(%rbp)
                        ## (temp <- temp): t$61 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -496(%rbp)
                        ## (temp <- temp): t$62 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -504(%rbp)
                        ## t$63 <- t$61 * t$62
                        movq -496(%rbp), %r13
                        movq -504(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -512(%rbp)
                        ## t$64 <- t$60 + t$63
                        movq -488(%rbp), %r13
                        movq -512(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -520(%rbp)
                        ## (temp <- temp): t$65 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -528(%rbp)
                        ## t$66 <- t$64 + t$65
                        movq -520(%rbp), %r13
                        movq -528(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -536(%rbp)
                        ## (temp <- temp): t$67 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -544(%rbp)
                        ## t$68 <- -t$67
                        movq -544(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -552(%rbp)
                        ## new int t$69 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -560(%rbp)
                        ## t$70 <- t$68 * t$69
                        movq -552(%rbp), %r13
                        movq -560(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -568(%rbp)
                        ## (temp <- temp): t$71 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -576(%rbp)
                        ## t$72 <- t$70 / t$71
                        movq -576(%rbp), %r13
                        cmpq $0, %r13
           jne main_l4_div_ok
                        movq $string16, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l4_div_ok
main_l4_div_ok:        ## division is okay 
                        movq -568(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -584(%rbp)
                        ## t$73 <- t$66 - t$72
                        movq -536(%rbp), %r13
                        movq -584(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -592(%rbp)
                        ## (temp <- temp): t$7 <- t$73
                        movq -592(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ## (temp <- temp): t$74 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -600(%rbp)
                        ## (temp <- temp): t$75 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -608(%rbp)
                        ## (temp <- temp): t$76 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -616(%rbp)
                        ## t$77 <- t$75 * t$76
                        movq -608(%rbp), %r13
                        movq -616(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -624(%rbp)
                        ## (temp <- temp): t$78 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -632(%rbp)
                        ## (temp <- temp): t$79 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -640(%rbp)
                        ## t$80 <- t$78 / t$79
                        movq -640(%rbp), %r13
                        cmpq $0, %r13
           jne main_l5_div_ok
                        movq $string17, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l5_div_ok
main_l5_div_ok:        ## division is okay 
                        movq -632(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -648(%rbp)
                        ## t$81 <- t$77 - t$80
                        movq -624(%rbp), %r13
                        movq -648(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -656(%rbp)
                        ## (temp <- temp): t$82 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -664(%rbp)
                        ## t$83 <- -t$82
                        movq -664(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -672(%rbp)
                        ## new int t$84 <- 10
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -680(%rbp)
                        ## t$85 <- t$83 * t$84
                        movq -672(%rbp), %r13
                        movq -680(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -688(%rbp)
                        ## t$86 <- t$81 + t$85
                        movq -656(%rbp), %r13
                        movq -688(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -696(%rbp)
                        ## (temp <- temp): t$8 <- t$86
                        movq -696(%rbp), %r13
                        movq %r13, -72(%rbp)
                        ## (temp <- temp): t$87 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -704(%rbp)
                        ## (temp <- temp): t$88 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -712(%rbp)
                        ## (temp <- temp): t$89 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -720(%rbp)
                        ## (temp <- temp): t$90 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -728(%rbp)
                        ## t$91 <- t$89 * t$90
                        movq -720(%rbp), %r13
                        movq -728(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -736(%rbp)
                        ## t$92 <- t$88 - t$91
                        movq -712(%rbp), %r13
                        movq -736(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -744(%rbp)
                        ## (temp <- temp): t$93 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -752(%rbp)
                        ## new int t$94 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -760(%rbp)
                        ## t$95 <- -t$94
                        movq -760(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -768(%rbp)
                        ## t$96 <- t$93 / t$95
                        movq -768(%rbp), %r13
                        cmpq $0, %r13
           jne main_l6_div_ok
                        movq $string18, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l6_div_ok
main_l6_div_ok:        ## division is okay 
                        movq -752(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -776(%rbp)
                        ## t$97 <- t$92 + t$96
                        movq -744(%rbp), %r13
                        movq -776(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -784(%rbp)
                        ## (temp <- temp): t$98 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -792(%rbp)
                        ## (temp <- temp): t$99 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -800(%rbp)
                        ## t$100 <- t$98 * t$99
                        movq -792(%rbp), %r13
                        movq -800(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -808(%rbp)
                        ## t$101 <- t$97 - t$100
                        movq -784(%rbp), %r13
                        movq -808(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -816(%rbp)
                        ## (temp <- temp): t$9 <- t$101
                        movq -816(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ## (temp <- temp): t$102 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -824(%rbp)
                        ## (temp <- temp): t$103 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -832(%rbp)
                        ## t$104 <- -t$103
                        movq -832(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -840(%rbp)
                        ## (temp <- temp): t$105 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -848(%rbp)
                        ## (temp <- temp): t$106 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -856(%rbp)
                        ## t$107 <- t$105 * t$106
                        movq -848(%rbp), %r13
                        movq -856(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -864(%rbp)
                        ## t$108 <- t$104 + t$107
                        movq -840(%rbp), %r13
                        movq -864(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -872(%rbp)
                        ## (temp <- temp): t$109 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -880(%rbp)
                        ## (temp <- temp): t$110 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -888(%rbp)
                        ## t$111 <- t$109 * t$110
                        movq -880(%rbp), %r13
                        movq -888(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -896(%rbp)
                        ## t$112 <- t$108 - t$111
                        movq -872(%rbp), %r13
                        movq -896(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -904(%rbp)
                        ## (temp <- temp): t$113 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -912(%rbp)
                        ## (temp <- temp): t$114 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -920(%rbp)
                        ## t$115 <- t$113 * t$114
                        movq -912(%rbp), %r13
                        movq -920(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -928(%rbp)
                        ## t$116 <- t$112 + t$115
                        movq -904(%rbp), %r13
                        movq -928(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -936(%rbp)
                        ## (temp <- temp): t$117 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -944(%rbp)
                        ## t$118 <- t$116 - t$117
                        movq -936(%rbp), %r13
                        movq -944(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -952(%rbp)
                        ## (temp <- temp): t$10 <- t$118
                        movq -952(%rbp), %r13
                        movq %r13, -88(%rbp)
                        ## (temp <- temp): t$119 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -960(%rbp)
                        ## (temp <- temp): t$120 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -968(%rbp)
                        ## (temp <- temp): t$121 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -976(%rbp)
                        ## (temp <- temp): t$122 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -984(%rbp)
                        ## t$123 <- t$121 * t$122
                        movq -976(%rbp), %r13
                        movq -984(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -992(%rbp)
                        ## t$124 <- t$120 + t$123
                        movq -968(%rbp), %r13
                        movq -992(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1000(%rbp)
                        ## (temp <- temp): t$125 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1008(%rbp)
                        ## (temp <- temp): t$126 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1016(%rbp)
                        ## t$127 <- t$125 * t$126
                        movq -1008(%rbp), %r13
                        movq -1016(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1024(%rbp)
                        ## (temp <- temp): t$128 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1032(%rbp)
                        ## t$129 <- t$127 * t$128
                        movq -1024(%rbp), %r13
                        movq -1032(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1040(%rbp)
                        ## t$130 <- t$124 - t$129
                        movq -1000(%rbp), %r13
                        movq -1040(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1048(%rbp)
                        ## (temp <- temp): t$131 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1056(%rbp)
                        ## (temp <- temp): t$132 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1064(%rbp)
                        ## t$133 <- t$131 * t$132
                        movq -1056(%rbp), %r13
                        movq -1064(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1072(%rbp)
                        ## t$134 <- t$130 + t$133
                        movq -1048(%rbp), %r13
                        movq -1072(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1080(%rbp)
                        ## (temp <- temp): t$135 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1088(%rbp)
                        ## (temp <- temp): t$136 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -1096(%rbp)
                        ## t$137 <- t$135 / t$136
                        movq -1096(%rbp), %r13
                        cmpq $0, %r13
           jne main_l7_div_ok
                        movq $string19, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l7_div_ok
main_l7_div_ok:        ## division is okay 
                        movq -1088(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1104(%rbp)
                        ## t$138 <- t$134 - t$137
                        movq -1080(%rbp), %r13
                        movq -1104(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1112(%rbp)
                        ## (temp <- temp): t$11 <- t$138
                        movq -1112(%rbp), %r13
                        movq %r13, -96(%rbp)
                        ## (temp <- temp): t$139 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -1120(%rbp)
                        ## new String t$140 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1128(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$140 (pointer)
                        movq -1128(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$141 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1136(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1136(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$141
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$142 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1144(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1144(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$142
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$143 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1152(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1152(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$143
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$144 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1160(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1160(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$144
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$145 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1168(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1168(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$145
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$146 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1176(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1176(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$146
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$147 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1184(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1184(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$147
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$148 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1192(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1192(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$148
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$149 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -1200(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1200(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$149
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$150 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -1208(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1208(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$150
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## new String t$151 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1216(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$151 (pointer)
                        movq -1216(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$152 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1224(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$152 (pointer)
                        movq -1224(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$153 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1232(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$153 (pointer)
                        movq -1232(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$154 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1240(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$154 (pointer)
                        movq -1240(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$155 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1248(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$155 (pointer)
                        movq -1248(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$156 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1256(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$156 (pointer)
                        movq -1256(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$157 <- "Enter string: \n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string10 holds "Enter string: \n"
                        movq $string10, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1264(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$157 (pointer)
                        movq -1264(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## in_string(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up in_string() at offset 6 in vtable
                        movq  48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$17 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -144(%rbp)
                        ## (temp <- temp): t$158 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -1272(%rbp)
                        ## new String t$159 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1280(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$159 (pointer)
                        movq -1280(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$160 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -1288(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$160 (pointer)
                        movq -1288(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$161 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1296(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$161 (pointer)
                        movq -1296(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## in_int(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up in_int() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$1 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -16(%rbp)
                        ## (temp <- temp): t$162 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1304(%rbp)
                        ## (temp <- temp): t$163 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1312(%rbp)
                        ## t$164 <- -t$163
                        movq -1312(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1320(%rbp)
                        ## new int t$165 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1328(%rbp)
                        ## new int t$166 <- 1
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1336(%rbp)
                        ## t$167 <- t$165 / t$166
                        movq -1336(%rbp), %r13
                        cmpq $0, %r13
           jne main_l8_div_ok
                        movq $string20, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l8_div_ok
main_l8_div_ok:        ## division is okay 
                        movq -1328(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1344(%rbp)
                        ## t$168 <- t$164 - t$167
                        movq -1320(%rbp), %r13
                        movq -1344(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1352(%rbp)
                        ## new int t$169 <- 100
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $100, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1360(%rbp)
                        ## new int t$170 <- 7
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1368(%rbp)
                        ## t$171 <- -t$170
                        movq -1368(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1376(%rbp)
                        ## t$172 <- t$169 * t$171
                        movq -1360(%rbp), %r13
                        movq -1376(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1384(%rbp)
                        ## new int t$173 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1392(%rbp)
                        ## t$174 <- t$172 * t$173
                        movq -1384(%rbp), %r13
                        movq -1392(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1400(%rbp)
                        ## t$175 <- t$168 + t$174
                        movq -1352(%rbp), %r13
                        movq -1400(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1408(%rbp)
                        ## (temp <- temp): t$2 <- t$175
                        movq -1408(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$176 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1416(%rbp)
                        ## (temp <- temp): t$177 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1424(%rbp)
                        ## (temp <- temp): t$178 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1432(%rbp)
                        ## t$179 <- t$177 - t$178
                        movq -1424(%rbp), %r13
                        movq -1432(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1440(%rbp)
                        ## new int t$180 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1448(%rbp)
                        ## new int t$181 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1456(%rbp)
                        ## t$182 <- -t$181
                        movq -1456(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1464(%rbp)
                        ## t$183 <- t$180 * t$182
                        movq -1448(%rbp), %r13
                        movq -1464(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1472(%rbp)
                        ## t$184 <- t$179 + t$183
                        movq -1440(%rbp), %r13
                        movq -1472(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1480(%rbp)
                        ## new int t$185 <- 8
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1488(%rbp)
                        ## new int t$186 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1496(%rbp)
                        ## t$187 <- t$185 / t$186
                        movq -1496(%rbp), %r13
                        cmpq $0, %r13
           jne main_l9_div_ok
                        movq $string21, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l9_div_ok
main_l9_div_ok:        ## division is okay 
                        movq -1488(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1504(%rbp)
                        ## t$188 <- t$184 - t$187
                        movq -1480(%rbp), %r13
                        movq -1504(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1512(%rbp)
                        ## (temp <- temp): t$4 <- t$188
                        movq -1512(%rbp), %r13
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$189 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1520(%rbp)
                        ## new int t$190 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1528(%rbp)
                        ## new int t$191 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1536(%rbp)
                        ## t$192 <- t$190 / t$191
                        movq -1536(%rbp), %r13
                        cmpq $0, %r13
           jne main_l10_div_ok
                        movq $string22, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l10_div_ok
main_l10_div_ok:        ## division is okay 
                        movq -1528(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1544(%rbp)
                        ## new int t$193 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1552(%rbp)
                        ## t$194 <- -t$193
                        movq -1552(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1560(%rbp)
                        ## t$195 <- t$192 * t$194
                        movq -1544(%rbp), %r13
                        movq -1560(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1568(%rbp)
                        ## new int t$196 <- 9
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $9, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1576(%rbp)
                        ## t$197 <- t$195 - t$196
                        movq -1568(%rbp), %r13
                        movq -1576(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1584(%rbp)
                        ## (temp <- temp): t$198 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1592(%rbp)
                        ## (temp <- temp): t$199 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1600(%rbp)
                        ## t$200 <- t$198 * t$199
                        movq -1592(%rbp), %r13
                        movq -1600(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1608(%rbp)
                        ## t$201 <- t$197 + t$200
                        movq -1584(%rbp), %r13
                        movq -1608(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1616(%rbp)
                        ## (temp <- temp): t$5 <- t$201
                        movq -1616(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ## (temp <- temp): t$202 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1624(%rbp)
                        ## (temp <- temp): t$203 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1632(%rbp)
                        ## (temp <- temp): t$204 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1640(%rbp)
                        ## (temp <- temp): t$205 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1648(%rbp)
                        ## t$206 <- t$204 * t$205
                        movq -1640(%rbp), %r13
                        movq -1648(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1656(%rbp)
                        ## t$207 <- t$203 + t$206
                        movq -1632(%rbp), %r13
                        movq -1656(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1664(%rbp)
                        ## (temp <- temp): t$208 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1672(%rbp)
                        ## t$209 <- -t$208
                        movq -1672(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1680(%rbp)
                        ## new int t$210 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1688(%rbp)
                        ## t$211 <- t$209 / t$210
                        movq -1688(%rbp), %r13
                        cmpq $0, %r13
           jne main_l11_div_ok
                        movq $string23, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l11_div_ok
main_l11_div_ok:        ## division is okay 
                        movq -1680(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1696(%rbp)
                        ## t$212 <- t$207 - t$211
                        movq -1664(%rbp), %r13
                        movq -1696(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1704(%rbp)
                        ## new int t$213 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1712(%rbp)
                        ## new int t$214 <- 11
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $11, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1720(%rbp)
                        ## t$215 <- t$213 * t$214
                        movq -1712(%rbp), %r13
                        movq -1720(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1728(%rbp)
                        ## (temp <- temp): t$216 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1736(%rbp)
                        ## t$217 <- -t$216
                        movq -1736(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1744(%rbp)
                        ## t$218 <- t$215 * t$217
                        movq -1728(%rbp), %r13
                        movq -1744(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1752(%rbp)
                        ## t$219 <- t$212 + t$218
                        movq -1704(%rbp), %r13
                        movq -1752(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1760(%rbp)
                        ## (temp <- temp): t$6 <- t$219
                        movq -1760(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$220 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1768(%rbp)
                        ## (temp <- temp): t$221 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1776(%rbp)
                        ## (temp <- temp): t$222 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1784(%rbp)
                        ## (temp <- temp): t$223 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1792(%rbp)
                        ## t$224 <- t$222 * t$223
                        movq -1784(%rbp), %r13
                        movq -1792(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1800(%rbp)
                        ## t$225 <- t$221 + t$224
                        movq -1776(%rbp), %r13
                        movq -1800(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1808(%rbp)
                        ## (temp <- temp): t$226 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1816(%rbp)
                        ## t$227 <- t$225 + t$226
                        movq -1808(%rbp), %r13
                        movq -1816(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1824(%rbp)
                        ## (temp <- temp): t$228 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1832(%rbp)
                        ## t$229 <- -t$228
                        movq -1832(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1840(%rbp)
                        ## new int t$230 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1848(%rbp)
                        ## t$231 <- t$229 * t$230
                        movq -1840(%rbp), %r13
                        movq -1848(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1856(%rbp)
                        ## (temp <- temp): t$232 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1864(%rbp)
                        ## t$233 <- t$231 / t$232
                        movq -1864(%rbp), %r13
                        cmpq $0, %r13
           jne main_l12_div_ok
                        movq $string24, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l12_div_ok
main_l12_div_ok:        ## division is okay 
                        movq -1856(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1872(%rbp)
                        ## t$234 <- t$227 - t$233
                        movq -1824(%rbp), %r13
                        movq -1872(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1880(%rbp)
                        ## (temp <- temp): t$7 <- t$234
                        movq -1880(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ## (temp <- temp): t$235 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1888(%rbp)
                        ## (temp <- temp): t$236 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1896(%rbp)
                        ## (temp <- temp): t$237 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1904(%rbp)
                        ## t$238 <- t$236 * t$237
                        movq -1896(%rbp), %r13
                        movq -1904(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1912(%rbp)
                        ## (temp <- temp): t$239 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1920(%rbp)
                        ## (temp <- temp): t$240 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1928(%rbp)
                        ## t$241 <- t$239 / t$240
                        movq -1928(%rbp), %r13
                        cmpq $0, %r13
           jne main_l13_div_ok
                        movq $string25, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l13_div_ok
main_l13_div_ok:        ## division is okay 
                        movq -1920(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1936(%rbp)
                        ## t$242 <- t$238 - t$241
                        movq -1912(%rbp), %r13
                        movq -1936(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1944(%rbp)
                        ## (temp <- temp): t$243 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1952(%rbp)
                        ## t$244 <- -t$243
                        movq -1952(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1960(%rbp)
                        ## new int t$245 <- 1805
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1805, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1968(%rbp)
                        ## t$246 <- t$244 * t$245
                        movq -1960(%rbp), %r13
                        movq -1968(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1976(%rbp)
                        ## t$247 <- t$242 + t$246
                        movq -1944(%rbp), %r13
                        movq -1976(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1984(%rbp)
                        ## (temp <- temp): t$8 <- t$247
                        movq -1984(%rbp), %r13
                        movq %r13, -72(%rbp)
                        ## (temp <- temp): t$248 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1992(%rbp)
                        ## (temp <- temp): t$249 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2000(%rbp)
                        ## (temp <- temp): t$250 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2008(%rbp)
                        ## (temp <- temp): t$251 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2016(%rbp)
                        ## t$252 <- t$250 * t$251
                        movq -2008(%rbp), %r13
                        movq -2016(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2024(%rbp)
                        ## t$253 <- t$249 - t$252
                        movq -2000(%rbp), %r13
                        movq -2024(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2032(%rbp)
                        ## (temp <- temp): t$254 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2040(%rbp)
                        ## new int t$255 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -2048(%rbp)
                        ## t$256 <- -t$255
                        movq -2048(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2056(%rbp)
                        ## t$257 <- t$254 / t$256
                        movq -2056(%rbp), %r13
                        cmpq $0, %r13
           jne main_l14_div_ok
                        movq $string26, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l14_div_ok
main_l14_div_ok:        ## division is okay 
                        movq -2040(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2064(%rbp)
                        ## t$258 <- t$253 + t$257
                        movq -2032(%rbp), %r13
                        movq -2064(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2072(%rbp)
                        ## (temp <- temp): t$259 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2080(%rbp)
                        ## (temp <- temp): t$260 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2088(%rbp)
                        ## t$261 <- t$259 * t$260
                        movq -2080(%rbp), %r13
                        movq -2088(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2096(%rbp)
                        ## t$262 <- t$258 - t$261
                        movq -2072(%rbp), %r13
                        movq -2096(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2104(%rbp)
                        ## (temp <- temp): t$9 <- t$262
                        movq -2104(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ## (temp <- temp): t$263 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2112(%rbp)
                        ## (temp <- temp): t$264 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2120(%rbp)
                        ## t$265 <- -t$264
                        movq -2120(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2128(%rbp)
                        ## (temp <- temp): t$266 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2136(%rbp)
                        ## (temp <- temp): t$267 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2144(%rbp)
                        ## t$268 <- t$266 * t$267
                        movq -2136(%rbp), %r13
                        movq -2144(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2152(%rbp)
                        ## t$269 <- t$265 + t$268
                        movq -2128(%rbp), %r13
                        movq -2152(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2160(%rbp)
                        ## (temp <- temp): t$270 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2168(%rbp)
                        ## (temp <- temp): t$271 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2176(%rbp)
                        ## t$272 <- t$270 * t$271
                        movq -2168(%rbp), %r13
                        movq -2176(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2184(%rbp)
                        ## t$273 <- t$269 - t$272
                        movq -2160(%rbp), %r13
                        movq -2184(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2192(%rbp)
                        ## (temp <- temp): t$274 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2200(%rbp)
                        ## (temp <- temp): t$275 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2208(%rbp)
                        ## t$276 <- t$274 * t$275
                        movq -2200(%rbp), %r13
                        movq -2208(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2216(%rbp)
                        ## t$277 <- t$273 + t$276
                        movq -2192(%rbp), %r13
                        movq -2216(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2224(%rbp)
                        ## (temp <- temp): t$278 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2232(%rbp)
                        ## t$279 <- t$277 - t$278
                        movq -2224(%rbp), %r13
                        movq -2232(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2240(%rbp)
                        ## (temp <- temp): t$10 <- t$279
                        movq -2240(%rbp), %r13
                        movq %r13, -88(%rbp)
                        ## (temp <- temp): t$280 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2248(%rbp)
                        ## (temp <- temp): t$281 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2256(%rbp)
                        ## (temp <- temp): t$282 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2264(%rbp)
                        ## t$283 <- t$281 + t$282
                        movq -2256(%rbp), %r13
                        movq -2264(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2272(%rbp)
                        ## (temp <- temp): t$284 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2280(%rbp)
                        ## (temp <- temp): t$285 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2288(%rbp)
                        ## t$286 <- t$284 * t$285
                        movq -2280(%rbp), %r13
                        movq -2288(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2296(%rbp)
                        ## t$287 <- t$283 + t$286
                        movq -2272(%rbp), %r13
                        movq -2296(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2304(%rbp)
                        ## (temp <- temp): t$288 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2312(%rbp)
                        ## (temp <- temp): t$289 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2320(%rbp)
                        ## t$290 <- t$288 * t$289
                        movq -2312(%rbp), %r13
                        movq -2320(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2328(%rbp)
                        ## (temp <- temp): t$291 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2336(%rbp)
                        ## t$292 <- t$290 * t$291
                        movq -2328(%rbp), %r13
                        movq -2336(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2344(%rbp)
                        ## t$293 <- t$287 - t$292
                        movq -2304(%rbp), %r13
                        movq -2344(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2352(%rbp)
                        ## (temp <- temp): t$294 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2360(%rbp)
                        ## (temp <- temp): t$295 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2368(%rbp)
                        ## t$296 <- t$294 * t$295
                        movq -2360(%rbp), %r13
                        movq -2368(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2376(%rbp)
                        ## t$297 <- t$293 + t$296
                        movq -2352(%rbp), %r13
                        movq -2376(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2384(%rbp)
                        ## (temp <- temp): t$298 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2392(%rbp)
                        ## (temp <- temp): t$299 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2400(%rbp)
                        ## t$300 <- t$298 / t$299
                        movq -2400(%rbp), %r13
                        cmpq $0, %r13
           jne main_l15_div_ok
                        movq $string27, %r13
                        ## division by zero detected
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movq %r13, %rdi
           call cooloutstr
                        ## guarantee 16-byte alignment before call
           andq $0xFFFFFFFFFFFFFFF0, %rsp
           movl $0, %edi
           call exit
.global main_l15_div_ok
main_l15_div_ok:        ## division is okay 
                        movq -2392(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2408(%rbp)
                        ## t$301 <- t$297 - t$300
                        movq -2384(%rbp), %r13
                        movq -2408(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2416(%rbp)
                        ## (temp <- temp): t$11 <- t$301
                        movq -2416(%rbp), %r13
                        movq %r13, -96(%rbp)
                        ## (temp <- temp): t$302 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -2424(%rbp)
                        ## new String t$303 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2432(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$303 (pointer)
                        movq -2432(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$304 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2440(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2440(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$304
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$305 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2448(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2448(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$305
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$306 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2456(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2456(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$306
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$307 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2464(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2464(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$307
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$308 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2472(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2472(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$308
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$309 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2480(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2480(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$309
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$310 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2488(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2488(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$310
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$311 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2496(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2496(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$311
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$312 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2504(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2504(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$312
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## (temp <- temp): t$313 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -2512(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2512(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$313
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ##  obtain vtable for self object of type Main
                        movq  16(%r12), %r14
                        ##   look up out_int() at offset 7 in vtable
                        movq  56(%r14), %r14
                        call  *%r14
                        addq  $16, %rsp
                        popq  %rbp
                        popq  %r12
                        ## new String t$314 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2520(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$314 (pointer)
                        movq -2520(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$315 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2528(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$315 (pointer)
                        movq -2528(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$316 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2536(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$316 (pointer)
                        movq -2536(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$317 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2544(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$317 (pointer)
                        movq -2544(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$318 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2552(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$318 (pointer)
                        movq -2552(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$319 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2560(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$319 (pointer)
                        movq -2560(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$320 <- "Enter string: \n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string10 holds "Enter string: \n"
                        movq $string10, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2568(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$320 (pointer)
                        movq -2568(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## in_string(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up in_string() at offset 6 in vtable
                        movq  48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$17 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -144(%rbp)
                        ## (temp <- temp): t$321 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -2576(%rbp)
                        ## new String t$322 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2584(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$322 (pointer)
                        movq -2584(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## (temp <- temp): t$323 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -2592(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$323 (pointer)
                        movq -2592(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)
                        ## new String t$324 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2600(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$324 (pointer)
                        movq -2600(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r14
                        movq %r14, -8(%rbp)

.globl Main.main.end
Main.main.end:          ## method body ends
          ## return address handling
          movq %rbp, %rsp
          popq %rbp
          ret
          ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                         ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.concat
String.concat:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument s (String)
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r15
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r14
                        movq 24(%r12), %r13
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			movq %r14, %rsi
			call coolstrcat
			movq %rax, %r13
                        movq %r13, 24(%r15)
                        movq %r15, %r13
.globl String.concat.end
String.concat.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                            ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.length
String.length:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r14
                        movq 24(%r12), %r13
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			movl $0, %eax
			call coolstrlen
			movq %rax, %r13
                        movq %r13, 24(%r14)
                        movq %r14, %r13
.globl String.length.end
String.length.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                            ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.substr
String.substr:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[4] holds argument i (Int)
                        ## fp[3] holds argument l (Int)
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r15
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r14
                        movq 32(%rbp), %r13
                        movq 24(%r13), %r13
                        movq 24(%r12), %r12
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r12, %rdi
			movq %r13, %rsi
			movq %r14, %rdx
			call coolsubstr
			movq %rax, %r13
                        cmpq $0, %r13
			jne l3
                        movq $string11, %r13
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			call cooloutstr
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movl $0,  %edi
			call exit
.globl l3
l3:                     movq %r13, 24(%r15)
                        movq %r15, %r13
.globl String.substr.end
String.substr.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                       ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       ## global string constants
.globl the.empty.string
the.empty.string:			  # ""
.byte 0	


.globl percent.d
percent.d:			  # "%ld"
.byte 37	# '%'
.byte 108	# 'l'
.byte 100	# 'd'
.byte 0	


.globl percent.ld
percent.ld:			  # " %ld"
.byte 32	# ' '
.byte 37	# '%'
.byte 108	# 'l'
.byte 100	# 'd'
.byte 0	


.globl string1
string1:			  # "Bool"
.byte 66	# 'B'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 0	


.globl string2
string2:			  # "IO"
.byte 73	# 'I'
.byte 79	# 'O'
.byte 0	


.globl string3
string3:			  # "Int"
.byte 73	# 'I'
.byte 110	# 'n'
.byte 116	# 't'
.byte 0	


.globl string4
string4:			  # "Main"
.byte 77	# 'M'
.byte 97	# 'a'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 0	


.globl string5
string5:			  # "Object"
.byte 79	# 'O'
.byte 98	# 'b'
.byte 106	# 'j'
.byte 101	# 'e'
.byte 99	# 'c'
.byte 116	# 't'
.byte 0	


.globl string6
string6:			  # "String"
.byte 83	# 'S'
.byte 116	# 't'
.byte 114	# 'r'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 103	# 'g'
.byte 0	


.globl string7
string7:			  # "abort\n"
.byte 97	# 'a'
.byte 98	# 'b'
.byte 111	# 'o'
.byte 114	# 'r'
.byte 116	# 't'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string8
string8:			  # "Enter number: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 110	# 'n'
.byte 117	# 'u'
.byte 109	# 'm'
.byte 98	# 'b'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string9
string9:			  # "\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string10
string10:			  # "Enter string: \n"
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 115	# 's'
.byte 116	# 't'
.byte 114	# 'r'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 103	# 'g'
.byte 58	# ':'
.byte 32	# ' '
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string11
string11:			  # "ERROR: 0: Exception: String.substr out of range\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 48	# '0'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 83	# 'S'
.byte 116	# 't'
.byte 114	# 'r'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 103	# 'g'
.byte 46	# '.'
.byte 115	# 's'
.byte 117	# 'u'
.byte 98	# 'b'
.byte 115	# 's'
.byte 116	# 't'
.byte 114	# 'r'
.byte 32	# ' '
.byte 111	# 'o'
.byte 117	# 'u'
.byte 116	# 't'
.byte 32	# ' '
.byte 111	# 'o'
.byte 102	# 'f'
.byte 32	# ' '
.byte 114	# 'r'
.byte 97	# 'a'
.byte 110	# 'n'
.byte 103	# 'g'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string12
string12:			  # "ERROR: 24: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
.byte 52	# '4'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string13
string13:			  # "ERROR: 25: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
.byte 53	# '5'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string14
string14:			  # "ERROR: 26: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
.byte 54	# '6'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string15
string15:			  # "ERROR: 27: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
.byte 55	# '7'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string16
string16:			  # "ERROR: 28: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
.byte 56	# '8'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string17
string17:			  # "ERROR: 29: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
.byte 57	# '9'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string18
string18:			  # "ERROR: 30: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 51	# '3'
.byte 48	# '0'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string19
string19:			  # "ERROR: 32: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 51	# '3'
.byte 50	# '2'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string20
string20:			  # "ERROR: 53: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 51	# '3'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string21
string21:			  # "ERROR: 54: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 52	# '4'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string22
string22:			  # "ERROR: 55: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 53	# '5'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string23
string23:			  # "ERROR: 56: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 54	# '6'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string24
string24:			  # "ERROR: 57: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 55	# '7'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string25
string25:			  # "ERROR: 58: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 56	# '8'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string26
string26:			  # "ERROR: 59: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 53	# '5'
.byte 57	# '9'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string27
string27:			  # "ERROR: 61: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 54	# '6'
.byte 49	# '1'
.byte 58	# ':'
.byte 32	# ' '
.byte 69	# 'E'
.byte 120	# 'x'
.byte 99	# 'c'
.byte 101	# 'e'
.byte 112	# 'p'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 58	# ':'
.byte 32	# ' '
.byte 100	# 'd'
.byte 105	# 'i'
.byte 118	# 'v'
.byte 105	# 'i'
.byte 115	# 's'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 98	# 'b'
.byte 121	# 'y'
.byte 32	# ' '
.byte 122	# 'z'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 111	# 'o'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


                               ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl eq_handler
eq_handler:             ## helper function for =
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 32(%rbp), %r12
                        ## return address handling
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je eq_true
                        movq $0, %r15
                        cmpq %r15, %r13
			je eq_false
                        cmpq %r15, %r14
			je eq_false
                        movq 0(%r13), %r13
                        movq 0(%r14), %r14
                        ## place the sum of the type tags in r1
                        addq %r14, %r13
                        movq $0, %r14
                        cmpq %r14, %r13
			je eq_bool
                        movq $2, %r14
                        cmpq %r14, %r13
			je eq_int
                        movq $6, %r14
                        cmpq %r14, %r13
			je eq_string
                        ## otherwise, use pointer comparison
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je eq_true
.globl eq_false
eq_false:               ## not equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp eq_end
.globl eq_true
eq_true:                ## equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp eq_end
.globl eq_bool
eq_bool:                ## two Bools
.globl eq_int
eq_int:                 ## two Ints
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        cmpq %r14, %r13
			je eq_true
                        jmp eq_false
.globl eq_string
eq_string:              ## two Strings
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			movq %r14, %rsi
			call strcmp 
			cmp $0, %eax
			je eq_true
                        jmp eq_false
.globl eq_end
eq_end:                 ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl le_handler
le_handler:             ## helper function for <=
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 32(%rbp), %r12
                        ## return address handling
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je le_true
                        movq $0, %r15
                        cmpq %r15, %r13
			je le_false
                        cmpq %r15, %r14
			je le_false
                        movq 0(%r13), %r13
                        movq 0(%r14), %r14
                        ## place the sum of the type tags in r1
                        addq %r14, %r13
                        movq $0, %r14
                        cmpq %r14, %r13
			je le_bool
                        movq $2, %r14
                        cmpq %r14, %r13
			je le_int
                        movq $6, %r14
                        cmpq %r14, %r13
			je le_string
                        ## for non-primitives, equality is our only hope
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je le_true
.globl le_false
le_false:               ## not less-than-or-equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp le_end
.globl le_true
le_true:                ## less-than-or-equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp le_end
.globl le_bool
le_bool:                ## two Bools
.globl le_int
le_int:                 ## two Ints
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        cmpl %r14d, %r13d
			jle le_true
                        jmp le_false
.globl le_string
le_string:              ## two Strings
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			movq %r14, %rsi
			call strcmp 
			cmp $0, %eax
			jle le_true
                        jmp le_false
.globl le_end
le_end:                 ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl lt_handler
lt_handler:             ## helper function for <
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 32(%rbp), %r12
                        ## return address handling
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq $0, %r15
                        cmpq %r15, %r13
			je lt_false
                        cmpq %r15, %r14
			je lt_false
                        movq 0(%r13), %r13
                        movq 0(%r14), %r14
                        ## place the sum of the type tags in r1
                        addq %r14, %r13
                        movq $0, %r14
                        cmpq %r14, %r13
			je lt_bool
                        movq $2, %r14
                        cmpq %r14, %r13
			je lt_int
                        movq $6, %r14
                        cmpq %r14, %r13
			je lt_string
                        ## for non-primitives, < is always false
.globl lt_false
lt_false:               ## not less than
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp lt_end
.globl lt_true
lt_true:                ## less than
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp lt_end
.globl lt_bool
lt_bool:                ## two Bools
.globl lt_int
lt_int:                 ## two Ints
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        cmpl %r14d, %r13d
			jl lt_true
                        jmp lt_false
.globl lt_string
lt_string:              ## two Strings
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movq %r13, %rdi
			movq %r14, %rsi
			call strcmp 
			cmp $0, %eax
			jl lt_true
                        jmp lt_false
.globl lt_end
lt_end:                 ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl start
start:                  ## program begins here
                        .globl main
			.type main, @function
main:
                        movq $Main..new, %r14
                        pushq %rbp
                        call *%r14
                        pushq %rbp
                        pushq %r13
                        movq $Main.main, %r14
                        call *%r14
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
			movl $0, %edi
			call exit
                        
	.globl	cooloutstr
	.type	cooloutstr, @function
cooloutstr:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L2
.L5:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L3
	movl	-4(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$110, %al
	jne	.L3
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	addl	$2, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L4
	movl	-4(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$116, %al
	jne	.L4
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$9, %edi
	call	fputc@PLT
	addl	$2, -4(%rbp)
	jmp	.L2
.L4:
	movq	stdout(%rip), %rdx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fputc@PLT
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L5
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	cooloutstr, .-cooloutstr
	.globl	coolstrlen
	.type	coolstrlen, @function
coolstrlen:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L7
.L8:
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -4(%rbp)
.L7:
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L8
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	coolstrlen, .-coolstrlen
	.section	.rodata
.LC0:
	.string	"%s%s"
	.text
	.globl	coolstrcat
	.type	coolstrcat, @function
coolstrcat:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L11
	movq	-48(%rbp), %rax
	jmp	.L12
.L11:
	cmpq	$0, -48(%rbp)
	jne	.L13
	movq	-40(%rbp), %rax
	jmp	.L12
.L13:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	movl	%eax, %ebx
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	addl	%ebx, %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	cltq
	movl	$1, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, -24(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rsi
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	.LC0(%rip), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movq	-24(%rbp), %rax
.L12:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	coolstrcat, .-coolstrcat
	.globl	coolgetstr
	.type	coolgetstr, @function
coolgetstr:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movq	stdin(%rip), %rdx
	leaq	-24(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	getline@PLT
	movq	%rax, -16(%rbp)
	cmpq	$-1, -16(%rbp)
	je	.L15
	movq	-32(%rbp), %rax
	testq	%rax, %rax
	jne	.L16
.L15:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %edi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movb	$0, (%rax)
	jmp	.L17
.L16:
	movq	-16(%rbp), %rdx
	movq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memchr@PLT
	testq	%rax, %rax
	je	.L18
	movq	-32(%rbp), %rax
	movb	$0, (%rax)
	jmp	.L17
.L18:
	movq	-32(%rbp), %rdx
	movq	-16(%rbp), %rax
	subq	$1, %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	jne	.L17
	movq	-32(%rbp), %rdx
	subq	$1, -16(%rbp)
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
.L17:
	movq	-32(%rbp), %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L20
	call	__stack_chk_fail@PLT
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	coolgetstr, .-coolgetstr
	.globl	coolsubstr
	.type	coolsubstr, @function
coolsubstr:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	movl	%eax, -4(%rbp)
	cmpq	$0, -32(%rbp)
	js	.L22
	cmpq	$0, -40(%rbp)
	js	.L22
	movq	-32(%rbp), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	jle	.L23
.L22:
	movl	$0, %eax
	jmp	.L24
.L23:
	movq	-40(%rbp), %rax
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strndup@PLT
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	coolsubstr, .-coolsubstr
	.globl	coolinint
	.type	coolinint, @function
coolinint:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$304, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	stdin(%rip), %rdx
	leaq	-272(%rbp), %rax
	movl	$256, %esi
	movq	%rax, %rdi
	call	fgets@PLT
	testq	%rax, %rax
	jne	.L26
	movl	$0, %eax
	jmp	.L37
.L26:
	leaq	-272(%rbp), %rax
	movq	%rax, -288(%rbp)
	jmp	.L28
.L29:
	addq	$1, -288(%rbp)
.L28:
	call	__ctype_b_loc@PLT
	movq	(%rax), %rdx
	movq	-288(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addq	%rax, %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$8192, %eax
	testl	%eax, %eax
	jne	.L29
	movq	-288(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L30
	movq	-288(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	je	.L31
	movq	-288(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	je	.L31
	call	__ctype_b_loc@PLT
	movq	(%rax), %rdx
	movq	-288(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addq	%rax, %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	jne	.L31
.L30:
	movl	$0, %eax
	jmp	.L37
.L31:
	leaq	-296(%rbp), %rcx
	movq	-288(%rbp), %rax
	movl	$10, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strtol@PLT
	movq	%rax, -280(%rbp)
	movabsq	$-2147483649, %rax
	cmpq	%rax, -280(%rbp)
	jle	.L32
	movl	$2147483648, %eax
	cmpq	%rax, -280(%rbp)
	jl	.L34
.L32:
	movl	$0, %eax
	jmp	.L37
.L36:
	movq	-296(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -296(%rbp)
.L34:
	movq	-296(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L35
	movq	-296(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	jne	.L36
.L35:
	movq	-280(%rbp), %rax
.L37:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L38
	call	__stack_chk_fail@PLT
.L38:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	coolinint, .-coolinint
