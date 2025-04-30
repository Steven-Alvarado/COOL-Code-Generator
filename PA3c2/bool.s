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
						## stack room for temporaries: 160
						movq $1280, %r14
						subq %r14, %rsp
						## return address handling
						## method body begins
                        ## Basic block: BB0
                        ##t$0 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## (temp <- temp): t$1 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -16(%rbp)
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
                        ## (temp <- temp): t$3 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -32(%rbp)
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
                        ## (temp <- temp): t$5 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ##t$6 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$7 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ##t$8 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -72(%rbp)
                        ## (temp <- temp): t$9 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ##t$10 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -88(%rbp)
                        ## (temp <- temp): t$11 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -96(%rbp)
                        ##t$12 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -104(%rbp)
                        ## (temp <- temp): t$13 <- t$12
                        movq -104(%rbp), %r13
                        movq %r13, -112(%rbp)
                        ## new String t$14 <- "Enter an integer value for x: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string8 holds "Enter an integer value for x: "
                        movq $string8, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -120(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$14 (pointer)
                        movq -120(%rbp), %r13
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
                        ## (temp <- temp): t$15 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -128(%rbp)
                        ## new String t$16 <- "Enter an integer value for y: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "Enter an integer value for y: "
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -136(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$16 (pointer)
                        movq -136(%rbp), %r13
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
                        ## (temp <- temp): t$2 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$17 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -144(%rbp)
                        ## new String t$18 <- "Enter a string: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string10 holds "Enter a string: "
                        movq $string10, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -152(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$18 (pointer)
                        movq -152(%rbp), %r13
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
                        ## (temp <- temp): t$4 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$19 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -160(%rbp)
                        ## (temp <- temp): t$20 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -168(%rbp)
                        ## (temp <- temp): t$21 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -176(%rbp)
                        ## t$22 <- t$20 * t$21
                        movq -168(%rbp), %r13
                        movq -176(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -184(%rbp)
                        ## t$23 <- -t$22
                        movq -184(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -192(%rbp)
                        ## (temp <- temp): t$24 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -200(%rbp)
                        ## (temp <- temp): t$25 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -208(%rbp)
                        ## t$26 <- t$24 / t$25
                        movq -208(%rbp), %r13
                        cmpq $0, %r13
           jne main_l36_div_ok
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
.global main_l36_div_ok
main_l36_div_ok:        ## division is okay 
                        movq -200(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -216(%rbp)
                        ## (temp <- temp): t$27 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -224(%rbp)
                        ## (temp <- temp): t$28 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -232(%rbp)
                        ## t$29 <- t$27 - t$28
                        movq -224(%rbp), %r13
                        movq -232(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -240(%rbp)
                        ## t$30 <- t$26 * t$29
                        movq -216(%rbp), %r13
                        movq -240(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -248(%rbp)
                        ## t$31 <- t$23 + t$30
                        movq -192(%rbp), %r13
                        movq -248(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -256(%rbp)
                        ## (temp <- temp): t$3 <- t$31
                        movq -256(%rbp), %r13
                        movq %r13, -32(%rbp)
                        ## (temp <- temp): t$32 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -264(%rbp)
                        ## (temp <- temp): t$33 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -272(%rbp)
                        ## (temp <- temp): t$34 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -280(%rbp)
                        ## t$35 <- t$33 < t$34 
                        pushq %r12
                        pushq %rbp
                        ## t$33
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -272(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$34
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -280(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        movq %r13, -288(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$36 <- not t$35
                        movq -288(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l37_true
.globl main_l38_false
main_l38_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l39_end
.globl main_l37_true
main_l37_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l39_end
main_l39_end:            ## end of if conditional
                        movq %r13, -296(%rbp)
                        ## (temp <- temp): t$5 <- t$36
                        movq -296(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ## (temp <- temp): t$37 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -304(%rbp)
                        ## (temp <- temp): t$38 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -312(%rbp)
                        ## (temp <- temp): t$39 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -320(%rbp)
                        ## t$40 <- t$38 + t$39
                        movq -312(%rbp), %r13
                        movq -320(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -328(%rbp)
                        ## (temp <- temp): t$41 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -336(%rbp)
                        ## (temp <- temp): t$42 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -344(%rbp)
                        ## t$43 <- t$41 * t$42
                        movq -336(%rbp), %r13
                        movq -344(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -352(%rbp)
                        ## t$44 <- t$40 <= t$43 
                        pushq %r12
                        pushq %rbp
                        ## t$40
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -328(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$43
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -352(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call le_handler
                        addq $24, %rsp
                        movq %r13, -360(%rbp)
                        popq %rbp
                        popq %r12
                        ## (temp <- temp): t$6 <- t$44
                        movq -360(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$45 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -368(%rbp)
                        ## (temp <- temp): t$46 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -376(%rbp)
                        ## (temp <- temp): t$47 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -384(%rbp)
                        ## t$48 <- t$46 = t$47 
                        pushq %r12
                        pushq %rbp
                        ## t$46
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -376(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$47
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -384(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        movq %r13, -392(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$49 <- not t$48
                        movq -392(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l40_true
.globl main_l41_false
main_l41_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l42_end
.globl main_l40_true
main_l40_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l42_end
main_l42_end:            ## end of if conditional
                        movq %r13, -400(%rbp)
                        ## t$50 <- not t$49
                        movq -400(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l43_true
.globl main_l44_false
main_l44_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l45_end
.globl main_l43_true
main_l43_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l45_end
main_l45_end:            ## end of if conditional
                        movq %r13, -408(%rbp)
                        ## (temp <- temp): t$7 <- t$50
                        movq -408(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ## (temp <- temp): t$51 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -416(%rbp)
                        ## new String t$52 <- "You entered: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "You entered: "
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -424(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$52 (pointer)
                        movq -424(%rbp), %r13
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
                        ## (temp <- temp): t$53 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -432(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$53 (pointer)
                        movq -432(%rbp), %r13
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
                        ## new String t$54 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string12 holds "\n"
                        movq $string12, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -440(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$54 (pointer)
                        movq -440(%rbp), %r13
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
                        ## (temp <- temp): t$55 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -448(%rbp)
                        ## t$56 <- not t$55
                        movq -448(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l46_true
.globl main_l47_false
main_l47_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l48_end
.globl main_l46_true
main_l46_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l48_end
main_l48_end:            ## end of if conditional
                        movq %r13, -456(%rbp)
                        ## if t$56 jump to main_l1
                        movq -456(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l1
                        ## Basic block: BB1
                        ## if t$55 jump to main_l0
                        movq -448(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l0
                        ## Basic block: BB2
                        ## then branch
                        ## Basic block: BB3
.globl main_l0
main_l0:
                        ## (temp <- temp): t$57 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -464(%rbp)
                        ## t$58 <- not t$57
                        movq -464(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l49_true
.globl main_l50_false
main_l50_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l51_end
.globl main_l49_true
main_l49_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l51_end
main_l51_end:            ## end of if conditional
                        movq %r13, -472(%rbp)
                        ## if t$58 jump to main_l4
                        movq -472(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l4
                        ## Basic block: BB4
                        ## if t$57 jump to main_l3
                        movq -464(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l3
                        ## Basic block: BB5
                        ## then branch
                        ## Basic block: BB6
.globl main_l3
main_l3:
                        ## new String t$59 <- "Path 1: b1 true, b2 true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string13 holds "Path 1: b1 true, b2 true\n"
                        movq $string13, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -480(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$59 (pointer)
                        movq -480(%rbp), %r13
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
                        ## (temp <- temp): t$61 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -496(%rbp)
                        ## unconditional jump to main_l5
                        jmp main_l5
                        ## Basic block: BB7
                        ## else branch
                        ## Basic block: BB8
.globl main_l4
main_l4:
                        ## new String t$60 <- "Path 2: b1 true, b2 false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string14 holds "Path 2: b1 true, b2 false\n"
                        movq $string14, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -488(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$60 (pointer)
                        movq -488(%rbp), %r13
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
                        ## (temp <- temp): t$61 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -496(%rbp)
                        ## unconditional jump to main_l5
                        jmp main_l5
                        ## Basic block: BB9
                        ## if-join
                        ## Basic block: BB10
.globl main_l5
main_l5:
                        ## (temp <- temp): t$62 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -504(%rbp)
                        ## t$63 <- not t$62
                        movq -504(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l52_true
.globl main_l53_false
main_l53_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l54_end
.globl main_l52_true
main_l52_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l54_end
main_l54_end:            ## end of if conditional
                        movq %r13, -512(%rbp)
                        ## t$64 <- not t$63
                        movq -512(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l55_true
.globl main_l56_false
main_l56_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l57_end
.globl main_l55_true
main_l55_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l57_end
main_l57_end:            ## end of if conditional
                        movq %r13, -520(%rbp)
                        ## if t$64 jump to main_l7
                        movq -520(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l7
                        ## Basic block: BB11
                        ## if t$63 jump to main_l6
                        movq -512(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l6
                        ## Basic block: BB12
                        ## then branch
                        ## Basic block: BB13
.globl main_l6
main_l6:
                        ## (temp <- temp): t$65 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -528(%rbp)
                        ## new int t$66 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -536(%rbp)
                        ## t$67 <- t$65 * t$66
                        movq -528(%rbp), %r13
                        movq -536(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -544(%rbp)
                        ## (temp <- temp): t$71 <- t$67
                        movq -544(%rbp), %r13
                        movq %r13, -576(%rbp)
                        ## unconditional jump to main_l8
                        jmp main_l8
                        ## Basic block: BB14
                        ## else branch
                        ## Basic block: BB15
.globl main_l7
main_l7:
                        ## (temp <- temp): t$68 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -552(%rbp)
                        ## new int t$69 <- 1
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -560(%rbp)
                        ## t$70 <- t$68 - t$69
                        movq -552(%rbp), %r13
                        movq -560(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -568(%rbp)
                        ## (temp <- temp): t$71 <- t$70
                        movq -568(%rbp), %r13
                        movq %r13, -576(%rbp)
                        ## unconditional jump to main_l8
                        jmp main_l8
                        ## Basic block: BB16
                        ## if-join
                        ## Basic block: BB17
.globl main_l8
main_l8:
                        ## (temp <- temp): t$1 <- t$71
                        movq -576(%rbp), %r13
                        movq %r13, -16(%rbp)
                        ## (temp <- temp): t$72 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -584(%rbp)
                        ## (temp <- temp): t$89 <- t$72
                        movq -584(%rbp), %r13
                        movq %r13, -720(%rbp)
                        ## unconditional jump to main_l2
                        jmp main_l2
                        ## Basic block: BB18
                        ## else branch
                        ## Basic block: BB19
.globl main_l1
main_l1:
                        ## (temp <- temp): t$73 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -592(%rbp)
                        ## t$74 <- not t$73
                        movq -592(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l58_true
.globl main_l59_false
main_l59_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l60_end
.globl main_l58_true
main_l58_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l60_end
main_l60_end:            ## end of if conditional
                        movq %r13, -600(%rbp)
                        ## t$75 <- not t$74
                        movq -600(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l61_true
.globl main_l62_false
main_l62_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l63_end
.globl main_l61_true
main_l61_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l63_end
main_l63_end:            ## end of if conditional
                        movq %r13, -608(%rbp)
                        ## if t$75 jump to main_l10
                        movq -608(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l10
                        ## Basic block: BB20
                        ## if t$74 jump to main_l9
                        movq -600(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l9
                        ## Basic block: BB21
                        ## then branch
                        ## Basic block: BB22
.globl main_l9
main_l9:
                        ## new String t$76 <- "Path 3: b1 false, b2 false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds "Path 3: b1 false, b2 false\n"
                        movq $string15, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -616(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$76 (pointer)
                        movq -616(%rbp), %r13
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
                        ## (temp <- temp): t$78 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -632(%rbp)
                        ## unconditional jump to main_l11
                        jmp main_l11
                        ## Basic block: BB23
                        ## else branch
                        ## Basic block: BB24
.globl main_l10
main_l10:
                        ## new String t$77 <- "Path 4: b1 false, b2 true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string16 holds "Path 4: b1 false, b2 true\n"
                        movq $string16, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -624(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$77 (pointer)
                        movq -624(%rbp), %r13
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
                        ## (temp <- temp): t$78 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -632(%rbp)
                        ## unconditional jump to main_l11
                        jmp main_l11
                        ## Basic block: BB25
                        ## if-join
                        ## Basic block: BB26
.globl main_l11
main_l11:
                        ## (temp <- temp): t$79 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -640(%rbp)
                        ## t$80 <- not t$79
                        movq -640(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l64_true
.globl main_l65_false
main_l65_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l66_end
.globl main_l64_true
main_l64_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l66_end
main_l66_end:            ## end of if conditional
                        movq %r13, -648(%rbp)
                        ## if t$80 jump to main_l13
                        movq -648(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l13
                        ## Basic block: BB27
                        ## if t$79 jump to main_l12
                        movq -640(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l12
                        ## Basic block: BB28
                        ## then branch
                        ## Basic block: BB29
.globl main_l12
main_l12:
                        ## (temp <- temp): t$81 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -656(%rbp)
                        ## new int t$82 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -664(%rbp)
                        ## t$83 <- t$81 * t$82
                        movq -656(%rbp), %r13
                        movq -664(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -672(%rbp)
                        ## (temp <- temp): t$87 <- t$83
                        movq -672(%rbp), %r13
                        movq %r13, -704(%rbp)
                        ## unconditional jump to main_l14
                        jmp main_l14
                        ## Basic block: BB30
                        ## else branch
                        ## Basic block: BB31
.globl main_l13
main_l13:
                        ## (temp <- temp): t$84 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -680(%rbp)
                        ## new int t$85 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -688(%rbp)
                        ## t$86 <- t$84 - t$85
                        movq -680(%rbp), %r13
                        movq -688(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -696(%rbp)
                        ## (temp <- temp): t$87 <- t$86
                        movq -696(%rbp), %r13
                        movq %r13, -704(%rbp)
                        ## unconditional jump to main_l14
                        jmp main_l14
                        ## Basic block: BB32
                        ## if-join
                        ## Basic block: BB33
.globl main_l14
main_l14:
                        ## (temp <- temp): t$2 <- t$87
                        movq -704(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$88 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -712(%rbp)
                        ## (temp <- temp): t$89 <- t$88
                        movq -712(%rbp), %r13
                        movq %r13, -720(%rbp)
                        ## unconditional jump to main_l2
                        jmp main_l2
                        ## Basic block: BB34
                        ## if-join
                        ## Basic block: BB35
.globl main_l2
main_l2:
                        ## (temp <- temp): t$90 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -728(%rbp)
                        ## (temp <- temp): t$91 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -736(%rbp)
                        ## t$92 <- -t$91
                        movq -736(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -744(%rbp)
                        ## t$93 <- t$90 * t$92
                        movq -728(%rbp), %r13
                        movq -744(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -752(%rbp)
                        ## (temp <- temp): t$94 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -760(%rbp)
                        ## t$95 <- not t$94
                        movq -760(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l67_true
.globl main_l68_false
main_l68_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l69_end
.globl main_l67_true
main_l67_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l69_end
main_l69_end:            ## end of if conditional
                        movq %r13, -768(%rbp)
                        ## if t$95 jump to main_l16
                        movq -768(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l16
                        ## Basic block: BB36
                        ## if t$94 jump to main_l15
                        movq -760(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l15
                        ## Basic block: BB37
                        ## then branch
                        ## Basic block: BB38
.globl main_l15
main_l15:
                        ## (temp <- temp): t$96 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -776(%rbp)
                        ## (temp <- temp): t$98 <- t$96
                        movq -776(%rbp), %r13
                        movq %r13, -792(%rbp)
                        ## unconditional jump to main_l17
                        jmp main_l17
                        ## Basic block: BB39
                        ## else branch
                        ## Basic block: BB40
.globl main_l16
main_l16:
                        ## (temp <- temp): t$97 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -784(%rbp)
                        ## (temp <- temp): t$98 <- t$97
                        movq -784(%rbp), %r13
                        movq %r13, -792(%rbp)
                        ## unconditional jump to main_l17
                        jmp main_l17
                        ## Basic block: BB41
                        ## if-join
                        ## Basic block: BB42
.globl main_l17
main_l17:
                        ## t$99 <- t$93 + t$98
                        movq -752(%rbp), %r13
                        movq -792(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -800(%rbp)
                        ## (temp <- temp): t$3 <- t$99
                        movq -800(%rbp), %r13
                        movq %r13, -32(%rbp)
                        ## (temp <- temp): t$100 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -808(%rbp)
                        ## new String t$101 <- "Final values:\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string17 holds "Final values:\n"
                        movq $string17, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -816(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$101 (pointer)
                        movq -816(%rbp), %r13
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
                        ## new String t$102 <- "x = "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string18 holds "x = "
                        movq $string18, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -824(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$102 (pointer)
                        movq -824(%rbp), %r13
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
                        ## (temp <- temp): t$103 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -832(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -832(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$103
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
                        ## new String t$104 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string12 holds "\n"
                        movq $string12, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -840(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$104 (pointer)
                        movq -840(%rbp), %r13
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
                        ## new String t$105 <- "y = "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string19 holds "y = "
                        movq $string19, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -848(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$105 (pointer)
                        movq -848(%rbp), %r13
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
                        ## (temp <- temp): t$106 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -856(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -856(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$106
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
                        ## new String t$107 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string12 holds "\n"
                        movq $string12, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -864(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$107 (pointer)
                        movq -864(%rbp), %r13
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
                        ## new String t$108 <- "z = "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string20 holds "z = "
                        movq $string20, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -872(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$108 (pointer)
                        movq -872(%rbp), %r13
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
                        ## (temp <- temp): t$109 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -880(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -880(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$109
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
                        ## new String t$110 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string12 holds "\n"
                        movq $string12, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -888(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$110 (pointer)
                        movq -888(%rbp), %r13
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
                        ## (temp <- temp): t$111 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -896(%rbp)
                        ## new int t$112 <- 10
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -904(%rbp)
                        ## t$113 <- t$111 < t$112 
                        pushq %r12
                        pushq %rbp
                        ## t$111
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -896(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$112
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -904(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        movq %r13, -912(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$114 <- not t$113
                        movq -912(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l70_true
.globl main_l71_false
main_l71_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l72_end
.globl main_l70_true
main_l70_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l72_end
main_l72_end:            ## end of if conditional
                        movq %r13, -920(%rbp)
                        ## if t$114 jump to main_l19
                        movq -920(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l19
                        ## Basic block: BB43
                        ## if t$113 jump to main_l18
                        movq -912(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l18
                        ## Basic block: BB44
                        ## then branch
                        ## Basic block: BB45
.globl main_l18
main_l18:
                        ## (temp <- temp): t$115 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -928(%rbp)
                        ## new int t$116 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -936(%rbp)
                        ## t$117 <- t$115 < t$116 
                        pushq %r12
                        pushq %rbp
                        ## t$115
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -928(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$116
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -936(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        movq %r13, -944(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$118 <- not t$117
                        movq -944(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l73_true
.globl main_l74_false
main_l74_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l75_end
.globl main_l73_true
main_l73_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l75_end
main_l75_end:            ## end of if conditional
                        movq %r13, -952(%rbp)
                        ## if t$118 jump to main_l22
                        movq -952(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l22
                        ## Basic block: BB46
                        ## if t$117 jump to main_l21
                        movq -944(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l21
                        ## Basic block: BB47
                        ## then branch
                        ## Basic block: BB48
.globl main_l21
main_l21:
                        ## (temp <- temp): t$119 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -960(%rbp)
                        ## (temp <- temp): t$120 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -968(%rbp)
                        ## t$121 <- t$119 * t$120
                        movq -960(%rbp), %r13
                        movq -968(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -976(%rbp)
                        ## (temp <- temp): t$125 <- t$121
                        movq -976(%rbp), %r13
                        movq %r13, -1008(%rbp)
                        ## unconditional jump to main_l23
                        jmp main_l23
                        ## Basic block: BB49
                        ## else branch
                        ## Basic block: BB50
.globl main_l22
main_l22:
                        ## (temp <- temp): t$122 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -984(%rbp)
                        ## (temp <- temp): t$123 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -992(%rbp)
                        ## t$124 <- t$122 + t$123
                        movq -984(%rbp), %r13
                        movq -992(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1000(%rbp)
                        ## (temp <- temp): t$125 <- t$124
                        movq -1000(%rbp), %r13
                        movq %r13, -1008(%rbp)
                        ## unconditional jump to main_l23
                        jmp main_l23
                        ## Basic block: BB51
                        ## if-join
                        ## Basic block: BB52
.globl main_l23
main_l23:
                        ## (temp <- temp): t$137 <- t$125
                        movq -1008(%rbp), %r13
                        movq %r13, -1104(%rbp)
                        ## unconditional jump to main_l20
                        jmp main_l20
                        ## Basic block: BB53
                        ## else branch
                        ## Basic block: BB54
.globl main_l19
main_l19:
                        ## (temp <- temp): t$126 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1016(%rbp)
                        ## (temp <- temp): t$127 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1024(%rbp)
                        ## t$128 <- t$126 = t$127 
                        pushq %r12
                        pushq %rbp
                        ## t$126
                        movq -1016(%rbp), %r13
                        pushq %r13
                        ## t$127
                        movq -1024(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        movq %r13, -1032(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$129 <- not t$128
                        movq -1032(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l76_true
.globl main_l77_false
main_l77_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l78_end
.globl main_l76_true
main_l76_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l78_end
main_l78_end:            ## end of if conditional
                        movq %r13, -1040(%rbp)
                        ## if t$129 jump to main_l25
                        movq -1040(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l25
                        ## Basic block: BB55
                        ## if t$128 jump to main_l24
                        movq -1032(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l24
                        ## Basic block: BB56
                        ## then branch
                        ## Basic block: BB57
.globl main_l24
main_l24:
                        ## (temp <- temp): t$130 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1048(%rbp)
                        ## (temp <- temp): t$131 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1056(%rbp)
                        ## t$132 <- t$130 - t$131
                        movq -1048(%rbp), %r13
                        movq -1056(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1064(%rbp)
                        ## (temp <- temp): t$136 <- t$132
                        movq -1064(%rbp), %r13
                        movq %r13, -1096(%rbp)
                        ## unconditional jump to main_l26
                        jmp main_l26
                        ## Basic block: BB58
                        ## else branch
                        ## Basic block: BB59
.globl main_l25
main_l25:
                        ## (temp <- temp): t$133 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1072(%rbp)
                        ## (temp <- temp): t$134 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1080(%rbp)
                        ## t$135 <- t$133 / t$134
                        movq -1080(%rbp), %r13
                        cmpq $0, %r13
           jne main_l79_div_ok
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
.global main_l79_div_ok
main_l79_div_ok:        ## division is okay 
                        movq -1072(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1088(%rbp)
                        ## (temp <- temp): t$136 <- t$135
                        movq -1088(%rbp), %r13
                        movq %r13, -1096(%rbp)
                        ## unconditional jump to main_l26
                        jmp main_l26
                        ## Basic block: BB60
                        ## if-join
                        ## Basic block: BB61
.globl main_l26
main_l26:
                        ## (temp <- temp): t$137 <- t$136
                        movq -1096(%rbp), %r13
                        movq %r13, -1104(%rbp)
                        ## unconditional jump to main_l20
                        jmp main_l20
                        ## Basic block: BB62
                        ## if-join
                        ## Basic block: BB63
.globl main_l20
main_l20:
                        ## (temp <- temp): t$138 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1112(%rbp)
                        ## t$139 <- not t$138
                        movq -1112(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l80_true
.globl main_l81_false
main_l81_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l82_end
.globl main_l80_true
main_l80_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l82_end
main_l82_end:            ## end of if conditional
                        movq %r13, -1120(%rbp)
                        ## if t$139 jump to main_l28
                        movq -1120(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l28
                        ## Basic block: BB64
                        ## if t$138 jump to main_l27
                        movq -1112(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l27
                        ## Basic block: BB65
                        ## then branch
                        ## Basic block: BB66
.globl main_l27
main_l27:
                        ## new int t$140 <- 100
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $100, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1128(%rbp)
                        ## (temp <- temp): t$142 <- t$140
                        movq -1128(%rbp), %r13
                        movq %r13, -1144(%rbp)
                        ## unconditional jump to main_l29
                        jmp main_l29
                        ## Basic block: BB67
                        ## else branch
                        ## Basic block: BB68
.globl main_l28
main_l28:
                        ## new int t$141 <- 200
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $200, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1136(%rbp)
                        ## (temp <- temp): t$142 <- t$141
                        movq -1136(%rbp), %r13
                        movq %r13, -1144(%rbp)
                        ## unconditional jump to main_l29
                        jmp main_l29
                        ## Basic block: BB69
                        ## if-join
                        ## Basic block: BB70
.globl main_l29
main_l29:
                        ## t$143 <- t$137 + t$142
                        movq -1104(%rbp), %r13
                        movq -1144(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1152(%rbp)
                        ## (temp <- temp): t$3 <- t$143
                        movq -1152(%rbp), %r13
                        movq %r13, -32(%rbp)
                        ## (temp <- temp): t$144 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -1160(%rbp)
                        ## new String t$145 <- "New z value: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string21 holds "New z value: "
                        movq $string21, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1168(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$145 (pointer)
                        movq -1168(%rbp), %r13
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
                        ## (temp <- temp): t$146 <- t$3
                        movq -32(%rbp), %r13
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
                        ## new String t$147 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string12 holds "\n"
                        movq $string12, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1184(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$147 (pointer)
                        movq -1184(%rbp), %r13
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
                        ## (temp <- temp): t$148 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1192(%rbp)
                        ## t$149 <- not t$148
                        movq -1192(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l83_true
.globl main_l84_false
main_l84_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l85_end
.globl main_l83_true
main_l83_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l85_end
main_l85_end:            ## end of if conditional
                        movq %r13, -1200(%rbp)
                        ## if t$149 jump to main_l31
                        movq -1200(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l31
                        ## Basic block: BB71
                        ## if t$148 jump to main_l30
                        movq -1192(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l30
                        ## Basic block: BB72
                        ## then branch
                        ## Basic block: BB73
.globl main_l30
main_l30:
                        ## (temp <- temp): t$150 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1208(%rbp)
                        ## t$151 <- not t$150
                        movq -1208(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l86_true
.globl main_l87_false
main_l87_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l88_end
.globl main_l86_true
main_l86_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l88_end
main_l88_end:            ## end of if conditional
                        movq %r13, -1216(%rbp)
                        ## (temp <- temp): t$153 <- t$151
                        movq -1216(%rbp), %r13
                        movq %r13, -1232(%rbp)
                        ## unconditional jump to main_l32
                        jmp main_l32
                        ## Basic block: BB74
                        ## else branch
                        ## Basic block: BB75
.globl main_l31
main_l31:
                        ## (temp <- temp): t$152 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1224(%rbp)
                        ## (temp <- temp): t$153 <- t$152
                        movq -1224(%rbp), %r13
                        movq %r13, -1232(%rbp)
                        ## unconditional jump to main_l32
                        jmp main_l32
                        ## Basic block: BB76
                        ## if-join
                        ## Basic block: BB77
.globl main_l32
main_l32:
                        ## t$154 <- not t$153
                        movq -1232(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l89_true
.globl main_l90_false
main_l90_false:
                        ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp main_l91_end
.globl main_l89_true
main_l89_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l91_end
main_l91_end:            ## end of if conditional
                        movq %r13, -1240(%rbp)
                        ## if t$154 jump to main_l34
                        movq -1240(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l34
                        ## Basic block: BB78
                        ## if t$153 jump to main_l33
                        movq -1232(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l33
                        ## Basic block: BB79
                        ## then branch
                        ## Basic block: BB80
.globl main_l33
main_l33:
                        ## new String t$155 <- "Complex condition true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "Complex condition true\n"
                        movq $string22, %r14
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
                        ## (temp <- temp): t$156 <- t$4
                        movq -40(%rbp), %r13
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
                        ## (temp <- temp): t$159 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -1280(%rbp)
                        ## unconditional jump to main_l35
                        jmp main_l35
                        ## Basic block: BB81
                        ## else branch
                        ## Basic block: BB82
.globl main_l34
main_l34:
                        ## new String t$157 <- "Complex condition false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string23 holds "Complex condition false\n"
                        movq $string23, %r14
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
                        ## (temp <- temp): t$158 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1272(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$158 (pointer)
                        movq -1272(%rbp), %r13
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
                        ## (temp <- temp): t$159 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -1280(%rbp)
                        ## unconditional jump to main_l35
                        jmp main_l35
                        ## Basic block: BB83
                        ## if-join
                        ## Basic block: BB84
.globl main_l35
main_l35:

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
                        movq $string24, %r13
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
string8:			  # "Enter an integer value for x: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 97	# 'a'
.byte 110	# 'n'
.byte 32	# ' '
.byte 105	# 'i'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 103	# 'g'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 118	# 'v'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 32	# ' '
.byte 102	# 'f'
.byte 111	# 'o'
.byte 114	# 'r'
.byte 32	# ' '
.byte 120	# 'x'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string9
string9:			  # "Enter an integer value for y: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 97	# 'a'
.byte 110	# 'n'
.byte 32	# ' '
.byte 105	# 'i'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 103	# 'g'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 118	# 'v'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 32	# ' '
.byte 102	# 'f'
.byte 111	# 'o'
.byte 114	# 'r'
.byte 32	# ' '
.byte 121	# 'y'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string10
string10:			  # "Enter a string: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 97	# 'a'
.byte 32	# ' '
.byte 115	# 's'
.byte 116	# 't'
.byte 114	# 'r'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 103	# 'g'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string11
string11:			  # "You entered: "
.byte 89	# 'Y'
.byte 111	# 'o'
.byte 117	# 'u'
.byte 32	# ' '
.byte 101	# 'e'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 101	# 'e'
.byte 100	# 'd'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string12
string12:			  # "\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string13
string13:			  # "Path 1: b1 true, b2 true\n"
.byte 80	# 'P'
.byte 97	# 'a'
.byte 116	# 't'
.byte 104	# 'h'
.byte 32	# ' '
.byte 49	# '1'
.byte 58	# ':'
.byte 32	# ' '
.byte 98	# 'b'
.byte 49	# '1'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 44	# ','
.byte 32	# ' '
.byte 98	# 'b'
.byte 50	# '2'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string14
string14:			  # "Path 2: b1 true, b2 false\n"
.byte 80	# 'P'
.byte 97	# 'a'
.byte 116	# 't'
.byte 104	# 'h'
.byte 32	# ' '
.byte 50	# '2'
.byte 58	# ':'
.byte 32	# ' '
.byte 98	# 'b'
.byte 49	# '1'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 44	# ','
.byte 32	# ' '
.byte 98	# 'b'
.byte 50	# '2'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string15
string15:			  # "Path 3: b1 false, b2 false\n"
.byte 80	# 'P'
.byte 97	# 'a'
.byte 116	# 't'
.byte 104	# 'h'
.byte 32	# ' '
.byte 51	# '3'
.byte 58	# ':'
.byte 32	# ' '
.byte 98	# 'b'
.byte 49	# '1'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 44	# ','
.byte 32	# ' '
.byte 98	# 'b'
.byte 50	# '2'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string16
string16:			  # "Path 4: b1 false, b2 true\n"
.byte 80	# 'P'
.byte 97	# 'a'
.byte 116	# 't'
.byte 104	# 'h'
.byte 32	# ' '
.byte 52	# '4'
.byte 58	# ':'
.byte 32	# ' '
.byte 98	# 'b'
.byte 49	# '1'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 44	# ','
.byte 32	# ' '
.byte 98	# 'b'
.byte 50	# '2'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string17
string17:			  # "Final values:\n"
.byte 70	# 'F'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 32	# ' '
.byte 118	# 'v'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 115	# 's'
.byte 58	# ':'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string18
string18:			  # "x = "
.byte 120	# 'x'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 0	


.globl string19
string19:			  # "y = "
.byte 121	# 'y'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 0	


.globl string20
string20:			  # "z = "
.byte 122	# 'z'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 0	


.globl string21
string21:			  # "New z value: "
.byte 78	# 'N'
.byte 101	# 'e'
.byte 119	# 'w'
.byte 32	# ' '
.byte 122	# 'z'
.byte 32	# ' '
.byte 118	# 'v'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string22
string22:			  # "Complex condition true\n"
.byte 67	# 'C'
.byte 111	# 'o'
.byte 109	# 'm'
.byte 112	# 'p'
.byte 108	# 'l'
.byte 101	# 'e'
.byte 120	# 'x'
.byte 32	# ' '
.byte 99	# 'c'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 100	# 'd'
.byte 105	# 'i'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string23
string23:			  # "Complex condition false\n"
.byte 67	# 'C'
.byte 111	# 'o'
.byte 109	# 'm'
.byte 112	# 'p'
.byte 108	# 'l'
.byte 101	# 'e'
.byte 120	# 'x'
.byte 32	# ' '
.byte 99	# 'c'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 100	# 'd'
.byte 105	# 'i'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string24
string24:			  # "ERROR: 0: Exception: String.substr out of range\n"
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


.globl string25
string25:			  # "ERROR: 23: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 50	# '2'
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


.globl string26
string26:			  # "ERROR: 69: Exception: division by zero\n"
.byte 69	# 'E'
.byte 82	# 'R'
.byte 82	# 'R'
.byte 79	# 'O'
.byte 82	# 'R'
.byte 58	# ':'
.byte 32	# ' '
.byte 54	# '6'
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
