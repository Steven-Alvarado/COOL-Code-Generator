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
						## stack room for temporaries: 169
						movq $1360, %r14
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
                        ##t$14 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -120(%rbp)
                        ## (temp <- temp): t$15 <- t$14
                        movq -120(%rbp), %r13
                        movq %r13, -128(%rbp)
                        ##t$16 <- Default Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -136(%rbp)
                        ## (temp <- temp): t$17 <- t$16
                        movq -136(%rbp), %r13
                        movq %r13, -144(%rbp)
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
                        ## (temp <- temp): t$19 <- t$18
                        movq -152(%rbp), %r13
                        movq %r13, -160(%rbp)
                        ##t$20 <- Default String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## empty string
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -168(%rbp)
                        ## (temp <- temp): t$21 <- t$20
                        movq -168(%rbp), %r13
                        movq %r13, -176(%rbp)
                        ## new String t$22 <- "Enter a value for x: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string8 holds "Enter a value for x: "
                        movq $string8, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -184(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$22 (pointer)
                        movq -184(%rbp), %r13
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
                        ## (temp <- temp): t$5 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -48(%rbp)
                        ## (temp <- temp): t$23 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -192(%rbp)
                        ## new int t$24 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -200(%rbp)
                        ## new int t$25 <- 6
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $6, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -208(%rbp)
                        ## t$26 <- t$24 < t$25 
                        pushq %r12
                        pushq %rbp
                        ## t$24
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -200(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$25
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -208(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        movq %r13, -216(%rbp)
                        popq %rbp
                        popq %r12
                        ## (temp <- temp): t$7 <- t$26
                        movq -216(%rbp), %r13
                        movq %r13, -64(%rbp)
                        ## (temp <- temp): t$27 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -224(%rbp)
                        ## (temp <- temp): t$28 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -232(%rbp)
                        ## new int t$29 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -240(%rbp)
                        ## t$30 <- t$28 <= t$29 
                        pushq %r12
                        pushq %rbp
                        ## t$28
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -232(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$29
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -240(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call le_handler
                        addq $24, %rsp
                        movq %r13, -248(%rbp)
                        popq %rbp
                        popq %r12
                        ## (temp <- temp): t$8 <- t$30
                        movq -248(%rbp), %r13
                        movq %r13, -72(%rbp)
                        ## (temp <- temp): t$31 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -256(%rbp)
                        ## (temp <- temp): t$32 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -264(%rbp)
                        ## (temp <- temp): t$33 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -272(%rbp)
                        ## t$34 <- t$32 = t$33 
                        pushq %r12
                        pushq %rbp
                        ## t$32
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -264(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
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
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        movq %r13, -280(%rbp)
                        popq %rbp
                        popq %r12
                        ## (temp <- temp): t$9 <- t$34
                        movq -280(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ## (temp <- temp): t$35 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -288(%rbp)
                        ## new String t$36 <- "Enter a value for c: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string9 holds "Enter a value for c: "
                        movq $string9, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -296(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$36 (pointer)
                        movq -296(%rbp), %r13
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
                        ## (temp <- temp): t$3 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -32(%rbp)
                        ## (temp <- temp): t$37 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -304(%rbp)
                        ## new String t$38 <- "Enter a value for d: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string10 holds "Enter a value for d: "
                        movq $string10, %r14
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
                        ## (temp <- temp): t$4 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -40(%rbp)
                        ## (temp <- temp): t$39 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -320(%rbp)
                        ## (temp <- temp): t$40 <- t$3
                        movq -32(%rbp), %r13
                        movq %r13, -328(%rbp)
                        ## (temp <- temp): t$41 <- t$4
                        movq -40(%rbp), %r13
                        movq %r13, -336(%rbp)
                        ## t$42 <- t$40 = t$41 
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
                        ## t$41
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -336(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        movq %r13, -344(%rbp)
                        popq %rbp
                        popq %r12
                        ## (temp <- temp): t$9 <- t$42
                        movq -344(%rbp), %r13
                        movq %r13, -80(%rbp)
                        ## (temp <- temp): t$43 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -352(%rbp)
                        ## new String t$44 <- "\nBoolean test results:\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "\nBoolean test results:\n"
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -360(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$44 (pointer)
                        movq -360(%rbp), %r13
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
                        ## (temp <- temp): t$45 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -368(%rbp)
                        ## t$46 <- not t$45
                        movq -368(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l42_true
.globl main_l43_false
main_l43_false:
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
                        jmp main_l44_end
.globl main_l42_true
main_l42_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l44_end
main_l44_end:            ## end of if conditional
                        movq %r13, -376(%rbp)
                        ## if t$46 jump to main_l1
                        movq -376(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l1
                        ## Basic block: BB1
                        ## if t$45 jump to main_l0
                        movq -368(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l0
                        ## Basic block: BB2
                        ## then branch
                        ## Basic block: BB3
.globl main_l0
main_l0:
                        ## new String t$47 <- "4 < 6 is true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string12 holds "4 < 6 is true\n"
                        movq $string12, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -384(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$47 (pointer)
                        movq -384(%rbp), %r13
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
                        ## (temp <- temp): t$49 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -400(%rbp)
                        ## unconditional jump to main_l2
                        jmp main_l2
                        ## Basic block: BB4
                        ## else branch
                        ## Basic block: BB5
.globl main_l1
main_l1:
                        ## new String t$48 <- "4 < 6 is false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string13 holds "4 < 6 is false\n"
                        movq $string13, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -392(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$48 (pointer)
                        movq -392(%rbp), %r13
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
                        ## (temp <- temp): t$49 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -400(%rbp)
                        ## unconditional jump to main_l2
                        jmp main_l2
                        ## Basic block: BB6
                        ## if-join
                        ## Basic block: BB7
.globl main_l2
main_l2:
                        ## (temp <- temp): t$50 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -408(%rbp)
                        ## t$51 <- not t$50
                        movq -408(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l45_true
.globl main_l46_false
main_l46_false:
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
                        jmp main_l47_end
.globl main_l45_true
main_l45_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l47_end
main_l47_end:            ## end of if conditional
                        movq %r13, -416(%rbp)
                        ## if t$51 jump to main_l4
                        movq -416(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l4
                        ## Basic block: BB8
                        ## if t$50 jump to main_l3
                        movq -408(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l3
                        ## Basic block: BB9
                        ## then branch
                        ## Basic block: BB10
.globl main_l3
main_l3:
                        ## new String t$52 <- "x <= 5 is true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string14 holds "x <= 5 is true\n"
                        movq $string14, %r14
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
                        ## (temp <- temp): t$54 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -440(%rbp)
                        ## unconditional jump to main_l5
                        jmp main_l5
                        ## Basic block: BB11
                        ## else branch
                        ## Basic block: BB12
.globl main_l4
main_l4:
                        ## new String t$53 <- "x <= 5 is false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds "x <= 5 is false\n"
                        movq $string15, %r14
                        movq %r14, 24(%r13)
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
                        ## (temp <- temp): t$54 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -440(%rbp)
                        ## unconditional jump to main_l5
                        jmp main_l5
                        ## Basic block: BB13
                        ## if-join
                        ## Basic block: BB14
.globl main_l5
main_l5:
                        ## (temp <- temp): t$55 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -448(%rbp)
                        ## t$56 <- not t$55
                        movq -448(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l48_true
.globl main_l49_false
main_l49_false:
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
                        jmp main_l50_end
.globl main_l48_true
main_l48_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l50_end
main_l50_end:            ## end of if conditional
                        movq %r13, -456(%rbp)
                        ## if t$56 jump to main_l7
                        movq -456(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l7
                        ## Basic block: BB15
                        ## if t$55 jump to main_l6
                        movq -448(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l6
                        ## Basic block: BB16
                        ## then branch
                        ## Basic block: BB17
.globl main_l6
main_l6:
                        ## new String t$57 <- "c = d is true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string16 holds "c = d is true\n"
                        movq $string16, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -464(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$57 (pointer)
                        movq -464(%rbp), %r13
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
                        ## (temp <- temp): t$59 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -480(%rbp)
                        ## unconditional jump to main_l8
                        jmp main_l8
                        ## Basic block: BB18
                        ## else branch
                        ## Basic block: BB19
.globl main_l7
main_l7:
                        ## new String t$58 <- "c = d is false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string17 holds "c = d is false\n"
                        movq $string17, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -472(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$58 (pointer)
                        movq -472(%rbp), %r13
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
                        ## (temp <- temp): t$59 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -480(%rbp)
                        ## unconditional jump to main_l8
                        jmp main_l8
                        ## Basic block: BB20
                        ## if-join
                        ## Basic block: BB21
.globl main_l8
main_l8:
                        ## new String t$60 <- "\nTesting nested if statements:\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string18 holds "\nTesting nested if statements:\n"
                        movq $string18, %r14
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
                        ## (temp <- temp): t$61 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -496(%rbp)
                        ## new int t$62 <- 10
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -504(%rbp)
                        ## t$63 <- t$61 < t$62 
                        pushq %r12
                        pushq %rbp
                        ## t$61
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -496(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$62
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -504(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        movq %r13, -512(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$64 <- not t$63
                        movq -512(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l51_true
.globl main_l52_false
main_l52_false:
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
                        jmp main_l53_end
.globl main_l51_true
main_l51_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l53_end
main_l53_end:            ## end of if conditional
                        movq %r13, -520(%rbp)
                        ## if t$64 jump to main_l10
                        movq -520(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l10
                        ## Basic block: BB22
                        ## if t$63 jump to main_l9
                        movq -512(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l9
                        ## Basic block: BB23
                        ## then branch
                        ## Basic block: BB24
.globl main_l9
main_l9:
                        ## (temp <- temp): t$65 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -528(%rbp)
                        ## new int t$66 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -536(%rbp)
                        ## t$67 <- t$65 < t$66 
                        pushq %r12
                        pushq %rbp
                        ## t$65
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -528(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$66
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -536(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        movq %r13, -544(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$68 <- not t$67
                        movq -544(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l54_true
.globl main_l55_false
main_l55_false:
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
                        jmp main_l56_end
.globl main_l54_true
main_l54_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l56_end
main_l56_end:            ## end of if conditional
                        movq %r13, -552(%rbp)
                        ## if t$68 jump to main_l13
                        movq -552(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l13
                        ## Basic block: BB25
                        ## if t$67 jump to main_l12
                        movq -544(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l12
                        ## Basic block: BB26
                        ## then branch
                        ## Basic block: BB27
.globl main_l12
main_l12:
                        ## new String t$69 <- "x is less than 5\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string19 holds "x is less than 5\n"
                        movq $string19, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -560(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$69 (pointer)
                        movq -560(%rbp), %r13
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
                        ## (temp <- temp): t$71 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -576(%rbp)
                        ## unconditional jump to main_l14
                        jmp main_l14
                        ## Basic block: BB28
                        ## else branch
                        ## Basic block: BB29
.globl main_l13
main_l13:
                        ## new String t$70 <- "x is between 5 and 9\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string20 holds "x is between 5 and 9\n"
                        movq $string20, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -568(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$70 (pointer)
                        movq -568(%rbp), %r13
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
                        ## (temp <- temp): t$71 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -576(%rbp)
                        ## unconditional jump to main_l14
                        jmp main_l14
                        ## Basic block: BB30
                        ## if-join
                        ## Basic block: BB31
.globl main_l14
main_l14:
                        ## (temp <- temp): t$79 <- t$71
                        movq -576(%rbp), %r13
                        movq %r13, -640(%rbp)
                        ## unconditional jump to main_l11
                        jmp main_l11
                        ## Basic block: BB32
                        ## else branch
                        ## Basic block: BB33
.globl main_l10
main_l10:
                        ## (temp <- temp): t$72 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -584(%rbp)
                        ## new int t$73 <- 20
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $20, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -592(%rbp)
                        ## t$74 <- t$72 <= t$73 
                        pushq %r12
                        pushq %rbp
                        ## t$72
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -584(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## t$73
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -592(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call le_handler
                        addq $24, %rsp
                        movq %r13, -600(%rbp)
                        popq %rbp
                        popq %r12
                        ## t$75 <- not t$74
                        movq -600(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l57_true
.globl main_l58_false
main_l58_false:
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
                        jmp main_l59_end
.globl main_l57_true
main_l57_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l59_end
main_l59_end:            ## end of if conditional
                        movq %r13, -608(%rbp)
                        ## if t$75 jump to main_l16
                        movq -608(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l16
                        ## Basic block: BB34
                        ## if t$74 jump to main_l15
                        movq -600(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l15
                        ## Basic block: BB35
                        ## then branch
                        ## Basic block: BB36
.globl main_l15
main_l15:
                        ## new String t$76 <- "x is between 10 and 20\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string21 holds "x is between 10 and 20\n"
                        movq $string21, %r14
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
                        ## unconditional jump to main_l17
                        jmp main_l17
                        ## Basic block: BB37
                        ## else branch
                        ## Basic block: BB38
.globl main_l16
main_l16:
                        ## new String t$77 <- "x is greater than 20\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "x is greater than 20\n"
                        movq $string22, %r14
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
                        ## unconditional jump to main_l17
                        jmp main_l17
                        ## Basic block: BB39
                        ## if-join
                        ## Basic block: BB40
.globl main_l17
main_l17:
                        ## (temp <- temp): t$79 <- t$78
                        movq -632(%rbp), %r13
                        movq %r13, -640(%rbp)
                        ## unconditional jump to main_l11
                        jmp main_l11
                        ## Basic block: BB41
                        ## if-join
                        ## Basic block: BB42
.globl main_l11
main_l11:
                        ## new String t$80 <- "\nComplex arithmetic with conditions:\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string23 holds "\nComplex arithmetic with conditions:\n"
                        movq $string23, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -648(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$80 (pointer)
                        movq -648(%rbp), %r13
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
                        ## (temp <- temp): t$81 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -656(%rbp)
                        ## t$82 <- not t$81
                        movq -656(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l60_true
.globl main_l61_false
main_l61_false:
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
                        jmp main_l62_end
.globl main_l60_true
main_l60_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l62_end
main_l62_end:            ## end of if conditional
                        movq %r13, -664(%rbp)
                        ## if t$82 jump to main_l19
                        movq -664(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l19
                        ## Basic block: BB43
                        ## if t$81 jump to main_l18
                        movq -656(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l18
                        ## Basic block: BB44
                        ## then branch
                        ## Basic block: BB45
.globl main_l18
main_l18:
                        ## (temp <- temp): t$83 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -672(%rbp)
                        ## new int t$84 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
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
                        ## new int t$86 <- 10
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -696(%rbp)
                        ## t$87 <- t$85 + t$86
                        movq -688(%rbp), %r13
                        movq -696(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -704(%rbp)
                        ## (temp <- temp): t$1 <- t$87
                        movq -704(%rbp), %r13
                        movq %r13, -16(%rbp)
                        ## (temp <- temp): t$88 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -712(%rbp)
                        ## (temp <- temp): t$95 <- t$88
                        movq -712(%rbp), %r13
                        movq %r13, -768(%rbp)
                        ## unconditional jump to main_l20
                        jmp main_l20
                        ## Basic block: BB46
                        ## else branch
                        ## Basic block: BB47
.globl main_l19
main_l19:
                        ## (temp <- temp): t$89 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -720(%rbp)
                        ## new int t$90 <- 3
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
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
                        ## new int t$92 <- 5
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -744(%rbp)
                        ## t$93 <- t$91 - t$92
                        movq -736(%rbp), %r13
                        movq -744(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -752(%rbp)
                        ## (temp <- temp): t$1 <- t$93
                        movq -752(%rbp), %r13
                        movq %r13, -16(%rbp)
                        ## (temp <- temp): t$94 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -760(%rbp)
                        ## (temp <- temp): t$95 <- t$94
                        movq -760(%rbp), %r13
                        movq %r13, -768(%rbp)
                        ## unconditional jump to main_l20
                        jmp main_l20
                        ## Basic block: BB48
                        ## if-join
                        ## Basic block: BB49
.globl main_l20
main_l20:
                        ## (temp <- temp): t$96 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -776(%rbp)
                        ## t$97 <- not t$96
                        movq -776(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l63_true
.globl main_l64_false
main_l64_false:
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
                        jmp main_l65_end
.globl main_l63_true
main_l63_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l65_end
main_l65_end:            ## end of if conditional
                        movq %r13, -784(%rbp)
                        ## if t$97 jump to main_l22
                        movq -784(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l22
                        ## Basic block: BB50
                        ## if t$96 jump to main_l21
                        movq -776(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l21
                        ## Basic block: BB51
                        ## then branch
                        ## Basic block: BB52
.globl main_l21
main_l21:
                        ## (temp <- temp): t$98 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -792(%rbp)
                        ## (temp <- temp): t$99 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -800(%rbp)
                        ## new int t$100 <- 4
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
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
                        ## (temp <- temp): t$2 <- t$102
                        movq -824(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$103 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -832(%rbp)
                        ## (temp <- temp): t$110 <- t$103
                        movq -832(%rbp), %r13
                        movq %r13, -888(%rbp)
                        ## unconditional jump to main_l23
                        jmp main_l23
                        ## Basic block: BB53
                        ## else branch
                        ## Basic block: BB54
.globl main_l22
main_l22:
                        ## (temp <- temp): t$104 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -840(%rbp)
                        ## (temp <- temp): t$105 <- t$5
                        movq -48(%rbp), %r13
                        movq %r13, -848(%rbp)
                        ## new int t$106 <- 2
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
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
                        ## t$108 <- t$104 - t$107
                        movq -840(%rbp), %r13
                        movq -864(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -872(%rbp)
                        ## (temp <- temp): t$2 <- t$108
                        movq -872(%rbp), %r13
                        movq %r13, -24(%rbp)
                        ## (temp <- temp): t$109 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -880(%rbp)
                        ## (temp <- temp): t$110 <- t$109
                        movq -880(%rbp), %r13
                        movq %r13, -888(%rbp)
                        ## unconditional jump to main_l23
                        jmp main_l23
                        ## Basic block: BB55
                        ## if-join
                        ## Basic block: BB56
.globl main_l23
main_l23:
                        ## new String t$111 <- "a = "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string24 holds "a = "
                        movq $string24, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -896(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$111 (pointer)
                        movq -896(%rbp), %r13
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
                        ## (temp <- temp): t$112 <- t$1
                        movq -16(%rbp), %r13
                        movq %r13, -904(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -904(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$112
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
                        ## new String t$113 <- "\nb = "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string25 holds "\nb = "
                        movq $string25, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -912(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$113 (pointer)
                        movq -912(%rbp), %r13
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
                        ## (temp <- temp): t$114 <- t$2
                        movq -24(%rbp), %r13
                        movq %r13, -920(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -920(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$114
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
                        ## new String t$115 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string26 holds "\n"
                        movq $string26, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -928(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$115 (pointer)
                        movq -928(%rbp), %r13
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
                        ## new String t$116 <- "\nEnter a string: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string27 holds "\nEnter a string: "
                        movq $string27, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -936(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$116 (pointer)
                        movq -936(%rbp), %r13
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
                        ## new String t$117 <- "\nBoolean combinations:\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string28 holds "\nBoolean combinations:\n"
                        movq $string28, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -944(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$117 (pointer)
                        movq -944(%rbp), %r13
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
                        ## (temp <- temp): t$118 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -952(%rbp)
                        ## t$119 <- not t$118
                        movq -952(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l66_true
.globl main_l67_false
main_l67_false:
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
                        jmp main_l68_end
.globl main_l66_true
main_l66_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l68_end
main_l68_end:            ## end of if conditional
                        movq %r13, -960(%rbp)
                        ## if t$119 jump to main_l25
                        movq -960(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l25
                        ## Basic block: BB57
                        ## if t$118 jump to main_l24
                        movq -952(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l24
                        ## Basic block: BB58
                        ## then branch
                        ## Basic block: BB59
.globl main_l24
main_l24:
                        ## (temp <- temp): t$120 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -968(%rbp)
                        ## t$121 <- not t$120
                        movq -968(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l69_true
.globl main_l70_false
main_l70_false:
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
                        jmp main_l71_end
.globl main_l69_true
main_l69_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l71_end
main_l71_end:            ## end of if conditional
                        movq %r13, -976(%rbp)
                        ## if t$121 jump to main_l28
                        movq -976(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l28
                        ## Basic block: BB60
                        ## if t$120 jump to main_l27
                        movq -968(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l27
                        ## Basic block: BB61
                        ## then branch
                        ## Basic block: BB62
.globl main_l27
main_l27:
                        ## new String t$122 <- "Both bool1 and bool2 are true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string29 holds "Both bool1 and bool2 are true\n"
                        movq $string29, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -984(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$122 (pointer)
                        movq -984(%rbp), %r13
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
                        ## (temp <- temp): t$124 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -1000(%rbp)
                        ## unconditional jump to main_l29
                        jmp main_l29
                        ## Basic block: BB63
                        ## else branch
                        ## Basic block: BB64
.globl main_l28
main_l28:
                        ## new String t$123 <- "bool1 is true but bool2 is false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string30 holds "bool1 is true but bool2 is false\n"
                        movq $string30, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -992(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$123 (pointer)
                        movq -992(%rbp), %r13
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
                        ## (temp <- temp): t$124 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -1000(%rbp)
                        ## unconditional jump to main_l29
                        jmp main_l29
                        ## Basic block: BB65
                        ## if-join
                        ## Basic block: BB66
.globl main_l29
main_l29:
                        ## (temp <- temp): t$130 <- t$124
                        movq -1000(%rbp), %r13
                        movq %r13, -1048(%rbp)
                        ## unconditional jump to main_l26
                        jmp main_l26
                        ## Basic block: BB67
                        ## else branch
                        ## Basic block: BB68
.globl main_l25
main_l25:
                        ## (temp <- temp): t$125 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1008(%rbp)
                        ## t$126 <- not t$125
                        movq -1008(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l72_true
.globl main_l73_false
main_l73_false:
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
                        jmp main_l74_end
.globl main_l72_true
main_l72_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l74_end
main_l74_end:            ## end of if conditional
                        movq %r13, -1016(%rbp)
                        ## if t$126 jump to main_l31
                        movq -1016(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l31
                        ## Basic block: BB69
                        ## if t$125 jump to main_l30
                        movq -1008(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l30
                        ## Basic block: BB70
                        ## then branch
                        ## Basic block: BB71
.globl main_l30
main_l30:
                        ## new String t$127 <- "bool1 is false but bool3 is true\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string31 holds "bool1 is false but bool3 is true\n"
                        movq $string31, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1024(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$127 (pointer)
                        movq -1024(%rbp), %r13
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
                        ## (temp <- temp): t$129 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -1040(%rbp)
                        ## unconditional jump to main_l32
                        jmp main_l32
                        ## Basic block: BB72
                        ## else branch
                        ## Basic block: BB73
.globl main_l31
main_l31:
                        ## new String t$128 <- "bool1 and bool3 are both false\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string32 holds "bool1 and bool3 are both false\n"
                        movq $string32, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1032(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$128 (pointer)
                        movq -1032(%rbp), %r13
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
                        ## (temp <- temp): t$129 <- t$0
                        movq -8(%rbp), %r13
                        movq %r13, -1040(%rbp)
                        ## unconditional jump to main_l32
                        jmp main_l32
                        ## Basic block: BB74
                        ## if-join
                        ## Basic block: BB75
.globl main_l32
main_l32:
                        ## (temp <- temp): t$130 <- t$129
                        movq -1040(%rbp), %r13
                        movq %r13, -1048(%rbp)
                        ## unconditional jump to main_l26
                        jmp main_l26
                        ## Basic block: BB76
                        ## if-join
                        ## Basic block: BB77
.globl main_l26
main_l26:
                        ## new int t$131 <- 0
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1056(%rbp)
                        ## (temp <- temp): t$6 <- t$131
                        movq -1056(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$132 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1064(%rbp)
                        ## (temp <- temp): t$133 <- t$7
                        movq -64(%rbp), %r13
                        movq %r13, -1072(%rbp)
                        ## t$134 <- not t$133
                        movq -1072(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l75_true
.globl main_l76_false
main_l76_false:
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
                        jmp main_l77_end
.globl main_l75_true
main_l75_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l77_end
main_l77_end:            ## end of if conditional
                        movq %r13, -1080(%rbp)
                        ## if t$134 jump to main_l34
                        movq -1080(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l34
                        ## Basic block: BB78
                        ## if t$133 jump to main_l33
                        movq -1072(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l33
                        ## Basic block: BB79
                        ## then branch
                        ## Basic block: BB80
.globl main_l33
main_l33:
                        ## (temp <- temp): t$135 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1088(%rbp)
                        ## new int t$136 <- 100
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $100, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1096(%rbp)
                        ## t$137 <- t$135 + t$136
                        movq -1088(%rbp), %r13
                        movq -1096(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1104(%rbp)
                        ## (temp <- temp): t$6 <- t$137
                        movq -1104(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$138 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1112(%rbp)
                        ## (temp <- temp): t$143 <- t$138
                        movq -1112(%rbp), %r13
                        movq %r13, -1152(%rbp)
                        ## unconditional jump to main_l35
                        jmp main_l35
                        ## Basic block: BB81
                        ## else branch
                        ## Basic block: BB82
.globl main_l34
main_l34:
                        ## (temp <- temp): t$139 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1120(%rbp)
                        ## new int t$140 <- 50
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $50, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1128(%rbp)
                        ## t$141 <- t$139 - t$140
                        movq -1120(%rbp), %r13
                        movq -1128(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1136(%rbp)
                        ## (temp <- temp): t$6 <- t$141
                        movq -1136(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$142 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1144(%rbp)
                        ## (temp <- temp): t$143 <- t$142
                        movq -1144(%rbp), %r13
                        movq %r13, -1152(%rbp)
                        ## unconditional jump to main_l35
                        jmp main_l35
                        ## Basic block: BB83
                        ## if-join
                        ## Basic block: BB84
.globl main_l35
main_l35:
                        ## (temp <- temp): t$144 <- t$8
                        movq -72(%rbp), %r13
                        movq %r13, -1160(%rbp)
                        ## t$145 <- not t$144
                        movq -1160(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l78_true
.globl main_l79_false
main_l79_false:
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
                        jmp main_l80_end
.globl main_l78_true
main_l78_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l80_end
main_l80_end:            ## end of if conditional
                        movq %r13, -1168(%rbp)
                        ## if t$145 jump to main_l37
                        movq -1168(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l37
                        ## Basic block: BB85
                        ## if t$144 jump to main_l36
                        movq -1160(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l36
                        ## Basic block: BB86
                        ## then branch
                        ## Basic block: BB87
.globl main_l36
main_l36:
                        ## (temp <- temp): t$146 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1176(%rbp)
                        ## new int t$147 <- 200
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $200, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1184(%rbp)
                        ## t$148 <- t$146 + t$147
                        movq -1176(%rbp), %r13
                        movq -1184(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1192(%rbp)
                        ## (temp <- temp): t$6 <- t$148
                        movq -1192(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$149 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1200(%rbp)
                        ## (temp <- temp): t$154 <- t$149
                        movq -1200(%rbp), %r13
                        movq %r13, -1240(%rbp)
                        ## unconditional jump to main_l38
                        jmp main_l38
                        ## Basic block: BB88
                        ## else branch
                        ## Basic block: BB89
.globl main_l37
main_l37:
                        ## (temp <- temp): t$150 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1208(%rbp)
                        ## new int t$151 <- 25
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $25, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1216(%rbp)
                        ## t$152 <- t$150 - t$151
                        movq -1208(%rbp), %r13
                        movq -1216(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1224(%rbp)
                        ## (temp <- temp): t$6 <- t$152
                        movq -1224(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$153 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1232(%rbp)
                        ## (temp <- temp): t$154 <- t$153
                        movq -1232(%rbp), %r13
                        movq %r13, -1240(%rbp)
                        ## unconditional jump to main_l38
                        jmp main_l38
                        ## Basic block: BB90
                        ## if-join
                        ## Basic block: BB91
.globl main_l38
main_l38:
                        ## (temp <- temp): t$155 <- t$9
                        movq -80(%rbp), %r13
                        movq %r13, -1248(%rbp)
                        ## t$156 <- not t$155
                        movq -1248(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l81_true
.globl main_l82_false
main_l82_false:
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
                        jmp main_l83_end
.globl main_l81_true
main_l81_true:
                        ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl main_l83_end
main_l83_end:            ## end of if conditional
                        movq %r13, -1256(%rbp)
                        ## if t$156 jump to main_l40
                        movq -1256(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l40
                        ## Basic block: BB92
                        ## if t$155 jump to main_l39
                        movq -1248(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
                        jne main_l39
                        ## Basic block: BB93
                        ## then branch
                        ## Basic block: BB94
.globl main_l39
main_l39:
                        ## (temp <- temp): t$157 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1264(%rbp)
                        ## new int t$158 <- 300
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $300, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1272(%rbp)
                        ## t$159 <- t$157 + t$158
                        movq -1264(%rbp), %r13
                        movq -1272(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -1280(%rbp)
                        ## (temp <- temp): t$6 <- t$159
                        movq -1280(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$160 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1288(%rbp)
                        ## (temp <- temp): t$165 <- t$160
                        movq -1288(%rbp), %r13
                        movq %r13, -1328(%rbp)
                        ## unconditional jump to main_l41
                        jmp main_l41
                        ## Basic block: BB95
                        ## else branch
                        ## Basic block: BB96
.globl main_l40
main_l40:
                        ## (temp <- temp): t$161 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1296(%rbp)
                        ## new int t$162 <- 75
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $75, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -1304(%rbp)
                        ## t$163 <- t$161 - t$162
                        movq -1296(%rbp), %r13
                        movq -1304(%rbp), %r14
                        subq %r14, %r13
                        movq %r13, -1312(%rbp)
                        ## (temp <- temp): t$6 <- t$163
                        movq -1312(%rbp), %r13
                        movq %r13, -56(%rbp)
                        ## (temp <- temp): t$164 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1320(%rbp)
                        ## (temp <- temp): t$165 <- t$164
                        movq -1320(%rbp), %r13
                        movq %r13, -1328(%rbp)
                        ## unconditional jump to main_l41
                        jmp main_l41
                        ## Basic block: BB97
                        ## if-join
                        ## Basic block: BB98
.globl main_l41
main_l41:
                        ## new String t$166 <- "\nFinal result: "
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string33 holds "\nFinal result: "
                        movq $string33, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1336(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$166 (pointer)
                        movq -1336(%rbp), %r13
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
                        ## (temp <- temp): t$167 <- t$6
                        movq -56(%rbp), %r13
                        movq %r13, -1344(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq  -1344(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13,       0(%rbp)
                        ## out_int(...)
                        pushq %r12
                        pushq %rbp
                        ## t$167
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
                        ## new String t$168 <- "\n"
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string26 holds "\n"
                        movq $string26, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -1352(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## arg t$168 (pointer)
                        movq -1352(%rbp), %r13
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
                        movq $string34, %r13
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
string8:			  # "Enter a value for x: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 97	# 'a'
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
string9:			  # "Enter a value for c: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 97	# 'a'
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
.byte 99	# 'c'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string10
string10:			  # "Enter a value for d: "
.byte 69	# 'E'
.byte 110	# 'n'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 97	# 'a'
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
.byte 100	# 'd'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string11
string11:			  # "\nBoolean test results:\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 66	# 'B'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 101	# 'e'
.byte 97	# 'a'
.byte 110	# 'n'
.byte 32	# ' '
.byte 116	# 't'
.byte 101	# 'e'
.byte 115	# 's'
.byte 116	# 't'
.byte 32	# ' '
.byte 114	# 'r'
.byte 101	# 'e'
.byte 115	# 's'
.byte 117	# 'u'
.byte 108	# 'l'
.byte 116	# 't'
.byte 115	# 's'
.byte 58	# ':'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string12
string12:			  # "4 < 6 is true\n"
.byte 52	# '4'
.byte 32	# ' '
.byte 60	# '<'
.byte 32	# ' '
.byte 54	# '6'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string13
string13:			  # "4 < 6 is false\n"
.byte 52	# '4'
.byte 32	# ' '
.byte 60	# '<'
.byte 32	# ' '
.byte 54	# '6'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string14
string14:			  # "x <= 5 is true\n"
.byte 120	# 'x'
.byte 32	# ' '
.byte 60	# '<'
.byte 61	# '='
.byte 32	# ' '
.byte 53	# '5'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string15
string15:			  # "x <= 5 is false\n"
.byte 120	# 'x'
.byte 32	# ' '
.byte 60	# '<'
.byte 61	# '='
.byte 32	# ' '
.byte 53	# '5'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
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
string16:			  # "c = d is true\n"
.byte 99	# 'c'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 100	# 'd'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string17
string17:			  # "c = d is false\n"
.byte 99	# 'c'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 100	# 'd'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string18
string18:			  # "\nTesting nested if statements:\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 84	# 'T'
.byte 101	# 'e'
.byte 115	# 's'
.byte 116	# 't'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 103	# 'g'
.byte 32	# ' '
.byte 110	# 'n'
.byte 101	# 'e'
.byte 115	# 's'
.byte 116	# 't'
.byte 101	# 'e'
.byte 100	# 'd'
.byte 32	# ' '
.byte 105	# 'i'
.byte 102	# 'f'
.byte 32	# ' '
.byte 115	# 's'
.byte 116	# 't'
.byte 97	# 'a'
.byte 116	# 't'
.byte 101	# 'e'
.byte 109	# 'm'
.byte 101	# 'e'
.byte 110	# 'n'
.byte 116	# 't'
.byte 115	# 's'
.byte 58	# ':'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string19
string19:			  # "x is less than 5\n"
.byte 120	# 'x'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 108	# 'l'
.byte 101	# 'e'
.byte 115	# 's'
.byte 115	# 's'
.byte 32	# ' '
.byte 116	# 't'
.byte 104	# 'h'
.byte 97	# 'a'
.byte 110	# 'n'
.byte 32	# ' '
.byte 53	# '5'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string20
string20:			  # "x is between 5 and 9\n"
.byte 120	# 'x'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 98	# 'b'
.byte 101	# 'e'
.byte 116	# 't'
.byte 119	# 'w'
.byte 101	# 'e'
.byte 101	# 'e'
.byte 110	# 'n'
.byte 32	# ' '
.byte 53	# '5'
.byte 32	# ' '
.byte 97	# 'a'
.byte 110	# 'n'
.byte 100	# 'd'
.byte 32	# ' '
.byte 57	# '9'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string21
string21:			  # "x is between 10 and 20\n"
.byte 120	# 'x'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 98	# 'b'
.byte 101	# 'e'
.byte 116	# 't'
.byte 119	# 'w'
.byte 101	# 'e'
.byte 101	# 'e'
.byte 110	# 'n'
.byte 32	# ' '
.byte 49	# '1'
.byte 48	# '0'
.byte 32	# ' '
.byte 97	# 'a'
.byte 110	# 'n'
.byte 100	# 'd'
.byte 32	# ' '
.byte 50	# '2'
.byte 48	# '0'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string22
string22:			  # "x is greater than 20\n"
.byte 120	# 'x'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 103	# 'g'
.byte 114	# 'r'
.byte 101	# 'e'
.byte 97	# 'a'
.byte 116	# 't'
.byte 101	# 'e'
.byte 114	# 'r'
.byte 32	# ' '
.byte 116	# 't'
.byte 104	# 'h'
.byte 97	# 'a'
.byte 110	# 'n'
.byte 32	# ' '
.byte 50	# '2'
.byte 48	# '0'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string23
string23:			  # "\nComplex arithmetic with conditions:\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 67	# 'C'
.byte 111	# 'o'
.byte 109	# 'm'
.byte 112	# 'p'
.byte 108	# 'l'
.byte 101	# 'e'
.byte 120	# 'x'
.byte 32	# ' '
.byte 97	# 'a'
.byte 114	# 'r'
.byte 105	# 'i'
.byte 116	# 't'
.byte 104	# 'h'
.byte 109	# 'm'
.byte 101	# 'e'
.byte 116	# 't'
.byte 105	# 'i'
.byte 99	# 'c'
.byte 32	# ' '
.byte 119	# 'w'
.byte 105	# 'i'
.byte 116	# 't'
.byte 104	# 'h'
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
.byte 115	# 's'
.byte 58	# ':'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string24
string24:			  # "a = "
.byte 97	# 'a'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 0	


.globl string25
string25:			  # "\nb = "
.byte 92	# '\\'
.byte 110	# 'n'
.byte 98	# 'b'
.byte 32	# ' '
.byte 61	# '='
.byte 32	# ' '
.byte 0	


.globl string26
string26:			  # "\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string27
string27:			  # "\nEnter a string: "
.byte 92	# '\\'
.byte 110	# 'n'
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


.globl string28
string28:			  # "\nBoolean combinations:\n"
.byte 92	# '\\'
.byte 110	# 'n'
.byte 66	# 'B'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 101	# 'e'
.byte 97	# 'a'
.byte 110	# 'n'
.byte 32	# ' '
.byte 99	# 'c'
.byte 111	# 'o'
.byte 109	# 'm'
.byte 98	# 'b'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 97	# 'a'
.byte 116	# 't'
.byte 105	# 'i'
.byte 111	# 'o'
.byte 110	# 'n'
.byte 115	# 's'
.byte 58	# ':'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string29
string29:			  # "Both bool1 and bool2 are true\n"
.byte 66	# 'B'
.byte 111	# 'o'
.byte 116	# 't'
.byte 104	# 'h'
.byte 32	# ' '
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 49	# '1'
.byte 32	# ' '
.byte 97	# 'a'
.byte 110	# 'n'
.byte 100	# 'd'
.byte 32	# ' '
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 50	# '2'
.byte 32	# ' '
.byte 97	# 'a'
.byte 114	# 'r'
.byte 101	# 'e'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string30
string30:			  # "bool1 is true but bool2 is false\n"
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 49	# '1'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 32	# ' '
.byte 98	# 'b'
.byte 117	# 'u'
.byte 116	# 't'
.byte 32	# ' '
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 50	# '2'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string31
string31:			  # "bool1 is false but bool3 is true\n"
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 49	# '1'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 32	# ' '
.byte 98	# 'b'
.byte 117	# 'u'
.byte 116	# 't'
.byte 32	# ' '
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 51	# '3'
.byte 32	# ' '
.byte 105	# 'i'
.byte 115	# 's'
.byte 32	# ' '
.byte 116	# 't'
.byte 114	# 'r'
.byte 117	# 'u'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string32
string32:			  # "bool1 and bool3 are both false\n"
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 49	# '1'
.byte 32	# ' '
.byte 97	# 'a'
.byte 110	# 'n'
.byte 100	# 'd'
.byte 32	# ' '
.byte 98	# 'b'
.byte 111	# 'o'
.byte 111	# 'o'
.byte 108	# 'l'
.byte 51	# '3'
.byte 32	# ' '
.byte 97	# 'a'
.byte 114	# 'r'
.byte 101	# 'e'
.byte 32	# ' '
.byte 98	# 'b'
.byte 111	# 'o'
.byte 116	# 't'
.byte 104	# 'h'
.byte 32	# ' '
.byte 102	# 'f'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 115	# 's'
.byte 101	# 'e'
.byte 92	# '\\'
.byte 110	# 'n'
.byte 0	


.globl string33
string33:			  # "\nFinal result: "
.byte 92	# '\\'
.byte 110	# 'n'
.byte 70	# 'F'
.byte 105	# 'i'
.byte 110	# 'n'
.byte 97	# 'a'
.byte 108	# 'l'
.byte 32	# ' '
.byte 114	# 'r'
.byte 101	# 'e'
.byte 115	# 's'
.byte 117	# 'u'
.byte 108	# 'l'
.byte 116	# 't'
.byte 58	# ':'
.byte 32	# ' '
.byte 0	


.globl string34
string34:			  # "ERROR: 0: Exception: String.substr out of range\n"
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
