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
						## stack room for temporaries: 363
						movq $2912, %r14
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
                        ##t$4 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$5 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -48(%rbp)
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
                        ## (temp <- temp): t$7 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -64(%rbp)
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
                        ## (temp <- temp): t$9 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -80(%rbp)
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
                        ## (temp <- temp): t$11 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -96(%rbp)
                        ##t$12 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -104(%rbp)
                        ## (temp <- temp): t$13 <- t$12
                        movq -104(%rbp), %r13
                        movq %r13, -112(%rbp)
                        ##t$14 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -120(%rbp)
                        ## (temp <- temp): t$15 <- t$14
                        movq -120(%rbp), %r13
                        movq %r13, -128(%rbp)
                        ##t$16 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -136(%rbp)
                        ## (temp <- temp): t$17 <- t$16
                        movq -136(%rbp), %r13
                        movq %r13, -144(%rbp)
                        ##t$18 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -152(%rbp)
                        ## (temp <- temp): t$19 <- t$18
                        movq -152(%rbp), %r13
                        movq %r13, -160(%rbp)
                        ##t$20 <- Default Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -168(%rbp)
                        ## (temp <- temp): t$21 <- t$20
                        movq -168(%rbp), %r13
                        movq %r13, -176(%rbp)
                        ##t$22 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -184(%rbp)
                        ## (temp <- temp): t$23 <- t$22
                        movq -184(%rbp), %r13
                        movq %r13, -192(%rbp)
                        ##t$24 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -200(%rbp)
                        ## (temp <- temp): t$25 <- t$24
                        movq -200(%rbp), %r13
                        movq %r13, -208(%rbp)
                        ##t$26 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -216(%rbp)
                        ## (temp <- temp): t$27 <- t$26
                        movq -216(%rbp), %r13
                        movq %r13, -224(%rbp)
                        ##t$28 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -232(%rbp)
                        ## (temp <- temp): t$29 <- t$28
                        movq -232(%rbp), %r13
                        movq %r13, -240(%rbp)
                        ##t$30 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -248(%rbp)
                        ## (temp <- temp): t$31 <- t$30
                        movq -248(%rbp), %r13
                        movq %r13, -256(%rbp)
                        ##t$32 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -264(%rbp)
                        ## (temp <- temp): t$33 <- t$32
                        movq -264(%rbp), %r13
                        movq %r13, -272(%rbp)
                        ##t$34 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -280(%rbp)
                        ## (temp <- temp): t$35 <- t$34
                        movq -280(%rbp), %r13
                        movq %r13, -288(%rbp)
                        ##t$36 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -296(%rbp)
                        ## (temp <- temp): t$37 <- t$36
                        movq -296(%rbp), %r13
                        movq %r13, -304(%rbp)
                        ## new String t$38 <- "Enter number: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string8 holds "Enter number: "
                        movq $string8, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -312(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$38 (pointer)
                        movq -312(%rbp), %r13
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
                        ## (temp <- temp): t$39 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -320(%rbp)
                        ## (temp <- temp): t$40 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -328(%rbp)
                        ## t$41 <- -t$40
                        movq -328(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -336(%rbp)
                        ## new int t$42 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -344(%rbp)
                        ## new int t$43 <- 1
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -352(%rbp)
                        ## t$44 <- t$42 / t$43
                        movq -352(%rbp), %r13
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
                        movq -344(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -360(%rbp)
                        ## t$45 <- t$41 - t$44
                        movq -336(%rbp), %r13
                        movq -360(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -368(%rbp)
                        ## new int t$46 <- 100
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $100, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -376(%rbp)
                        ## new int t$47 <- 7
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -384(%rbp)
                        ## t$48 <- -t$47
                        movq -384(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -392(%rbp)
                        ## t$49 <- t$46 * t$48
                        movq -376(%rbp), %r13
                        movq -392(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -400(%rbp)
                        ## new int t$50 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -408(%rbp)
                        ## t$51 <- t$49 * t$50
                        movq -400(%rbp), %r13
                        movq -408(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -416(%rbp)
                        ## t$52 <- t$45 + t$51
                        movq -368(%rbp), %r13
                        movq -416(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -424(%rbp)
                        ## (temp <- temp): t$2 <- t$52
                        movq -424(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$53 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -432(%rbp)
                        ## (temp <- temp): t$54 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -440(%rbp)
                        ## (temp <- temp): t$55 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -448(%rbp)
                        ## t$56 <- t$54 - t$55
                        movq -440(%rbp), %r13
                        movq -448(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -456(%rbp)
                        ## new int t$57 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -464(%rbp)
                        ## new int t$58 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -472(%rbp)
                        ## t$59 <- -t$58
                        movq -472(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -480(%rbp)
                        ## t$60 <- t$57 * t$59
                        movq -464(%rbp), %r13
                        movq -480(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -488(%rbp)
                        ## t$61 <- t$56 + t$60
                        movq -456(%rbp), %r13
                        movq -488(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -496(%rbp)
                        ## new int t$62 <- 8
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -504(%rbp)
                        ## new int t$63 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -512(%rbp)
                        ## t$64 <- t$62 / t$63
                        movq -512(%rbp), %r13
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
                        movq -504(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -520(%rbp)
                        ## t$65 <- t$61 - t$64
                        movq -496(%rbp), %r13
                        movq -520(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -528(%rbp)
                        ## (temp <- temp): t$4 <- t$65
                        movq -528(%rbp), %r13
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$66 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -536(%rbp)
                        ## new int t$67 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -544(%rbp)
                        ## new int t$68 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -552(%rbp)
                        ## t$69 <- t$67 / t$68
                        movq -552(%rbp), %r13
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
                        movq -544(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -560(%rbp)
                        ## new int t$70 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -568(%rbp)
                        ## t$71 <- -t$70
                        movq -568(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -576(%rbp)
                        ## t$72 <- t$69 * t$71
                        movq -560(%rbp), %r13
                        movq -576(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -584(%rbp)
                        ## new int t$73 <- 9
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $9, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -592(%rbp)
                        ## t$74 <- t$72 - t$73
                        movq -584(%rbp), %r13
                        movq -592(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -600(%rbp)
                        ## (temp <- temp): t$75 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -608(%rbp)
                        ## (temp <- temp): t$76 <- t$2
                        movq -24(%rbp), %r13
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
                        ## t$78 <- t$74 + t$77
                        movq -600(%rbp), %r13
                        movq -624(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -632(%rbp)
                        ## (temp <- temp): t$5 <- t$78
                        movq -632(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ## (temp <- temp): t$79 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -640(%rbp)
                        ## (temp <- temp): t$80 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -648(%rbp)
                        ## (temp <- temp): t$81 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -656(%rbp)
                        ## (temp <- temp): t$82 <- t$5
                        movq -48(%rbp), %r13
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
                        ## t$84 <- t$80 + t$83
                        movq -648(%rbp), %r13
                        movq -672(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -680(%rbp)
                        ## (temp <- temp): t$85 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -688(%rbp)
                        ## t$86 <- -t$85
                        movq -688(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -696(%rbp)
                        ## new int t$87 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -704(%rbp)
                        ## t$88 <- t$86 / t$87
                        movq -704(%rbp), %r13
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
                        movq -696(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -712(%rbp)
                        ## t$89 <- t$84 - t$88
                        movq -680(%rbp), %r13
                        movq -712(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -720(%rbp)
                        ## new int t$90 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -728(%rbp)
                        ## new int t$91 <- 11
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $11, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -736(%rbp)
                        ## t$92 <- t$90 * t$91
                        movq -728(%rbp), %r13
                        movq -736(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -744(%rbp)
                        ## (temp <- temp): t$93 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -752(%rbp)
                        ## t$94 <- -t$93
                        movq -752(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -760(%rbp)
                        ## t$95 <- t$92 * t$94
                        movq -744(%rbp), %r13
                        movq -760(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -768(%rbp)
                        ## t$96 <- t$89 + t$95
                        movq -720(%rbp), %r13
                        movq -768(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -776(%rbp)
                        ## (temp <- temp): t$6 <- t$96
                        movq -776(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$97 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -784(%rbp)
                        ## (temp <- temp): t$98 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -792(%rbp)
                        ## (temp <- temp): t$99 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -800(%rbp)
                        ## (temp <- temp): t$100 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -808(%rbp)
                        ## t$101 <- t$99 * t$100
                        movq -800(%rbp), %r13
                        movq -808(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -816(%rbp)
                        ## t$102 <- t$98 + t$101
                        movq -792(%rbp), %r13
                        movq -816(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -824(%rbp)
                        ## (temp <- temp): t$103 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -832(%rbp)
                        ## t$104 <- t$102 + t$103
                        movq -824(%rbp), %r13
                        movq -832(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -840(%rbp)
                        ## (temp <- temp): t$105 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -848(%rbp)
                        ## t$106 <- -t$105
                        movq -848(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -856(%rbp)
                        ## new int t$107 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -864(%rbp)
                        ## t$108 <- t$106 * t$107
                        movq -856(%rbp), %r13
                        movq -864(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -872(%rbp)
                        ## (temp <- temp): t$109 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -880(%rbp)
                        ## t$110 <- t$108 / t$109
                        movq -880(%rbp), %r13
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
                        movq -872(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -888(%rbp)
                        ## t$111 <- t$104 - t$110
                        movq -840(%rbp), %r13
                        movq -888(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -896(%rbp)
                        ## (temp <- temp): t$7 <- t$111
                        movq -896(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ## (temp <- temp): t$112 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -904(%rbp)
                        ## (temp <- temp): t$113 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -912(%rbp)
                        ## (temp <- temp): t$114 <- t$1
                        movq -16(%rbp), %r13
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
                        ## (temp <- temp): t$116 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -936(%rbp)
                        ## (temp <- temp): t$117 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -944(%rbp)
                        ## t$118 <- t$116 / t$117
                        movq -944(%rbp), %r13
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
                        movq -936(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -952(%rbp)
                        ## t$119 <- t$115 - t$118
                        movq -928(%rbp), %r13
                        movq -952(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -960(%rbp)
                        ## (temp <- temp): t$120 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -968(%rbp)
                        ## t$121 <- -t$120
                        movq -968(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -976(%rbp)
                        ## new int t$122 <- 10
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
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
                        ## t$124 <- t$119 + t$123
                        movq -960(%rbp), %r13
                        movq -992(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1000(%rbp)
                        ## (temp <- temp): t$8 <- t$124
                        movq -1000(%rbp), %r13
                        movq %r13, -72(%rbp)
                        ## (temp <- temp): t$125 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1008(%rbp)
                        ## (temp <- temp): t$126 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1016(%rbp)
                        ## (temp <- temp): t$127 <- t$6
                        movq -56(%rbp), %r13
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
                        ## t$130 <- t$126 - t$129
                        movq -1016(%rbp), %r13
                        movq -1040(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1048(%rbp)
                        ## (temp <- temp): t$131 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1056(%rbp)
                        ## new int t$132 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1064(%rbp)
                        ## t$133 <- -t$132
                        movq -1064(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1072(%rbp)
                        ## t$134 <- t$131 / t$133
                        movq -1072(%rbp), %r13
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
                        movq -1056(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1080(%rbp)
                        ## t$135 <- t$130 + t$134
                        movq -1048(%rbp), %r13
                        movq -1080(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1088(%rbp)
                        ## (temp <- temp): t$136 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1096(%rbp)
                        ## (temp <- temp): t$137 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1104(%rbp)
                        ## t$138 <- t$136 * t$137
                        movq -1096(%rbp), %r13
                        movq -1104(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1112(%rbp)
                        ## t$139 <- t$135 - t$138
                        movq -1088(%rbp), %r13
                        movq -1112(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1120(%rbp)
                        ## (temp <- temp): t$9 <- t$139
                        movq -1120(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ## (temp <- temp): t$140 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1128(%rbp)
                        ## (temp <- temp): t$141 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1136(%rbp)
                        ## t$142 <- -t$141
                        movq -1136(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1144(%rbp)
                        ## (temp <- temp): t$143 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1152(%rbp)
                        ## (temp <- temp): t$144 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1160(%rbp)
                        ## t$145 <- t$143 * t$144
                        movq -1152(%rbp), %r13
                        movq -1160(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1168(%rbp)
                        ## t$146 <- t$142 + t$145
                        movq -1144(%rbp), %r13
                        movq -1168(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1176(%rbp)
                        ## (temp <- temp): t$147 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1184(%rbp)
                        ## (temp <- temp): t$148 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1192(%rbp)
                        ## t$149 <- t$147 * t$148
                        movq -1184(%rbp), %r13
                        movq -1192(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1200(%rbp)
                        ## t$150 <- t$146 - t$149
                        movq -1176(%rbp), %r13
                        movq -1200(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1208(%rbp)
                        ## (temp <- temp): t$151 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1216(%rbp)
                        ## (temp <- temp): t$152 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1224(%rbp)
                        ## t$153 <- t$151 * t$152
                        movq -1216(%rbp), %r13
                        movq -1224(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1232(%rbp)
                        ## t$154 <- t$150 + t$153
                        movq -1208(%rbp), %r13
                        movq -1232(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1240(%rbp)
                        ## (temp <- temp): t$155 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1248(%rbp)
                        ## t$156 <- t$154 - t$155
                        movq -1240(%rbp), %r13
                        movq -1248(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1256(%rbp)
                        ## (temp <- temp): t$10 <- t$156
                        movq -1256(%rbp), %r13
                        movq %r13, -88(%rbp)
                        ## (temp <- temp): t$157 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -1264(%rbp)
                        ## (temp <- temp): t$158 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1272(%rbp)
                        ## (temp <- temp): t$159 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -1280(%rbp)
                        ## (temp <- temp): t$160 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1288(%rbp)
                        ## t$161 <- t$159 * t$160
                        movq -1280(%rbp), %r13
                        movq -1288(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1296(%rbp)
                        ## t$162 <- t$158 + t$161
                        movq -1272(%rbp), %r13
                        movq -1296(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1304(%rbp)
                        ## (temp <- temp): t$163 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1312(%rbp)
                        ## (temp <- temp): t$164 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1320(%rbp)
                        ## t$165 <- t$163 * t$164
                        movq -1312(%rbp), %r13
                        movq -1320(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1328(%rbp)
                        ## (temp <- temp): t$166 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1336(%rbp)
                        ## t$167 <- t$165 * t$166
                        movq -1328(%rbp), %r13
                        movq -1336(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1344(%rbp)
                        ## t$168 <- t$162 - t$167
                        movq -1304(%rbp), %r13
                        movq -1344(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1352(%rbp)
                        ## (temp <- temp): t$169 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1360(%rbp)
                        ## (temp <- temp): t$170 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1368(%rbp)
                        ## t$171 <- t$169 * t$170
                        movq -1360(%rbp), %r13
                        movq -1368(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1376(%rbp)
                        ## t$172 <- t$168 + t$171
                        movq -1352(%rbp), %r13
                        movq -1376(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1384(%rbp)
                        ## (temp <- temp): t$173 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1392(%rbp)
                        ## (temp <- temp): t$174 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -1400(%rbp)
                        ## t$175 <- t$173 / t$174
                        movq -1400(%rbp), %r13
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
                        movq -1392(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1408(%rbp)
                        ## t$176 <- t$172 - t$175
                        movq -1384(%rbp), %r13
                        movq -1408(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1416(%rbp)
                        ## (temp <- temp): t$11 <- t$176
                        movq -1416(%rbp), %r13
                        movq %r13, -96(%rbp)
                        ## (temp <- temp): t$177 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -1424(%rbp)
                        ## new String t$178 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1432(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$178 (pointer)
                        movq -1432(%rbp), %r13
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
                        ## (temp <- temp): t$179 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1440(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1440(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$179
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
                        ## (temp <- temp): t$180 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1448(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1448(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$180
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
                        ## (temp <- temp): t$181 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1456(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1456(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$181
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
                        ## (temp <- temp): t$182 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1464(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1464(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$182
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
                        ## (temp <- temp): t$183 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1472(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1472(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$183
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
                        ## (temp <- temp): t$184 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1480(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1480(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$184
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
                        ## (temp <- temp): t$185 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1488(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1488(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$185
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
                        ## (temp <- temp): t$186 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1496(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1496(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$186
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
                        ## (temp <- temp): t$187 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -1504(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1504(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$187
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
                        ## (temp <- temp): t$188 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -1512(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1512(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$188
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
                        ## new String t$189 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1520(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$189 (pointer)
                        movq -1520(%rbp), %r13
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
                        ## new String t$190 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1528(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$190 (pointer)
                        movq -1528(%rbp), %r13
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
                        ## new String t$191 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1536(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$191 (pointer)
                        movq -1536(%rbp), %r13
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
                        ## new String t$192 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1544(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$192 (pointer)
                        movq -1544(%rbp), %r13
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
                        ## new String t$193 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1552(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$193 (pointer)
                        movq -1552(%rbp), %r13
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
                        ## new String t$194 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1560(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$194 (pointer)
                        movq -1560(%rbp), %r13
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
                        ## new String t$195 <- "Enter string: \n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string10 holds "Enter string: \n"
                        movq $string10, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1568(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$195 (pointer)
                        movq -1568(%rbp), %r13
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
                        ## (temp <- temp): t$196 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -1576(%rbp)
                        ## new String t$197 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1584(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$197 (pointer)
                        movq -1584(%rbp), %r13
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
                        ## (temp <- temp): t$198 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -1592(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$198 (pointer)
                        movq -1592(%rbp), %r13
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
                        ## new String t$199 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1600(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$199 (pointer)
                        movq -1600(%rbp), %r13
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
                        ## (temp <- temp): t$200 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1608(%rbp)
                        ## (temp <- temp): t$201 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1616(%rbp)
                        ## t$202 <- -t$201
                        movq -1616(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1624(%rbp)
                        ## new int t$203 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1632(%rbp)
                        ## new int t$204 <- 1
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1640(%rbp)
                        ## t$205 <- t$203 / t$204
                        movq -1640(%rbp), %r13
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
                        movq -1632(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1648(%rbp)
                        ## t$206 <- t$202 - t$205
                        movq -1624(%rbp), %r13
                        movq -1648(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1656(%rbp)
                        ## new int t$207 <- 100
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $100, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1664(%rbp)
                        ## new int t$208 <- 7
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1672(%rbp)
                        ## t$209 <- -t$208
                        movq -1672(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1680(%rbp)
                        ## t$210 <- t$207 * t$209
                        movq -1664(%rbp), %r13
                        movq -1680(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1688(%rbp)
                        ## new int t$211 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1696(%rbp)
                        ## t$212 <- t$210 * t$211
                        movq -1688(%rbp), %r13
                        movq -1696(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1704(%rbp)
                        ## t$213 <- t$206 + t$212
                        movq -1656(%rbp), %r13
                        movq -1704(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1712(%rbp)
                        ## (temp <- temp): t$2 <- t$213
                        movq -1712(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$214 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1720(%rbp)
                        ## (temp <- temp): t$215 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1728(%rbp)
                        ## (temp <- temp): t$216 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1736(%rbp)
                        ## t$217 <- t$215 - t$216
                        movq -1728(%rbp), %r13
                        movq -1736(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1744(%rbp)
                        ## new int t$218 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1752(%rbp)
                        ## new int t$219 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1760(%rbp)
                        ## t$220 <- -t$219
                        movq -1760(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1768(%rbp)
                        ## t$221 <- t$218 * t$220
                        movq -1752(%rbp), %r13
                        movq -1768(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1776(%rbp)
                        ## t$222 <- t$217 + t$221
                        movq -1744(%rbp), %r13
                        movq -1776(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1784(%rbp)
                        ## new int t$223 <- 8
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1792(%rbp)
                        ## new int t$224 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1800(%rbp)
                        ## t$225 <- t$223 / t$224
                        movq -1800(%rbp), %r13
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
                        movq -1792(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1808(%rbp)
                        ## t$226 <- t$222 - t$225
                        movq -1784(%rbp), %r13
                        movq -1808(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1816(%rbp)
                        ## (temp <- temp): t$4 <- t$226
                        movq -1816(%rbp), %r13
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$227 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -1824(%rbp)
                        ## new int t$228 <- 15
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1832(%rbp)
                        ## new int t$229 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1840(%rbp)
                        ## t$230 <- t$228 / t$229
                        movq -1840(%rbp), %r13
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
                        movq -1832(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -1848(%rbp)
                        ## new int t$231 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1856(%rbp)
                        ## t$232 <- -t$231
                        movq -1856(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1864(%rbp)
                        ## t$233 <- t$230 * t$232
                        movq -1848(%rbp), %r13
                        movq -1864(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1872(%rbp)
                        ## new int t$234 <- 9
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $9, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1880(%rbp)
                        ## t$235 <- t$233 - t$234
                        movq -1872(%rbp), %r13
                        movq -1880(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1888(%rbp)
                        ## (temp <- temp): t$236 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1896(%rbp)
                        ## (temp <- temp): t$237 <- t$2
                        movq -24(%rbp), %r13
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
                        ## t$239 <- t$235 + t$238
                        movq -1888(%rbp), %r13
                        movq -1912(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1920(%rbp)
                        ## (temp <- temp): t$5 <- t$239
                        movq -1920(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ## (temp <- temp): t$240 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1928(%rbp)
                        ## (temp <- temp): t$241 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1936(%rbp)
                        ## (temp <- temp): t$242 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -1944(%rbp)
                        ## (temp <- temp): t$243 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -1952(%rbp)
                        ## t$244 <- t$242 * t$243
                        movq -1944(%rbp), %r13
                        movq -1952(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -1960(%rbp)
                        ## t$245 <- t$241 + t$244
                        movq -1936(%rbp), %r13
                        movq -1960(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1968(%rbp)
                        ## (temp <- temp): t$246 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -1976(%rbp)
                        ## t$247 <- -t$246
                        movq -1976(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -1984(%rbp)
                        ## new int t$248 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1992(%rbp)
                        ## t$249 <- t$247 / t$248
                        movq -1992(%rbp), %r13
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
                        movq -1984(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2000(%rbp)
                        ## t$250 <- t$245 - t$249
                        movq -1968(%rbp), %r13
                        movq -2000(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2008(%rbp)
                        ## new int t$251 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -2016(%rbp)
                        ## new int t$252 <- 11
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $11, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -2024(%rbp)
                        ## t$253 <- t$251 * t$252
                        movq -2016(%rbp), %r13
                        movq -2024(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2032(%rbp)
                        ## (temp <- temp): t$254 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2040(%rbp)
                        ## t$255 <- -t$254
                        movq -2040(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2048(%rbp)
                        ## t$256 <- t$253 * t$255
                        movq -2032(%rbp), %r13
                        movq -2048(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2056(%rbp)
                        ## t$257 <- t$250 + t$256
                        movq -2008(%rbp), %r13
                        movq -2056(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2064(%rbp)
                        ## (temp <- temp): t$6 <- t$257
                        movq -2064(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$258 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2072(%rbp)
                        ## (temp <- temp): t$259 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2080(%rbp)
                        ## (temp <- temp): t$260 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2088(%rbp)
                        ## (temp <- temp): t$261 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2096(%rbp)
                        ## t$262 <- t$260 * t$261
                        movq -2088(%rbp), %r13
                        movq -2096(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2104(%rbp)
                        ## t$263 <- t$259 + t$262
                        movq -2080(%rbp), %r13
                        movq -2104(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2112(%rbp)
                        ## (temp <- temp): t$264 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2120(%rbp)
                        ## t$265 <- t$263 + t$264
                        movq -2112(%rbp), %r13
                        movq -2120(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2128(%rbp)
                        ## (temp <- temp): t$266 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2136(%rbp)
                        ## t$267 <- -t$266
                        movq -2136(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2144(%rbp)
                        ## new int t$268 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -2152(%rbp)
                        ## t$269 <- t$267 * t$268
                        movq -2144(%rbp), %r13
                        movq -2152(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2160(%rbp)
                        ## (temp <- temp): t$270 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2168(%rbp)
                        ## t$271 <- t$269 / t$270
                        movq -2168(%rbp), %r13
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
                        movq -2160(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2176(%rbp)
                        ## t$272 <- t$265 - t$271
                        movq -2128(%rbp), %r13
                        movq -2176(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2184(%rbp)
                        ## (temp <- temp): t$7 <- t$272
                        movq -2184(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ## (temp <- temp): t$273 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2192(%rbp)
                        ## (temp <- temp): t$274 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2200(%rbp)
                        ## (temp <- temp): t$275 <- t$1
                        movq -16(%rbp), %r13
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
                        ## (temp <- temp): t$277 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2224(%rbp)
                        ## (temp <- temp): t$278 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2232(%rbp)
                        ## t$279 <- t$277 / t$278
                        movq -2232(%rbp), %r13
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
                        movq -2224(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2240(%rbp)
                        ## t$280 <- t$276 - t$279
                        movq -2216(%rbp), %r13
                        movq -2240(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2248(%rbp)
                        ## (temp <- temp): t$281 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2256(%rbp)
                        ## t$282 <- -t$281
                        movq -2256(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2264(%rbp)
                        ## new int t$283 <- 1805
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1805, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -2272(%rbp)
                        ## t$284 <- t$282 * t$283
                        movq -2264(%rbp), %r13
                        movq -2272(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2280(%rbp)
                        ## t$285 <- t$280 + t$284
                        movq -2248(%rbp), %r13
                        movq -2280(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2288(%rbp)
                        ## (temp <- temp): t$8 <- t$285
                        movq -2288(%rbp), %r13
                        movq %r13, -72(%rbp)
                        ## (temp <- temp): t$286 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2296(%rbp)
                        ## (temp <- temp): t$287 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2304(%rbp)
                        ## (temp <- temp): t$288 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2312(%rbp)
                        ## (temp <- temp): t$289 <- t$5
                        movq -48(%rbp), %r13
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
                        ## t$291 <- t$287 - t$290
                        movq -2304(%rbp), %r13
                        movq -2328(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2336(%rbp)
                        ## (temp <- temp): t$292 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2344(%rbp)
                        ## new int t$293 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -2352(%rbp)
                        ## t$294 <- -t$293
                        movq -2352(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2360(%rbp)
                        ## t$295 <- t$292 / t$294
                        movq -2360(%rbp), %r13
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
                        movq -2344(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2368(%rbp)
                        ## t$296 <- t$291 + t$295
                        movq -2336(%rbp), %r13
                        movq -2368(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2376(%rbp)
                        ## (temp <- temp): t$297 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2384(%rbp)
                        ## (temp <- temp): t$298 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2392(%rbp)
                        ## t$299 <- t$297 * t$298
                        movq -2384(%rbp), %r13
                        movq -2392(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2400(%rbp)
                        ## t$300 <- t$296 - t$299
                        movq -2376(%rbp), %r13
                        movq -2400(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2408(%rbp)
                        ## (temp <- temp): t$9 <- t$300
                        movq -2408(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ## (temp <- temp): t$301 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2416(%rbp)
                        ## (temp <- temp): t$302 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2424(%rbp)
                        ## t$303 <- -t$302
                        movq -2424(%rbp), %r13
movq %r13, %rax
negq %rax
movq %rax, %r13 
                        movq %r13, -2432(%rbp)
                        ## (temp <- temp): t$304 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2440(%rbp)
                        ## (temp <- temp): t$305 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2448(%rbp)
                        ## t$306 <- t$304 * t$305
                        movq -2440(%rbp), %r13
                        movq -2448(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2456(%rbp)
                        ## t$307 <- t$303 + t$306
                        movq -2432(%rbp), %r13
                        movq -2456(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2464(%rbp)
                        ## (temp <- temp): t$308 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2472(%rbp)
                        ## (temp <- temp): t$309 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2480(%rbp)
                        ## t$310 <- t$308 * t$309
                        movq -2472(%rbp), %r13
                        movq -2480(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2488(%rbp)
                        ## t$311 <- t$307 - t$310
                        movq -2464(%rbp), %r13
                        movq -2488(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2496(%rbp)
                        ## (temp <- temp): t$312 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2504(%rbp)
                        ## (temp <- temp): t$313 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2512(%rbp)
                        ## t$314 <- t$312 * t$313
                        movq -2504(%rbp), %r13
                        movq -2512(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2520(%rbp)
                        ## t$315 <- t$311 + t$314
                        movq -2496(%rbp), %r13
                        movq -2520(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2528(%rbp)
                        ## (temp <- temp): t$316 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2536(%rbp)
                        ## t$317 <- t$315 - t$316
                        movq -2528(%rbp), %r13
                        movq -2536(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2544(%rbp)
                        ## (temp <- temp): t$10 <- t$317
                        movq -2544(%rbp), %r13
                        movq %r13, -88(%rbp)
                        ## (temp <- temp): t$318 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2552(%rbp)
                        ## (temp <- temp): t$319 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2560(%rbp)
                        ## (temp <- temp): t$320 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2568(%rbp)
                        ## t$321 <- t$319 + t$320
                        movq -2560(%rbp), %r13
                        movq -2568(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2576(%rbp)
                        ## (temp <- temp): t$322 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2584(%rbp)
                        ## (temp <- temp): t$323 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2592(%rbp)
                        ## t$324 <- t$322 * t$323
                        movq -2584(%rbp), %r13
                        movq -2592(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2600(%rbp)
                        ## t$325 <- t$321 + t$324
                        movq -2576(%rbp), %r13
                        movq -2600(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2608(%rbp)
                        ## (temp <- temp): t$326 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2616(%rbp)
                        ## (temp <- temp): t$327 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2624(%rbp)
                        ## t$328 <- t$326 * t$327
                        movq -2616(%rbp), %r13
                        movq -2624(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2632(%rbp)
                        ## (temp <- temp): t$329 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2640(%rbp)
                        ## t$330 <- t$328 * t$329
                        movq -2632(%rbp), %r13
                        movq -2640(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2648(%rbp)
                        ## t$331 <- t$325 - t$330
                        movq -2608(%rbp), %r13
                        movq -2648(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2656(%rbp)
                        ## (temp <- temp): t$332 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2664(%rbp)
                        ## (temp <- temp): t$333 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2672(%rbp)
                        ## t$334 <- t$332 * t$333
                        movq -2664(%rbp), %r13
                        movq -2672(%rbp), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax   
shrq $32, %rax   
movl %eax, %r13d 
                        movq %r13, -2680(%rbp)
                        ## t$335 <- t$331 + t$334
                        movq -2656(%rbp), %r13
                        movq -2680(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -2688(%rbp)
                        ## (temp <- temp): t$336 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2696(%rbp)
                        ## (temp <- temp): t$337 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2704(%rbp)
                        ## t$338 <- t$336 / t$337
                        movq -2704(%rbp), %r13
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
                        movq -2696(%rbp), %r14
movq $0, %rdx
movq %r14, %rax
cdq
idivl %r13d
movq %rax, %r13
                        movq %r13, -2712(%rbp)
                        ## t$339 <- t$335 - t$338
                        movq -2688(%rbp), %r13
                        movq -2712(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -2720(%rbp)
                        ## (temp <- temp): t$11 <- t$339
                        movq -2720(%rbp), %r13
                        movq %r13, -96(%rbp)
                        ## (temp <- temp): t$340 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -2728(%rbp)
                        ## new String t$341 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2736(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$341 (pointer)
                        movq -2736(%rbp), %r13
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
                        ## (temp <- temp): t$342 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -2744(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2744(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$342
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
                        ## (temp <- temp): t$343 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -2752(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2752(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$343
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
                        ## (temp <- temp): t$344 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -2760(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2760(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$344
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
                        ## (temp <- temp): t$345 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -2768(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2768(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$345
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
                        ## (temp <- temp): t$346 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -2776(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2776(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$346
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
                        ## (temp <- temp): t$347 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -2784(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2784(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$347
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
                        ## (temp <- temp): t$348 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -2792(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2792(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$348
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
                        ## (temp <- temp): t$349 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -2800(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2800(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$349
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
                        ## (temp <- temp): t$350 <- t$10
                        movq -88(%rbp), %r13
                        movq %r13, -2808(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2808(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$350
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
                        ## (temp <- temp): t$351 <- t$11
                        movq -96(%rbp), %r13
                        movq %r13, -2816(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -2816(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$351
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
                        ## new String t$352 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2824(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$352 (pointer)
                        movq -2824(%rbp), %r13
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
                        ## new String t$353 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2832(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$353 (pointer)
                        movq -2832(%rbp), %r13
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
                        ## new String t$354 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2840(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$354 (pointer)
                        movq -2840(%rbp), %r13
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
                        ## new String t$355 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2848(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$355 (pointer)
                        movq -2848(%rbp), %r13
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
                        ## new String t$356 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2856(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$356 (pointer)
                        movq -2856(%rbp), %r13
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
                        ## new String t$357 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2864(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$357 (pointer)
                        movq -2864(%rbp), %r13
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
                        ## new String t$358 <- "Enter string: \n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string10 holds "Enter string: \n"
                        movq $string10, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2872(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$358 (pointer)
                        movq -2872(%rbp), %r13
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
                        ## (temp <- temp): t$359 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -2880(%rbp)
                        ## new String t$360 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2888(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$360 (pointer)
                        movq -2888(%rbp), %r13
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
                        ## (temp <- temp): t$361 <- t$17
                        movq -144(%rbp), %r13
                        movq %r13, -2896(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$361 (pointer)
                        movq -2896(%rbp), %r13
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
                        ## new String t$362 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "\n"
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -2904(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$362 (pointer)
                        movq -2904(%rbp), %r13
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
