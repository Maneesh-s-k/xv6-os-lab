
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	99010113          	addi	sp,sp,-1648 # 80007990 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff8d937>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	df878793          	addi	a5,a5,-520 # 80000e7c <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	711d                	addi	sp,sp,-96
    800000d6:	ec86                	sd	ra,88(sp)
    800000d8:	e8a2                	sd	s0,80(sp)
    800000da:	e0ca                	sd	s2,64(sp)
    800000dc:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    800000de:	04c05863          	blez	a2,8000012e <consolewrite+0x5a>
    800000e2:	e4a6                	sd	s1,72(sp)
    800000e4:	fc4e                	sd	s3,56(sp)
    800000e6:	f852                	sd	s4,48(sp)
    800000e8:	f456                	sd	s5,40(sp)
    800000ea:	f05a                	sd	s6,32(sp)
    800000ec:	ec5e                	sd	s7,24(sp)
    800000ee:	8a2a                	mv	s4,a0
    800000f0:	84ae                	mv	s1,a1
    800000f2:	89b2                	mv	s3,a2
    800000f4:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000f6:	faf40b93          	addi	s7,s0,-81
    800000fa:	4b05                	li	s6,1
    800000fc:	5afd                	li	s5,-1
    800000fe:	86da                	mv	a3,s6
    80000100:	8626                	mv	a2,s1
    80000102:	85d2                	mv	a1,s4
    80000104:	855e                	mv	a0,s7
    80000106:	26e020ef          	jal	80002374 <either_copyin>
    8000010a:	03550463          	beq	a0,s5,80000132 <consolewrite+0x5e>
      break;
    uartputc(c);
    8000010e:	faf44503          	lbu	a0,-81(s0)
    80000112:	01d000ef          	jal	8000092e <uartputc>
  for(i = 0; i < n; i++){
    80000116:	2905                	addiw	s2,s2,1
    80000118:	0485                	addi	s1,s1,1
    8000011a:	ff2992e3          	bne	s3,s2,800000fe <consolewrite+0x2a>
    8000011e:	894e                	mv	s2,s3
    80000120:	64a6                	ld	s1,72(sp)
    80000122:	79e2                	ld	s3,56(sp)
    80000124:	7a42                	ld	s4,48(sp)
    80000126:	7aa2                	ld	s5,40(sp)
    80000128:	7b02                	ld	s6,32(sp)
    8000012a:	6be2                	ld	s7,24(sp)
    8000012c:	a809                	j	8000013e <consolewrite+0x6a>
    8000012e:	4901                	li	s2,0
    80000130:	a039                	j	8000013e <consolewrite+0x6a>
    80000132:	64a6                	ld	s1,72(sp)
    80000134:	79e2                	ld	s3,56(sp)
    80000136:	7a42                	ld	s4,48(sp)
    80000138:	7aa2                	ld	s5,40(sp)
    8000013a:	7b02                	ld	s6,32(sp)
    8000013c:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60e6                	ld	ra,88(sp)
    80000142:	6446                	ld	s0,80(sp)
    80000144:	6906                	ld	s2,64(sp)
    80000146:	6125                	addi	sp,sp,96
    80000148:	8082                	ret

000000008000014a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000014a:	711d                	addi	sp,sp,-96
    8000014c:	ec86                	sd	ra,88(sp)
    8000014e:	e8a2                	sd	s0,80(sp)
    80000150:	e4a6                	sd	s1,72(sp)
    80000152:	e0ca                	sd	s2,64(sp)
    80000154:	fc4e                	sd	s3,56(sp)
    80000156:	f852                	sd	s4,48(sp)
    80000158:	f456                	sd	s5,40(sp)
    8000015a:	f05a                	sd	s6,32(sp)
    8000015c:	1080                	addi	s0,sp,96
    8000015e:	8aaa                	mv	s5,a0
    80000160:	8a2e                	mv	s4,a1
    80000162:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000164:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80000166:	00010517          	auipc	a0,0x10
    8000016a:	82a50513          	addi	a0,a0,-2006 # 8000f990 <cons>
    8000016e:	289000ef          	jal	80000bf6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000172:	00010497          	auipc	s1,0x10
    80000176:	81e48493          	addi	s1,s1,-2018 # 8000f990 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000017a:	00010917          	auipc	s2,0x10
    8000017e:	8ae90913          	addi	s2,s2,-1874 # 8000fa28 <cons+0x98>
  while(n > 0){
    80000182:	0b305b63          	blez	s3,80000238 <consoleread+0xee>
    while(cons.r == cons.w){
    80000186:	0984a783          	lw	a5,152(s1)
    8000018a:	09c4a703          	lw	a4,156(s1)
    8000018e:	0af71063          	bne	a4,a5,8000022e <consoleread+0xe4>
      if(killed(myproc())){
    80000192:	03b010ef          	jal	800019cc <myproc>
    80000196:	076020ef          	jal	8000220c <killed>
    8000019a:	e12d                	bnez	a0,800001fc <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000019c:	85a6                	mv	a1,s1
    8000019e:	854a                	mv	a0,s2
    800001a0:	635010ef          	jal	80001fd4 <sleep>
    while(cons.r == cons.w){
    800001a4:	0984a783          	lw	a5,152(s1)
    800001a8:	09c4a703          	lw	a4,156(s1)
    800001ac:	fef703e3          	beq	a4,a5,80000192 <consoleread+0x48>
    800001b0:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001b2:	0000f717          	auipc	a4,0xf
    800001b6:	7de70713          	addi	a4,a4,2014 # 8000f990 <cons>
    800001ba:	0017869b          	addiw	a3,a5,1
    800001be:	08d72c23          	sw	a3,152(a4)
    800001c2:	07f7f693          	andi	a3,a5,127
    800001c6:	9736                	add	a4,a4,a3
    800001c8:	01874703          	lbu	a4,24(a4)
    800001cc:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001d0:	4691                	li	a3,4
    800001d2:	04db8663          	beq	s7,a3,8000021e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001d6:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001da:	4685                	li	a3,1
    800001dc:	faf40613          	addi	a2,s0,-81
    800001e0:	85d2                	mv	a1,s4
    800001e2:	8556                	mv	a0,s5
    800001e4:	146020ef          	jal	8000232a <either_copyout>
    800001e8:	57fd                	li	a5,-1
    800001ea:	04f50663          	beq	a0,a5,80000236 <consoleread+0xec>
      break;

    dst++;
    800001ee:	0a05                	addi	s4,s4,1
    --n;
    800001f0:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001f2:	47a9                	li	a5,10
    800001f4:	04fb8b63          	beq	s7,a5,8000024a <consoleread+0x100>
    800001f8:	6be2                	ld	s7,24(sp)
    800001fa:	b761                	j	80000182 <consoleread+0x38>
        release(&cons.lock);
    800001fc:	0000f517          	auipc	a0,0xf
    80000200:	79450513          	addi	a0,a0,1940 # 8000f990 <cons>
    80000204:	287000ef          	jal	80000c8a <release>
        return -1;
    80000208:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000020a:	60e6                	ld	ra,88(sp)
    8000020c:	6446                	ld	s0,80(sp)
    8000020e:	64a6                	ld	s1,72(sp)
    80000210:	6906                	ld	s2,64(sp)
    80000212:	79e2                	ld	s3,56(sp)
    80000214:	7a42                	ld	s4,48(sp)
    80000216:	7aa2                	ld	s5,40(sp)
    80000218:	7b02                	ld	s6,32(sp)
    8000021a:	6125                	addi	sp,sp,96
    8000021c:	8082                	ret
      if(n < target){
    8000021e:	0169fa63          	bgeu	s3,s6,80000232 <consoleread+0xe8>
        cons.r--;
    80000222:	00010717          	auipc	a4,0x10
    80000226:	80f72323          	sw	a5,-2042(a4) # 8000fa28 <cons+0x98>
    8000022a:	6be2                	ld	s7,24(sp)
    8000022c:	a031                	j	80000238 <consoleread+0xee>
    8000022e:	ec5e                	sd	s7,24(sp)
    80000230:	b749                	j	800001b2 <consoleread+0x68>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	a011                	j	80000238 <consoleread+0xee>
    80000236:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000238:	0000f517          	auipc	a0,0xf
    8000023c:	75850513          	addi	a0,a0,1880 # 8000f990 <cons>
    80000240:	24b000ef          	jal	80000c8a <release>
  return target - n;
    80000244:	413b053b          	subw	a0,s6,s3
    80000248:	b7c9                	j	8000020a <consoleread+0xc0>
    8000024a:	6be2                	ld	s7,24(sp)
    8000024c:	b7f5                	j	80000238 <consoleread+0xee>

000000008000024e <consputc>:
{
    8000024e:	1141                	addi	sp,sp,-16
    80000250:	e406                	sd	ra,8(sp)
    80000252:	e022                	sd	s0,0(sp)
    80000254:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000256:	10000793          	li	a5,256
    8000025a:	00f50863          	beq	a0,a5,8000026a <consputc+0x1c>
    uartputc_sync(c);
    8000025e:	5fe000ef          	jal	8000085c <uartputc_sync>
}
    80000262:	60a2                	ld	ra,8(sp)
    80000264:	6402                	ld	s0,0(sp)
    80000266:	0141                	addi	sp,sp,16
    80000268:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026a:	4521                	li	a0,8
    8000026c:	5f0000ef          	jal	8000085c <uartputc_sync>
    80000270:	02000513          	li	a0,32
    80000274:	5e8000ef          	jal	8000085c <uartputc_sync>
    80000278:	4521                	li	a0,8
    8000027a:	5e2000ef          	jal	8000085c <uartputc_sync>
    8000027e:	b7d5                	j	80000262 <consputc+0x14>

0000000080000280 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000280:	7179                	addi	sp,sp,-48
    80000282:	f406                	sd	ra,40(sp)
    80000284:	f022                	sd	s0,32(sp)
    80000286:	ec26                	sd	s1,24(sp)
    80000288:	1800                	addi	s0,sp,48
    8000028a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000028c:	0000f517          	auipc	a0,0xf
    80000290:	70450513          	addi	a0,a0,1796 # 8000f990 <cons>
    80000294:	163000ef          	jal	80000bf6 <acquire>

  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48e63          	beq	s1,a5,80000336 <consoleintr+0xb6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x48>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48863          	beq	s1,a5,80000394 <consoleintr+0x114>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49963          	bne	s1,a5,800003bc <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	110020ef          	jal	800023be <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002b2:	0000f517          	auipc	a0,0xf
    800002b6:	6de50513          	addi	a0,a0,1758 # 8000f990 <cons>
    800002ba:	1d1000ef          	jal	80000c8a <release>
}
    800002be:	70a2                	ld	ra,40(sp)
    800002c0:	7402                	ld	s0,32(sp)
    800002c2:	64e2                	ld	s1,24(sp)
    800002c4:	6145                	addi	sp,sp,48
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48463          	beq	s1,a5,80000394 <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	0000f717          	auipc	a4,0xf
    800002d4:	6c070713          	addi	a4,a4,1728 # 8000f990 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48b63          	beq	s1,a5,800003c2 <consoleintr+0x142>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f5dff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	0000f797          	auipc	a5,0xf
    800002fa:	69a78793          	addi	a5,a5,1690 # 8000f990 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	863a                	mv	a2,a4
    80000308:	0ae7a023          	sw	a4,160(a5)
    8000030c:	07f6f693          	andi	a3,a3,127
    80000310:	97b6                	add	a5,a5,a3
    80000312:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000316:	47a9                	li	a5,10
    80000318:	0cf48963          	beq	s1,a5,800003ea <consoleintr+0x16a>
    8000031c:	4791                	li	a5,4
    8000031e:	0cf48663          	beq	s1,a5,800003ea <consoleintr+0x16a>
    80000322:	0000f797          	auipc	a5,0xf
    80000326:	7067a783          	lw	a5,1798(a5) # 8000fa28 <cons+0x98>
    8000032a:	9f1d                	subw	a4,a4,a5
    8000032c:	08000793          	li	a5,128
    80000330:	f8f711e3          	bne	a4,a5,800002b2 <consoleintr+0x32>
    80000334:	a85d                	j	800003ea <consoleintr+0x16a>
    80000336:	e84a                	sd	s2,16(sp)
    80000338:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    8000033a:	0000f717          	auipc	a4,0xf
    8000033e:	65670713          	addi	a4,a4,1622 # 8000f990 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	0000f497          	auipc	s1,0xf
    8000034e:	64648493          	addi	s1,s1,1606 # 8000f990 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
      consputc(BACKSPACE);
    80000354:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80000358:	02f70863          	beq	a4,a5,80000388 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035c:	37fd                	addiw	a5,a5,-1
    8000035e:	07f7f713          	andi	a4,a5,127
    80000362:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000364:	01874703          	lbu	a4,24(a4)
    80000368:	03270363          	beq	a4,s2,8000038e <consoleintr+0x10e>
      cons.e--;
    8000036c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000370:	854e                	mv	a0,s3
    80000372:	eddff0ef          	jal	8000024e <consputc>
    while(cons.e != cons.w &&
    80000376:	0a04a783          	lw	a5,160(s1)
    8000037a:	09c4a703          	lw	a4,156(s1)
    8000037e:	fcf71fe3          	bne	a4,a5,8000035c <consoleintr+0xdc>
    80000382:	6942                	ld	s2,16(sp)
    80000384:	69a2                	ld	s3,8(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x32>
    80000388:	6942                	ld	s2,16(sp)
    8000038a:	69a2                	ld	s3,8(sp)
    8000038c:	b71d                	j	800002b2 <consoleintr+0x32>
    8000038e:	6942                	ld	s2,16(sp)
    80000390:	69a2                	ld	s3,8(sp)
    80000392:	b705                	j	800002b2 <consoleintr+0x32>
    if(cons.e != cons.w){
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	5fc70713          	addi	a4,a4,1532 # 8000f990 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
    800003a4:	f0f707e3          	beq	a4,a5,800002b2 <consoleintr+0x32>
      cons.e--;
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	0000f717          	auipc	a4,0xf
    800003ae:	68f72323          	sw	a5,1670(a4) # 8000fa30 <cons+0xa0>
      consputc(BACKSPACE);
    800003b2:	10000513          	li	a0,256
    800003b6:	e99ff0ef          	jal	8000024e <consputc>
    800003ba:	bde5                	j	800002b2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003bc:	ee048be3          	beqz	s1,800002b2 <consoleintr+0x32>
    800003c0:	bf01                	j	800002d0 <consoleintr+0x50>
      consputc(c);
    800003c2:	4529                	li	a0,10
    800003c4:	e8bff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c8:	0000f797          	auipc	a5,0xf
    800003cc:	5c878793          	addi	a5,a5,1480 # 8000f990 <cons>
    800003d0:	0a07a703          	lw	a4,160(a5)
    800003d4:	0017069b          	addiw	a3,a4,1
    800003d8:	8636                	mv	a2,a3
    800003da:	0ad7a023          	sw	a3,160(a5)
    800003de:	07f77713          	andi	a4,a4,127
    800003e2:	97ba                	add	a5,a5,a4
    800003e4:	4729                	li	a4,10
    800003e6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003ea:	0000f797          	auipc	a5,0xf
    800003ee:	64c7a123          	sw	a2,1602(a5) # 8000fa2c <cons+0x9c>
        wakeup(&cons.r);
    800003f2:	0000f517          	auipc	a0,0xf
    800003f6:	63650513          	addi	a0,a0,1590 # 8000fa28 <cons+0x98>
    800003fa:	427010ef          	jal	80002020 <wakeup>
    800003fe:	bd55                	j	800002b2 <consoleintr+0x32>

0000000080000400 <consoleinit>:

void
consoleinit(void)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e406                	sd	ra,8(sp)
    80000404:	e022                	sd	s0,0(sp)
    80000406:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000408:	00007597          	auipc	a1,0x7
    8000040c:	bf858593          	addi	a1,a1,-1032 # 80007000 <etext>
    80000410:	0000f517          	auipc	a0,0xf
    80000414:	58050513          	addi	a0,a0,1408 # 8000f990 <cons>
    80000418:	75a000ef          	jal	80000b72 <initlock>

  uartinit();
    8000041c:	3ea000ef          	jal	80000806 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000420:	00070797          	auipc	a5,0x70
    80000424:	91078793          	addi	a5,a5,-1776 # 8006fd30 <devsw>
    80000428:	00000717          	auipc	a4,0x0
    8000042c:	d2270713          	addi	a4,a4,-734 # 8000014a <consoleread>
    80000430:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000432:	00000717          	auipc	a4,0x0
    80000436:	ca270713          	addi	a4,a4,-862 # 800000d4 <consolewrite>
    8000043a:	ef98                	sd	a4,24(a5)
}
    8000043c:	60a2                	ld	ra,8(sp)
    8000043e:	6402                	ld	s0,0(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret

0000000080000444 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000444:	7139                	addi	sp,sp,-64
    80000446:	fc06                	sd	ra,56(sp)
    80000448:	f822                	sd	s0,48(sp)
    8000044a:	f426                	sd	s1,40(sp)
    8000044c:	f04a                	sd	s2,32(sp)
    8000044e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000450:	c219                	beqz	a2,80000456 <printint+0x12>
    80000452:	06054a63          	bltz	a0,800004c6 <printint+0x82>
    x = -xx;
  else
    x = xx;
    80000456:	4e01                	li	t3,0

  i = 0;
    80000458:	fc840313          	addi	t1,s0,-56
    x = xx;
    8000045c:	869a                	mv	a3,t1
  i = 0;
    8000045e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000460:	00007817          	auipc	a6,0x7
    80000464:	38080813          	addi	a6,a6,896 # 800077e0 <digits>
    80000468:	88be                	mv	a7,a5
    8000046a:	0017861b          	addiw	a2,a5,1
    8000046e:	87b2                	mv	a5,a2
    80000470:	02b57733          	remu	a4,a0,a1
    80000474:	9742                	add	a4,a4,a6
    80000476:	00074703          	lbu	a4,0(a4)
    8000047a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000047e:	872a                	mv	a4,a0
    80000480:	02b55533          	divu	a0,a0,a1
    80000484:	0685                	addi	a3,a3,1
    80000486:	feb771e3          	bgeu	a4,a1,80000468 <printint+0x24>

  if(sign)
    8000048a:	000e0c63          	beqz	t3,800004a2 <printint+0x5e>
    buf[i++] = '-';
    8000048e:	fe060793          	addi	a5,a2,-32
    80000492:	00878633          	add	a2,a5,s0
    80000496:	02d00793          	li	a5,45
    8000049a:	fef60423          	sb	a5,-24(a2)
    8000049e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800004a2:	fff7891b          	addiw	s2,a5,-1
    800004a6:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800004aa:	fff4c503          	lbu	a0,-1(s1)
    800004ae:	da1ff0ef          	jal	8000024e <consputc>
  while(--i >= 0)
    800004b2:	397d                	addiw	s2,s2,-1
    800004b4:	14fd                	addi	s1,s1,-1
    800004b6:	fe095ae3          	bgez	s2,800004aa <printint+0x66>
}
    800004ba:	70e2                	ld	ra,56(sp)
    800004bc:	7442                	ld	s0,48(sp)
    800004be:	74a2                	ld	s1,40(sp)
    800004c0:	7902                	ld	s2,32(sp)
    800004c2:	6121                	addi	sp,sp,64
    800004c4:	8082                	ret
    x = -xx;
    800004c6:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004ca:	4e05                	li	t3,1
    x = -xx;
    800004cc:	b771                	j	80000458 <printint+0x14>

00000000800004ce <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004ce:	7155                	addi	sp,sp,-208
    800004d0:	e506                	sd	ra,136(sp)
    800004d2:	e122                	sd	s0,128(sp)
    800004d4:	f0d2                	sd	s4,96(sp)
    800004d6:	0900                	addi	s0,sp,144
    800004d8:	8a2a                	mv	s4,a0
    800004da:	e40c                	sd	a1,8(s0)
    800004dc:	e810                	sd	a2,16(s0)
    800004de:	ec14                	sd	a3,24(s0)
    800004e0:	f018                	sd	a4,32(s0)
    800004e2:	f41c                	sd	a5,40(s0)
    800004e4:	03043823          	sd	a6,48(s0)
    800004e8:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ec:	0000f797          	auipc	a5,0xf
    800004f0:	5647a783          	lw	a5,1380(a5) # 8000fa50 <pr+0x18>
    800004f4:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004f8:	e3a1                	bnez	a5,80000538 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fa:	00840793          	addi	a5,s0,8
    800004fe:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000502:	00054503          	lbu	a0,0(a0)
    80000506:	26050663          	beqz	a0,80000772 <printf+0x2a4>
    8000050a:	fca6                	sd	s1,120(sp)
    8000050c:	f8ca                	sd	s2,112(sp)
    8000050e:	f4ce                	sd	s3,104(sp)
    80000510:	ecd6                	sd	s5,88(sp)
    80000512:	e8da                	sd	s6,80(sp)
    80000514:	e0e2                	sd	s8,64(sp)
    80000516:	fc66                	sd	s9,56(sp)
    80000518:	f86a                	sd	s10,48(sp)
    8000051a:	f46e                	sd	s11,40(sp)
    8000051c:	4981                	li	s3,0
    if(cx != '%'){
    8000051e:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000522:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000526:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052a:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000052e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000532:	07000d93          	li	s11,112
    80000536:	a80d                	j	80000568 <printf+0x9a>
    acquire(&pr.lock);
    80000538:	0000f517          	auipc	a0,0xf
    8000053c:	50050513          	addi	a0,a0,1280 # 8000fa38 <pr>
    80000540:	6b6000ef          	jal	80000bf6 <acquire>
  va_start(ap, fmt);
    80000544:	00840793          	addi	a5,s0,8
    80000548:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054c:	000a4503          	lbu	a0,0(s4)
    80000550:	fd4d                	bnez	a0,8000050a <printf+0x3c>
    80000552:	ac3d                	j	80000790 <printf+0x2c2>
      consputc(cx);
    80000554:	cfbff0ef          	jal	8000024e <consputc>
      continue;
    80000558:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055a:	2485                	addiw	s1,s1,1
    8000055c:	89a6                	mv	s3,s1
    8000055e:	94d2                	add	s1,s1,s4
    80000560:	0004c503          	lbu	a0,0(s1)
    80000564:	1e050b63          	beqz	a0,8000075a <printf+0x28c>
    if(cx != '%'){
    80000568:	ff5516e3          	bne	a0,s5,80000554 <printf+0x86>
    i++;
    8000056c:	0019879b          	addiw	a5,s3,1
    80000570:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80000572:	00fa0733          	add	a4,s4,a5
    80000576:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057a:	1e090063          	beqz	s2,8000075a <printf+0x28c>
    8000057e:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    80000582:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    80000584:	c701                	beqz	a4,8000058c <printf+0xbe>
    80000586:	97d2                	add	a5,a5,s4
    80000588:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    8000058c:	03690763          	beq	s2,s6,800005ba <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80000590:	05890163          	beq	s2,s8,800005d2 <printf+0x104>
    } else if(c0 == 'u'){
    80000594:	0d990b63          	beq	s2,s9,8000066a <printf+0x19c>
    } else if(c0 == 'x'){
    80000598:	13a90163          	beq	s2,s10,800006ba <printf+0x1ec>
    } else if(c0 == 'p'){
    8000059c:	13b90b63          	beq	s2,s11,800006d2 <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a0:	07300793          	li	a5,115
    800005a4:	16f90a63          	beq	s2,a5,80000718 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005a8:	1b590463          	beq	s2,s5,80000750 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005ac:	8556                	mv	a0,s5
    800005ae:	ca1ff0ef          	jal	8000024e <consputc>
      consputc(c0);
    800005b2:	854a                	mv	a0,s2
    800005b4:	c9bff0ef          	jal	8000024e <consputc>
    800005b8:	b74d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005ba:	f8843783          	ld	a5,-120(s0)
    800005be:	00878713          	addi	a4,a5,8
    800005c2:	f8e43423          	sd	a4,-120(s0)
    800005c6:	4605                	li	a2,1
    800005c8:	45a9                	li	a1,10
    800005ca:	4388                	lw	a0,0(a5)
    800005cc:	e79ff0ef          	jal	80000444 <printint>
    800005d0:	b769                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d2:	03670663          	beq	a4,s6,800005fe <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005d6:	05870263          	beq	a4,s8,8000061a <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    800005da:	0b970463          	beq	a4,s9,80000682 <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    800005de:	fda717e3          	bne	a4,s10,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800005e2:	f8843783          	ld	a5,-120(s0)
    800005e6:	00878713          	addi	a4,a5,8
    800005ea:	f8e43423          	sd	a4,-120(s0)
    800005ee:	4601                	li	a2,0
    800005f0:	45c1                	li	a1,16
    800005f2:	6388                	ld	a0,0(a5)
    800005f4:	e51ff0ef          	jal	80000444 <printint>
      i += 1;
    800005f8:	0029849b          	addiw	s1,s3,2
    800005fc:	bfb9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005fe:	f8843783          	ld	a5,-120(s0)
    80000602:	00878713          	addi	a4,a5,8
    80000606:	f8e43423          	sd	a4,-120(s0)
    8000060a:	4605                	li	a2,1
    8000060c:	45a9                	li	a1,10
    8000060e:	6388                	ld	a0,0(a5)
    80000610:	e35ff0ef          	jal	80000444 <printint>
      i += 1;
    80000614:	0029849b          	addiw	s1,s3,2
    80000618:	b789                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061a:	06400793          	li	a5,100
    8000061e:	02f68863          	beq	a3,a5,8000064e <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000622:	07500793          	li	a5,117
    80000626:	06f68c63          	beq	a3,a5,8000069e <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062a:	07800793          	li	a5,120
    8000062e:	f6f69fe3          	bne	a3,a5,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    80000632:	f8843783          	ld	a5,-120(s0)
    80000636:	00878713          	addi	a4,a5,8
    8000063a:	f8e43423          	sd	a4,-120(s0)
    8000063e:	4601                	li	a2,0
    80000640:	45c1                	li	a1,16
    80000642:	6388                	ld	a0,0(a5)
    80000644:	e01ff0ef          	jal	80000444 <printint>
      i += 2;
    80000648:	0039849b          	addiw	s1,s3,3
    8000064c:	b739                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    8000064e:	f8843783          	ld	a5,-120(s0)
    80000652:	00878713          	addi	a4,a5,8
    80000656:	f8e43423          	sd	a4,-120(s0)
    8000065a:	4605                	li	a2,1
    8000065c:	45a9                	li	a1,10
    8000065e:	6388                	ld	a0,0(a5)
    80000660:	de5ff0ef          	jal	80000444 <printint>
      i += 2;
    80000664:	0039849b          	addiw	s1,s3,3
    80000668:	bdcd                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	addi	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4601                	li	a2,0
    80000678:	45a9                	li	a1,10
    8000067a:	4388                	lw	a0,0(a5)
    8000067c:	dc9ff0ef          	jal	80000444 <printint>
    80000680:	bde9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4601                	li	a2,0
    80000690:	45a9                	li	a1,10
    80000692:	6388                	ld	a0,0(a5)
    80000694:	db1ff0ef          	jal	80000444 <printint>
      i += 1;
    80000698:	0029849b          	addiw	s1,s3,2
    8000069c:	bd7d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4601                	li	a2,0
    800006ac:	45a9                	li	a1,10
    800006ae:	6388                	ld	a0,0(a5)
    800006b0:	d95ff0ef          	jal	80000444 <printint>
      i += 2;
    800006b4:	0039849b          	addiw	s1,s3,3
    800006b8:	b54d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006ba:	f8843783          	ld	a5,-120(s0)
    800006be:	00878713          	addi	a4,a5,8
    800006c2:	f8e43423          	sd	a4,-120(s0)
    800006c6:	4601                	li	a2,0
    800006c8:	45c1                	li	a1,16
    800006ca:	4388                	lw	a0,0(a5)
    800006cc:	d79ff0ef          	jal	80000444 <printint>
    800006d0:	b569                	j	8000055a <printf+0x8c>
    800006d2:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d4:	f8843783          	ld	a5,-120(s0)
    800006d8:	00878713          	addi	a4,a5,8
    800006dc:	f8e43423          	sd	a4,-120(s0)
    800006e0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e4:	03000513          	li	a0,48
    800006e8:	b67ff0ef          	jal	8000024e <consputc>
  consputc('x');
    800006ec:	07800513          	li	a0,120
    800006f0:	b5fff0ef          	jal	8000024e <consputc>
    800006f4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f6:	00007b97          	auipc	s7,0x7
    800006fa:	0eab8b93          	addi	s7,s7,234 # 800077e0 <digits>
    800006fe:	03c9d793          	srli	a5,s3,0x3c
    80000702:	97de                	add	a5,a5,s7
    80000704:	0007c503          	lbu	a0,0(a5)
    80000708:	b47ff0ef          	jal	8000024e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0992                	slli	s3,s3,0x4
    8000070e:	397d                	addiw	s2,s2,-1
    80000710:	fe0917e3          	bnez	s2,800006fe <printf+0x230>
    80000714:	6ba6                	ld	s7,72(sp)
    80000716:	b591                	j	8000055a <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007b903          	ld	s2,0(a5)
    80000728:	00090d63          	beqz	s2,80000742 <printf+0x274>
      for(; *s; s++)
    8000072c:	00094503          	lbu	a0,0(s2)
    80000730:	e20505e3          	beqz	a0,8000055a <printf+0x8c>
        consputc(*s);
    80000734:	b1bff0ef          	jal	8000024e <consputc>
      for(; *s; s++)
    80000738:	0905                	addi	s2,s2,1
    8000073a:	00094503          	lbu	a0,0(s2)
    8000073e:	f97d                	bnez	a0,80000734 <printf+0x266>
    80000740:	bd29                	j	8000055a <printf+0x8c>
        s = "(null)";
    80000742:	00007917          	auipc	s2,0x7
    80000746:	8c690913          	addi	s2,s2,-1850 # 80007008 <etext+0x8>
      for(; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printf+0x266>
      consputc('%');
    80000750:	02500513          	li	a0,37
    80000754:	afbff0ef          	jal	8000024e <consputc>
    80000758:	b509                	j	8000055a <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075a:	f7843783          	ld	a5,-136(s0)
    8000075e:	e385                	bnez	a5,8000077e <printf+0x2b0>
    80000760:	74e6                	ld	s1,120(sp)
    80000762:	7946                	ld	s2,112(sp)
    80000764:	79a6                	ld	s3,104(sp)
    80000766:	6ae6                	ld	s5,88(sp)
    80000768:	6b46                	ld	s6,80(sp)
    8000076a:	6c06                	ld	s8,64(sp)
    8000076c:	7ce2                	ld	s9,56(sp)
    8000076e:	7d42                	ld	s10,48(sp)
    80000770:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000772:	4501                	li	a0,0
    80000774:	60aa                	ld	ra,136(sp)
    80000776:	640a                	ld	s0,128(sp)
    80000778:	7a06                	ld	s4,96(sp)
    8000077a:	6169                	addi	sp,sp,208
    8000077c:	8082                	ret
    8000077e:	74e6                	ld	s1,120(sp)
    80000780:	7946                	ld	s2,112(sp)
    80000782:	79a6                	ld	s3,104(sp)
    80000784:	6ae6                	ld	s5,88(sp)
    80000786:	6b46                	ld	s6,80(sp)
    80000788:	6c06                	ld	s8,64(sp)
    8000078a:	7ce2                	ld	s9,56(sp)
    8000078c:	7d42                	ld	s10,48(sp)
    8000078e:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000790:	0000f517          	auipc	a0,0xf
    80000794:	2a850513          	addi	a0,a0,680 # 8000fa38 <pr>
    80000798:	4f2000ef          	jal	80000c8a <release>
    8000079c:	bfd9                	j	80000772 <printf+0x2a4>

000000008000079e <panic>:

void
panic(char *s)
{
    8000079e:	1101                	addi	sp,sp,-32
    800007a0:	ec06                	sd	ra,24(sp)
    800007a2:	e822                	sd	s0,16(sp)
    800007a4:	e426                	sd	s1,8(sp)
    800007a6:	1000                	addi	s0,sp,32
    800007a8:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007aa:	0000f797          	auipc	a5,0xf
    800007ae:	2a07a323          	sw	zero,678(a5) # 8000fa50 <pr+0x18>
  printf("panic: ");
    800007b2:	00007517          	auipc	a0,0x7
    800007b6:	86650513          	addi	a0,a0,-1946 # 80007018 <etext+0x18>
    800007ba:	d15ff0ef          	jal	800004ce <printf>
  printf("%s\n", s);
    800007be:	85a6                	mv	a1,s1
    800007c0:	00007517          	auipc	a0,0x7
    800007c4:	86050513          	addi	a0,a0,-1952 # 80007020 <etext+0x20>
    800007c8:	d07ff0ef          	jal	800004ce <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007cc:	4785                	li	a5,1
    800007ce:	00007717          	auipc	a4,0x7
    800007d2:	18f72123          	sw	a5,386(a4) # 80007950 <panicked>
  for(;;)
    800007d6:	a001                	j	800007d6 <panic+0x38>

00000000800007d8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007d8:	1101                	addi	sp,sp,-32
    800007da:	ec06                	sd	ra,24(sp)
    800007dc:	e822                	sd	s0,16(sp)
    800007de:	e426                	sd	s1,8(sp)
    800007e0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e2:	0000f497          	auipc	s1,0xf
    800007e6:	25648493          	addi	s1,s1,598 # 8000fa38 <pr>
    800007ea:	00007597          	auipc	a1,0x7
    800007ee:	83e58593          	addi	a1,a1,-1986 # 80007028 <etext+0x28>
    800007f2:	8526                	mv	a0,s1
    800007f4:	37e000ef          	jal	80000b72 <initlock>
  pr.locking = 1;
    800007f8:	4785                	li	a5,1
    800007fa:	cc9c                	sw	a5,24(s1)
}
    800007fc:	60e2                	ld	ra,24(sp)
    800007fe:	6442                	ld	s0,16(sp)
    80000800:	64a2                	ld	s1,8(sp)
    80000802:	6105                	addi	sp,sp,32
    80000804:	8082                	ret

0000000080000806 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000806:	1141                	addi	sp,sp,-16
    80000808:	e406                	sd	ra,8(sp)
    8000080a:	e022                	sd	s0,0(sp)
    8000080c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000080e:	100007b7          	lui	a5,0x10000
    80000812:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000816:	10000737          	lui	a4,0x10000
    8000081a:	f8000693          	li	a3,-128
    8000081e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000822:	468d                	li	a3,3
    80000824:	10000637          	lui	a2,0x10000
    80000828:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000082c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000830:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000834:	8732                	mv	a4,a2
    80000836:	461d                	li	a2,7
    80000838:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000083c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000840:	00006597          	auipc	a1,0x6
    80000844:	7f058593          	addi	a1,a1,2032 # 80007030 <etext+0x30>
    80000848:	0000f517          	auipc	a0,0xf
    8000084c:	21050513          	addi	a0,a0,528 # 8000fa58 <uart_tx_lock>
    80000850:	322000ef          	jal	80000b72 <initlock>
}
    80000854:	60a2                	ld	ra,8(sp)
    80000856:	6402                	ld	s0,0(sp)
    80000858:	0141                	addi	sp,sp,16
    8000085a:	8082                	ret

000000008000085c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000085c:	1101                	addi	sp,sp,-32
    8000085e:	ec06                	sd	ra,24(sp)
    80000860:	e822                	sd	s0,16(sp)
    80000862:	e426                	sd	s1,8(sp)
    80000864:	1000                	addi	s0,sp,32
    80000866:	84aa                	mv	s1,a0
  push_off();
    80000868:	34e000ef          	jal	80000bb6 <push_off>

  if(panicked){
    8000086c:	00007797          	auipc	a5,0x7
    80000870:	0e47a783          	lw	a5,228(a5) # 80007950 <panicked>
    80000874:	e795                	bnez	a5,800008a0 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000876:	10000737          	lui	a4,0x10000
    8000087a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000087c:	00074783          	lbu	a5,0(a4)
    80000880:	0207f793          	andi	a5,a5,32
    80000884:	dfe5                	beqz	a5,8000087c <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000886:	0ff4f513          	zext.b	a0,s1
    8000088a:	100007b7          	lui	a5,0x10000
    8000088e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000892:	3a8000ef          	jal	80000c3a <pop_off>
}
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    for(;;)
    800008a0:	a001                	j	800008a0 <uartputc_sync+0x44>

00000000800008a2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a2:	00007797          	auipc	a5,0x7
    800008a6:	0b67b783          	ld	a5,182(a5) # 80007958 <uart_tx_r>
    800008aa:	00007717          	auipc	a4,0x7
    800008ae:	0b673703          	ld	a4,182(a4) # 80007960 <uart_tx_w>
    800008b2:	06f70d63          	beq	a4,a5,8000092c <uartstart+0x8a>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	e05a                	sd	s6,0(sp)
    800008c8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ca:	10000937          	lui	s2,0x10000
    800008ce:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d0:	0000fa97          	auipc	s5,0xf
    800008d4:	188a8a93          	addi	s5,s5,392 # 8000fa58 <uart_tx_lock>
    uart_tx_r += 1;
    800008d8:	00007497          	auipc	s1,0x7
    800008dc:	08048493          	addi	s1,s1,128 # 80007958 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e0:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e4:	00007997          	auipc	s3,0x7
    800008e8:	07c98993          	addi	s3,s3,124 # 80007960 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ec:	00094703          	lbu	a4,0(s2)
    800008f0:	02077713          	andi	a4,a4,32
    800008f4:	c315                	beqz	a4,80000918 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f6:	01f7f713          	andi	a4,a5,31
    800008fa:	9756                	add	a4,a4,s5
    800008fc:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000900:	0785                	addi	a5,a5,1
    80000902:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000904:	8526                	mv	a0,s1
    80000906:	71a010ef          	jal	80002020 <wakeup>
    WriteReg(THR, c);
    8000090a:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000090e:	609c                	ld	a5,0(s1)
    80000910:	0009b703          	ld	a4,0(s3)
    80000914:	fcf71ce3          	bne	a4,a5,800008ec <uartstart+0x4a>
  }
}
    80000918:	70e2                	ld	ra,56(sp)
    8000091a:	7442                	ld	s0,48(sp)
    8000091c:	74a2                	ld	s1,40(sp)
    8000091e:	7902                	ld	s2,32(sp)
    80000920:	69e2                	ld	s3,24(sp)
    80000922:	6a42                	ld	s4,16(sp)
    80000924:	6aa2                	ld	s5,8(sp)
    80000926:	6b02                	ld	s6,0(sp)
    80000928:	6121                	addi	sp,sp,64
    8000092a:	8082                	ret
    8000092c:	8082                	ret

000000008000092e <uartputc>:
{
    8000092e:	7179                	addi	sp,sp,-48
    80000930:	f406                	sd	ra,40(sp)
    80000932:	f022                	sd	s0,32(sp)
    80000934:	ec26                	sd	s1,24(sp)
    80000936:	e84a                	sd	s2,16(sp)
    80000938:	e44e                	sd	s3,8(sp)
    8000093a:	e052                	sd	s4,0(sp)
    8000093c:	1800                	addi	s0,sp,48
    8000093e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000940:	0000f517          	auipc	a0,0xf
    80000944:	11850513          	addi	a0,a0,280 # 8000fa58 <uart_tx_lock>
    80000948:	2ae000ef          	jal	80000bf6 <acquire>
  if(panicked){
    8000094c:	00007797          	auipc	a5,0x7
    80000950:	0047a783          	lw	a5,4(a5) # 80007950 <panicked>
    80000954:	efbd                	bnez	a5,800009d2 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000956:	00007717          	auipc	a4,0x7
    8000095a:	00a73703          	ld	a4,10(a4) # 80007960 <uart_tx_w>
    8000095e:	00007797          	auipc	a5,0x7
    80000962:	ffa7b783          	ld	a5,-6(a5) # 80007958 <uart_tx_r>
    80000966:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000096a:	0000f997          	auipc	s3,0xf
    8000096e:	0ee98993          	addi	s3,s3,238 # 8000fa58 <uart_tx_lock>
    80000972:	00007497          	auipc	s1,0x7
    80000976:	fe648493          	addi	s1,s1,-26 # 80007958 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000097a:	00007917          	auipc	s2,0x7
    8000097e:	fe690913          	addi	s2,s2,-26 # 80007960 <uart_tx_w>
    80000982:	00e79d63          	bne	a5,a4,8000099c <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000986:	85ce                	mv	a1,s3
    80000988:	8526                	mv	a0,s1
    8000098a:	64a010ef          	jal	80001fd4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000098e:	00093703          	ld	a4,0(s2)
    80000992:	609c                	ld	a5,0(s1)
    80000994:	02078793          	addi	a5,a5,32
    80000998:	fee787e3          	beq	a5,a4,80000986 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000099c:	0000f497          	auipc	s1,0xf
    800009a0:	0bc48493          	addi	s1,s1,188 # 8000fa58 <uart_tx_lock>
    800009a4:	01f77793          	andi	a5,a4,31
    800009a8:	97a6                	add	a5,a5,s1
    800009aa:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ae:	0705                	addi	a4,a4,1
    800009b0:	00007797          	auipc	a5,0x7
    800009b4:	fae7b823          	sd	a4,-80(a5) # 80007960 <uart_tx_w>
  uartstart();
    800009b8:	eebff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    800009bc:	8526                	mv	a0,s1
    800009be:	2cc000ef          	jal	80000c8a <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xa4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e406                	sd	ra,8(sp)
    800009d8:	e022                	sd	s0,0(sp)
    800009da:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb89                	beqz	a5,800009f8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    return -1;
    800009f8:	557d                	li	a0,-1
    800009fa:	bfdd                	j	800009f0 <uartgetc+0x1c>

00000000800009fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fc:	1101                	addi	sp,sp,-32
    800009fe:	ec06                	sd	ra,24(sp)
    80000a00:	e822                	sd	s0,16(sp)
    80000a02:	e426                	sd	s1,8(sp)
    80000a04:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80000a06:	100007b7          	lui	a5,0x10000
    80000a0a:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a0e:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a10:	fc5ff0ef          	jal	800009d4 <uartgetc>
    if(c == -1)
    80000a14:	00950563          	beq	a0,s1,80000a1e <uartintr+0x22>
      break;
    consoleintr(c);
    80000a18:	869ff0ef          	jal	80000280 <consoleintr>
  while(1){
    80000a1c:	bfd5                	j	80000a10 <uartintr+0x14>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1e:	0000f497          	auipc	s1,0xf
    80000a22:	03a48493          	addi	s1,s1,58 # 8000fa58 <uart_tx_lock>
    80000a26:	8526                	mv	a0,s1
    80000a28:	1ce000ef          	jal	80000bf6 <acquire>
  uartstart();
    80000a2c:	e77ff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    80000a30:	8526                	mv	a0,s1
    80000a32:	258000ef          	jal	80000c8a <release>
}
    80000a36:	60e2                	ld	ra,24(sp)
    80000a38:	6442                	ld	s0,16(sp)
    80000a3a:	64a2                	ld	s1,8(sp)
    80000a3c:	6105                	addi	sp,sp,32
    80000a3e:	8082                	ret

0000000080000a40 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a40:	1101                	addi	sp,sp,-32
    80000a42:	ec06                	sd	ra,24(sp)
    80000a44:	e822                	sd	s0,16(sp)
    80000a46:	e426                	sd	s1,8(sp)
    80000a48:	e04a                	sd	s2,0(sp)
    80000a4a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4c:	03451793          	slli	a5,a0,0x34
    80000a50:	e7a9                	bnez	a5,80000a9a <kfree+0x5a>
    80000a52:	84aa                	mv	s1,a0
    80000a54:	00070797          	auipc	a5,0x70
    80000a58:	47478793          	addi	a5,a5,1140 # 80070ec8 <end>
    80000a5c:	02f56f63          	bltu	a0,a5,80000a9a <kfree+0x5a>
    80000a60:	47c5                	li	a5,17
    80000a62:	07ee                	slli	a5,a5,0x1b
    80000a64:	02f57b63          	bgeu	a0,a5,80000a9a <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a68:	6605                	lui	a2,0x1
    80000a6a:	4585                	li	a1,1
    80000a6c:	25a000ef          	jal	80000cc6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a70:	0000f917          	auipc	s2,0xf
    80000a74:	02090913          	addi	s2,s2,32 # 8000fa90 <kmem>
    80000a78:	854a                	mv	a0,s2
    80000a7a:	17c000ef          	jal	80000bf6 <acquire>
  r->next = kmem.freelist;
    80000a7e:	01893783          	ld	a5,24(s2)
    80000a82:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a84:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a88:	854a                	mv	a0,s2
    80000a8a:	200000ef          	jal	80000c8a <release>
}
    80000a8e:	60e2                	ld	ra,24(sp)
    80000a90:	6442                	ld	s0,16(sp)
    80000a92:	64a2                	ld	s1,8(sp)
    80000a94:	6902                	ld	s2,0(sp)
    80000a96:	6105                	addi	sp,sp,32
    80000a98:	8082                	ret
    panic("kfree");
    80000a9a:	00006517          	auipc	a0,0x6
    80000a9e:	59e50513          	addi	a0,a0,1438 # 80007038 <etext+0x38>
    80000aa2:	cfdff0ef          	jal	8000079e <panic>

0000000080000aa6 <freerange>:
{
    80000aa6:	7179                	addi	sp,sp,-48
    80000aa8:	f406                	sd	ra,40(sp)
    80000aaa:	f022                	sd	s0,32(sp)
    80000aac:	ec26                	sd	s1,24(sp)
    80000aae:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab0:	6785                	lui	a5,0x1
    80000ab2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab6:	00e504b3          	add	s1,a0,a4
    80000aba:	777d                	lui	a4,0xfffff
    80000abc:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000abe:	94be                	add	s1,s1,a5
    80000ac0:	0295e263          	bltu	a1,s1,80000ae4 <freerange+0x3e>
    80000ac4:	e84a                	sd	s2,16(sp)
    80000ac6:	e44e                	sd	s3,8(sp)
    80000ac8:	e052                	sd	s4,0(sp)
    80000aca:	892e                	mv	s2,a1
    kfree(p);
    80000acc:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	89be                	mv	s3,a5
    kfree(p);
    80000ad0:	01448533          	add	a0,s1,s4
    80000ad4:	f6dff0ef          	jal	80000a40 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94ce                	add	s1,s1,s3
    80000ada:	fe997be3          	bgeu	s2,s1,80000ad0 <freerange+0x2a>
    80000ade:	6942                	ld	s2,16(sp)
    80000ae0:	69a2                	ld	s3,8(sp)
    80000ae2:	6a02                	ld	s4,0(sp)
}
    80000ae4:	70a2                	ld	ra,40(sp)
    80000ae6:	7402                	ld	s0,32(sp)
    80000ae8:	64e2                	ld	s1,24(sp)
    80000aea:	6145                	addi	sp,sp,48
    80000aec:	8082                	ret

0000000080000aee <kinit>:
{
    80000aee:	1141                	addi	sp,sp,-16
    80000af0:	e406                	sd	ra,8(sp)
    80000af2:	e022                	sd	s0,0(sp)
    80000af4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af6:	00006597          	auipc	a1,0x6
    80000afa:	54a58593          	addi	a1,a1,1354 # 80007040 <etext+0x40>
    80000afe:	0000f517          	auipc	a0,0xf
    80000b02:	f9250513          	addi	a0,a0,-110 # 8000fa90 <kmem>
    80000b06:	06c000ef          	jal	80000b72 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0a:	45c5                	li	a1,17
    80000b0c:	05ee                	slli	a1,a1,0x1b
    80000b0e:	00070517          	auipc	a0,0x70
    80000b12:	3ba50513          	addi	a0,a0,954 # 80070ec8 <end>
    80000b16:	f91ff0ef          	jal	80000aa6 <freerange>
}
    80000b1a:	60a2                	ld	ra,8(sp)
    80000b1c:	6402                	ld	s0,0(sp)
    80000b1e:	0141                	addi	sp,sp,16
    80000b20:	8082                	ret

0000000080000b22 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b22:	1101                	addi	sp,sp,-32
    80000b24:	ec06                	sd	ra,24(sp)
    80000b26:	e822                	sd	s0,16(sp)
    80000b28:	e426                	sd	s1,8(sp)
    80000b2a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2c:	0000f497          	auipc	s1,0xf
    80000b30:	f6448493          	addi	s1,s1,-156 # 8000fa90 <kmem>
    80000b34:	8526                	mv	a0,s1
    80000b36:	0c0000ef          	jal	80000bf6 <acquire>
  r = kmem.freelist;
    80000b3a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3c:	c485                	beqz	s1,80000b64 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b3e:	609c                	ld	a5,0(s1)
    80000b40:	0000f517          	auipc	a0,0xf
    80000b44:	f5050513          	addi	a0,a0,-176 # 8000fa90 <kmem>
    80000b48:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4a:	140000ef          	jal	80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b4e:	6605                	lui	a2,0x1
    80000b50:	4595                	li	a1,5
    80000b52:	8526                	mv	a0,s1
    80000b54:	172000ef          	jal	80000cc6 <memset>
  return (void*)r;
}
    80000b58:	8526                	mv	a0,s1
    80000b5a:	60e2                	ld	ra,24(sp)
    80000b5c:	6442                	ld	s0,16(sp)
    80000b5e:	64a2                	ld	s1,8(sp)
    80000b60:	6105                	addi	sp,sp,32
    80000b62:	8082                	ret
  release(&kmem.lock);
    80000b64:	0000f517          	auipc	a0,0xf
    80000b68:	f2c50513          	addi	a0,a0,-212 # 8000fa90 <kmem>
    80000b6c:	11e000ef          	jal	80000c8a <release>
  if(r)
    80000b70:	b7e5                	j	80000b58 <kalloc+0x36>

0000000080000b72 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b72:	1141                	addi	sp,sp,-16
    80000b74:	e406                	sd	ra,8(sp)
    80000b76:	e022                	sd	s0,0(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	60a2                	ld	ra,8(sp)
    80000b86:	6402                	ld	s0,0(sp)
    80000b88:	0141                	addi	sp,sp,16
    80000b8a:	8082                	ret

0000000080000b8c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8c:	411c                	lw	a5,0(a0)
    80000b8e:	e399                	bnez	a5,80000b94 <holding+0x8>
    80000b90:	4501                	li	a0,0
  return r;
}
    80000b92:	8082                	ret
{
    80000b94:	1101                	addi	sp,sp,-32
    80000b96:	ec06                	sd	ra,24(sp)
    80000b98:	e822                	sd	s0,16(sp)
    80000b9a:	e426                	sd	s1,8(sp)
    80000b9c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9e:	6904                	ld	s1,16(a0)
    80000ba0:	60d000ef          	jal	800019ac <mycpu>
    80000ba4:	40a48533          	sub	a0,s1,a0
    80000ba8:	00153513          	seqz	a0,a0
}
    80000bac:	60e2                	ld	ra,24(sp)
    80000bae:	6442                	ld	s0,16(sp)
    80000bb0:	64a2                	ld	s1,8(sp)
    80000bb2:	6105                	addi	sp,sp,32
    80000bb4:	8082                	ret

0000000080000bb6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb6:	1101                	addi	sp,sp,-32
    80000bb8:	ec06                	sd	ra,24(sp)
    80000bba:	e822                	sd	s0,16(sp)
    80000bbc:	e426                	sd	s1,8(sp)
    80000bbe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc0:	100024f3          	csrr	s1,sstatus
  int old = intr_get();

  if(mycpu()->noff == 0){
    80000bc4:	5e9000ef          	jal	800019ac <mycpu>
    80000bc8:	5d3c                	lw	a5,120(a0)
    80000bca:	cb99                	beqz	a5,80000be0 <push_off+0x2a>
    intr_off();
    mycpu()->intena = old;
  }
  mycpu()->noff += 1;
    80000bcc:	5e1000ef          	jal	800019ac <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	2785                	addiw	a5,a5,1
    80000bd4:	dd3c                	sw	a5,120(a0)
}
    80000bd6:	60e2                	ld	ra,24(sp)
    80000bd8:	6442                	ld	s0,16(sp)
    80000bda:	64a2                	ld	s1,8(sp)
    80000bdc:	6105                	addi	sp,sp,32
    80000bde:	8082                	ret
    80000be0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000be4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000be6:	10079073          	csrw	sstatus,a5
    mycpu()->intena = old;
    80000bea:	5c3000ef          	jal	800019ac <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bee:	8085                	srli	s1,s1,0x1
    80000bf0:	8885                	andi	s1,s1,1
    80000bf2:	dd64                	sw	s1,124(a0)
    80000bf4:	bfe1                	j	80000bcc <push_off+0x16>

0000000080000bf6 <acquire>:
{
    80000bf6:	1101                	addi	sp,sp,-32
    80000bf8:	ec06                	sd	ra,24(sp)
    80000bfa:	e822                	sd	s0,16(sp)
    80000bfc:	e426                	sd	s1,8(sp)
    80000bfe:	1000                	addi	s0,sp,32
    80000c00:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c02:	fb5ff0ef          	jal	80000bb6 <push_off>
  if(holding(lk))
    80000c06:	8526                	mv	a0,s1
    80000c08:	f85ff0ef          	jal	80000b8c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0c:	4705                	li	a4,1
  if(holding(lk))
    80000c0e:	e105                	bnez	a0,80000c2e <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c10:	87ba                	mv	a5,a4
    80000c12:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c16:	2781                	sext.w	a5,a5
    80000c18:	ffe5                	bnez	a5,80000c10 <acquire+0x1a>
  __sync_synchronize();
    80000c1a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1e:	58f000ef          	jal	800019ac <mycpu>
    80000c22:	e888                	sd	a0,16(s1)
}
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6105                	addi	sp,sp,32
    80000c2c:	8082                	ret
    panic("acquire");
    80000c2e:	00006517          	auipc	a0,0x6
    80000c32:	41a50513          	addi	a0,a0,1050 # 80007048 <etext+0x48>
    80000c36:	b69ff0ef          	jal	8000079e <panic>

0000000080000c3a <pop_off>:

void
pop_off(void)
{
    80000c3a:	1141                	addi	sp,sp,-16
    80000c3c:	e406                	sd	ra,8(sp)
    80000c3e:	e022                	sd	s0,0(sp)
    80000c40:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c42:	56b000ef          	jal	800019ac <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c4a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4c:	e39d                	bnez	a5,80000c72 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4e:	5d3c                	lw	a5,120(a0)
    80000c50:	02f05763          	blez	a5,80000c7e <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c54:	37fd                	addiw	a5,a5,-1
    80000c56:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c58:	eb89                	bnez	a5,80000c6a <pop_off+0x30>
    80000c5a:	5d7c                	lw	a5,124(a0)
    80000c5c:	c799                	beqz	a5,80000c6a <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6a:	60a2                	ld	ra,8(sp)
    80000c6c:	6402                	ld	s0,0(sp)
    80000c6e:	0141                	addi	sp,sp,16
    80000c70:	8082                	ret
    panic("pop_off - interruptible");
    80000c72:	00006517          	auipc	a0,0x6
    80000c76:	3de50513          	addi	a0,a0,990 # 80007050 <etext+0x50>
    80000c7a:	b25ff0ef          	jal	8000079e <panic>
    panic("pop_off");
    80000c7e:	00006517          	auipc	a0,0x6
    80000c82:	3ea50513          	addi	a0,a0,1002 # 80007068 <etext+0x68>
    80000c86:	b19ff0ef          	jal	8000079e <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	ef7ff0ef          	jal	80000b8c <holding>
    80000c9a:	c105                	beqz	a0,80000cba <release+0x30>
  lk->cpu = 0;
    80000c9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca4:	0310000f          	fence	rw,w
    80000ca8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cac:	f8fff0ef          	jal	80000c3a <pop_off>
}
    80000cb0:	60e2                	ld	ra,24(sp)
    80000cb2:	6442                	ld	s0,16(sp)
    80000cb4:	64a2                	ld	s1,8(sp)
    80000cb6:	6105                	addi	sp,sp,32
    80000cb8:	8082                	ret
    panic("release");
    80000cba:	00006517          	auipc	a0,0x6
    80000cbe:	3b650513          	addi	a0,a0,950 # 80007070 <etext+0x70>
    80000cc2:	addff0ef          	jal	8000079e <panic>

0000000080000cc6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc6:	1141                	addi	sp,sp,-16
    80000cc8:	e406                	sd	ra,8(sp)
    80000cca:	e022                	sd	s0,0(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1e>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x14>
  }
  return dst;
}
    80000ce4:	60a2                	ld	ra,8(sp)
    80000ce6:	6402                	ld	s0,0(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret

0000000080000cec <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cec:	1141                	addi	sp,sp,-16
    80000cee:	e406                	sd	ra,8(sp)
    80000cf0:	e022                	sd	s0,0(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca0d                	beqz	a2,80000d26 <memcmp+0x3a>
    80000cf6:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x16>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x32>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	60a2                	ld	ra,8(sp)
    80000d20:	6402                	ld	s0,0(sp)
    80000d22:	0141                	addi	sp,sp,16
    80000d24:	8082                	ret
  return 0;
    80000d26:	4501                	li	a0,0
    80000d28:	bfdd                	j	80000d1e <memcmp+0x32>

0000000080000d2a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e406                	sd	ra,8(sp)
    80000d2e:	e022                	sd	s0,0(sp)
    80000d30:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d32:	c205                	beqz	a2,80000d52 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d34:	02a5e363          	bltu	a1,a0,80000d5a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d38:	1602                	slli	a2,a2,0x20
    80000d3a:	9201                	srli	a2,a2,0x20
    80000d3c:	00c587b3          	add	a5,a1,a2
{
    80000d40:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d42:	0585                	addi	a1,a1,1
    80000d44:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ff8e139>
    80000d46:	fff5c683          	lbu	a3,-1(a1)
    80000d4a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d4e:	feb79ae3          	bne	a5,a1,80000d42 <memmove+0x18>

  return dst;
}
    80000d52:	60a2                	ld	ra,8(sp)
    80000d54:	6402                	ld	s0,0(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  if(s < d && s + n > d){
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57ae3          	bgeu	a0,a4,80000d38 <memmove+0xe>
    d += n;
    80000d68:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4e>
    80000d88:	b7e9                	j	80000d52 <memmove+0x28>

0000000080000d8a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d92:	f99ff0ef          	jal	80000d2a <memmove>
}
    80000d96:	60a2                	ld	ra,8(sp)
    80000d98:	6402                	ld	s0,0(sp)
    80000d9a:	0141                	addi	sp,sp,16
    80000d9c:	8082                	ret

0000000080000d9e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da6:	ce11                	beqz	a2,80000dc2 <strncmp+0x24>
    80000da8:	00054783          	lbu	a5,0(a0)
    80000dac:	cf89                	beqz	a5,80000dc6 <strncmp+0x28>
    80000dae:	0005c703          	lbu	a4,0(a1)
    80000db2:	00f71a63          	bne	a4,a5,80000dc6 <strncmp+0x28>
    n--, p++, q++;
    80000db6:	367d                	addiw	a2,a2,-1
    80000db8:	0505                	addi	a0,a0,1
    80000dba:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbc:	f675                	bnez	a2,80000da8 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dbe:	4501                	li	a0,0
    80000dc0:	a801                	j	80000dd0 <strncmp+0x32>
    80000dc2:	4501                	li	a0,0
    80000dc4:	a031                	j	80000dd0 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000dc6:	00054503          	lbu	a0,0(a0)
    80000dca:	0005c783          	lbu	a5,0(a1)
    80000dce:	9d1d                	subw	a0,a0,a5
}
    80000dd0:	60a2                	ld	ra,8(sp)
    80000dd2:	6402                	ld	s0,0(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e406                	sd	ra,8(sp)
    80000ddc:	e022                	sd	s0,0(sp)
    80000dde:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de0:	87aa                	mv	a5,a0
    80000de2:	86b2                	mv	a3,a2
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	02d05563          	blez	a3,80000e10 <strncpy+0x38>
    80000dea:	0785                	addi	a5,a5,1
    80000dec:	0005c703          	lbu	a4,0(a1)
    80000df0:	fee78fa3          	sb	a4,-1(a5)
    80000df4:	0585                	addi	a1,a1,1
    80000df6:	f775                	bnez	a4,80000de2 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000df8:	873e                	mv	a4,a5
    80000dfa:	00c05b63          	blez	a2,80000e10 <strncpy+0x38>
    80000dfe:	9fb5                	addw	a5,a5,a3
    80000e00:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e02:	0705                	addi	a4,a4,1
    80000e04:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e08:	40e786bb          	subw	a3,a5,a4
    80000e0c:	fed04be3          	bgtz	a3,80000e02 <strncpy+0x2a>
  return os;
}
    80000e10:	60a2                	ld	ra,8(sp)
    80000e12:	6402                	ld	s0,0(sp)
    80000e14:	0141                	addi	sp,sp,16
    80000e16:	8082                	ret

0000000080000e18 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e406                	sd	ra,8(sp)
    80000e1c:	e022                	sd	s0,0(sp)
    80000e1e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e20:	02c05363          	blez	a2,80000e46 <safestrcpy+0x2e>
    80000e24:	fff6069b          	addiw	a3,a2,-1
    80000e28:	1682                	slli	a3,a3,0x20
    80000e2a:	9281                	srli	a3,a3,0x20
    80000e2c:	96ae                	add	a3,a3,a1
    80000e2e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e30:	00d58963          	beq	a1,a3,80000e42 <safestrcpy+0x2a>
    80000e34:	0585                	addi	a1,a1,1
    80000e36:	0785                	addi	a5,a5,1
    80000e38:	fff5c703          	lbu	a4,-1(a1)
    80000e3c:	fee78fa3          	sb	a4,-1(a5)
    80000e40:	fb65                	bnez	a4,80000e30 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e42:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e46:	60a2                	ld	ra,8(sp)
    80000e48:	6402                	ld	s0,0(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:

int
strlen(const char *s)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e406                	sd	ra,8(sp)
    80000e52:	e022                	sd	s0,0(sp)
    80000e54:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e56:	00054783          	lbu	a5,0(a0)
    80000e5a:	cf99                	beqz	a5,80000e78 <strlen+0x2a>
    80000e5c:	0505                	addi	a0,a0,1
    80000e5e:	87aa                	mv	a5,a0
    80000e60:	86be                	mv	a3,a5
    80000e62:	0785                	addi	a5,a5,1
    80000e64:	fff7c703          	lbu	a4,-1(a5)
    80000e68:	ff65                	bnez	a4,80000e60 <strlen+0x12>
    80000e6a:	40a6853b          	subw	a0,a3,a0
    80000e6e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e70:	60a2                	ld	ra,8(sp)
    80000e72:	6402                	ld	s0,0(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e78:	4501                	li	a0,0
    80000e7a:	bfdd                	j	80000e70 <strlen+0x22>

0000000080000e7c <main>:
extern void init_prime_pids(void);

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e84:	315000ef          	jal	80001998 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e88:	00007717          	auipc	a4,0x7
    80000e8c:	ae070713          	addi	a4,a4,-1312 # 80007968 <started>
  if(cpuid() == 0){
    80000e90:	c51d                	beqz	a0,80000ebe <main+0x42>
    while(started == 0)
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x16>
      ;
    __sync_synchronize();
    80000e98:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e9c:	2fd000ef          	jal	80001998 <cpuid>
    80000ea0:	85aa                	mv	a1,a0
    80000ea2:	00006517          	auipc	a0,0x6
    80000ea6:	21650513          	addi	a0,a0,534 # 800070b8 <etext+0xb8>
    80000eaa:	e24ff0ef          	jal	800004ce <printf>
    kvminithart();    // turn on paging
    80000eae:	090000ef          	jal	80000f3e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb2:	6c8010ef          	jal	8000257a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eb6:	632040ef          	jal	800054e8 <plicinithart>
  }

  scheduler();        
    80000eba:	783000ef          	jal	80001e3c <scheduler>
    consoleinit();
    80000ebe:	d42ff0ef          	jal	80000400 <consoleinit>
    printfinit();
    80000ec2:	917ff0ef          	jal	800007d8 <printfinit>
    printf("\n");
    80000ec6:	00006517          	auipc	a0,0x6
    80000eca:	36a50513          	addi	a0,a0,874 # 80007230 <etext+0x230>
    80000ece:	e00ff0ef          	jal	800004ce <printf>
    printf("xv6 kernel is booting just see\n");
    80000ed2:	00006517          	auipc	a0,0x6
    80000ed6:	1a650513          	addi	a0,a0,422 # 80007078 <etext+0x78>
    80000eda:	df4ff0ef          	jal	800004ce <printf>
    printf("\n");
    80000ede:	00006517          	auipc	a0,0x6
    80000ee2:	35250513          	addi	a0,a0,850 # 80007230 <etext+0x230>
    80000ee6:	de8ff0ef          	jal	800004ce <printf>
    kinit();         // physical page allocator
    80000eea:	c05ff0ef          	jal	80000aee <kinit>
    kvminit();       // create kernel page table
    80000eee:	2de000ef          	jal	800011cc <kvminit>
    kvminithart();   // turn on paging
    80000ef2:	04c000ef          	jal	80000f3e <kvminithart>
    printf("calling prime initializer\n");
    80000ef6:	00006517          	auipc	a0,0x6
    80000efa:	1a250513          	addi	a0,a0,418 # 80007098 <etext+0x98>
    80000efe:	dd0ff0ef          	jal	800004ce <printf>
    init_prime_pids();   //    ----------  to initialize primes ------------
    80000f02:	061000ef          	jal	80001762 <init_prime_pids>
    procinit();      // process table
    80000f06:	1db000ef          	jal	800018e0 <procinit>
    trapinit();      // trap vectors
    80000f0a:	64c010ef          	jal	80002556 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f0e:	66c010ef          	jal	8000257a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f12:	5bc040ef          	jal	800054ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f16:	5d2040ef          	jal	800054e8 <plicinithart>
    binit();         // buffer cache
    80000f1a:	539010ef          	jal	80002c52 <binit>
    iinit();         // inode table
    80000f1e:	304020ef          	jal	80003222 <iinit>
    fileinit();      // file table
    80000f22:	0d2030ef          	jal	80003ff4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f26:	6b2040ef          	jal	800055d8 <virtio_disk_init>
    userinit();      // first user process
    80000f2a:	547000ef          	jal	80001c70 <userinit>
    __sync_synchronize();
    80000f2e:	0330000f          	fence	rw,rw
    started = 1;
    80000f32:	4785                	li	a5,1
    80000f34:	00007717          	auipc	a4,0x7
    80000f38:	a2f72a23          	sw	a5,-1484(a4) # 80007968 <started>
    80000f3c:	bfbd                	j	80000eba <main+0x3e>

0000000080000f3e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e406                	sd	ra,8(sp)
    80000f42:	e022                	sd	s0,0(sp)
    80000f44:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f46:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f4a:	00007797          	auipc	a5,0x7
    80000f4e:	a267b783          	ld	a5,-1498(a5) # 80007970 <kernel_pagetable>
    80000f52:	83b1                	srli	a5,a5,0xc
    80000f54:	577d                	li	a4,-1
    80000f56:	177e                	slli	a4,a4,0x3f
    80000f58:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f5a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f5e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f62:	60a2                	ld	ra,8(sp)
    80000f64:	6402                	ld	s0,0(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret

0000000080000f6a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f6a:	7139                	addi	sp,sp,-64
    80000f6c:	fc06                	sd	ra,56(sp)
    80000f6e:	f822                	sd	s0,48(sp)
    80000f70:	f426                	sd	s1,40(sp)
    80000f72:	f04a                	sd	s2,32(sp)
    80000f74:	ec4e                	sd	s3,24(sp)
    80000f76:	e852                	sd	s4,16(sp)
    80000f78:	e456                	sd	s5,8(sp)
    80000f7a:	e05a                	sd	s6,0(sp)
    80000f7c:	0080                	addi	s0,sp,64
    80000f7e:	84aa                	mv	s1,a0
    80000f80:	89ae                	mv	s3,a1
    80000f82:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f84:	57fd                	li	a5,-1
    80000f86:	83e9                	srli	a5,a5,0x1a
    80000f88:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f8a:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f8c:	04b7e263          	bltu	a5,a1,80000fd0 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f90:	0149d933          	srl	s2,s3,s4
    80000f94:	1ff97913          	andi	s2,s2,511
    80000f98:	090e                	slli	s2,s2,0x3
    80000f9a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f9c:	00093483          	ld	s1,0(s2)
    80000fa0:	0014f793          	andi	a5,s1,1
    80000fa4:	cf85                	beqz	a5,80000fdc <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fa6:	80a9                	srli	s1,s1,0xa
    80000fa8:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000faa:	3a5d                	addiw	s4,s4,-9
    80000fac:	ff6a12e3          	bne	s4,s6,80000f90 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fb0:	00c9d513          	srli	a0,s3,0xc
    80000fb4:	1ff57513          	andi	a0,a0,511
    80000fb8:	050e                	slli	a0,a0,0x3
    80000fba:	9526                	add	a0,a0,s1
}
    80000fbc:	70e2                	ld	ra,56(sp)
    80000fbe:	7442                	ld	s0,48(sp)
    80000fc0:	74a2                	ld	s1,40(sp)
    80000fc2:	7902                	ld	s2,32(sp)
    80000fc4:	69e2                	ld	s3,24(sp)
    80000fc6:	6a42                	ld	s4,16(sp)
    80000fc8:	6aa2                	ld	s5,8(sp)
    80000fca:	6b02                	ld	s6,0(sp)
    80000fcc:	6121                	addi	sp,sp,64
    80000fce:	8082                	ret
    panic("walk");
    80000fd0:	00006517          	auipc	a0,0x6
    80000fd4:	10050513          	addi	a0,a0,256 # 800070d0 <etext+0xd0>
    80000fd8:	fc6ff0ef          	jal	8000079e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fdc:	020a8263          	beqz	s5,80001000 <walk+0x96>
    80000fe0:	b43ff0ef          	jal	80000b22 <kalloc>
    80000fe4:	84aa                	mv	s1,a0
    80000fe6:	d979                	beqz	a0,80000fbc <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fe8:	6605                	lui	a2,0x1
    80000fea:	4581                	li	a1,0
    80000fec:	cdbff0ef          	jal	80000cc6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff0:	00c4d793          	srli	a5,s1,0xc
    80000ff4:	07aa                	slli	a5,a5,0xa
    80000ff6:	0017e793          	ori	a5,a5,1
    80000ffa:	00f93023          	sd	a5,0(s2)
    80000ffe:	b775                	j	80000faa <walk+0x40>
        return 0;
    80001000:	4501                	li	a0,0
    80001002:	bf6d                	j	80000fbc <walk+0x52>

0000000080001004 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001004:	57fd                	li	a5,-1
    80001006:	83e9                	srli	a5,a5,0x1a
    80001008:	00b7f463          	bgeu	a5,a1,80001010 <walkaddr+0xc>
    return 0;
    8000100c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000100e:	8082                	ret
{
    80001010:	1141                	addi	sp,sp,-16
    80001012:	e406                	sd	ra,8(sp)
    80001014:	e022                	sd	s0,0(sp)
    80001016:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001018:	4601                	li	a2,0
    8000101a:	f51ff0ef          	jal	80000f6a <walk>
  if(pte == 0)
    8000101e:	c105                	beqz	a0,8000103e <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001020:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001022:	0117f693          	andi	a3,a5,17
    80001026:	4745                	li	a4,17
    return 0;
    80001028:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000102a:	00e68663          	beq	a3,a4,80001036 <walkaddr+0x32>
}
    8000102e:	60a2                	ld	ra,8(sp)
    80001030:	6402                	ld	s0,0(sp)
    80001032:	0141                	addi	sp,sp,16
    80001034:	8082                	ret
  pa = PTE2PA(*pte);
    80001036:	83a9                	srli	a5,a5,0xa
    80001038:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000103c:	bfcd                	j	8000102e <walkaddr+0x2a>
    return 0;
    8000103e:	4501                	li	a0,0
    80001040:	b7fd                	j	8000102e <walkaddr+0x2a>

0000000080001042 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001042:	715d                	addi	sp,sp,-80
    80001044:	e486                	sd	ra,72(sp)
    80001046:	e0a2                	sd	s0,64(sp)
    80001048:	fc26                	sd	s1,56(sp)
    8000104a:	f84a                	sd	s2,48(sp)
    8000104c:	f44e                	sd	s3,40(sp)
    8000104e:	f052                	sd	s4,32(sp)
    80001050:	ec56                	sd	s5,24(sp)
    80001052:	e85a                	sd	s6,16(sp)
    80001054:	e45e                	sd	s7,8(sp)
    80001056:	e062                	sd	s8,0(sp)
    80001058:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000105a:	03459793          	slli	a5,a1,0x34
    8000105e:	e7b1                	bnez	a5,800010aa <mappages+0x68>
    80001060:	8aaa                	mv	s5,a0
    80001062:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001064:	03461793          	slli	a5,a2,0x34
    80001068:	e7b9                	bnez	a5,800010b6 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    8000106a:	ce21                	beqz	a2,800010c2 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000106c:	77fd                	lui	a5,0xfffff
    8000106e:	963e                	add	a2,a2,a5
    80001070:	00b609b3          	add	s3,a2,a1
  a = va;
    80001074:	892e                	mv	s2,a1
    80001076:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000107c:	6c05                	lui	s8,0x1
    8000107e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001082:	865e                	mv	a2,s7
    80001084:	85ca                	mv	a1,s2
    80001086:	8556                	mv	a0,s5
    80001088:	ee3ff0ef          	jal	80000f6a <walk>
    8000108c:	c539                	beqz	a0,800010da <mappages+0x98>
    if(*pte & PTE_V)
    8000108e:	611c                	ld	a5,0(a0)
    80001090:	8b85                	andi	a5,a5,1
    80001092:	ef95                	bnez	a5,800010ce <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001094:	80b1                	srli	s1,s1,0xc
    80001096:	04aa                	slli	s1,s1,0xa
    80001098:	0164e4b3          	or	s1,s1,s6
    8000109c:	0014e493          	ori	s1,s1,1
    800010a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800010a2:	05390963          	beq	s2,s3,800010f4 <mappages+0xb2>
    a += PGSIZE;
    800010a6:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a8:	bfd9                	j	8000107e <mappages+0x3c>
    panic("mappages: va not aligned");
    800010aa:	00006517          	auipc	a0,0x6
    800010ae:	02e50513          	addi	a0,a0,46 # 800070d8 <etext+0xd8>
    800010b2:	eecff0ef          	jal	8000079e <panic>
    panic("mappages: size not aligned");
    800010b6:	00006517          	auipc	a0,0x6
    800010ba:	04250513          	addi	a0,a0,66 # 800070f8 <etext+0xf8>
    800010be:	ee0ff0ef          	jal	8000079e <panic>
    panic("mappages: size");
    800010c2:	00006517          	auipc	a0,0x6
    800010c6:	05650513          	addi	a0,a0,86 # 80007118 <etext+0x118>
    800010ca:	ed4ff0ef          	jal	8000079e <panic>
      panic("mappages: remap");
    800010ce:	00006517          	auipc	a0,0x6
    800010d2:	05a50513          	addi	a0,a0,90 # 80007128 <etext+0x128>
    800010d6:	ec8ff0ef          	jal	8000079e <panic>
      return -1;
    800010da:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010dc:	60a6                	ld	ra,72(sp)
    800010de:	6406                	ld	s0,64(sp)
    800010e0:	74e2                	ld	s1,56(sp)
    800010e2:	7942                	ld	s2,48(sp)
    800010e4:	79a2                	ld	s3,40(sp)
    800010e6:	7a02                	ld	s4,32(sp)
    800010e8:	6ae2                	ld	s5,24(sp)
    800010ea:	6b42                	ld	s6,16(sp)
    800010ec:	6ba2                	ld	s7,8(sp)
    800010ee:	6c02                	ld	s8,0(sp)
    800010f0:	6161                	addi	sp,sp,80
    800010f2:	8082                	ret
  return 0;
    800010f4:	4501                	li	a0,0
    800010f6:	b7dd                	j	800010dc <mappages+0x9a>

00000000800010f8 <kvmmap>:
{
    800010f8:	1141                	addi	sp,sp,-16
    800010fa:	e406                	sd	ra,8(sp)
    800010fc:	e022                	sd	s0,0(sp)
    800010fe:	0800                	addi	s0,sp,16
    80001100:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001102:	86b2                	mv	a3,a2
    80001104:	863e                	mv	a2,a5
    80001106:	f3dff0ef          	jal	80001042 <mappages>
    8000110a:	e509                	bnez	a0,80001114 <kvmmap+0x1c>
}
    8000110c:	60a2                	ld	ra,8(sp)
    8000110e:	6402                	ld	s0,0(sp)
    80001110:	0141                	addi	sp,sp,16
    80001112:	8082                	ret
    panic("kvmmap");
    80001114:	00006517          	auipc	a0,0x6
    80001118:	02450513          	addi	a0,a0,36 # 80007138 <etext+0x138>
    8000111c:	e82ff0ef          	jal	8000079e <panic>

0000000080001120 <kvmmake>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	e04a                	sd	s2,0(sp)
    8000112a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000112c:	9f7ff0ef          	jal	80000b22 <kalloc>
    80001130:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001132:	6605                	lui	a2,0x1
    80001134:	4581                	li	a1,0
    80001136:	b91ff0ef          	jal	80000cc6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000113a:	4719                	li	a4,6
    8000113c:	6685                	lui	a3,0x1
    8000113e:	10000637          	lui	a2,0x10000
    80001142:	85b2                	mv	a1,a2
    80001144:	8526                	mv	a0,s1
    80001146:	fb3ff0ef          	jal	800010f8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000114a:	4719                	li	a4,6
    8000114c:	6685                	lui	a3,0x1
    8000114e:	10001637          	lui	a2,0x10001
    80001152:	85b2                	mv	a1,a2
    80001154:	8526                	mv	a0,s1
    80001156:	fa3ff0ef          	jal	800010f8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000115a:	4719                	li	a4,6
    8000115c:	040006b7          	lui	a3,0x4000
    80001160:	0c000637          	lui	a2,0xc000
    80001164:	85b2                	mv	a1,a2
    80001166:	8526                	mv	a0,s1
    80001168:	f91ff0ef          	jal	800010f8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000116c:	00006917          	auipc	s2,0x6
    80001170:	e9490913          	addi	s2,s2,-364 # 80007000 <etext>
    80001174:	4729                	li	a4,10
    80001176:	80006697          	auipc	a3,0x80006
    8000117a:	e8a68693          	addi	a3,a3,-374 # 7000 <_entry-0x7fff9000>
    8000117e:	4605                	li	a2,1
    80001180:	067e                	slli	a2,a2,0x1f
    80001182:	85b2                	mv	a1,a2
    80001184:	8526                	mv	a0,s1
    80001186:	f73ff0ef          	jal	800010f8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000118a:	4719                	li	a4,6
    8000118c:	46c5                	li	a3,17
    8000118e:	06ee                	slli	a3,a3,0x1b
    80001190:	412686b3          	sub	a3,a3,s2
    80001194:	864a                	mv	a2,s2
    80001196:	85ca                	mv	a1,s2
    80001198:	8526                	mv	a0,s1
    8000119a:	f5fff0ef          	jal	800010f8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000119e:	4729                	li	a4,10
    800011a0:	6685                	lui	a3,0x1
    800011a2:	00005617          	auipc	a2,0x5
    800011a6:	e5e60613          	addi	a2,a2,-418 # 80006000 <_trampoline>
    800011aa:	040005b7          	lui	a1,0x4000
    800011ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011b0:	05b2                	slli	a1,a1,0xc
    800011b2:	8526                	mv	a0,s1
    800011b4:	f45ff0ef          	jal	800010f8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011b8:	8526                	mv	a0,s1
    800011ba:	688000ef          	jal	80001842 <proc_mapstacks>
}
    800011be:	8526                	mv	a0,s1
    800011c0:	60e2                	ld	ra,24(sp)
    800011c2:	6442                	ld	s0,16(sp)
    800011c4:	64a2                	ld	s1,8(sp)
    800011c6:	6902                	ld	s2,0(sp)
    800011c8:	6105                	addi	sp,sp,32
    800011ca:	8082                	ret

00000000800011cc <kvminit>:
{
    800011cc:	1141                	addi	sp,sp,-16
    800011ce:	e406                	sd	ra,8(sp)
    800011d0:	e022                	sd	s0,0(sp)
    800011d2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011d4:	f4dff0ef          	jal	80001120 <kvmmake>
    800011d8:	00006797          	auipc	a5,0x6
    800011dc:	78a7bc23          	sd	a0,1944(a5) # 80007970 <kernel_pagetable>
}
    800011e0:	60a2                	ld	ra,8(sp)
    800011e2:	6402                	ld	s0,0(sp)
    800011e4:	0141                	addi	sp,sp,16
    800011e6:	8082                	ret

00000000800011e8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e8:	715d                	addi	sp,sp,-80
    800011ea:	e486                	sd	ra,72(sp)
    800011ec:	e0a2                	sd	s0,64(sp)
    800011ee:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011f0:	03459793          	slli	a5,a1,0x34
    800011f4:	e39d                	bnez	a5,8000121a <uvmunmap+0x32>
    800011f6:	f84a                	sd	s2,48(sp)
    800011f8:	f44e                	sd	s3,40(sp)
    800011fa:	f052                	sd	s4,32(sp)
    800011fc:	ec56                	sd	s5,24(sp)
    800011fe:	e85a                	sd	s6,16(sp)
    80001200:	e45e                	sd	s7,8(sp)
    80001202:	8a2a                	mv	s4,a0
    80001204:	892e                	mv	s2,a1
    80001206:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001208:	0632                	slli	a2,a2,0xc
    8000120a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000120e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001210:	6b05                	lui	s6,0x1
    80001212:	0735ff63          	bgeu	a1,s3,80001290 <uvmunmap+0xa8>
    80001216:	fc26                	sd	s1,56(sp)
    80001218:	a0a9                	j	80001262 <uvmunmap+0x7a>
    8000121a:	fc26                	sd	s1,56(sp)
    8000121c:	f84a                	sd	s2,48(sp)
    8000121e:	f44e                	sd	s3,40(sp)
    80001220:	f052                	sd	s4,32(sp)
    80001222:	ec56                	sd	s5,24(sp)
    80001224:	e85a                	sd	s6,16(sp)
    80001226:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001228:	00006517          	auipc	a0,0x6
    8000122c:	f1850513          	addi	a0,a0,-232 # 80007140 <etext+0x140>
    80001230:	d6eff0ef          	jal	8000079e <panic>
      panic("uvmunmap: walk");
    80001234:	00006517          	auipc	a0,0x6
    80001238:	f2450513          	addi	a0,a0,-220 # 80007158 <etext+0x158>
    8000123c:	d62ff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not mapped");
    80001240:	00006517          	auipc	a0,0x6
    80001244:	f2850513          	addi	a0,a0,-216 # 80007168 <etext+0x168>
    80001248:	d56ff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not a leaf");
    8000124c:	00006517          	auipc	a0,0x6
    80001250:	f3450513          	addi	a0,a0,-204 # 80007180 <etext+0x180>
    80001254:	d4aff0ef          	jal	8000079e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001258:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000125c:	995a                	add	s2,s2,s6
    8000125e:	03397863          	bgeu	s2,s3,8000128e <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001262:	4601                	li	a2,0
    80001264:	85ca                	mv	a1,s2
    80001266:	8552                	mv	a0,s4
    80001268:	d03ff0ef          	jal	80000f6a <walk>
    8000126c:	84aa                	mv	s1,a0
    8000126e:	d179                	beqz	a0,80001234 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001270:	6108                	ld	a0,0(a0)
    80001272:	00157793          	andi	a5,a0,1
    80001276:	d7e9                	beqz	a5,80001240 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001278:	3ff57793          	andi	a5,a0,1023
    8000127c:	fd7788e3          	beq	a5,s7,8000124c <uvmunmap+0x64>
    if(do_free){
    80001280:	fc0a8ce3          	beqz	s5,80001258 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001284:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001286:	0532                	slli	a0,a0,0xc
    80001288:	fb8ff0ef          	jal	80000a40 <kfree>
    8000128c:	b7f1                	j	80001258 <uvmunmap+0x70>
    8000128e:	74e2                	ld	s1,56(sp)
    80001290:	7942                	ld	s2,48(sp)
    80001292:	79a2                	ld	s3,40(sp)
    80001294:	7a02                	ld	s4,32(sp)
    80001296:	6ae2                	ld	s5,24(sp)
    80001298:	6b42                	ld	s6,16(sp)
    8000129a:	6ba2                	ld	s7,8(sp)
  }
}
    8000129c:	60a6                	ld	ra,72(sp)
    8000129e:	6406                	ld	s0,64(sp)
    800012a0:	6161                	addi	sp,sp,80
    800012a2:	8082                	ret

00000000800012a4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800012a4:	1101                	addi	sp,sp,-32
    800012a6:	ec06                	sd	ra,24(sp)
    800012a8:	e822                	sd	s0,16(sp)
    800012aa:	e426                	sd	s1,8(sp)
    800012ac:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012ae:	875ff0ef          	jal	80000b22 <kalloc>
    800012b2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012b4:	c509                	beqz	a0,800012be <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012b6:	6605                	lui	a2,0x1
    800012b8:	4581                	li	a1,0
    800012ba:	a0dff0ef          	jal	80000cc6 <memset>
  return pagetable;
}
    800012be:	8526                	mv	a0,s1
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret

00000000800012ca <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012ca:	7179                	addi	sp,sp,-48
    800012cc:	f406                	sd	ra,40(sp)
    800012ce:	f022                	sd	s0,32(sp)
    800012d0:	ec26                	sd	s1,24(sp)
    800012d2:	e84a                	sd	s2,16(sp)
    800012d4:	e44e                	sd	s3,8(sp)
    800012d6:	e052                	sd	s4,0(sp)
    800012d8:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012da:	6785                	lui	a5,0x1
    800012dc:	04f67063          	bgeu	a2,a5,8000131c <uvmfirst+0x52>
    800012e0:	8a2a                	mv	s4,a0
    800012e2:	89ae                	mv	s3,a1
    800012e4:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012e6:	83dff0ef          	jal	80000b22 <kalloc>
    800012ea:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012ec:	6605                	lui	a2,0x1
    800012ee:	4581                	li	a1,0
    800012f0:	9d7ff0ef          	jal	80000cc6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012f4:	4779                	li	a4,30
    800012f6:	86ca                	mv	a3,s2
    800012f8:	6605                	lui	a2,0x1
    800012fa:	4581                	li	a1,0
    800012fc:	8552                	mv	a0,s4
    800012fe:	d45ff0ef          	jal	80001042 <mappages>
  memmove(mem, src, sz);
    80001302:	8626                	mv	a2,s1
    80001304:	85ce                	mv	a1,s3
    80001306:	854a                	mv	a0,s2
    80001308:	a23ff0ef          	jal	80000d2a <memmove>
}
    8000130c:	70a2                	ld	ra,40(sp)
    8000130e:	7402                	ld	s0,32(sp)
    80001310:	64e2                	ld	s1,24(sp)
    80001312:	6942                	ld	s2,16(sp)
    80001314:	69a2                	ld	s3,8(sp)
    80001316:	6a02                	ld	s4,0(sp)
    80001318:	6145                	addi	sp,sp,48
    8000131a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000131c:	00006517          	auipc	a0,0x6
    80001320:	e7c50513          	addi	a0,a0,-388 # 80007198 <etext+0x198>
    80001324:	c7aff0ef          	jal	8000079e <panic>

0000000080001328 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001332:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001334:	00b67d63          	bgeu	a2,a1,8000134e <uvmdealloc+0x26>
    80001338:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000133a:	6785                	lui	a5,0x1
    8000133c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000133e:	00f60733          	add	a4,a2,a5
    80001342:	76fd                	lui	a3,0xfffff
    80001344:	8f75                	and	a4,a4,a3
    80001346:	97ae                	add	a5,a5,a1
    80001348:	8ff5                	and	a5,a5,a3
    8000134a:	00f76863          	bltu	a4,a5,8000135a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000134e:	8526                	mv	a0,s1
    80001350:	60e2                	ld	ra,24(sp)
    80001352:	6442                	ld	s0,16(sp)
    80001354:	64a2                	ld	s1,8(sp)
    80001356:	6105                	addi	sp,sp,32
    80001358:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000135a:	8f99                	sub	a5,a5,a4
    8000135c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000135e:	4685                	li	a3,1
    80001360:	0007861b          	sext.w	a2,a5
    80001364:	85ba                	mv	a1,a4
    80001366:	e83ff0ef          	jal	800011e8 <uvmunmap>
    8000136a:	b7d5                	j	8000134e <uvmdealloc+0x26>

000000008000136c <uvmalloc>:
  if(newsz < oldsz)
    8000136c:	0ab66363          	bltu	a2,a1,80001412 <uvmalloc+0xa6>
{
    80001370:	715d                	addi	sp,sp,-80
    80001372:	e486                	sd	ra,72(sp)
    80001374:	e0a2                	sd	s0,64(sp)
    80001376:	f052                	sd	s4,32(sp)
    80001378:	ec56                	sd	s5,24(sp)
    8000137a:	e85a                	sd	s6,16(sp)
    8000137c:	0880                	addi	s0,sp,80
    8000137e:	8b2a                	mv	s6,a0
    80001380:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80001382:	6785                	lui	a5,0x1
    80001384:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001386:	95be                	add	a1,a1,a5
    80001388:	77fd                	lui	a5,0xfffff
    8000138a:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000138e:	08ca7463          	bgeu	s4,a2,80001416 <uvmalloc+0xaa>
    80001392:	fc26                	sd	s1,56(sp)
    80001394:	f84a                	sd	s2,48(sp)
    80001396:	f44e                	sd	s3,40(sp)
    80001398:	e45e                	sd	s7,8(sp)
    8000139a:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    8000139c:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000139e:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800013a2:	f80ff0ef          	jal	80000b22 <kalloc>
    800013a6:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a8:	c515                	beqz	a0,800013d4 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800013aa:	864e                	mv	a2,s3
    800013ac:	4581                	li	a1,0
    800013ae:	919ff0ef          	jal	80000cc6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013b2:	875e                	mv	a4,s7
    800013b4:	86a6                	mv	a3,s1
    800013b6:	864e                	mv	a2,s3
    800013b8:	85ca                	mv	a1,s2
    800013ba:	855a                	mv	a0,s6
    800013bc:	c87ff0ef          	jal	80001042 <mappages>
    800013c0:	e91d                	bnez	a0,800013f6 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013c2:	994e                	add	s2,s2,s3
    800013c4:	fd596fe3          	bltu	s2,s5,800013a2 <uvmalloc+0x36>
  return newsz;
    800013c8:	8556                	mv	a0,s5
    800013ca:	74e2                	ld	s1,56(sp)
    800013cc:	7942                	ld	s2,48(sp)
    800013ce:	79a2                	ld	s3,40(sp)
    800013d0:	6ba2                	ld	s7,8(sp)
    800013d2:	a819                	j	800013e8 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800013d4:	8652                	mv	a2,s4
    800013d6:	85ca                	mv	a1,s2
    800013d8:	855a                	mv	a0,s6
    800013da:	f4fff0ef          	jal	80001328 <uvmdealloc>
      return 0;
    800013de:	4501                	li	a0,0
    800013e0:	74e2                	ld	s1,56(sp)
    800013e2:	7942                	ld	s2,48(sp)
    800013e4:	79a2                	ld	s3,40(sp)
    800013e6:	6ba2                	ld	s7,8(sp)
}
    800013e8:	60a6                	ld	ra,72(sp)
    800013ea:	6406                	ld	s0,64(sp)
    800013ec:	7a02                	ld	s4,32(sp)
    800013ee:	6ae2                	ld	s5,24(sp)
    800013f0:	6b42                	ld	s6,16(sp)
    800013f2:	6161                	addi	sp,sp,80
    800013f4:	8082                	ret
      kfree(mem);
    800013f6:	8526                	mv	a0,s1
    800013f8:	e48ff0ef          	jal	80000a40 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013fc:	8652                	mv	a2,s4
    800013fe:	85ca                	mv	a1,s2
    80001400:	855a                	mv	a0,s6
    80001402:	f27ff0ef          	jal	80001328 <uvmdealloc>
      return 0;
    80001406:	4501                	li	a0,0
    80001408:	74e2                	ld	s1,56(sp)
    8000140a:	7942                	ld	s2,48(sp)
    8000140c:	79a2                	ld	s3,40(sp)
    8000140e:	6ba2                	ld	s7,8(sp)
    80001410:	bfe1                	j	800013e8 <uvmalloc+0x7c>
    return oldsz;
    80001412:	852e                	mv	a0,a1
}
    80001414:	8082                	ret
  return newsz;
    80001416:	8532                	mv	a0,a2
    80001418:	bfc1                	j	800013e8 <uvmalloc+0x7c>

000000008000141a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000141a:	7179                	addi	sp,sp,-48
    8000141c:	f406                	sd	ra,40(sp)
    8000141e:	f022                	sd	s0,32(sp)
    80001420:	ec26                	sd	s1,24(sp)
    80001422:	e84a                	sd	s2,16(sp)
    80001424:	e44e                	sd	s3,8(sp)
    80001426:	e052                	sd	s4,0(sp)
    80001428:	1800                	addi	s0,sp,48
    8000142a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000142c:	84aa                	mv	s1,a0
    8000142e:	6905                	lui	s2,0x1
    80001430:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001432:	4985                	li	s3,1
    80001434:	a819                	j	8000144a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001436:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001438:	00c79513          	slli	a0,a5,0xc
    8000143c:	fdfff0ef          	jal	8000141a <freewalk>
      pagetable[i] = 0;
    80001440:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001444:	04a1                	addi	s1,s1,8
    80001446:	01248f63          	beq	s1,s2,80001464 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000144a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000144c:	00f7f713          	andi	a4,a5,15
    80001450:	ff3703e3          	beq	a4,s3,80001436 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001454:	8b85                	andi	a5,a5,1
    80001456:	d7fd                	beqz	a5,80001444 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001458:	00006517          	auipc	a0,0x6
    8000145c:	d6050513          	addi	a0,a0,-672 # 800071b8 <etext+0x1b8>
    80001460:	b3eff0ef          	jal	8000079e <panic>
    }
  }
  kfree((void*)pagetable);
    80001464:	8552                	mv	a0,s4
    80001466:	ddaff0ef          	jal	80000a40 <kfree>
}
    8000146a:	70a2                	ld	ra,40(sp)
    8000146c:	7402                	ld	s0,32(sp)
    8000146e:	64e2                	ld	s1,24(sp)
    80001470:	6942                	ld	s2,16(sp)
    80001472:	69a2                	ld	s3,8(sp)
    80001474:	6a02                	ld	s4,0(sp)
    80001476:	6145                	addi	sp,sp,48
    80001478:	8082                	ret

000000008000147a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000147a:	1101                	addi	sp,sp,-32
    8000147c:	ec06                	sd	ra,24(sp)
    8000147e:	e822                	sd	s0,16(sp)
    80001480:	e426                	sd	s1,8(sp)
    80001482:	1000                	addi	s0,sp,32
    80001484:	84aa                	mv	s1,a0
  if(sz > 0)
    80001486:	e989                	bnez	a1,80001498 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001488:	8526                	mv	a0,s1
    8000148a:	f91ff0ef          	jal	8000141a <freewalk>
}
    8000148e:	60e2                	ld	ra,24(sp)
    80001490:	6442                	ld	s0,16(sp)
    80001492:	64a2                	ld	s1,8(sp)
    80001494:	6105                	addi	sp,sp,32
    80001496:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001498:	6785                	lui	a5,0x1
    8000149a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000149c:	95be                	add	a1,a1,a5
    8000149e:	4685                	li	a3,1
    800014a0:	00c5d613          	srli	a2,a1,0xc
    800014a4:	4581                	li	a1,0
    800014a6:	d43ff0ef          	jal	800011e8 <uvmunmap>
    800014aa:	bff9                	j	80001488 <uvmfree+0xe>

00000000800014ac <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014ac:	ca4d                	beqz	a2,8000155e <uvmcopy+0xb2>
{
    800014ae:	715d                	addi	sp,sp,-80
    800014b0:	e486                	sd	ra,72(sp)
    800014b2:	e0a2                	sd	s0,64(sp)
    800014b4:	fc26                	sd	s1,56(sp)
    800014b6:	f84a                	sd	s2,48(sp)
    800014b8:	f44e                	sd	s3,40(sp)
    800014ba:	f052                	sd	s4,32(sp)
    800014bc:	ec56                	sd	s5,24(sp)
    800014be:	e85a                	sd	s6,16(sp)
    800014c0:	e45e                	sd	s7,8(sp)
    800014c2:	e062                	sd	s8,0(sp)
    800014c4:	0880                	addi	s0,sp,80
    800014c6:	8baa                	mv	s7,a0
    800014c8:	8b2e                	mv	s6,a1
    800014ca:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014cc:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014ce:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800014d0:	4601                	li	a2,0
    800014d2:	85ce                	mv	a1,s3
    800014d4:	855e                	mv	a0,s7
    800014d6:	a95ff0ef          	jal	80000f6a <walk>
    800014da:	cd1d                	beqz	a0,80001518 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    800014dc:	6118                	ld	a4,0(a0)
    800014de:	00177793          	andi	a5,a4,1
    800014e2:	c3a9                	beqz	a5,80001524 <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    800014e4:	00a75593          	srli	a1,a4,0xa
    800014e8:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014ec:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014f0:	e32ff0ef          	jal	80000b22 <kalloc>
    800014f4:	892a                	mv	s2,a0
    800014f6:	c121                	beqz	a0,80001536 <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    800014f8:	8652                	mv	a2,s4
    800014fa:	85e2                	mv	a1,s8
    800014fc:	82fff0ef          	jal	80000d2a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001500:	8726                	mv	a4,s1
    80001502:	86ca                	mv	a3,s2
    80001504:	8652                	mv	a2,s4
    80001506:	85ce                	mv	a1,s3
    80001508:	855a                	mv	a0,s6
    8000150a:	b39ff0ef          	jal	80001042 <mappages>
    8000150e:	e10d                	bnez	a0,80001530 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80001510:	99d2                	add	s3,s3,s4
    80001512:	fb59efe3          	bltu	s3,s5,800014d0 <uvmcopy+0x24>
    80001516:	a805                	j	80001546 <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80001518:	00006517          	auipc	a0,0x6
    8000151c:	cb050513          	addi	a0,a0,-848 # 800071c8 <etext+0x1c8>
    80001520:	a7eff0ef          	jal	8000079e <panic>
      panic("uvmcopy: page not present");
    80001524:	00006517          	auipc	a0,0x6
    80001528:	cc450513          	addi	a0,a0,-828 # 800071e8 <etext+0x1e8>
    8000152c:	a72ff0ef          	jal	8000079e <panic>
      kfree(mem);
    80001530:	854a                	mv	a0,s2
    80001532:	d0eff0ef          	jal	80000a40 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001536:	4685                	li	a3,1
    80001538:	00c9d613          	srli	a2,s3,0xc
    8000153c:	4581                	li	a1,0
    8000153e:	855a                	mv	a0,s6
    80001540:	ca9ff0ef          	jal	800011e8 <uvmunmap>
  return -1;
    80001544:	557d                	li	a0,-1
}
    80001546:	60a6                	ld	ra,72(sp)
    80001548:	6406                	ld	s0,64(sp)
    8000154a:	74e2                	ld	s1,56(sp)
    8000154c:	7942                	ld	s2,48(sp)
    8000154e:	79a2                	ld	s3,40(sp)
    80001550:	7a02                	ld	s4,32(sp)
    80001552:	6ae2                	ld	s5,24(sp)
    80001554:	6b42                	ld	s6,16(sp)
    80001556:	6ba2                	ld	s7,8(sp)
    80001558:	6c02                	ld	s8,0(sp)
    8000155a:	6161                	addi	sp,sp,80
    8000155c:	8082                	ret
  return 0;
    8000155e:	4501                	li	a0,0
}
    80001560:	8082                	ret

0000000080001562 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001562:	1141                	addi	sp,sp,-16
    80001564:	e406                	sd	ra,8(sp)
    80001566:	e022                	sd	s0,0(sp)
    80001568:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000156a:	4601                	li	a2,0
    8000156c:	9ffff0ef          	jal	80000f6a <walk>
  if(pte == 0)
    80001570:	c901                	beqz	a0,80001580 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001572:	611c                	ld	a5,0(a0)
    80001574:	9bbd                	andi	a5,a5,-17
    80001576:	e11c                	sd	a5,0(a0)
}
    80001578:	60a2                	ld	ra,8(sp)
    8000157a:	6402                	ld	s0,0(sp)
    8000157c:	0141                	addi	sp,sp,16
    8000157e:	8082                	ret
    panic("uvmclear");
    80001580:	00006517          	auipc	a0,0x6
    80001584:	c8850513          	addi	a0,a0,-888 # 80007208 <etext+0x208>
    80001588:	a16ff0ef          	jal	8000079e <panic>

000000008000158c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    8000158c:	c2d9                	beqz	a3,80001612 <copyout+0x86>
{
    8000158e:	711d                	addi	sp,sp,-96
    80001590:	ec86                	sd	ra,88(sp)
    80001592:	e8a2                	sd	s0,80(sp)
    80001594:	e4a6                	sd	s1,72(sp)
    80001596:	e0ca                	sd	s2,64(sp)
    80001598:	fc4e                	sd	s3,56(sp)
    8000159a:	f852                	sd	s4,48(sp)
    8000159c:	f456                	sd	s5,40(sp)
    8000159e:	f05a                	sd	s6,32(sp)
    800015a0:	ec5e                	sd	s7,24(sp)
    800015a2:	e862                	sd	s8,16(sp)
    800015a4:	e466                	sd	s9,8(sp)
    800015a6:	e06a                	sd	s10,0(sp)
    800015a8:	1080                	addi	s0,sp,96
    800015aa:	8c2a                	mv	s8,a0
    800015ac:	892e                	mv	s2,a1
    800015ae:	8ab2                	mv	s5,a2
    800015b0:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015b2:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    800015b4:	5bfd                	li	s7,-1
    800015b6:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ba:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    800015bc:	6b05                	lui	s6,0x1
    800015be:	a015                	j	800015e2 <copyout+0x56>
    pa0 = PTE2PA(*pte);
    800015c0:	83a9                	srli	a5,a5,0xa
    800015c2:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015c4:	41390533          	sub	a0,s2,s3
    800015c8:	0004861b          	sext.w	a2,s1
    800015cc:	85d6                	mv	a1,s5
    800015ce:	953e                	add	a0,a0,a5
    800015d0:	f5aff0ef          	jal	80000d2a <memmove>

    len -= n;
    800015d4:	409a0a33          	sub	s4,s4,s1
    src += n;
    800015d8:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    800015da:	01698933          	add	s2,s3,s6
  while(len > 0){
    800015de:	020a0863          	beqz	s4,8000160e <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    800015e2:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    800015e6:	033be863          	bltu	s7,s3,80001616 <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    800015ea:	4601                	li	a2,0
    800015ec:	85ce                	mv	a1,s3
    800015ee:	8562                	mv	a0,s8
    800015f0:	97bff0ef          	jal	80000f6a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015f4:	c121                	beqz	a0,80001634 <copyout+0xa8>
    800015f6:	611c                	ld	a5,0(a0)
    800015f8:	0157f713          	andi	a4,a5,21
    800015fc:	03a71e63          	bne	a4,s10,80001638 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80001600:	412984b3          	sub	s1,s3,s2
    80001604:	94da                	add	s1,s1,s6
    if(n > len)
    80001606:	fa9a7de3          	bgeu	s4,s1,800015c0 <copyout+0x34>
    8000160a:	84d2                	mv	s1,s4
    8000160c:	bf55                	j	800015c0 <copyout+0x34>
  }
  return 0;
    8000160e:	4501                	li	a0,0
    80001610:	a021                	j	80001618 <copyout+0x8c>
    80001612:	4501                	li	a0,0
}
    80001614:	8082                	ret
      return -1;
    80001616:	557d                	li	a0,-1
}
    80001618:	60e6                	ld	ra,88(sp)
    8000161a:	6446                	ld	s0,80(sp)
    8000161c:	64a6                	ld	s1,72(sp)
    8000161e:	6906                	ld	s2,64(sp)
    80001620:	79e2                	ld	s3,56(sp)
    80001622:	7a42                	ld	s4,48(sp)
    80001624:	7aa2                	ld	s5,40(sp)
    80001626:	7b02                	ld	s6,32(sp)
    80001628:	6be2                	ld	s7,24(sp)
    8000162a:	6c42                	ld	s8,16(sp)
    8000162c:	6ca2                	ld	s9,8(sp)
    8000162e:	6d02                	ld	s10,0(sp)
    80001630:	6125                	addi	sp,sp,96
    80001632:	8082                	ret
      return -1;
    80001634:	557d                	li	a0,-1
    80001636:	b7cd                	j	80001618 <copyout+0x8c>
    80001638:	557d                	li	a0,-1
    8000163a:	bff9                	j	80001618 <copyout+0x8c>

000000008000163c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000163c:	c6a5                	beqz	a3,800016a4 <copyin+0x68>
{
    8000163e:	715d                	addi	sp,sp,-80
    80001640:	e486                	sd	ra,72(sp)
    80001642:	e0a2                	sd	s0,64(sp)
    80001644:	fc26                	sd	s1,56(sp)
    80001646:	f84a                	sd	s2,48(sp)
    80001648:	f44e                	sd	s3,40(sp)
    8000164a:	f052                	sd	s4,32(sp)
    8000164c:	ec56                	sd	s5,24(sp)
    8000164e:	e85a                	sd	s6,16(sp)
    80001650:	e45e                	sd	s7,8(sp)
    80001652:	e062                	sd	s8,0(sp)
    80001654:	0880                	addi	s0,sp,80
    80001656:	8b2a                	mv	s6,a0
    80001658:	8a2e                	mv	s4,a1
    8000165a:	8c32                	mv	s8,a2
    8000165c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000165e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001660:	6a85                	lui	s5,0x1
    80001662:	a00d                	j	80001684 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001664:	018505b3          	add	a1,a0,s8
    80001668:	0004861b          	sext.w	a2,s1
    8000166c:	412585b3          	sub	a1,a1,s2
    80001670:	8552                	mv	a0,s4
    80001672:	eb8ff0ef          	jal	80000d2a <memmove>

    len -= n;
    80001676:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000167a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000167c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001680:	02098063          	beqz	s3,800016a0 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001684:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001688:	85ca                	mv	a1,s2
    8000168a:	855a                	mv	a0,s6
    8000168c:	979ff0ef          	jal	80001004 <walkaddr>
    if(pa0 == 0)
    80001690:	cd01                	beqz	a0,800016a8 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80001692:	418904b3          	sub	s1,s2,s8
    80001696:	94d6                	add	s1,s1,s5
    if(n > len)
    80001698:	fc99f6e3          	bgeu	s3,s1,80001664 <copyin+0x28>
    8000169c:	84ce                	mv	s1,s3
    8000169e:	b7d9                	j	80001664 <copyin+0x28>
  }
  return 0;
    800016a0:	4501                	li	a0,0
    800016a2:	a021                	j	800016aa <copyin+0x6e>
    800016a4:	4501                	li	a0,0
}
    800016a6:	8082                	ret
      return -1;
    800016a8:	557d                	li	a0,-1
}
    800016aa:	60a6                	ld	ra,72(sp)
    800016ac:	6406                	ld	s0,64(sp)
    800016ae:	74e2                	ld	s1,56(sp)
    800016b0:	7942                	ld	s2,48(sp)
    800016b2:	79a2                	ld	s3,40(sp)
    800016b4:	7a02                	ld	s4,32(sp)
    800016b6:	6ae2                	ld	s5,24(sp)
    800016b8:	6b42                	ld	s6,16(sp)
    800016ba:	6ba2                	ld	s7,8(sp)
    800016bc:	6c02                	ld	s8,0(sp)
    800016be:	6161                	addi	sp,sp,80
    800016c0:	8082                	ret

00000000800016c2 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800016c2:	715d                	addi	sp,sp,-80
    800016c4:	e486                	sd	ra,72(sp)
    800016c6:	e0a2                	sd	s0,64(sp)
    800016c8:	fc26                	sd	s1,56(sp)
    800016ca:	f84a                	sd	s2,48(sp)
    800016cc:	f44e                	sd	s3,40(sp)
    800016ce:	f052                	sd	s4,32(sp)
    800016d0:	ec56                	sd	s5,24(sp)
    800016d2:	e85a                	sd	s6,16(sp)
    800016d4:	e45e                	sd	s7,8(sp)
    800016d6:	0880                	addi	s0,sp,80
    800016d8:	8aaa                	mv	s5,a0
    800016da:	89ae                	mv	s3,a1
    800016dc:	8bb2                	mv	s7,a2
    800016de:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    800016e0:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016e2:	6a05                	lui	s4,0x1
    800016e4:	a02d                	j	8000170e <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016e6:	00078023          	sb	zero,0(a5)
    800016ea:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016ec:	0017c793          	xori	a5,a5,1
    800016f0:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016f4:	60a6                	ld	ra,72(sp)
    800016f6:	6406                	ld	s0,64(sp)
    800016f8:	74e2                	ld	s1,56(sp)
    800016fa:	7942                	ld	s2,48(sp)
    800016fc:	79a2                	ld	s3,40(sp)
    800016fe:	7a02                	ld	s4,32(sp)
    80001700:	6ae2                	ld	s5,24(sp)
    80001702:	6b42                	ld	s6,16(sp)
    80001704:	6ba2                	ld	s7,8(sp)
    80001706:	6161                	addi	sp,sp,80
    80001708:	8082                	ret
    srcva = va0 + PGSIZE;
    8000170a:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    8000170e:	c4b1                	beqz	s1,8000175a <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80001710:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001714:	85ca                	mv	a1,s2
    80001716:	8556                	mv	a0,s5
    80001718:	8edff0ef          	jal	80001004 <walkaddr>
    if(pa0 == 0)
    8000171c:	c129                	beqz	a0,8000175e <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    8000171e:	41790633          	sub	a2,s2,s7
    80001722:	9652                	add	a2,a2,s4
    if(n > max)
    80001724:	00c4f363          	bgeu	s1,a2,8000172a <copyinstr+0x68>
    80001728:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000172a:	412b8bb3          	sub	s7,s7,s2
    8000172e:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001730:	de69                	beqz	a2,8000170a <copyinstr+0x48>
    80001732:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001734:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001738:	964e                	add	a2,a2,s3
    8000173a:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000173c:	00f68733          	add	a4,a3,a5
    80001740:	00074703          	lbu	a4,0(a4)
    80001744:	d34d                	beqz	a4,800016e6 <copyinstr+0x24>
        *dst = *p;
    80001746:	00e78023          	sb	a4,0(a5)
      dst++;
    8000174a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000174c:	fec797e3          	bne	a5,a2,8000173a <copyinstr+0x78>
    80001750:	14fd                	addi	s1,s1,-1
    80001752:	94ce                	add	s1,s1,s3
      --max;
    80001754:	8c8d                	sub	s1,s1,a1
    80001756:	89be                	mv	s3,a5
    80001758:	bf4d                	j	8000170a <copyinstr+0x48>
    8000175a:	4781                	li	a5,0
    8000175c:	bf41                	j	800016ec <copyinstr+0x2a>
      return -1;
    8000175e:	557d                	li	a0,-1
    80001760:	bf51                	j	800016f4 <copyinstr+0x32>

0000000080001762 <init_prime_pids>:
static int idx = 0;


void
init_prime_pids(void)
{
    80001762:	1141                	addi	sp,sp,-16
    80001764:	e406                	sd	ra,8(sp)
    80001766:	e022                	sd	s0,0(sp)
    80001768:	0800                	addi	s0,sp,16
    for(int i = 0;i <= MAXPID;i++)
    8000176a:	00054797          	auipc	a5,0x54
    8000176e:	37678793          	addi	a5,a5,886 # 80055ae0 <is_prime_pid>
    80001772:	00064717          	auipc	a4,0x64
    80001776:	36f70713          	addi	a4,a4,879 # 80065ae1 <is_prime_pid+0x10001>
      is_prime_pid[i] = 1;
    8000177a:	4685                	li	a3,1
    8000177c:	00d78023          	sb	a3,0(a5)
    for(int i = 0;i <= MAXPID;i++)
    80001780:	0785                	addi	a5,a5,1
    80001782:	fee79de3          	bne	a5,a4,8000177c <init_prime_pids+0x1a>

    is_prime_pid[0] = is_prime_pid[1] = 0;
    80001786:	00054797          	auipc	a5,0x54
    8000178a:	35a78793          	addi	a5,a5,858 # 80055ae0 <is_prime_pid>
    8000178e:	000780a3          	sb	zero,1(a5)
    80001792:	00078023          	sb	zero,0(a5)

    for(int i = 2;i * i <= MAXPID;i++) {
    80001796:	00054317          	auipc	t1,0x54
    8000179a:	34c30313          	addi	t1,t1,844 # 80055ae2 <is_prime_pid+0x2>
    is_prime_pid[0] = is_prime_pid[1] = 0;
    8000179e:	851a                	mv	a0,t1
    800017a0:	4609                	li	a2,2
    for(int i = 2;i * i <= MAXPID;i++) {
    800017a2:	4791                	li	a5,4
    800017a4:	00054e17          	auipc	t3,0x54
    800017a8:	33ce0e13          	addi	t3,t3,828 # 80055ae0 <is_prime_pid>
      if(is_prime_pid[i]){
        for(int j = i * i; j <= MAXPID; j += i)
    800017ac:	65c1                	lui	a1,0x10
    800017ae:	a809                	j	800017c0 <init_prime_pids+0x5e>
    for(int i = 2;i * i <= MAXPID;i++) {
    800017b0:	0018879b          	addiw	a5,a7,1
    800017b4:	02f787bb          	mulw	a5,a5,a5
    800017b8:	0605                	addi	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800017ba:	0505                	addi	a0,a0,1
    800017bc:	02f5c263          	blt	a1,a5,800017e0 <init_prime_pids+0x7e>
    800017c0:	0006089b          	sext.w	a7,a2
      if(is_prime_pid[i]){
    800017c4:	00054683          	lbu	a3,0(a0)
    800017c8:	d6e5                	beqz	a3,800017b0 <init_prime_pids+0x4e>
    800017ca:	8846                	mv	a6,a7
    800017cc:	01c786b3          	add	a3,a5,t3
          is_prime_pid[j] = 0;
    800017d0:	00068023          	sb	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ff8e138>
        for(int j = i * i; j <= MAXPID; j += i)
    800017d4:	00f807bb          	addw	a5,a6,a5
    800017d8:	96b2                	add	a3,a3,a2
    800017da:	fef5dbe3          	bge	a1,a5,800017d0 <init_prime_pids+0x6e>
    800017de:	bfc9                	j	800017b0 <init_prime_pids+0x4e>
    800017e0:	00006617          	auipc	a2,0x6
    800017e4:	1a462603          	lw	a2,420(a2) # 80007984 <num_primes>
    for(int i = 2;i * i <= MAXPID;i++) {
    800017e8:	879a                	mv	a5,t1
    800017ea:	4581                	li	a1,0
      }
    }

    for(int i = 2;i <= MAXPID;i++) {
      if(is_prime_pid[i]) prime_pids[num_primes++] = i;
    800017ec:	00014897          	auipc	a7,0x14
    800017f0:	2f488893          	addi	a7,a7,756 # 80015ae0 <prime_pids>
    800017f4:	4509                	li	a0,2
    800017f6:	4065053b          	subw	a0,a0,t1
    800017fa:	4805                	li	a6,1
    800017fc:	a021                	j	80001804 <init_prime_pids+0xa2>
    for(int i = 2;i <= MAXPID;i++) {
    800017fe:	0785                	addi	a5,a5,1
    80001800:	00e78e63          	beq	a5,a4,8000181c <init_prime_pids+0xba>
      if(is_prime_pid[i]) prime_pids[num_primes++] = i;
    80001804:	0007c683          	lbu	a3,0(a5)
    80001808:	dafd                	beqz	a3,800017fe <init_prime_pids+0x9c>
    8000180a:	00261693          	slli	a3,a2,0x2
    8000180e:	96c6                	add	a3,a3,a7
    80001810:	00f505bb          	addw	a1,a0,a5
    80001814:	c28c                	sw	a1,0(a3)
    80001816:	2605                	addiw	a2,a2,1
    80001818:	85c2                	mv	a1,a6
    8000181a:	b7d5                	j	800017fe <init_prime_pids+0x9c>
    8000181c:	c589                	beqz	a1,80001826 <init_prime_pids+0xc4>
    8000181e:	00006797          	auipc	a5,0x6
    80001822:	16c7a323          	sw	a2,358(a5) # 80007984 <num_primes>
      
    }

    printf("[kernel]%d total primes.\n", num_primes);
    80001826:	00006597          	auipc	a1,0x6
    8000182a:	15e5a583          	lw	a1,350(a1) # 80007984 <num_primes>
    8000182e:	00006517          	auipc	a0,0x6
    80001832:	9ea50513          	addi	a0,a0,-1558 # 80007218 <etext+0x218>
    80001836:	c99fe0ef          	jal	800004ce <printf>
}
    8000183a:	60a2                	ld	ra,8(sp)
    8000183c:	6402                	ld	s0,0(sp)
    8000183e:	0141                	addi	sp,sp,16
    80001840:	8082                	ret

0000000080001842 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001842:	715d                	addi	sp,sp,-80
    80001844:	e486                	sd	ra,72(sp)
    80001846:	e0a2                	sd	s0,64(sp)
    80001848:	fc26                	sd	s1,56(sp)
    8000184a:	f84a                	sd	s2,48(sp)
    8000184c:	f44e                	sd	s3,40(sp)
    8000184e:	f052                	sd	s4,32(sp)
    80001850:	ec56                	sd	s5,24(sp)
    80001852:	e85a                	sd	s6,16(sp)
    80001854:	e45e                	sd	s7,8(sp)
    80001856:	e062                	sd	s8,0(sp)
    80001858:	0880                	addi	s0,sp,80
    8000185a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185c:	0000e497          	auipc	s1,0xe
    80001860:	68448493          	addi	s1,s1,1668 # 8000fee0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001864:	8c26                	mv	s8,s1
    80001866:	e9bd37b7          	lui	a5,0xe9bd3
    8000186a:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69b628df>
    8000186e:	d37a7937          	lui	s2,0xd37a7
    80001872:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff53736086>
    80001876:	1902                	slli	s2,s2,0x20
    80001878:	993e                	add	s2,s2,a5
    8000187a:	040009b7          	lui	s3,0x4000
    8000187e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001880:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001882:	4b99                	li	s7,6
    80001884:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001886:	00014a97          	auipc	s5,0x14
    8000188a:	25aa8a93          	addi	s5,s5,602 # 80015ae0 <prime_pids>
    char *pa = kalloc();
    8000188e:	a94ff0ef          	jal	80000b22 <kalloc>
    80001892:	862a                	mv	a2,a0
    if(pa == 0)
    80001894:	c121                	beqz	a0,800018d4 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80001896:	418485b3          	sub	a1,s1,s8
    8000189a:	8591                	srai	a1,a1,0x4
    8000189c:	032585b3          	mul	a1,a1,s2
    800018a0:	2585                	addiw	a1,a1,1
    800018a2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018a6:	875e                	mv	a4,s7
    800018a8:	86da                	mv	a3,s6
    800018aa:	40b985b3          	sub	a1,s3,a1
    800018ae:	8552                	mv	a0,s4
    800018b0:	849ff0ef          	jal	800010f8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b4:	17048493          	addi	s1,s1,368
    800018b8:	fd549be3          	bne	s1,s5,8000188e <proc_mapstacks+0x4c>
  }
}
    800018bc:	60a6                	ld	ra,72(sp)
    800018be:	6406                	ld	s0,64(sp)
    800018c0:	74e2                	ld	s1,56(sp)
    800018c2:	7942                	ld	s2,48(sp)
    800018c4:	79a2                	ld	s3,40(sp)
    800018c6:	7a02                	ld	s4,32(sp)
    800018c8:	6ae2                	ld	s5,24(sp)
    800018ca:	6b42                	ld	s6,16(sp)
    800018cc:	6ba2                	ld	s7,8(sp)
    800018ce:	6c02                	ld	s8,0(sp)
    800018d0:	6161                	addi	sp,sp,80
    800018d2:	8082                	ret
      panic("kalloc");
    800018d4:	00006517          	auipc	a0,0x6
    800018d8:	96450513          	addi	a0,a0,-1692 # 80007238 <etext+0x238>
    800018dc:	ec3fe0ef          	jal	8000079e <panic>

00000000800018e0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018e0:	7139                	addi	sp,sp,-64
    800018e2:	fc06                	sd	ra,56(sp)
    800018e4:	f822                	sd	s0,48(sp)
    800018e6:	f426                	sd	s1,40(sp)
    800018e8:	f04a                	sd	s2,32(sp)
    800018ea:	ec4e                	sd	s3,24(sp)
    800018ec:	e852                	sd	s4,16(sp)
    800018ee:	e456                	sd	s5,8(sp)
    800018f0:	e05a                	sd	s6,0(sp)
    800018f2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018f4:	00006597          	auipc	a1,0x6
    800018f8:	94c58593          	addi	a1,a1,-1716 # 80007240 <etext+0x240>
    800018fc:	0000e517          	auipc	a0,0xe
    80001900:	1b450513          	addi	a0,a0,436 # 8000fab0 <pid_lock>
    80001904:	a6eff0ef          	jal	80000b72 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001908:	00006597          	auipc	a1,0x6
    8000190c:	94058593          	addi	a1,a1,-1728 # 80007248 <etext+0x248>
    80001910:	0000e517          	auipc	a0,0xe
    80001914:	1b850513          	addi	a0,a0,440 # 8000fac8 <wait_lock>
    80001918:	a5aff0ef          	jal	80000b72 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000191c:	0000e497          	auipc	s1,0xe
    80001920:	5c448493          	addi	s1,s1,1476 # 8000fee0 <proc>
      initlock(&p->lock, "proc");
    80001924:	00006b17          	auipc	s6,0x6
    80001928:	934b0b13          	addi	s6,s6,-1740 # 80007258 <etext+0x258>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000192c:	8aa6                	mv	s5,s1
    8000192e:	e9bd37b7          	lui	a5,0xe9bd3
    80001932:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69b628df>
    80001936:	d37a7937          	lui	s2,0xd37a7
    8000193a:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff53736086>
    8000193e:	1902                	slli	s2,s2,0x20
    80001940:	993e                	add	s2,s2,a5
    80001942:	040009b7          	lui	s3,0x4000
    80001946:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001948:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194a:	00014a17          	auipc	s4,0x14
    8000194e:	196a0a13          	addi	s4,s4,406 # 80015ae0 <prime_pids>
      initlock(&p->lock, "proc");
    80001952:	85da                	mv	a1,s6
    80001954:	8526                	mv	a0,s1
    80001956:	a1cff0ef          	jal	80000b72 <initlock>
      p->state = UNUSED;
    8000195a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000195e:	415487b3          	sub	a5,s1,s5
    80001962:	8791                	srai	a5,a5,0x4
    80001964:	032787b3          	mul	a5,a5,s2
    80001968:	2785                	addiw	a5,a5,1
    8000196a:	00d7979b          	slliw	a5,a5,0xd
    8000196e:	40f987b3          	sub	a5,s3,a5
    80001972:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001974:	17048493          	addi	s1,s1,368
    80001978:	fd449de3          	bne	s1,s4,80001952 <procinit+0x72>
  }
  p->rtime=0;
    8000197c:	00014797          	auipc	a5,0x14
    80001980:	2c07b623          	sd	zero,716(a5) # 80015c48 <prime_pids+0x168>
}
    80001984:	70e2                	ld	ra,56(sp)
    80001986:	7442                	ld	s0,48(sp)
    80001988:	74a2                	ld	s1,40(sp)
    8000198a:	7902                	ld	s2,32(sp)
    8000198c:	69e2                	ld	s3,24(sp)
    8000198e:	6a42                	ld	s4,16(sp)
    80001990:	6aa2                	ld	s5,8(sp)
    80001992:	6b02                	ld	s6,0(sp)
    80001994:	6121                	addi	sp,sp,64
    80001996:	8082                	ret

0000000080001998 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001998:	1141                	addi	sp,sp,-16
    8000199a:	e406                	sd	ra,8(sp)
    8000199c:	e022                	sd	s0,0(sp)
    8000199e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019a0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800019a2:	2501                	sext.w	a0,a0
    800019a4:	60a2                	ld	ra,8(sp)
    800019a6:	6402                	ld	s0,0(sp)
    800019a8:	0141                	addi	sp,sp,16
    800019aa:	8082                	ret

00000000800019ac <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800019ac:	1141                	addi	sp,sp,-16
    800019ae:	e406                	sd	ra,8(sp)
    800019b0:	e022                	sd	s0,0(sp)
    800019b2:	0800                	addi	s0,sp,16
    800019b4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019b6:	2781                	sext.w	a5,a5
    800019b8:	079e                	slli	a5,a5,0x7
  return c;
}
    800019ba:	0000e517          	auipc	a0,0xe
    800019be:	12650513          	addi	a0,a0,294 # 8000fae0 <cpus>
    800019c2:	953e                	add	a0,a0,a5
    800019c4:	60a2                	ld	ra,8(sp)
    800019c6:	6402                	ld	s0,0(sp)
    800019c8:	0141                	addi	sp,sp,16
    800019ca:	8082                	ret

00000000800019cc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019cc:	1101                	addi	sp,sp,-32
    800019ce:	ec06                	sd	ra,24(sp)
    800019d0:	e822                	sd	s0,16(sp)
    800019d2:	e426                	sd	s1,8(sp)
    800019d4:	1000                	addi	s0,sp,32
  push_off();
    800019d6:	9e0ff0ef          	jal	80000bb6 <push_off>
    800019da:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019dc:	2781                	sext.w	a5,a5
    800019de:	079e                	slli	a5,a5,0x7
    800019e0:	0000e717          	auipc	a4,0xe
    800019e4:	0d070713          	addi	a4,a4,208 # 8000fab0 <pid_lock>
    800019e8:	97ba                	add	a5,a5,a4
    800019ea:	7b84                	ld	s1,48(a5)
  pop_off();
    800019ec:	a4eff0ef          	jal	80000c3a <pop_off>
  return p;
}
    800019f0:	8526                	mv	a0,s1
    800019f2:	60e2                	ld	ra,24(sp)
    800019f4:	6442                	ld	s0,16(sp)
    800019f6:	64a2                	ld	s1,8(sp)
    800019f8:	6105                	addi	sp,sp,32
    800019fa:	8082                	ret

00000000800019fc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019fc:	1141                	addi	sp,sp,-16
    800019fe:	e406                	sd	ra,8(sp)
    80001a00:	e022                	sd	s0,0(sp)
    80001a02:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a04:	fc9ff0ef          	jal	800019cc <myproc>
    80001a08:	a82ff0ef          	jal	80000c8a <release>

  if (first) {
    80001a0c:	00006797          	auipc	a5,0x6
    80001a10:	ef47a783          	lw	a5,-268(a5) # 80007900 <first.1>
    80001a14:	e799                	bnez	a5,80001a22 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001a16:	381000ef          	jal	80002596 <usertrapret>
}
    80001a1a:	60a2                	ld	ra,8(sp)
    80001a1c:	6402                	ld	s0,0(sp)
    80001a1e:	0141                	addi	sp,sp,16
    80001a20:	8082                	ret
    fsinit(ROOTDEV);
    80001a22:	4505                	li	a0,1
    80001a24:	792010ef          	jal	800031b6 <fsinit>
    first = 0;
    80001a28:	00006797          	auipc	a5,0x6
    80001a2c:	ec07ac23          	sw	zero,-296(a5) # 80007900 <first.1>
    __sync_synchronize();
    80001a30:	0330000f          	fence	rw,rw
    80001a34:	b7cd                	j	80001a16 <forkret+0x1a>

0000000080001a36 <allocpid>:
{
    80001a36:	1101                	addi	sp,sp,-32
    80001a38:	ec06                	sd	ra,24(sp)
    80001a3a:	e822                	sd	s0,16(sp)
    80001a3c:	e426                	sd	s1,8(sp)
    80001a3e:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001a40:	0000e517          	auipc	a0,0xe
    80001a44:	07050513          	addi	a0,a0,112 # 8000fab0 <pid_lock>
    80001a48:	9aeff0ef          	jal	80000bf6 <acquire>
    if (idx >= num_primes) {
    80001a4c:	00006797          	auipc	a5,0x6
    80001a50:	f347a783          	lw	a5,-204(a5) # 80007980 <idx>
    80001a54:	00006717          	auipc	a4,0x6
    80001a58:	f3072703          	lw	a4,-208(a4) # 80007984 <num_primes>
    80001a5c:	04e7d263          	bge	a5,a4,80001aa0 <allocpid+0x6a>
    pid = prime_pids[idx++];
    80001a60:	0017871b          	addiw	a4,a5,1
    80001a64:	00006697          	auipc	a3,0x6
    80001a68:	f0e6ae23          	sw	a4,-228(a3) # 80007980 <idx>
    80001a6c:	078a                	slli	a5,a5,0x2
    80001a6e:	00014717          	auipc	a4,0x14
    80001a72:	07270713          	addi	a4,a4,114 # 80015ae0 <prime_pids>
    80001a76:	97ba                	add	a5,a5,a4
    80001a78:	4384                	lw	s1,0(a5)
    printf("Allocated PID : %d\n",pid);
    80001a7a:	85a6                	mv	a1,s1
    80001a7c:	00005517          	auipc	a0,0x5
    80001a80:	7fc50513          	addi	a0,a0,2044 # 80007278 <etext+0x278>
    80001a84:	a4bfe0ef          	jal	800004ce <printf>
    release(&pid_lock);
    80001a88:	0000e517          	auipc	a0,0xe
    80001a8c:	02850513          	addi	a0,a0,40 # 8000fab0 <pid_lock>
    80001a90:	9faff0ef          	jal	80000c8a <release>
}
    80001a94:	8526                	mv	a0,s1
    80001a96:	60e2                	ld	ra,24(sp)
    80001a98:	6442                	ld	s0,16(sp)
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	6105                	addi	sp,sp,32
    80001a9e:	8082                	ret
        panic("Out of prime PIDs!");
    80001aa0:	00005517          	auipc	a0,0x5
    80001aa4:	7c050513          	addi	a0,a0,1984 # 80007260 <etext+0x260>
    80001aa8:	cf7fe0ef          	jal	8000079e <panic>

0000000080001aac <proc_pagetable>:
{
    80001aac:	1101                	addi	sp,sp,-32
    80001aae:	ec06                	sd	ra,24(sp)
    80001ab0:	e822                	sd	s0,16(sp)
    80001ab2:	e426                	sd	s1,8(sp)
    80001ab4:	e04a                	sd	s2,0(sp)
    80001ab6:	1000                	addi	s0,sp,32
    80001ab8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001aba:	feaff0ef          	jal	800012a4 <uvmcreate>
    80001abe:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ac0:	cd05                	beqz	a0,80001af8 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ac2:	4729                	li	a4,10
    80001ac4:	00004697          	auipc	a3,0x4
    80001ac8:	53c68693          	addi	a3,a3,1340 # 80006000 <_trampoline>
    80001acc:	6605                	lui	a2,0x1
    80001ace:	040005b7          	lui	a1,0x4000
    80001ad2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad4:	05b2                	slli	a1,a1,0xc
    80001ad6:	d6cff0ef          	jal	80001042 <mappages>
    80001ada:	02054663          	bltz	a0,80001b06 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ade:	4719                	li	a4,6
    80001ae0:	05893683          	ld	a3,88(s2)
    80001ae4:	6605                	lui	a2,0x1
    80001ae6:	020005b7          	lui	a1,0x2000
    80001aea:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aec:	05b6                	slli	a1,a1,0xd
    80001aee:	8526                	mv	a0,s1
    80001af0:	d52ff0ef          	jal	80001042 <mappages>
    80001af4:	00054f63          	bltz	a0,80001b12 <proc_pagetable+0x66>
}
    80001af8:	8526                	mv	a0,s1
    80001afa:	60e2                	ld	ra,24(sp)
    80001afc:	6442                	ld	s0,16(sp)
    80001afe:	64a2                	ld	s1,8(sp)
    80001b00:	6902                	ld	s2,0(sp)
    80001b02:	6105                	addi	sp,sp,32
    80001b04:	8082                	ret
    uvmfree(pagetable, 0);
    80001b06:	4581                	li	a1,0
    80001b08:	8526                	mv	a0,s1
    80001b0a:	971ff0ef          	jal	8000147a <uvmfree>
    return 0;
    80001b0e:	4481                	li	s1,0
    80001b10:	b7e5                	j	80001af8 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b12:	4681                	li	a3,0
    80001b14:	4605                	li	a2,1
    80001b16:	040005b7          	lui	a1,0x4000
    80001b1a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b1c:	05b2                	slli	a1,a1,0xc
    80001b1e:	8526                	mv	a0,s1
    80001b20:	ec8ff0ef          	jal	800011e8 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b24:	4581                	li	a1,0
    80001b26:	8526                	mv	a0,s1
    80001b28:	953ff0ef          	jal	8000147a <uvmfree>
    return 0;
    80001b2c:	4481                	li	s1,0
    80001b2e:	b7e9                	j	80001af8 <proc_pagetable+0x4c>

0000000080001b30 <proc_freepagetable>:
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	e04a                	sd	s2,0(sp)
    80001b3a:	1000                	addi	s0,sp,32
    80001b3c:	84aa                	mv	s1,a0
    80001b3e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b40:	4681                	li	a3,0
    80001b42:	4605                	li	a2,1
    80001b44:	040005b7          	lui	a1,0x4000
    80001b48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b4a:	05b2                	slli	a1,a1,0xc
    80001b4c:	e9cff0ef          	jal	800011e8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b50:	4681                	li	a3,0
    80001b52:	4605                	li	a2,1
    80001b54:	020005b7          	lui	a1,0x2000
    80001b58:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b5a:	05b6                	slli	a1,a1,0xd
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	e8aff0ef          	jal	800011e8 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b62:	85ca                	mv	a1,s2
    80001b64:	8526                	mv	a0,s1
    80001b66:	915ff0ef          	jal	8000147a <uvmfree>
}
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6902                	ld	s2,0(sp)
    80001b72:	6105                	addi	sp,sp,32
    80001b74:	8082                	ret

0000000080001b76 <freeproc>:
{
    80001b76:	1101                	addi	sp,sp,-32
    80001b78:	ec06                	sd	ra,24(sp)
    80001b7a:	e822                	sd	s0,16(sp)
    80001b7c:	e426                	sd	s1,8(sp)
    80001b7e:	1000                	addi	s0,sp,32
    80001b80:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b82:	6d28                	ld	a0,88(a0)
    80001b84:	c119                	beqz	a0,80001b8a <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b86:	ebbfe0ef          	jal	80000a40 <kfree>
  p->trapframe = 0;
    80001b8a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b8e:	68a8                	ld	a0,80(s1)
    80001b90:	c501                	beqz	a0,80001b98 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b92:	64ac                	ld	a1,72(s1)
    80001b94:	f9dff0ef          	jal	80001b30 <proc_freepagetable>
  p->pagetable = 0;
    80001b98:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b9c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ba0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ba4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ba8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bac:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bb0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bb4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bb8:	0004ac23          	sw	zero,24(s1)
  p->rtime =0;
    80001bbc:	1604b423          	sd	zero,360(s1)
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <allocproc>:
{
    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	e04a                	sd	s2,0(sp)
    80001bd4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bd6:	0000e497          	auipc	s1,0xe
    80001bda:	30a48493          	addi	s1,s1,778 # 8000fee0 <proc>
    80001bde:	00014917          	auipc	s2,0x14
    80001be2:	f0290913          	addi	s2,s2,-254 # 80015ae0 <prime_pids>
    acquire(&p->lock);
    80001be6:	8526                	mv	a0,s1
    80001be8:	80eff0ef          	jal	80000bf6 <acquire>
    if(p->state == UNUSED) {
    80001bec:	4c9c                	lw	a5,24(s1)
    80001bee:	cb91                	beqz	a5,80001c02 <allocproc+0x38>
      release(&p->lock);
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	898ff0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bf6:	17048493          	addi	s1,s1,368
    80001bfa:	ff2496e3          	bne	s1,s2,80001be6 <allocproc+0x1c>
  return 0;
    80001bfe:	4481                	li	s1,0
    80001c00:	a089                	j	80001c42 <allocproc+0x78>
  p->pid = allocpid();
    80001c02:	e35ff0ef          	jal	80001a36 <allocpid>
    80001c06:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c08:	4785                	li	a5,1
    80001c0a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c0c:	f17fe0ef          	jal	80000b22 <kalloc>
    80001c10:	892a                	mv	s2,a0
    80001c12:	eca8                	sd	a0,88(s1)
    80001c14:	cd15                	beqz	a0,80001c50 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001c16:	8526                	mv	a0,s1
    80001c18:	e95ff0ef          	jal	80001aac <proc_pagetable>
    80001c1c:	892a                	mv	s2,a0
    80001c1e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c20:	c121                	beqz	a0,80001c60 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001c22:	07000613          	li	a2,112
    80001c26:	4581                	li	a1,0
    80001c28:	06048513          	addi	a0,s1,96
    80001c2c:	89aff0ef          	jal	80000cc6 <memset>
  p->context.ra = (uint64)forkret;
    80001c30:	00000797          	auipc	a5,0x0
    80001c34:	dcc78793          	addi	a5,a5,-564 # 800019fc <forkret>
    80001c38:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c3a:	60bc                	ld	a5,64(s1)
    80001c3c:	6705                	lui	a4,0x1
    80001c3e:	97ba                	add	a5,a5,a4
    80001c40:	f4bc                	sd	a5,104(s1)
}
    80001c42:	8526                	mv	a0,s1
    80001c44:	60e2                	ld	ra,24(sp)
    80001c46:	6442                	ld	s0,16(sp)
    80001c48:	64a2                	ld	s1,8(sp)
    80001c4a:	6902                	ld	s2,0(sp)
    80001c4c:	6105                	addi	sp,sp,32
    80001c4e:	8082                	ret
    freeproc(p);
    80001c50:	8526                	mv	a0,s1
    80001c52:	f25ff0ef          	jal	80001b76 <freeproc>
    release(&p->lock);
    80001c56:	8526                	mv	a0,s1
    80001c58:	832ff0ef          	jal	80000c8a <release>
    return 0;
    80001c5c:	84ca                	mv	s1,s2
    80001c5e:	b7d5                	j	80001c42 <allocproc+0x78>
    freeproc(p);
    80001c60:	8526                	mv	a0,s1
    80001c62:	f15ff0ef          	jal	80001b76 <freeproc>
    release(&p->lock);
    80001c66:	8526                	mv	a0,s1
    80001c68:	822ff0ef          	jal	80000c8a <release>
    return 0;
    80001c6c:	84ca                	mv	s1,s2
    80001c6e:	bfd1                	j	80001c42 <allocproc+0x78>

0000000080001c70 <userinit>:
{
    80001c70:	1101                	addi	sp,sp,-32
    80001c72:	ec06                	sd	ra,24(sp)
    80001c74:	e822                	sd	s0,16(sp)
    80001c76:	e426                	sd	s1,8(sp)
    80001c78:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c7a:	f51ff0ef          	jal	80001bca <allocproc>
    80001c7e:	84aa                	mv	s1,a0
  initproc = p;
    80001c80:	00006797          	auipc	a5,0x6
    80001c84:	cea7bc23          	sd	a0,-776(a5) # 80007978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001c88:	03400613          	li	a2,52
    80001c8c:	00006597          	auipc	a1,0x6
    80001c90:	c8458593          	addi	a1,a1,-892 # 80007910 <initcode>
    80001c94:	6928                	ld	a0,80(a0)
    80001c96:	e34ff0ef          	jal	800012ca <uvmfirst>
  p->sz = PGSIZE;
    80001c9a:	6785                	lui	a5,0x1
    80001c9c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001c9e:	6cb8                	ld	a4,88(s1)
    80001ca0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ca4:	6cb8                	ld	a4,88(s1)
    80001ca6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ca8:	4641                	li	a2,16
    80001caa:	00005597          	auipc	a1,0x5
    80001cae:	5e658593          	addi	a1,a1,1510 # 80007290 <etext+0x290>
    80001cb2:	15848513          	addi	a0,s1,344
    80001cb6:	962ff0ef          	jal	80000e18 <safestrcpy>
  p->cwd = namei("/");
    80001cba:	00005517          	auipc	a0,0x5
    80001cbe:	5e650513          	addi	a0,a0,1510 # 800072a0 <etext+0x2a0>
    80001cc2:	619010ef          	jal	80003ada <namei>
    80001cc6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cca:	478d                	li	a5,3
    80001ccc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	fbbfe0ef          	jal	80000c8a <release>
}
    80001cd4:	60e2                	ld	ra,24(sp)
    80001cd6:	6442                	ld	s0,16(sp)
    80001cd8:	64a2                	ld	s1,8(sp)
    80001cda:	6105                	addi	sp,sp,32
    80001cdc:	8082                	ret

0000000080001cde <growproc>:
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
    80001cea:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001cec:	ce1ff0ef          	jal	800019cc <myproc>
    80001cf0:	84aa                	mv	s1,a0
  sz = p->sz;
    80001cf2:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001cf4:	01204c63          	bgtz	s2,80001d0c <growproc+0x2e>
  } else if(n < 0){
    80001cf8:	02094463          	bltz	s2,80001d20 <growproc+0x42>
  p->sz = sz;
    80001cfc:	e4ac                	sd	a1,72(s1)
  return 0;
    80001cfe:	4501                	li	a0,0
}
    80001d00:	60e2                	ld	ra,24(sp)
    80001d02:	6442                	ld	s0,16(sp)
    80001d04:	64a2                	ld	s1,8(sp)
    80001d06:	6902                	ld	s2,0(sp)
    80001d08:	6105                	addi	sp,sp,32
    80001d0a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d0c:	4691                	li	a3,4
    80001d0e:	00b90633          	add	a2,s2,a1
    80001d12:	6928                	ld	a0,80(a0)
    80001d14:	e58ff0ef          	jal	8000136c <uvmalloc>
    80001d18:	85aa                	mv	a1,a0
    80001d1a:	f16d                	bnez	a0,80001cfc <growproc+0x1e>
      return -1;
    80001d1c:	557d                	li	a0,-1
    80001d1e:	b7cd                	j	80001d00 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d20:	00b90633          	add	a2,s2,a1
    80001d24:	6928                	ld	a0,80(a0)
    80001d26:	e02ff0ef          	jal	80001328 <uvmdealloc>
    80001d2a:	85aa                	mv	a1,a0
    80001d2c:	bfc1                	j	80001cfc <growproc+0x1e>

0000000080001d2e <fork>:
{
    80001d2e:	7139                	addi	sp,sp,-64
    80001d30:	fc06                	sd	ra,56(sp)
    80001d32:	f822                	sd	s0,48(sp)
    80001d34:	f04a                	sd	s2,32(sp)
    80001d36:	e456                	sd	s5,8(sp)
    80001d38:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d3a:	c93ff0ef          	jal	800019cc <myproc>
    80001d3e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d40:	e8bff0ef          	jal	80001bca <allocproc>
    80001d44:	0e050a63          	beqz	a0,80001e38 <fork+0x10a>
    80001d48:	e852                	sd	s4,16(sp)
    80001d4a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d4c:	048ab603          	ld	a2,72(s5)
    80001d50:	692c                	ld	a1,80(a0)
    80001d52:	050ab503          	ld	a0,80(s5)
    80001d56:	f56ff0ef          	jal	800014ac <uvmcopy>
    80001d5a:	04054a63          	bltz	a0,80001dae <fork+0x80>
    80001d5e:	f426                	sd	s1,40(sp)
    80001d60:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d62:	048ab783          	ld	a5,72(s5)
    80001d66:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d6a:	058ab683          	ld	a3,88(s5)
    80001d6e:	87b6                	mv	a5,a3
    80001d70:	058a3703          	ld	a4,88(s4)
    80001d74:	12068693          	addi	a3,a3,288
    80001d78:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001d7c:	6788                	ld	a0,8(a5)
    80001d7e:	6b8c                	ld	a1,16(a5)
    80001d80:	6f90                	ld	a2,24(a5)
    80001d82:	01073023          	sd	a6,0(a4)
    80001d86:	e708                	sd	a0,8(a4)
    80001d88:	eb0c                	sd	a1,16(a4)
    80001d8a:	ef10                	sd	a2,24(a4)
    80001d8c:	02078793          	addi	a5,a5,32
    80001d90:	02070713          	addi	a4,a4,32
    80001d94:	fed792e3          	bne	a5,a3,80001d78 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001d98:	058a3783          	ld	a5,88(s4)
    80001d9c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001da0:	0d0a8493          	addi	s1,s5,208
    80001da4:	0d0a0913          	addi	s2,s4,208
    80001da8:	150a8993          	addi	s3,s5,336
    80001dac:	a831                	j	80001dc8 <fork+0x9a>
    freeproc(np);
    80001dae:	8552                	mv	a0,s4
    80001db0:	dc7ff0ef          	jal	80001b76 <freeproc>
    release(&np->lock);
    80001db4:	8552                	mv	a0,s4
    80001db6:	ed5fe0ef          	jal	80000c8a <release>
    return -1;
    80001dba:	597d                	li	s2,-1
    80001dbc:	6a42                	ld	s4,16(sp)
    80001dbe:	a0b5                	j	80001e2a <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001dc0:	04a1                	addi	s1,s1,8
    80001dc2:	0921                	addi	s2,s2,8
    80001dc4:	01348963          	beq	s1,s3,80001dd6 <fork+0xa8>
    if(p->ofile[i])
    80001dc8:	6088                	ld	a0,0(s1)
    80001dca:	d97d                	beqz	a0,80001dc0 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dcc:	2aa020ef          	jal	80004076 <filedup>
    80001dd0:	00a93023          	sd	a0,0(s2)
    80001dd4:	b7f5                	j	80001dc0 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001dd6:	150ab503          	ld	a0,336(s5)
    80001dda:	5da010ef          	jal	800033b4 <idup>
    80001dde:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001de2:	4641                	li	a2,16
    80001de4:	158a8593          	addi	a1,s5,344
    80001de8:	158a0513          	addi	a0,s4,344
    80001dec:	82cff0ef          	jal	80000e18 <safestrcpy>
  pid = np->pid;
    80001df0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001df4:	8552                	mv	a0,s4
    80001df6:	e95fe0ef          	jal	80000c8a <release>
  acquire(&wait_lock);
    80001dfa:	0000e497          	auipc	s1,0xe
    80001dfe:	cce48493          	addi	s1,s1,-818 # 8000fac8 <wait_lock>
    80001e02:	8526                	mv	a0,s1
    80001e04:	df3fe0ef          	jal	80000bf6 <acquire>
  np->parent = p;
    80001e08:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e0c:	8526                	mv	a0,s1
    80001e0e:	e7dfe0ef          	jal	80000c8a <release>
  acquire(&np->lock);
    80001e12:	8552                	mv	a0,s4
    80001e14:	de3fe0ef          	jal	80000bf6 <acquire>
  np->state = RUNNABLE;
    80001e18:	478d                	li	a5,3
    80001e1a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e1e:	8552                	mv	a0,s4
    80001e20:	e6bfe0ef          	jal	80000c8a <release>
  return pid;
    80001e24:	74a2                	ld	s1,40(sp)
    80001e26:	69e2                	ld	s3,24(sp)
    80001e28:	6a42                	ld	s4,16(sp)
}
    80001e2a:	854a                	mv	a0,s2
    80001e2c:	70e2                	ld	ra,56(sp)
    80001e2e:	7442                	ld	s0,48(sp)
    80001e30:	7902                	ld	s2,32(sp)
    80001e32:	6aa2                	ld	s5,8(sp)
    80001e34:	6121                	addi	sp,sp,64
    80001e36:	8082                	ret
    return -1;
    80001e38:	597d                	li	s2,-1
    80001e3a:	bfc5                	j	80001e2a <fork+0xfc>

0000000080001e3c <scheduler>:
{
    80001e3c:	715d                	addi	sp,sp,-80
    80001e3e:	e486                	sd	ra,72(sp)
    80001e40:	e0a2                	sd	s0,64(sp)
    80001e42:	fc26                	sd	s1,56(sp)
    80001e44:	f84a                	sd	s2,48(sp)
    80001e46:	f44e                	sd	s3,40(sp)
    80001e48:	f052                	sd	s4,32(sp)
    80001e4a:	ec56                	sd	s5,24(sp)
    80001e4c:	e85a                	sd	s6,16(sp)
    80001e4e:	e45e                	sd	s7,8(sp)
    80001e50:	e062                	sd	s8,0(sp)
    80001e52:	0880                	addi	s0,sp,80
    80001e54:	8792                	mv	a5,tp
  int id = r_tp();
    80001e56:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e58:	00779b13          	slli	s6,a5,0x7
    80001e5c:	0000e717          	auipc	a4,0xe
    80001e60:	c5470713          	addi	a4,a4,-940 # 8000fab0 <pid_lock>
    80001e64:	975a                	add	a4,a4,s6
    80001e66:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001e6a:	0000e717          	auipc	a4,0xe
    80001e6e:	c7e70713          	addi	a4,a4,-898 # 8000fae8 <cpus+0x8>
    80001e72:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001e74:	4c11                	li	s8,4
        c->proc = p;
    80001e76:	079e                	slli	a5,a5,0x7
    80001e78:	0000ea17          	auipc	s4,0xe
    80001e7c:	c38a0a13          	addi	s4,s4,-968 # 8000fab0 <pid_lock>
    80001e80:	9a3e                	add	s4,s4,a5
        found = 1;
    80001e82:	4b85                	li	s7,1
    80001e84:	a83d                	j	80001ec2 <scheduler+0x86>
      release(&p->lock);
    80001e86:	8526                	mv	a0,s1
    80001e88:	e03fe0ef          	jal	80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e8c:	17048493          	addi	s1,s1,368
    80001e90:	03248563          	beq	s1,s2,80001eba <scheduler+0x7e>
      acquire(&p->lock);
    80001e94:	8526                	mv	a0,s1
    80001e96:	d61fe0ef          	jal	80000bf6 <acquire>
      if(p->state == RUNNABLE) {
    80001e9a:	4c9c                	lw	a5,24(s1)
    80001e9c:	ff3795e3          	bne	a5,s3,80001e86 <scheduler+0x4a>
        p->state = RUNNING;
    80001ea0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001ea4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001ea8:	06048593          	addi	a1,s1,96
    80001eac:	855a                	mv	a0,s6
    80001eae:	63e000ef          	jal	800024ec <swtch>
        c->proc = 0;
    80001eb2:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001eb6:	8ade                	mv	s5,s7
    80001eb8:	b7f9                	j	80001e86 <scheduler+0x4a>
    if(found == 0) {
    80001eba:	000a9463          	bnez	s5,80001ec2 <scheduler+0x86>
      asm volatile("wfi");
    80001ebe:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ec6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eca:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ece:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ed2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ed4:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001ed8:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eda:	0000e497          	auipc	s1,0xe
    80001ede:	00648493          	addi	s1,s1,6 # 8000fee0 <proc>
      if(p->state == RUNNABLE) {
    80001ee2:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee4:	00014917          	auipc	s2,0x14
    80001ee8:	bfc90913          	addi	s2,s2,-1028 # 80015ae0 <prime_pids>
    80001eec:	b765                	j	80001e94 <scheduler+0x58>

0000000080001eee <sched>:
{
    80001eee:	7179                	addi	sp,sp,-48
    80001ef0:	f406                	sd	ra,40(sp)
    80001ef2:	f022                	sd	s0,32(sp)
    80001ef4:	ec26                	sd	s1,24(sp)
    80001ef6:	e84a                	sd	s2,16(sp)
    80001ef8:	e44e                	sd	s3,8(sp)
    80001efa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001efc:	ad1ff0ef          	jal	800019cc <myproc>
    80001f00:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f02:	c8bfe0ef          	jal	80000b8c <holding>
    80001f06:	c92d                	beqz	a0,80001f78 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f08:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f0a:	2781                	sext.w	a5,a5
    80001f0c:	079e                	slli	a5,a5,0x7
    80001f0e:	0000e717          	auipc	a4,0xe
    80001f12:	ba270713          	addi	a4,a4,-1118 # 8000fab0 <pid_lock>
    80001f16:	97ba                	add	a5,a5,a4
    80001f18:	0a87a703          	lw	a4,168(a5)
    80001f1c:	4785                	li	a5,1
    80001f1e:	06f71363          	bne	a4,a5,80001f84 <sched+0x96>
  if(p->state == RUNNING)
    80001f22:	4c98                	lw	a4,24(s1)
    80001f24:	4791                	li	a5,4
    80001f26:	06f70563          	beq	a4,a5,80001f90 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f2e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f30:	e7b5                	bnez	a5,80001f9c <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f32:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f34:	0000e917          	auipc	s2,0xe
    80001f38:	b7c90913          	addi	s2,s2,-1156 # 8000fab0 <pid_lock>
    80001f3c:	2781                	sext.w	a5,a5
    80001f3e:	079e                	slli	a5,a5,0x7
    80001f40:	97ca                	add	a5,a5,s2
    80001f42:	0ac7a983          	lw	s3,172(a5)
    80001f46:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f48:	2781                	sext.w	a5,a5
    80001f4a:	079e                	slli	a5,a5,0x7
    80001f4c:	0000e597          	auipc	a1,0xe
    80001f50:	b9c58593          	addi	a1,a1,-1124 # 8000fae8 <cpus+0x8>
    80001f54:	95be                	add	a1,a1,a5
    80001f56:	06048513          	addi	a0,s1,96
    80001f5a:	592000ef          	jal	800024ec <swtch>
    80001f5e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f60:	2781                	sext.w	a5,a5
    80001f62:	079e                	slli	a5,a5,0x7
    80001f64:	993e                	add	s2,s2,a5
    80001f66:	0b392623          	sw	s3,172(s2)
}
    80001f6a:	70a2                	ld	ra,40(sp)
    80001f6c:	7402                	ld	s0,32(sp)
    80001f6e:	64e2                	ld	s1,24(sp)
    80001f70:	6942                	ld	s2,16(sp)
    80001f72:	69a2                	ld	s3,8(sp)
    80001f74:	6145                	addi	sp,sp,48
    80001f76:	8082                	ret
    panic("sched p->lock");
    80001f78:	00005517          	auipc	a0,0x5
    80001f7c:	33050513          	addi	a0,a0,816 # 800072a8 <etext+0x2a8>
    80001f80:	81ffe0ef          	jal	8000079e <panic>
    panic("sched locks");
    80001f84:	00005517          	auipc	a0,0x5
    80001f88:	33450513          	addi	a0,a0,820 # 800072b8 <etext+0x2b8>
    80001f8c:	813fe0ef          	jal	8000079e <panic>
    panic("sched RUNNING");
    80001f90:	00005517          	auipc	a0,0x5
    80001f94:	33850513          	addi	a0,a0,824 # 800072c8 <etext+0x2c8>
    80001f98:	807fe0ef          	jal	8000079e <panic>
    panic("sched interruptible");
    80001f9c:	00005517          	auipc	a0,0x5
    80001fa0:	33c50513          	addi	a0,a0,828 # 800072d8 <etext+0x2d8>
    80001fa4:	ffafe0ef          	jal	8000079e <panic>

0000000080001fa8 <yield>:
{
    80001fa8:	1101                	addi	sp,sp,-32
    80001faa:	ec06                	sd	ra,24(sp)
    80001fac:	e822                	sd	s0,16(sp)
    80001fae:	e426                	sd	s1,8(sp)
    80001fb0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fb2:	a1bff0ef          	jal	800019cc <myproc>
    80001fb6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fb8:	c3ffe0ef          	jal	80000bf6 <acquire>
  p->state = RUNNABLE;
    80001fbc:	478d                	li	a5,3
    80001fbe:	cc9c                	sw	a5,24(s1)
  sched();
    80001fc0:	f2fff0ef          	jal	80001eee <sched>
  release(&p->lock);
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	cc5fe0ef          	jal	80000c8a <release>
}
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <sleep>:

// Sleep on wait channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001fd4:	7179                	addi	sp,sp,-48
    80001fd6:	f406                	sd	ra,40(sp)
    80001fd8:	f022                	sd	s0,32(sp)
    80001fda:	ec26                	sd	s1,24(sp)
    80001fdc:	e84a                	sd	s2,16(sp)
    80001fde:	e44e                	sd	s3,8(sp)
    80001fe0:	1800                	addi	s0,sp,48
    80001fe2:	89aa                	mv	s3,a0
    80001fe4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fe6:	9e7ff0ef          	jal	800019cc <myproc>
    80001fea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001fec:	c0bfe0ef          	jal	80000bf6 <acquire>
  release(lk);
    80001ff0:	854a                	mv	a0,s2
    80001ff2:	c99fe0ef          	jal	80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    80001ff6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ffa:	4789                	li	a5,2
    80001ffc:	cc9c                	sw	a5,24(s1)

  sched();
    80001ffe:	ef1ff0ef          	jal	80001eee <sched>

  // Tidy up.
  p->chan = 0;
    80002002:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002006:	8526                	mv	a0,s1
    80002008:	c83fe0ef          	jal	80000c8a <release>
  acquire(lk);
    8000200c:	854a                	mv	a0,s2
    8000200e:	be9fe0ef          	jal	80000bf6 <acquire>
}
    80002012:	70a2                	ld	ra,40(sp)
    80002014:	7402                	ld	s0,32(sp)
    80002016:	64e2                	ld	s1,24(sp)
    80002018:	6942                	ld	s2,16(sp)
    8000201a:	69a2                	ld	s3,8(sp)
    8000201c:	6145                	addi	sp,sp,48
    8000201e:	8082                	ret

0000000080002020 <wakeup>:

// Wake up all processes sleeping on wait channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002020:	7139                	addi	sp,sp,-64
    80002022:	fc06                	sd	ra,56(sp)
    80002024:	f822                	sd	s0,48(sp)
    80002026:	f426                	sd	s1,40(sp)
    80002028:	f04a                	sd	s2,32(sp)
    8000202a:	ec4e                	sd	s3,24(sp)
    8000202c:	e852                	sd	s4,16(sp)
    8000202e:	e456                	sd	s5,8(sp)
    80002030:	0080                	addi	s0,sp,64
    80002032:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002034:	0000e497          	auipc	s1,0xe
    80002038:	eac48493          	addi	s1,s1,-340 # 8000fee0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000203c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000203e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002040:	00014917          	auipc	s2,0x14
    80002044:	aa090913          	addi	s2,s2,-1376 # 80015ae0 <prime_pids>
    80002048:	a801                	j	80002058 <wakeup+0x38>
      }
      release(&p->lock);
    8000204a:	8526                	mv	a0,s1
    8000204c:	c3ffe0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002050:	17048493          	addi	s1,s1,368
    80002054:	03248263          	beq	s1,s2,80002078 <wakeup+0x58>
    if(p != myproc()){
    80002058:	975ff0ef          	jal	800019cc <myproc>
    8000205c:	fea48ae3          	beq	s1,a0,80002050 <wakeup+0x30>
      acquire(&p->lock);
    80002060:	8526                	mv	a0,s1
    80002062:	b95fe0ef          	jal	80000bf6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002066:	4c9c                	lw	a5,24(s1)
    80002068:	ff3791e3          	bne	a5,s3,8000204a <wakeup+0x2a>
    8000206c:	709c                	ld	a5,32(s1)
    8000206e:	fd479ee3          	bne	a5,s4,8000204a <wakeup+0x2a>
        p->state = RUNNABLE;
    80002072:	0154ac23          	sw	s5,24(s1)
    80002076:	bfd1                	j	8000204a <wakeup+0x2a>
    }
  }
}
    80002078:	70e2                	ld	ra,56(sp)
    8000207a:	7442                	ld	s0,48(sp)
    8000207c:	74a2                	ld	s1,40(sp)
    8000207e:	7902                	ld	s2,32(sp)
    80002080:	69e2                	ld	s3,24(sp)
    80002082:	6a42                	ld	s4,16(sp)
    80002084:	6aa2                	ld	s5,8(sp)
    80002086:	6121                	addi	sp,sp,64
    80002088:	8082                	ret

000000008000208a <reparent>:
{
    8000208a:	7179                	addi	sp,sp,-48
    8000208c:	f406                	sd	ra,40(sp)
    8000208e:	f022                	sd	s0,32(sp)
    80002090:	ec26                	sd	s1,24(sp)
    80002092:	e84a                	sd	s2,16(sp)
    80002094:	e44e                	sd	s3,8(sp)
    80002096:	e052                	sd	s4,0(sp)
    80002098:	1800                	addi	s0,sp,48
    8000209a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000209c:	0000e497          	auipc	s1,0xe
    800020a0:	e4448493          	addi	s1,s1,-444 # 8000fee0 <proc>
      pp->parent = initproc;
    800020a4:	00006a17          	auipc	s4,0x6
    800020a8:	8d4a0a13          	addi	s4,s4,-1836 # 80007978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800020ac:	00014997          	auipc	s3,0x14
    800020b0:	a3498993          	addi	s3,s3,-1484 # 80015ae0 <prime_pids>
    800020b4:	a029                	j	800020be <reparent+0x34>
    800020b6:	17048493          	addi	s1,s1,368
    800020ba:	01348b63          	beq	s1,s3,800020d0 <reparent+0x46>
    if(pp->parent == p){
    800020be:	7c9c                	ld	a5,56(s1)
    800020c0:	ff279be3          	bne	a5,s2,800020b6 <reparent+0x2c>
      pp->parent = initproc;
    800020c4:	000a3503          	ld	a0,0(s4)
    800020c8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800020ca:	f57ff0ef          	jal	80002020 <wakeup>
    800020ce:	b7e5                	j	800020b6 <reparent+0x2c>
}
    800020d0:	70a2                	ld	ra,40(sp)
    800020d2:	7402                	ld	s0,32(sp)
    800020d4:	64e2                	ld	s1,24(sp)
    800020d6:	6942                	ld	s2,16(sp)
    800020d8:	69a2                	ld	s3,8(sp)
    800020da:	6a02                	ld	s4,0(sp)
    800020dc:	6145                	addi	sp,sp,48
    800020de:	8082                	ret

00000000800020e0 <exit>:
{
    800020e0:	7179                	addi	sp,sp,-48
    800020e2:	f406                	sd	ra,40(sp)
    800020e4:	f022                	sd	s0,32(sp)
    800020e6:	ec26                	sd	s1,24(sp)
    800020e8:	e84a                	sd	s2,16(sp)
    800020ea:	e44e                	sd	s3,8(sp)
    800020ec:	e052                	sd	s4,0(sp)
    800020ee:	1800                	addi	s0,sp,48
    800020f0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020f2:	8dbff0ef          	jal	800019cc <myproc>
    800020f6:	89aa                	mv	s3,a0
  if(p == initproc)
    800020f8:	00006797          	auipc	a5,0x6
    800020fc:	8807b783          	ld	a5,-1920(a5) # 80007978 <initproc>
    80002100:	0d050493          	addi	s1,a0,208
    80002104:	15050913          	addi	s2,a0,336
    80002108:	00a79b63          	bne	a5,a0,8000211e <exit+0x3e>
    panic("init exiting");
    8000210c:	00005517          	auipc	a0,0x5
    80002110:	1e450513          	addi	a0,a0,484 # 800072f0 <etext+0x2f0>
    80002114:	e8afe0ef          	jal	8000079e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002118:	04a1                	addi	s1,s1,8
    8000211a:	01248963          	beq	s1,s2,8000212c <exit+0x4c>
    if(p->ofile[fd]){
    8000211e:	6088                	ld	a0,0(s1)
    80002120:	dd65                	beqz	a0,80002118 <exit+0x38>
      fileclose(f);
    80002122:	79b010ef          	jal	800040bc <fileclose>
      p->ofile[fd] = 0;
    80002126:	0004b023          	sd	zero,0(s1)
    8000212a:	b7fd                	j	80002118 <exit+0x38>
  begin_op();
    8000212c:	371010ef          	jal	80003c9c <begin_op>
  iput(p->cwd);
    80002130:	1509b503          	ld	a0,336(s3)
    80002134:	438010ef          	jal	8000356c <iput>
  end_op();
    80002138:	3cf010ef          	jal	80003d06 <end_op>
  p->cwd = 0;
    8000213c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002140:	0000e497          	auipc	s1,0xe
    80002144:	98848493          	addi	s1,s1,-1656 # 8000fac8 <wait_lock>
    80002148:	8526                	mv	a0,s1
    8000214a:	aadfe0ef          	jal	80000bf6 <acquire>
  reparent(p);
    8000214e:	854e                	mv	a0,s3
    80002150:	f3bff0ef          	jal	8000208a <reparent>
  wakeup(p->parent);
    80002154:	0389b503          	ld	a0,56(s3)
    80002158:	ec9ff0ef          	jal	80002020 <wakeup>
  acquire(&p->lock);
    8000215c:	854e                	mv	a0,s3
    8000215e:	a99fe0ef          	jal	80000bf6 <acquire>
  p->xstate = status;
    80002162:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002166:	4795                	li	a5,5
    80002168:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000216c:	8526                	mv	a0,s1
    8000216e:	b1dfe0ef          	jal	80000c8a <release>
  sched();
    80002172:	d7dff0ef          	jal	80001eee <sched>
  panic("zombie exit");
    80002176:	00005517          	auipc	a0,0x5
    8000217a:	18a50513          	addi	a0,a0,394 # 80007300 <etext+0x300>
    8000217e:	e20fe0ef          	jal	8000079e <panic>

0000000080002182 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002182:	7179                	addi	sp,sp,-48
    80002184:	f406                	sd	ra,40(sp)
    80002186:	f022                	sd	s0,32(sp)
    80002188:	ec26                	sd	s1,24(sp)
    8000218a:	e84a                	sd	s2,16(sp)
    8000218c:	e44e                	sd	s3,8(sp)
    8000218e:	1800                	addi	s0,sp,48
    80002190:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002192:	0000e497          	auipc	s1,0xe
    80002196:	d4e48493          	addi	s1,s1,-690 # 8000fee0 <proc>
    8000219a:	00014997          	auipc	s3,0x14
    8000219e:	94698993          	addi	s3,s3,-1722 # 80015ae0 <prime_pids>
    acquire(&p->lock);
    800021a2:	8526                	mv	a0,s1
    800021a4:	a53fe0ef          	jal	80000bf6 <acquire>
    if(p->pid == pid){
    800021a8:	589c                	lw	a5,48(s1)
    800021aa:	01278b63          	beq	a5,s2,800021c0 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800021ae:	8526                	mv	a0,s1
    800021b0:	adbfe0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800021b4:	17048493          	addi	s1,s1,368
    800021b8:	ff3495e3          	bne	s1,s3,800021a2 <kill+0x20>
  }
  return -1;
    800021bc:	557d                	li	a0,-1
    800021be:	a819                	j	800021d4 <kill+0x52>
      p->killed = 1;
    800021c0:	4785                	li	a5,1
    800021c2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800021c4:	4c98                	lw	a4,24(s1)
    800021c6:	4789                	li	a5,2
    800021c8:	00f70d63          	beq	a4,a5,800021e2 <kill+0x60>
      release(&p->lock);
    800021cc:	8526                	mv	a0,s1
    800021ce:	abdfe0ef          	jal	80000c8a <release>
      return 0;
    800021d2:	4501                	li	a0,0
}
    800021d4:	70a2                	ld	ra,40(sp)
    800021d6:	7402                	ld	s0,32(sp)
    800021d8:	64e2                	ld	s1,24(sp)
    800021da:	6942                	ld	s2,16(sp)
    800021dc:	69a2                	ld	s3,8(sp)
    800021de:	6145                	addi	sp,sp,48
    800021e0:	8082                	ret
        p->state = RUNNABLE;
    800021e2:	478d                	li	a5,3
    800021e4:	cc9c                	sw	a5,24(s1)
    800021e6:	b7dd                	j	800021cc <kill+0x4a>

00000000800021e8 <setkilled>:

void
setkilled(struct proc *p)
{
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	e426                	sd	s1,8(sp)
    800021f0:	1000                	addi	s0,sp,32
    800021f2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021f4:	a03fe0ef          	jal	80000bf6 <acquire>
  p->killed = 1;
    800021f8:	4785                	li	a5,1
    800021fa:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800021fc:	8526                	mv	a0,s1
    800021fe:	a8dfe0ef          	jal	80000c8a <release>
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6105                	addi	sp,sp,32
    8000220a:	8082                	ret

000000008000220c <killed>:

int
killed(struct proc *p)
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	e426                	sd	s1,8(sp)
    80002214:	e04a                	sd	s2,0(sp)
    80002216:	1000                	addi	s0,sp,32
    80002218:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000221a:	9ddfe0ef          	jal	80000bf6 <acquire>
  k = p->killed;
    8000221e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002222:	8526                	mv	a0,s1
    80002224:	a67fe0ef          	jal	80000c8a <release>
  return k;
}
    80002228:	854a                	mv	a0,s2
    8000222a:	60e2                	ld	ra,24(sp)
    8000222c:	6442                	ld	s0,16(sp)
    8000222e:	64a2                	ld	s1,8(sp)
    80002230:	6902                	ld	s2,0(sp)
    80002232:	6105                	addi	sp,sp,32
    80002234:	8082                	ret

0000000080002236 <wait>:
{
    80002236:	715d                	addi	sp,sp,-80
    80002238:	e486                	sd	ra,72(sp)
    8000223a:	e0a2                	sd	s0,64(sp)
    8000223c:	fc26                	sd	s1,56(sp)
    8000223e:	f84a                	sd	s2,48(sp)
    80002240:	f44e                	sd	s3,40(sp)
    80002242:	f052                	sd	s4,32(sp)
    80002244:	ec56                	sd	s5,24(sp)
    80002246:	e85a                	sd	s6,16(sp)
    80002248:	e45e                	sd	s7,8(sp)
    8000224a:	0880                	addi	s0,sp,80
    8000224c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000224e:	f7eff0ef          	jal	800019cc <myproc>
    80002252:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002254:	0000e517          	auipc	a0,0xe
    80002258:	87450513          	addi	a0,a0,-1932 # 8000fac8 <wait_lock>
    8000225c:	99bfe0ef          	jal	80000bf6 <acquire>
        if(pp->state == ZOMBIE){
    80002260:	4a15                	li	s4,5
        havekids = 1;
    80002262:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002264:	00014997          	auipc	s3,0x14
    80002268:	87c98993          	addi	s3,s3,-1924 # 80015ae0 <prime_pids>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000226c:	0000eb97          	auipc	s7,0xe
    80002270:	85cb8b93          	addi	s7,s7,-1956 # 8000fac8 <wait_lock>
    80002274:	a869                	j	8000230e <wait+0xd8>
          pid = pp->pid;
    80002276:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000227a:	000b0c63          	beqz	s6,80002292 <wait+0x5c>
    8000227e:	4691                	li	a3,4
    80002280:	02c48613          	addi	a2,s1,44
    80002284:	85da                	mv	a1,s6
    80002286:	05093503          	ld	a0,80(s2)
    8000228a:	b02ff0ef          	jal	8000158c <copyout>
    8000228e:	02054a63          	bltz	a0,800022c2 <wait+0x8c>
          freeproc(pp);
    80002292:	8526                	mv	a0,s1
    80002294:	8e3ff0ef          	jal	80001b76 <freeproc>
          release(&pp->lock);
    80002298:	8526                	mv	a0,s1
    8000229a:	9f1fe0ef          	jal	80000c8a <release>
          release(&wait_lock);
    8000229e:	0000e517          	auipc	a0,0xe
    800022a2:	82a50513          	addi	a0,a0,-2006 # 8000fac8 <wait_lock>
    800022a6:	9e5fe0ef          	jal	80000c8a <release>
}
    800022aa:	854e                	mv	a0,s3
    800022ac:	60a6                	ld	ra,72(sp)
    800022ae:	6406                	ld	s0,64(sp)
    800022b0:	74e2                	ld	s1,56(sp)
    800022b2:	7942                	ld	s2,48(sp)
    800022b4:	79a2                	ld	s3,40(sp)
    800022b6:	7a02                	ld	s4,32(sp)
    800022b8:	6ae2                	ld	s5,24(sp)
    800022ba:	6b42                	ld	s6,16(sp)
    800022bc:	6ba2                	ld	s7,8(sp)
    800022be:	6161                	addi	sp,sp,80
    800022c0:	8082                	ret
            release(&pp->lock);
    800022c2:	8526                	mv	a0,s1
    800022c4:	9c7fe0ef          	jal	80000c8a <release>
            release(&wait_lock);
    800022c8:	0000e517          	auipc	a0,0xe
    800022cc:	80050513          	addi	a0,a0,-2048 # 8000fac8 <wait_lock>
    800022d0:	9bbfe0ef          	jal	80000c8a <release>
            return -1;
    800022d4:	59fd                	li	s3,-1
    800022d6:	bfd1                	j	800022aa <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022d8:	17048493          	addi	s1,s1,368
    800022dc:	03348063          	beq	s1,s3,800022fc <wait+0xc6>
      if(pp->parent == p){
    800022e0:	7c9c                	ld	a5,56(s1)
    800022e2:	ff279be3          	bne	a5,s2,800022d8 <wait+0xa2>
        acquire(&pp->lock);
    800022e6:	8526                	mv	a0,s1
    800022e8:	90ffe0ef          	jal	80000bf6 <acquire>
        if(pp->state == ZOMBIE){
    800022ec:	4c9c                	lw	a5,24(s1)
    800022ee:	f94784e3          	beq	a5,s4,80002276 <wait+0x40>
        release(&pp->lock);
    800022f2:	8526                	mv	a0,s1
    800022f4:	997fe0ef          	jal	80000c8a <release>
        havekids = 1;
    800022f8:	8756                	mv	a4,s5
    800022fa:	bff9                	j	800022d8 <wait+0xa2>
    if(!havekids || killed(p)){
    800022fc:	cf19                	beqz	a4,8000231a <wait+0xe4>
    800022fe:	854a                	mv	a0,s2
    80002300:	f0dff0ef          	jal	8000220c <killed>
    80002304:	e919                	bnez	a0,8000231a <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002306:	85de                	mv	a1,s7
    80002308:	854a                	mv	a0,s2
    8000230a:	ccbff0ef          	jal	80001fd4 <sleep>
    havekids = 0;
    8000230e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002310:	0000e497          	auipc	s1,0xe
    80002314:	bd048493          	addi	s1,s1,-1072 # 8000fee0 <proc>
    80002318:	b7e1                	j	800022e0 <wait+0xaa>
      release(&wait_lock);
    8000231a:	0000d517          	auipc	a0,0xd
    8000231e:	7ae50513          	addi	a0,a0,1966 # 8000fac8 <wait_lock>
    80002322:	969fe0ef          	jal	80000c8a <release>
      return -1;
    80002326:	59fd                	li	s3,-1
    80002328:	b749                	j	800022aa <wait+0x74>

000000008000232a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000232a:	7179                	addi	sp,sp,-48
    8000232c:	f406                	sd	ra,40(sp)
    8000232e:	f022                	sd	s0,32(sp)
    80002330:	ec26                	sd	s1,24(sp)
    80002332:	e84a                	sd	s2,16(sp)
    80002334:	e44e                	sd	s3,8(sp)
    80002336:	e052                	sd	s4,0(sp)
    80002338:	1800                	addi	s0,sp,48
    8000233a:	84aa                	mv	s1,a0
    8000233c:	892e                	mv	s2,a1
    8000233e:	89b2                	mv	s3,a2
    80002340:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002342:	e8aff0ef          	jal	800019cc <myproc>
  if(user_dst){
    80002346:	cc99                	beqz	s1,80002364 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002348:	86d2                	mv	a3,s4
    8000234a:	864e                	mv	a2,s3
    8000234c:	85ca                	mv	a1,s2
    8000234e:	6928                	ld	a0,80(a0)
    80002350:	a3cff0ef          	jal	8000158c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002354:	70a2                	ld	ra,40(sp)
    80002356:	7402                	ld	s0,32(sp)
    80002358:	64e2                	ld	s1,24(sp)
    8000235a:	6942                	ld	s2,16(sp)
    8000235c:	69a2                	ld	s3,8(sp)
    8000235e:	6a02                	ld	s4,0(sp)
    80002360:	6145                	addi	sp,sp,48
    80002362:	8082                	ret
    memmove((char *)dst, src, len);
    80002364:	000a061b          	sext.w	a2,s4
    80002368:	85ce                	mv	a1,s3
    8000236a:	854a                	mv	a0,s2
    8000236c:	9bffe0ef          	jal	80000d2a <memmove>
    return 0;
    80002370:	8526                	mv	a0,s1
    80002372:	b7cd                	j	80002354 <either_copyout+0x2a>

0000000080002374 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002374:	7179                	addi	sp,sp,-48
    80002376:	f406                	sd	ra,40(sp)
    80002378:	f022                	sd	s0,32(sp)
    8000237a:	ec26                	sd	s1,24(sp)
    8000237c:	e84a                	sd	s2,16(sp)
    8000237e:	e44e                	sd	s3,8(sp)
    80002380:	e052                	sd	s4,0(sp)
    80002382:	1800                	addi	s0,sp,48
    80002384:	892a                	mv	s2,a0
    80002386:	84ae                	mv	s1,a1
    80002388:	89b2                	mv	s3,a2
    8000238a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000238c:	e40ff0ef          	jal	800019cc <myproc>
  if(user_src){
    80002390:	cc99                	beqz	s1,800023ae <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002392:	86d2                	mv	a3,s4
    80002394:	864e                	mv	a2,s3
    80002396:	85ca                	mv	a1,s2
    80002398:	6928                	ld	a0,80(a0)
    8000239a:	aa2ff0ef          	jal	8000163c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000239e:	70a2                	ld	ra,40(sp)
    800023a0:	7402                	ld	s0,32(sp)
    800023a2:	64e2                	ld	s1,24(sp)
    800023a4:	6942                	ld	s2,16(sp)
    800023a6:	69a2                	ld	s3,8(sp)
    800023a8:	6a02                	ld	s4,0(sp)
    800023aa:	6145                	addi	sp,sp,48
    800023ac:	8082                	ret
    memmove(dst, (char*)src, len);
    800023ae:	000a061b          	sext.w	a2,s4
    800023b2:	85ce                	mv	a1,s3
    800023b4:	854a                	mv	a0,s2
    800023b6:	975fe0ef          	jal	80000d2a <memmove>
    return 0;
    800023ba:	8526                	mv	a0,s1
    800023bc:	b7cd                	j	8000239e <either_copyin+0x2a>

00000000800023be <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800023be:	715d                	addi	sp,sp,-80
    800023c0:	e486                	sd	ra,72(sp)
    800023c2:	e0a2                	sd	s0,64(sp)
    800023c4:	fc26                	sd	s1,56(sp)
    800023c6:	f84a                	sd	s2,48(sp)
    800023c8:	f44e                	sd	s3,40(sp)
    800023ca:	f052                	sd	s4,32(sp)
    800023cc:	ec56                	sd	s5,24(sp)
    800023ce:	e85a                	sd	s6,16(sp)
    800023d0:	e45e                	sd	s7,8(sp)
    800023d2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800023d4:	00005517          	auipc	a0,0x5
    800023d8:	e5c50513          	addi	a0,a0,-420 # 80007230 <etext+0x230>
    800023dc:	8f2fe0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800023e0:	0000e497          	auipc	s1,0xe
    800023e4:	c5848493          	addi	s1,s1,-936 # 80010038 <proc+0x158>
    800023e8:	00014917          	auipc	s2,0x14
    800023ec:	85090913          	addi	s2,s2,-1968 # 80015c38 <prime_pids+0x158>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023f0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800023f2:	00005997          	auipc	s3,0x5
    800023f6:	f1e98993          	addi	s3,s3,-226 # 80007310 <etext+0x310>
    printf("%d %s %s", p->pid, state, p->name);
    800023fa:	00005a97          	auipc	s5,0x5
    800023fe:	f1ea8a93          	addi	s5,s5,-226 # 80007318 <etext+0x318>
    printf("\n");
    80002402:	00005a17          	auipc	s4,0x5
    80002406:	e2ea0a13          	addi	s4,s4,-466 # 80007230 <etext+0x230>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000240a:	00005b97          	auipc	s7,0x5
    8000240e:	3eeb8b93          	addi	s7,s7,1006 # 800077f8 <states.0>
    80002412:	a829                	j	8000242c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002414:	ed86a583          	lw	a1,-296(a3)
    80002418:	8556                	mv	a0,s5
    8000241a:	8b4fe0ef          	jal	800004ce <printf>
    printf("\n");
    8000241e:	8552                	mv	a0,s4
    80002420:	8aefe0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002424:	17048493          	addi	s1,s1,368
    80002428:	03248263          	beq	s1,s2,8000244c <procdump+0x8e>
    if(p->state == UNUSED)
    8000242c:	86a6                	mv	a3,s1
    8000242e:	ec04a783          	lw	a5,-320(s1)
    80002432:	dbed                	beqz	a5,80002424 <procdump+0x66>
      state = "???";
    80002434:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002436:	fcfb6fe3          	bltu	s6,a5,80002414 <procdump+0x56>
    8000243a:	02079713          	slli	a4,a5,0x20
    8000243e:	01d75793          	srli	a5,a4,0x1d
    80002442:	97de                	add	a5,a5,s7
    80002444:	6390                	ld	a2,0(a5)
    80002446:	f679                	bnez	a2,80002414 <procdump+0x56>
      state = "???";
    80002448:	864e                	mv	a2,s3
    8000244a:	b7e9                	j	80002414 <procdump+0x56>
  }
}
    8000244c:	60a6                	ld	ra,72(sp)
    8000244e:	6406                	ld	s0,64(sp)
    80002450:	74e2                	ld	s1,56(sp)
    80002452:	7942                	ld	s2,48(sp)
    80002454:	79a2                	ld	s3,40(sp)
    80002456:	7a02                	ld	s4,32(sp)
    80002458:	6ae2                	ld	s5,24(sp)
    8000245a:	6b42                	ld	s6,16(sp)
    8000245c:	6ba2                	ld	s7,8(sp)
    8000245e:	6161                	addi	sp,sp,80
    80002460:	8082                	ret

0000000080002462 <getprocs>:


///------------------ to get all info from proc struct into a user-supply array--------

int getprocs(struct proc_info *info, int max) {
    80002462:	7139                	addi	sp,sp,-64
    80002464:	fc06                	sd	ra,56(sp)
    80002466:	f822                	sd	s0,48(sp)
    80002468:	f426                	sd	s1,40(sp)
    8000246a:	f04a                	sd	s2,32(sp)
    8000246c:	ec4e                	sd	s3,24(sp)
    8000246e:	e852                	sd	s4,16(sp)
    80002470:	e456                	sd	s5,8(sp)
    80002472:	e05a                	sd	s6,0(sp)
    80002474:	0080                	addi	s0,sp,64
    80002476:	8aaa                	mv	s5,a0
    80002478:	89ae                	mv	s3,a1
  int count = 0;
  for(struct proc *p = proc; p < &proc[NPROC] && count < max; p++) {
    8000247a:	0000e497          	auipc	s1,0xe
    8000247e:	a6648493          	addi	s1,s1,-1434 # 8000fee0 <proc>
  int count = 0;
    80002482:	4901                	li	s2,0
    acquire(&p->lock);
    if (p->state != UNUSED) {
      info[count].pid = p->pid;
      info[count].state = p->state;
      info[count].ticks = p->rtime; 
      safestrcpy(info[count].name, p->name, sizeof(info[count].name));
    80002484:	4b41                	li	s6,16
  for(struct proc *p = proc; p < &proc[NPROC] && count < max; p++) {
    80002486:	00013a17          	auipc	s4,0x13
    8000248a:	65aa0a13          	addi	s4,s4,1626 # 80015ae0 <prime_pids>
    8000248e:	a801                	j	8000249e <getprocs+0x3c>
      count++;
    }
    release(&p->lock);
    80002490:	8526                	mv	a0,s1
    80002492:	ff8fe0ef          	jal	80000c8a <release>
  for(struct proc *p = proc; p < &proc[NPROC] && count < max; p++) {
    80002496:	17048493          	addi	s1,s1,368
    8000249a:	03448e63          	beq	s1,s4,800024d6 <getprocs+0x74>
    8000249e:	03395c63          	bge	s2,s3,800024d6 <getprocs+0x74>
    acquire(&p->lock);
    800024a2:	8526                	mv	a0,s1
    800024a4:	f52fe0ef          	jal	80000bf6 <acquire>
    if (p->state != UNUSED) {
    800024a8:	4c9c                	lw	a5,24(s1)
    800024aa:	d3fd                	beqz	a5,80002490 <getprocs+0x2e>
      info[count].pid = p->pid;
    800024ac:	00391513          	slli	a0,s2,0x3
    800024b0:	41250533          	sub	a0,a0,s2
    800024b4:	050a                	slli	a0,a0,0x2
    800024b6:	9556                	add	a0,a0,s5
    800024b8:	589c                	lw	a5,48(s1)
    800024ba:	c11c                	sw	a5,0(a0)
      info[count].state = p->state;
    800024bc:	4c9c                	lw	a5,24(s1)
    800024be:	c15c                	sw	a5,4(a0)
      info[count].ticks = p->rtime; 
    800024c0:	1684b783          	ld	a5,360(s1)
    800024c4:	c51c                	sw	a5,8(a0)
      safestrcpy(info[count].name, p->name, sizeof(info[count].name));
    800024c6:	865a                	mv	a2,s6
    800024c8:	15848593          	addi	a1,s1,344
    800024cc:	0531                	addi	a0,a0,12
    800024ce:	94bfe0ef          	jal	80000e18 <safestrcpy>
      count++;
    800024d2:	2905                	addiw	s2,s2,1
    800024d4:	bf75                	j	80002490 <getprocs+0x2e>
  }
  return count;
}
    800024d6:	854a                	mv	a0,s2
    800024d8:	70e2                	ld	ra,56(sp)
    800024da:	7442                	ld	s0,48(sp)
    800024dc:	74a2                	ld	s1,40(sp)
    800024de:	7902                	ld	s2,32(sp)
    800024e0:	69e2                	ld	s3,24(sp)
    800024e2:	6a42                	ld	s4,16(sp)
    800024e4:	6aa2                	ld	s5,8(sp)
    800024e6:	6b02                	ld	s6,0(sp)
    800024e8:	6121                	addi	sp,sp,64
    800024ea:	8082                	ret

00000000800024ec <swtch>:
    800024ec:	00153023          	sd	ra,0(a0)
    800024f0:	00253423          	sd	sp,8(a0)
    800024f4:	e900                	sd	s0,16(a0)
    800024f6:	ed04                	sd	s1,24(a0)
    800024f8:	03253023          	sd	s2,32(a0)
    800024fc:	03353423          	sd	s3,40(a0)
    80002500:	03453823          	sd	s4,48(a0)
    80002504:	03553c23          	sd	s5,56(a0)
    80002508:	05653023          	sd	s6,64(a0)
    8000250c:	05753423          	sd	s7,72(a0)
    80002510:	05853823          	sd	s8,80(a0)
    80002514:	05953c23          	sd	s9,88(a0)
    80002518:	07a53023          	sd	s10,96(a0)
    8000251c:	07b53423          	sd	s11,104(a0)
    80002520:	0005b083          	ld	ra,0(a1)
    80002524:	0085b103          	ld	sp,8(a1)
    80002528:	6980                	ld	s0,16(a1)
    8000252a:	6d84                	ld	s1,24(a1)
    8000252c:	0205b903          	ld	s2,32(a1)
    80002530:	0285b983          	ld	s3,40(a1)
    80002534:	0305ba03          	ld	s4,48(a1)
    80002538:	0385ba83          	ld	s5,56(a1)
    8000253c:	0405bb03          	ld	s6,64(a1)
    80002540:	0485bb83          	ld	s7,72(a1)
    80002544:	0505bc03          	ld	s8,80(a1)
    80002548:	0585bc83          	ld	s9,88(a1)
    8000254c:	0605bd03          	ld	s10,96(a1)
    80002550:	0685bd83          	ld	s11,104(a1)
    80002554:	8082                	ret

0000000080002556 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002556:	1141                	addi	sp,sp,-16
    80002558:	e406                	sd	ra,8(sp)
    8000255a:	e022                	sd	s0,0(sp)
    8000255c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000255e:	00005597          	auipc	a1,0x5
    80002562:	dfa58593          	addi	a1,a1,-518 # 80007358 <etext+0x358>
    80002566:	00063517          	auipc	a0,0x63
    8000256a:	58250513          	addi	a0,a0,1410 # 80065ae8 <tickslock>
    8000256e:	e04fe0ef          	jal	80000b72 <initlock>
}
    80002572:	60a2                	ld	ra,8(sp)
    80002574:	6402                	ld	s0,0(sp)
    80002576:	0141                	addi	sp,sp,16
    80002578:	8082                	ret

000000008000257a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000257a:	1141                	addi	sp,sp,-16
    8000257c:	e406                	sd	ra,8(sp)
    8000257e:	e022                	sd	s0,0(sp)
    80002580:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002582:	00003797          	auipc	a5,0x3
    80002586:	eee78793          	addi	a5,a5,-274 # 80005470 <kernelvec>
    8000258a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000258e:	60a2                	ld	ra,8(sp)
    80002590:	6402                	ld	s0,0(sp)
    80002592:	0141                	addi	sp,sp,16
    80002594:	8082                	ret

0000000080002596 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002596:	1141                	addi	sp,sp,-16
    80002598:	e406                	sd	ra,8(sp)
    8000259a:	e022                	sd	s0,0(sp)
    8000259c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000259e:	c2eff0ef          	jal	800019cc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025a6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800025ac:	00004697          	auipc	a3,0x4
    800025b0:	a5468693          	addi	a3,a3,-1452 # 80006000 <_trampoline>
    800025b4:	00004717          	auipc	a4,0x4
    800025b8:	a4c70713          	addi	a4,a4,-1460 # 80006000 <_trampoline>
    800025bc:	8f15                	sub	a4,a4,a3
    800025be:	040007b7          	lui	a5,0x4000
    800025c2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800025c4:	07b2                	slli	a5,a5,0xc
    800025c6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025c8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025cc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025ce:	18002673          	csrr	a2,satp
    800025d2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025d4:	6d30                	ld	a2,88(a0)
    800025d6:	6138                	ld	a4,64(a0)
    800025d8:	6585                	lui	a1,0x1
    800025da:	972e                	add	a4,a4,a1
    800025dc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025de:	6d38                	ld	a4,88(a0)
    800025e0:	00000617          	auipc	a2,0x0
    800025e4:	12c60613          	addi	a2,a2,300 # 8000270c <usertrap>
    800025e8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025ea:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025ec:	8612                	mv	a2,tp
    800025ee:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025f0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025f4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025f8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025fc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002600:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002602:	6f18                	ld	a4,24(a4)
    80002604:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002608:	6928                	ld	a0,80(a0)
    8000260a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000260c:	00004717          	auipc	a4,0x4
    80002610:	a9070713          	addi	a4,a4,-1392 # 8000609c <userret>
    80002614:	8f15                	sub	a4,a4,a3
    80002616:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002618:	577d                	li	a4,-1
    8000261a:	177e                	slli	a4,a4,0x3f
    8000261c:	8d59                	or	a0,a0,a4
    8000261e:	9782                	jalr	a5
}
    80002620:	60a2                	ld	ra,8(sp)
    80002622:	6402                	ld	s0,0(sp)
    80002624:	0141                	addi	sp,sp,16
    80002626:	8082                	ret

0000000080002628 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002628:	1101                	addi	sp,sp,-32
    8000262a:	ec06                	sd	ra,24(sp)
    8000262c:	e822                	sd	s0,16(sp)
    8000262e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002630:	b68ff0ef          	jal	80001998 <cpuid>
    80002634:	c515                	beqz	a0,80002660 <clockintr+0x38>
    release(&tickslock);
  }


  //-------------------------runtime ticks for currently running process----------------------
    struct proc *p =mycpu()->proc;
    80002636:	b76ff0ef          	jal	800019ac <mycpu>
    8000263a:	611c                	ld	a5,0(a0)
  if(p != 0 && p->state == RUNNING){
    8000263c:	c789                	beqz	a5,80002646 <clockintr+0x1e>
    8000263e:	4f94                	lw	a3,24(a5)
    80002640:	4711                	li	a4,4
    80002642:	04e68563          	beq	a3,a4,8000268c <clockintr+0x64>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002646:	c01027f3          	rdtime	a5


  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000264a:	000f4737          	lui	a4,0xf4
    8000264e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002652:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002654:	14d79073          	csrw	stimecmp,a5
}
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret
    80002660:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002662:	00063497          	auipc	s1,0x63
    80002666:	48648493          	addi	s1,s1,1158 # 80065ae8 <tickslock>
    8000266a:	8526                	mv	a0,s1
    8000266c:	d8afe0ef          	jal	80000bf6 <acquire>
    ticks++;
    80002670:	00005517          	auipc	a0,0x5
    80002674:	31850513          	addi	a0,a0,792 # 80007988 <ticks>
    80002678:	411c                	lw	a5,0(a0)
    8000267a:	2785                	addiw	a5,a5,1
    8000267c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000267e:	9a3ff0ef          	jal	80002020 <wakeup>
    release(&tickslock);
    80002682:	8526                	mv	a0,s1
    80002684:	e06fe0ef          	jal	80000c8a <release>
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	b775                	j	80002636 <clockintr+0xe>
    p->rtime++;  // Increment run time tick count
    8000268c:	1687b703          	ld	a4,360(a5)
    80002690:	0705                	addi	a4,a4,1
    80002692:	16e7b423          	sd	a4,360(a5)
    80002696:	bf45                	j	80002646 <clockintr+0x1e>

0000000080002698 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002698:	1101                	addi	sp,sp,-32
    8000269a:	ec06                	sd	ra,24(sp)
    8000269c:	e822                	sd	s0,16(sp)
    8000269e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026a0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800026a4:	57fd                	li	a5,-1
    800026a6:	17fe                	slli	a5,a5,0x3f
    800026a8:	07a5                	addi	a5,a5,9
    800026aa:	00f70c63          	beq	a4,a5,800026c2 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800026ae:	57fd                	li	a5,-1
    800026b0:	17fe                	slli	a5,a5,0x3f
    800026b2:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800026b4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800026b6:	04f70763          	beq	a4,a5,80002704 <devintr+0x6c>
  }
}
    800026ba:	60e2                	ld	ra,24(sp)
    800026bc:	6442                	ld	s0,16(sp)
    800026be:	6105                	addi	sp,sp,32
    800026c0:	8082                	ret
    800026c2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800026c4:	659020ef          	jal	8000551c <plic_claim>
    800026c8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026ca:	47a9                	li	a5,10
    800026cc:	00f50963          	beq	a0,a5,800026de <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800026d0:	4785                	li	a5,1
    800026d2:	00f50963          	beq	a0,a5,800026e4 <devintr+0x4c>
    return 1;
    800026d6:	4505                	li	a0,1
    } else if(irq){
    800026d8:	e889                	bnez	s1,800026ea <devintr+0x52>
    800026da:	64a2                	ld	s1,8(sp)
    800026dc:	bff9                	j	800026ba <devintr+0x22>
      uartintr();
    800026de:	b1efe0ef          	jal	800009fc <uartintr>
    if(irq)
    800026e2:	a819                	j	800026f8 <devintr+0x60>
      virtio_disk_intr();
    800026e4:	2c8030ef          	jal	800059ac <virtio_disk_intr>
    if(irq)
    800026e8:	a801                	j	800026f8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800026ea:	85a6                	mv	a1,s1
    800026ec:	00005517          	auipc	a0,0x5
    800026f0:	c7450513          	addi	a0,a0,-908 # 80007360 <etext+0x360>
    800026f4:	ddbfd0ef          	jal	800004ce <printf>
      plic_complete(irq);
    800026f8:	8526                	mv	a0,s1
    800026fa:	643020ef          	jal	8000553c <plic_complete>
    return 1;
    800026fe:	4505                	li	a0,1
    80002700:	64a2                	ld	s1,8(sp)
    80002702:	bf65                	j	800026ba <devintr+0x22>
    clockintr();
    80002704:	f25ff0ef          	jal	80002628 <clockintr>
    return 2;
    80002708:	4509                	li	a0,2
    8000270a:	bf45                	j	800026ba <devintr+0x22>

000000008000270c <usertrap>:
{
    8000270c:	1101                	addi	sp,sp,-32
    8000270e:	ec06                	sd	ra,24(sp)
    80002710:	e822                	sd	s0,16(sp)
    80002712:	e426                	sd	s1,8(sp)
    80002714:	e04a                	sd	s2,0(sp)
    80002716:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002718:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000271c:	1007f793          	andi	a5,a5,256
    80002720:	ef85                	bnez	a5,80002758 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002722:	00003797          	auipc	a5,0x3
    80002726:	d4e78793          	addi	a5,a5,-690 # 80005470 <kernelvec>
    8000272a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000272e:	a9eff0ef          	jal	800019cc <myproc>
    80002732:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002734:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002736:	14102773          	csrr	a4,sepc
    8000273a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000273c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002740:	47a1                	li	a5,8
    80002742:	02f70163          	beq	a4,a5,80002764 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002746:	f53ff0ef          	jal	80002698 <devintr>
    8000274a:	892a                	mv	s2,a0
    8000274c:	c135                	beqz	a0,800027b0 <usertrap+0xa4>
  if(killed(p))
    8000274e:	8526                	mv	a0,s1
    80002750:	abdff0ef          	jal	8000220c <killed>
    80002754:	cd1d                	beqz	a0,80002792 <usertrap+0x86>
    80002756:	a81d                	j	8000278c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002758:	00005517          	auipc	a0,0x5
    8000275c:	c2850513          	addi	a0,a0,-984 # 80007380 <etext+0x380>
    80002760:	83efe0ef          	jal	8000079e <panic>
    if(killed(p))
    80002764:	aa9ff0ef          	jal	8000220c <killed>
    80002768:	e121                	bnez	a0,800027a8 <usertrap+0x9c>
    p->trapframe->epc += 4;
    8000276a:	6cb8                	ld	a4,88(s1)
    8000276c:	6f1c                	ld	a5,24(a4)
    8000276e:	0791                	addi	a5,a5,4
    80002770:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002772:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002776:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000277a:	10079073          	csrw	sstatus,a5
    syscall();
    8000277e:	240000ef          	jal	800029be <syscall>
  if(killed(p))
    80002782:	8526                	mv	a0,s1
    80002784:	a89ff0ef          	jal	8000220c <killed>
    80002788:	c901                	beqz	a0,80002798 <usertrap+0x8c>
    8000278a:	4901                	li	s2,0
    exit(-1);
    8000278c:	557d                	li	a0,-1
    8000278e:	953ff0ef          	jal	800020e0 <exit>
  if(which_dev == 2)
    80002792:	4789                	li	a5,2
    80002794:	04f90563          	beq	s2,a5,800027de <usertrap+0xd2>
  usertrapret();
    80002798:	dffff0ef          	jal	80002596 <usertrapret>
}
    8000279c:	60e2                	ld	ra,24(sp)
    8000279e:	6442                	ld	s0,16(sp)
    800027a0:	64a2                	ld	s1,8(sp)
    800027a2:	6902                	ld	s2,0(sp)
    800027a4:	6105                	addi	sp,sp,32
    800027a6:	8082                	ret
      exit(-1);
    800027a8:	557d                	li	a0,-1
    800027aa:	937ff0ef          	jal	800020e0 <exit>
    800027ae:	bf75                	j	8000276a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800027b4:	5890                	lw	a2,48(s1)
    800027b6:	00005517          	auipc	a0,0x5
    800027ba:	bea50513          	addi	a0,a0,-1046 # 800073a0 <etext+0x3a0>
    800027be:	d11fd0ef          	jal	800004ce <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027c2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027c6:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027ca:	00005517          	auipc	a0,0x5
    800027ce:	c0650513          	addi	a0,a0,-1018 # 800073d0 <etext+0x3d0>
    800027d2:	cfdfd0ef          	jal	800004ce <printf>
    setkilled(p);
    800027d6:	8526                	mv	a0,s1
    800027d8:	a11ff0ef          	jal	800021e8 <setkilled>
    800027dc:	b75d                	j	80002782 <usertrap+0x76>
    yield();
    800027de:	fcaff0ef          	jal	80001fa8 <yield>
    800027e2:	bf5d                	j	80002798 <usertrap+0x8c>

00000000800027e4 <kerneltrap>:
{
    800027e4:	7179                	addi	sp,sp,-48
    800027e6:	f406                	sd	ra,40(sp)
    800027e8:	f022                	sd	s0,32(sp)
    800027ea:	ec26                	sd	s1,24(sp)
    800027ec:	e84a                	sd	s2,16(sp)
    800027ee:	e44e                	sd	s3,8(sp)
    800027f0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027f2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027f6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027fa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800027fe:	1004f793          	andi	a5,s1,256
    80002802:	c795                	beqz	a5,8000282e <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002804:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002808:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000280a:	eb85                	bnez	a5,8000283a <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000280c:	e8dff0ef          	jal	80002698 <devintr>
    80002810:	c91d                	beqz	a0,80002846 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002812:	4789                	li	a5,2
    80002814:	04f50a63          	beq	a0,a5,80002868 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002818:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000281c:	10049073          	csrw	sstatus,s1
}
    80002820:	70a2                	ld	ra,40(sp)
    80002822:	7402                	ld	s0,32(sp)
    80002824:	64e2                	ld	s1,24(sp)
    80002826:	6942                	ld	s2,16(sp)
    80002828:	69a2                	ld	s3,8(sp)
    8000282a:	6145                	addi	sp,sp,48
    8000282c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000282e:	00005517          	auipc	a0,0x5
    80002832:	bca50513          	addi	a0,a0,-1078 # 800073f8 <etext+0x3f8>
    80002836:	f69fd0ef          	jal	8000079e <panic>
    panic("kerneltrap: interrupts enabled");
    8000283a:	00005517          	auipc	a0,0x5
    8000283e:	be650513          	addi	a0,a0,-1050 # 80007420 <etext+0x420>
    80002842:	f5dfd0ef          	jal	8000079e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002846:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000284a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000284e:	85ce                	mv	a1,s3
    80002850:	00005517          	auipc	a0,0x5
    80002854:	bf050513          	addi	a0,a0,-1040 # 80007440 <etext+0x440>
    80002858:	c77fd0ef          	jal	800004ce <printf>
    panic("kerneltrap");
    8000285c:	00005517          	auipc	a0,0x5
    80002860:	c0c50513          	addi	a0,a0,-1012 # 80007468 <etext+0x468>
    80002864:	f3bfd0ef          	jal	8000079e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002868:	964ff0ef          	jal	800019cc <myproc>
    8000286c:	d555                	beqz	a0,80002818 <kerneltrap+0x34>
    yield();
    8000286e:	f3aff0ef          	jal	80001fa8 <yield>
    80002872:	b75d                	j	80002818 <kerneltrap+0x34>

0000000080002874 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002874:	1101                	addi	sp,sp,-32
    80002876:	ec06                	sd	ra,24(sp)
    80002878:	e822                	sd	s0,16(sp)
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	1000                	addi	s0,sp,32
    8000287e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002880:	94cff0ef          	jal	800019cc <myproc>
  switch (n) {
    80002884:	4795                	li	a5,5
    80002886:	0497e163          	bltu	a5,s1,800028c8 <argraw+0x54>
    8000288a:	048a                	slli	s1,s1,0x2
    8000288c:	00005717          	auipc	a4,0x5
    80002890:	f9c70713          	addi	a4,a4,-100 # 80007828 <states.0+0x30>
    80002894:	94ba                	add	s1,s1,a4
    80002896:	409c                	lw	a5,0(s1)
    80002898:	97ba                	add	a5,a5,a4
    8000289a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000289c:	6d3c                	ld	a5,88(a0)
    8000289e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800028a0:	60e2                	ld	ra,24(sp)
    800028a2:	6442                	ld	s0,16(sp)
    800028a4:	64a2                	ld	s1,8(sp)
    800028a6:	6105                	addi	sp,sp,32
    800028a8:	8082                	ret
    return p->trapframe->a1;
    800028aa:	6d3c                	ld	a5,88(a0)
    800028ac:	7fa8                	ld	a0,120(a5)
    800028ae:	bfcd                	j	800028a0 <argraw+0x2c>
    return p->trapframe->a2;
    800028b0:	6d3c                	ld	a5,88(a0)
    800028b2:	63c8                	ld	a0,128(a5)
    800028b4:	b7f5                	j	800028a0 <argraw+0x2c>
    return p->trapframe->a3;
    800028b6:	6d3c                	ld	a5,88(a0)
    800028b8:	67c8                	ld	a0,136(a5)
    800028ba:	b7dd                	j	800028a0 <argraw+0x2c>
    return p->trapframe->a4;
    800028bc:	6d3c                	ld	a5,88(a0)
    800028be:	6bc8                	ld	a0,144(a5)
    800028c0:	b7c5                	j	800028a0 <argraw+0x2c>
    return p->trapframe->a5;
    800028c2:	6d3c                	ld	a5,88(a0)
    800028c4:	6fc8                	ld	a0,152(a5)
    800028c6:	bfe9                	j	800028a0 <argraw+0x2c>
  panic("argraw");
    800028c8:	00005517          	auipc	a0,0x5
    800028cc:	bb050513          	addi	a0,a0,-1104 # 80007478 <etext+0x478>
    800028d0:	ecffd0ef          	jal	8000079e <panic>

00000000800028d4 <fetchaddr>:
{
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	e426                	sd	s1,8(sp)
    800028dc:	e04a                	sd	s2,0(sp)
    800028de:	1000                	addi	s0,sp,32
    800028e0:	84aa                	mv	s1,a0
    800028e2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028e4:	8e8ff0ef          	jal	800019cc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028e8:	653c                	ld	a5,72(a0)
    800028ea:	02f4f663          	bgeu	s1,a5,80002916 <fetchaddr+0x42>
    800028ee:	00848713          	addi	a4,s1,8
    800028f2:	02e7e463          	bltu	a5,a4,8000291a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028f6:	46a1                	li	a3,8
    800028f8:	8626                	mv	a2,s1
    800028fa:	85ca                	mv	a1,s2
    800028fc:	6928                	ld	a0,80(a0)
    800028fe:	d3ffe0ef          	jal	8000163c <copyin>
    80002902:	00a03533          	snez	a0,a0
    80002906:	40a0053b          	negw	a0,a0
}
    8000290a:	60e2                	ld	ra,24(sp)
    8000290c:	6442                	ld	s0,16(sp)
    8000290e:	64a2                	ld	s1,8(sp)
    80002910:	6902                	ld	s2,0(sp)
    80002912:	6105                	addi	sp,sp,32
    80002914:	8082                	ret
    return -1;
    80002916:	557d                	li	a0,-1
    80002918:	bfcd                	j	8000290a <fetchaddr+0x36>
    8000291a:	557d                	li	a0,-1
    8000291c:	b7fd                	j	8000290a <fetchaddr+0x36>

000000008000291e <fetchstr>:
{
    8000291e:	7179                	addi	sp,sp,-48
    80002920:	f406                	sd	ra,40(sp)
    80002922:	f022                	sd	s0,32(sp)
    80002924:	ec26                	sd	s1,24(sp)
    80002926:	e84a                	sd	s2,16(sp)
    80002928:	e44e                	sd	s3,8(sp)
    8000292a:	1800                	addi	s0,sp,48
    8000292c:	892a                	mv	s2,a0
    8000292e:	84ae                	mv	s1,a1
    80002930:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002932:	89aff0ef          	jal	800019cc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002936:	86ce                	mv	a3,s3
    80002938:	864a                	mv	a2,s2
    8000293a:	85a6                	mv	a1,s1
    8000293c:	6928                	ld	a0,80(a0)
    8000293e:	d85fe0ef          	jal	800016c2 <copyinstr>
    80002942:	00054c63          	bltz	a0,8000295a <fetchstr+0x3c>
  return strlen(buf);
    80002946:	8526                	mv	a0,s1
    80002948:	d06fe0ef          	jal	80000e4e <strlen>
}
    8000294c:	70a2                	ld	ra,40(sp)
    8000294e:	7402                	ld	s0,32(sp)
    80002950:	64e2                	ld	s1,24(sp)
    80002952:	6942                	ld	s2,16(sp)
    80002954:	69a2                	ld	s3,8(sp)
    80002956:	6145                	addi	sp,sp,48
    80002958:	8082                	ret
    return -1;
    8000295a:	557d                	li	a0,-1
    8000295c:	bfc5                	j	8000294c <fetchstr+0x2e>

000000008000295e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000295e:	1101                	addi	sp,sp,-32
    80002960:	ec06                	sd	ra,24(sp)
    80002962:	e822                	sd	s0,16(sp)
    80002964:	e426                	sd	s1,8(sp)
    80002966:	1000                	addi	s0,sp,32
    80002968:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000296a:	f0bff0ef          	jal	80002874 <argraw>
    8000296e:	c088                	sw	a0,0(s1)
}
    80002970:	60e2                	ld	ra,24(sp)
    80002972:	6442                	ld	s0,16(sp)
    80002974:	64a2                	ld	s1,8(sp)
    80002976:	6105                	addi	sp,sp,32
    80002978:	8082                	ret

000000008000297a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000297a:	1101                	addi	sp,sp,-32
    8000297c:	ec06                	sd	ra,24(sp)
    8000297e:	e822                	sd	s0,16(sp)
    80002980:	e426                	sd	s1,8(sp)
    80002982:	1000                	addi	s0,sp,32
    80002984:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002986:	eefff0ef          	jal	80002874 <argraw>
    8000298a:	e088                	sd	a0,0(s1)
}
    8000298c:	60e2                	ld	ra,24(sp)
    8000298e:	6442                	ld	s0,16(sp)
    80002990:	64a2                	ld	s1,8(sp)
    80002992:	6105                	addi	sp,sp,32
    80002994:	8082                	ret

0000000080002996 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002996:	1101                	addi	sp,sp,-32
    80002998:	ec06                	sd	ra,24(sp)
    8000299a:	e822                	sd	s0,16(sp)
    8000299c:	e426                	sd	s1,8(sp)
    8000299e:	e04a                	sd	s2,0(sp)
    800029a0:	1000                	addi	s0,sp,32
    800029a2:	84ae                	mv	s1,a1
    800029a4:	8932                	mv	s2,a2
  *ip = argraw(n);
    800029a6:	ecfff0ef          	jal	80002874 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800029aa:	864a                	mv	a2,s2
    800029ac:	85a6                	mv	a1,s1
    800029ae:	f71ff0ef          	jal	8000291e <fetchstr>
}
    800029b2:	60e2                	ld	ra,24(sp)
    800029b4:	6442                	ld	s0,16(sp)
    800029b6:	64a2                	ld	s1,8(sp)
    800029b8:	6902                	ld	s2,0(sp)
    800029ba:	6105                	addi	sp,sp,32
    800029bc:	8082                	ret

00000000800029be <syscall>:

};

void
syscall(void)
{
    800029be:	1101                	addi	sp,sp,-32
    800029c0:	ec06                	sd	ra,24(sp)
    800029c2:	e822                	sd	s0,16(sp)
    800029c4:	e426                	sd	s1,8(sp)
    800029c6:	e04a                	sd	s2,0(sp)
    800029c8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800029ca:	802ff0ef          	jal	800019cc <myproc>
    800029ce:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800029d0:	05853903          	ld	s2,88(a0)
    800029d4:	0a893783          	ld	a5,168(s2)
    800029d8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029dc:	37fd                	addiw	a5,a5,-1
    800029de:	4755                	li	a4,21
    800029e0:	00f76f63          	bltu	a4,a5,800029fe <syscall+0x40>
    800029e4:	00369713          	slli	a4,a3,0x3
    800029e8:	00005797          	auipc	a5,0x5
    800029ec:	e5878793          	addi	a5,a5,-424 # 80007840 <syscalls>
    800029f0:	97ba                	add	a5,a5,a4
    800029f2:	639c                	ld	a5,0(a5)
    800029f4:	c789                	beqz	a5,800029fe <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029f6:	9782                	jalr	a5
    800029f8:	06a93823          	sd	a0,112(s2)
    800029fc:	a829                	j	80002a16 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029fe:	15848613          	addi	a2,s1,344
    80002a02:	588c                	lw	a1,48(s1)
    80002a04:	00005517          	auipc	a0,0x5
    80002a08:	a7c50513          	addi	a0,a0,-1412 # 80007480 <etext+0x480>
    80002a0c:	ac3fd0ef          	jal	800004ce <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a10:	6cbc                	ld	a5,88(s1)
    80002a12:	577d                	li	a4,-1
    80002a14:	fbb8                	sd	a4,112(a5)
  }
}
    80002a16:	60e2                	ld	ra,24(sp)
    80002a18:	6442                	ld	s0,16(sp)
    80002a1a:	64a2                	ld	s1,8(sp)
    80002a1c:	6902                	ld	s2,0(sp)
    80002a1e:	6105                	addi	sp,sp,32
    80002a20:	8082                	ret

0000000080002a22 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002a22:	1101                	addi	sp,sp,-32
    80002a24:	ec06                	sd	ra,24(sp)
    80002a26:	e822                	sd	s0,16(sp)
    80002a28:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a2a:	fec40593          	addi	a1,s0,-20
    80002a2e:	4501                	li	a0,0
    80002a30:	f2fff0ef          	jal	8000295e <argint>
  exit(n);
    80002a34:	fec42503          	lw	a0,-20(s0)
    80002a38:	ea8ff0ef          	jal	800020e0 <exit>
  return 0;  // not reached
}
    80002a3c:	4501                	li	a0,0
    80002a3e:	60e2                	ld	ra,24(sp)
    80002a40:	6442                	ld	s0,16(sp)
    80002a42:	6105                	addi	sp,sp,32
    80002a44:	8082                	ret

0000000080002a46 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a46:	1141                	addi	sp,sp,-16
    80002a48:	e406                	sd	ra,8(sp)
    80002a4a:	e022                	sd	s0,0(sp)
    80002a4c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a4e:	f7ffe0ef          	jal	800019cc <myproc>
}
    80002a52:	5908                	lw	a0,48(a0)
    80002a54:	60a2                	ld	ra,8(sp)
    80002a56:	6402                	ld	s0,0(sp)
    80002a58:	0141                	addi	sp,sp,16
    80002a5a:	8082                	ret

0000000080002a5c <sys_fork>:

uint64
sys_fork(void)
{
    80002a5c:	1141                	addi	sp,sp,-16
    80002a5e:	e406                	sd	ra,8(sp)
    80002a60:	e022                	sd	s0,0(sp)
    80002a62:	0800                	addi	s0,sp,16
  return fork();
    80002a64:	acaff0ef          	jal	80001d2e <fork>
}
    80002a68:	60a2                	ld	ra,8(sp)
    80002a6a:	6402                	ld	s0,0(sp)
    80002a6c:	0141                	addi	sp,sp,16
    80002a6e:	8082                	ret

0000000080002a70 <sys_wait>:

uint64
sys_wait(void)
{
    80002a70:	1101                	addi	sp,sp,-32
    80002a72:	ec06                	sd	ra,24(sp)
    80002a74:	e822                	sd	s0,16(sp)
    80002a76:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a78:	fe840593          	addi	a1,s0,-24
    80002a7c:	4501                	li	a0,0
    80002a7e:	efdff0ef          	jal	8000297a <argaddr>
  return wait(p);
    80002a82:	fe843503          	ld	a0,-24(s0)
    80002a86:	fb0ff0ef          	jal	80002236 <wait>
}
    80002a8a:	60e2                	ld	ra,24(sp)
    80002a8c:	6442                	ld	s0,16(sp)
    80002a8e:	6105                	addi	sp,sp,32
    80002a90:	8082                	ret

0000000080002a92 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002a9c:	fdc40593          	addi	a1,s0,-36
    80002aa0:	4501                	li	a0,0
    80002aa2:	ebdff0ef          	jal	8000295e <argint>
  addr = myproc()->sz;
    80002aa6:	f27fe0ef          	jal	800019cc <myproc>
    80002aaa:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002aac:	fdc42503          	lw	a0,-36(s0)
    80002ab0:	a2eff0ef          	jal	80001cde <growproc>
    80002ab4:	00054863          	bltz	a0,80002ac4 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002ab8:	8526                	mv	a0,s1
    80002aba:	70a2                	ld	ra,40(sp)
    80002abc:	7402                	ld	s0,32(sp)
    80002abe:	64e2                	ld	s1,24(sp)
    80002ac0:	6145                	addi	sp,sp,48
    80002ac2:	8082                	ret
    return -1;
    80002ac4:	54fd                	li	s1,-1
    80002ac6:	bfcd                	j	80002ab8 <sys_sbrk+0x26>

0000000080002ac8 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ac8:	7139                	addi	sp,sp,-64
    80002aca:	fc06                	sd	ra,56(sp)
    80002acc:	f822                	sd	s0,48(sp)
    80002ace:	f04a                	sd	s2,32(sp)
    80002ad0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ad2:	fcc40593          	addi	a1,s0,-52
    80002ad6:	4501                	li	a0,0
    80002ad8:	e87ff0ef          	jal	8000295e <argint>
  if(n < 0)
    80002adc:	fcc42783          	lw	a5,-52(s0)
    80002ae0:	0607c763          	bltz	a5,80002b4e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002ae4:	00063517          	auipc	a0,0x63
    80002ae8:	00450513          	addi	a0,a0,4 # 80065ae8 <tickslock>
    80002aec:	90afe0ef          	jal	80000bf6 <acquire>
  ticks0 = ticks;
    80002af0:	00005917          	auipc	s2,0x5
    80002af4:	e9892903          	lw	s2,-360(s2) # 80007988 <ticks>
  while(ticks - ticks0 < n){
    80002af8:	fcc42783          	lw	a5,-52(s0)
    80002afc:	cf8d                	beqz	a5,80002b36 <sys_sleep+0x6e>
    80002afe:	f426                	sd	s1,40(sp)
    80002b00:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b02:	00063997          	auipc	s3,0x63
    80002b06:	fe698993          	addi	s3,s3,-26 # 80065ae8 <tickslock>
    80002b0a:	00005497          	auipc	s1,0x5
    80002b0e:	e7e48493          	addi	s1,s1,-386 # 80007988 <ticks>
    if(killed(myproc())){
    80002b12:	ebbfe0ef          	jal	800019cc <myproc>
    80002b16:	ef6ff0ef          	jal	8000220c <killed>
    80002b1a:	ed0d                	bnez	a0,80002b54 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002b1c:	85ce                	mv	a1,s3
    80002b1e:	8526                	mv	a0,s1
    80002b20:	cb4ff0ef          	jal	80001fd4 <sleep>
  while(ticks - ticks0 < n){
    80002b24:	409c                	lw	a5,0(s1)
    80002b26:	412787bb          	subw	a5,a5,s2
    80002b2a:	fcc42703          	lw	a4,-52(s0)
    80002b2e:	fee7e2e3          	bltu	a5,a4,80002b12 <sys_sleep+0x4a>
    80002b32:	74a2                	ld	s1,40(sp)
    80002b34:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b36:	00063517          	auipc	a0,0x63
    80002b3a:	fb250513          	addi	a0,a0,-78 # 80065ae8 <tickslock>
    80002b3e:	94cfe0ef          	jal	80000c8a <release>
  return 0;
    80002b42:	4501                	li	a0,0
}
    80002b44:	70e2                	ld	ra,56(sp)
    80002b46:	7442                	ld	s0,48(sp)
    80002b48:	7902                	ld	s2,32(sp)
    80002b4a:	6121                	addi	sp,sp,64
    80002b4c:	8082                	ret
    n = 0;
    80002b4e:	fc042623          	sw	zero,-52(s0)
    80002b52:	bf49                	j	80002ae4 <sys_sleep+0x1c>
      release(&tickslock);
    80002b54:	00063517          	auipc	a0,0x63
    80002b58:	f9450513          	addi	a0,a0,-108 # 80065ae8 <tickslock>
    80002b5c:	92efe0ef          	jal	80000c8a <release>
      return -1;
    80002b60:	557d                	li	a0,-1
    80002b62:	74a2                	ld	s1,40(sp)
    80002b64:	69e2                	ld	s3,24(sp)
    80002b66:	bff9                	j	80002b44 <sys_sleep+0x7c>

0000000080002b68 <sys_kill>:

uint64
sys_kill(void)
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b70:	fec40593          	addi	a1,s0,-20
    80002b74:	4501                	li	a0,0
    80002b76:	de9ff0ef          	jal	8000295e <argint>
  return kill(pid);
    80002b7a:	fec42503          	lw	a0,-20(s0)
    80002b7e:	e04ff0ef          	jal	80002182 <kill>
}
    80002b82:	60e2                	ld	ra,24(sp)
    80002b84:	6442                	ld	s0,16(sp)
    80002b86:	6105                	addi	sp,sp,32
    80002b88:	8082                	ret

0000000080002b8a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b8a:	1101                	addi	sp,sp,-32
    80002b8c:	ec06                	sd	ra,24(sp)
    80002b8e:	e822                	sd	s0,16(sp)
    80002b90:	e426                	sd	s1,8(sp)
    80002b92:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b94:	00063517          	auipc	a0,0x63
    80002b98:	f5450513          	addi	a0,a0,-172 # 80065ae8 <tickslock>
    80002b9c:	85afe0ef          	jal	80000bf6 <acquire>
  xticks = ticks;
    80002ba0:	00005497          	auipc	s1,0x5
    80002ba4:	de84a483          	lw	s1,-536(s1) # 80007988 <ticks>
  release(&tickslock);
    80002ba8:	00063517          	auipc	a0,0x63
    80002bac:	f4050513          	addi	a0,a0,-192 # 80065ae8 <tickslock>
    80002bb0:	8dafe0ef          	jal	80000c8a <release>
  return xticks;
}
    80002bb4:	02049513          	slli	a0,s1,0x20
    80002bb8:	9101                	srli	a0,a0,0x20
    80002bba:	60e2                	ld	ra,24(sp)
    80002bbc:	6442                	ld	s0,16(sp)
    80002bbe:	64a2                	ld	s1,8(sp)
    80002bc0:	6105                	addi	sp,sp,32
    80002bc2:	8082                	ret

0000000080002bc4 <sys_getprocs>:


//----------syscall handler-------
uint64 sys_getprocs(void)
{
    80002bc4:	8c010113          	addi	sp,sp,-1856
    80002bc8:	72113c23          	sd	ra,1848(sp)
    80002bcc:	72813823          	sd	s0,1840(sp)
    80002bd0:	72913423          	sd	s1,1832(sp)
    80002bd4:	73213023          	sd	s2,1824(sp)
    80002bd8:	71313c23          	sd	s3,1816(sp)
    80002bdc:	74010413          	addi	s0,sp,1856
    uint64 u_info;
    int max;

    argint(1, &max);
    80002be0:	fc440593          	addi	a1,s0,-60
    80002be4:	4505                	li	a0,1
    80002be6:	d79ff0ef          	jal	8000295e <argint>
    argaddr(0, &u_info);
    80002bea:	fc840593          	addi	a1,s0,-56
    80002bee:	4501                	li	a0,0
    80002bf0:	d8bff0ef          	jal	8000297a <argaddr>

    if (max > NPROC) max = NPROC;
    80002bf4:	fc442703          	lw	a4,-60(s0)
    80002bf8:	04000793          	li	a5,64
    80002bfc:	00e7d463          	bge	a5,a4,80002c04 <sys_getprocs+0x40>
    80002c00:	fcf42223          	sw	a5,-60(s0)
    struct proc_info kbuf[NPROC];
    int n = getprocs(kbuf, max);
    80002c04:	8c040913          	addi	s2,s0,-1856
    80002c08:	fc442583          	lw	a1,-60(s0)
    80002c0c:	854a                	mv	a0,s2
    80002c0e:	855ff0ef          	jal	80002462 <getprocs>
    80002c12:	84aa                	mv	s1,a0

    if (copyout(myproc()->pagetable, u_info, (char*)kbuf, n * sizeof(struct proc_info)) < 0)
    80002c14:	db9fe0ef          	jal	800019cc <myproc>
    80002c18:	89a6                	mv	s3,s1
    80002c1a:	00349693          	slli	a3,s1,0x3
    80002c1e:	8e85                	sub	a3,a3,s1
    80002c20:	068a                	slli	a3,a3,0x2
    80002c22:	864a                	mv	a2,s2
    80002c24:	fc843583          	ld	a1,-56(s0)
    80002c28:	6928                	ld	a0,80(a0)
    80002c2a:	963fe0ef          	jal	8000158c <copyout>
    80002c2e:	02054063          	bltz	a0,80002c4e <sys_getprocs+0x8a>
        return -1;
    return n;
}
    80002c32:	854e                	mv	a0,s3
    80002c34:	73813083          	ld	ra,1848(sp)
    80002c38:	73013403          	ld	s0,1840(sp)
    80002c3c:	72813483          	ld	s1,1832(sp)
    80002c40:	72013903          	ld	s2,1824(sp)
    80002c44:	71813983          	ld	s3,1816(sp)
    80002c48:	74010113          	addi	sp,sp,1856
    80002c4c:	8082                	ret
        return -1;
    80002c4e:	59fd                	li	s3,-1
    80002c50:	b7cd                	j	80002c32 <sys_getprocs+0x6e>

0000000080002c52 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c52:	7179                	addi	sp,sp,-48
    80002c54:	f406                	sd	ra,40(sp)
    80002c56:	f022                	sd	s0,32(sp)
    80002c58:	ec26                	sd	s1,24(sp)
    80002c5a:	e84a                	sd	s2,16(sp)
    80002c5c:	e44e                	sd	s3,8(sp)
    80002c5e:	e052                	sd	s4,0(sp)
    80002c60:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c62:	00005597          	auipc	a1,0x5
    80002c66:	83e58593          	addi	a1,a1,-1986 # 800074a0 <etext+0x4a0>
    80002c6a:	00063517          	auipc	a0,0x63
    80002c6e:	e9650513          	addi	a0,a0,-362 # 80065b00 <bcache>
    80002c72:	f01fd0ef          	jal	80000b72 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c76:	0006b797          	auipc	a5,0x6b
    80002c7a:	e8a78793          	addi	a5,a5,-374 # 8006db00 <bcache+0x8000>
    80002c7e:	0006b717          	auipc	a4,0x6b
    80002c82:	0ea70713          	addi	a4,a4,234 # 8006dd68 <bcache+0x8268>
    80002c86:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c8a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c8e:	00063497          	auipc	s1,0x63
    80002c92:	e8a48493          	addi	s1,s1,-374 # 80065b18 <bcache+0x18>
    b->next = bcache.head.next;
    80002c96:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c98:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c9a:	00005a17          	auipc	s4,0x5
    80002c9e:	80ea0a13          	addi	s4,s4,-2034 # 800074a8 <etext+0x4a8>
    b->next = bcache.head.next;
    80002ca2:	2b893783          	ld	a5,696(s2)
    80002ca6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ca8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002cac:	85d2                	mv	a1,s4
    80002cae:	01048513          	addi	a0,s1,16
    80002cb2:	244010ef          	jal	80003ef6 <initsleeplock>
    bcache.head.next->prev = b;
    80002cb6:	2b893783          	ld	a5,696(s2)
    80002cba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002cbc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cc0:	45848493          	addi	s1,s1,1112
    80002cc4:	fd349fe3          	bne	s1,s3,80002ca2 <binit+0x50>
  }
}
    80002cc8:	70a2                	ld	ra,40(sp)
    80002cca:	7402                	ld	s0,32(sp)
    80002ccc:	64e2                	ld	s1,24(sp)
    80002cce:	6942                	ld	s2,16(sp)
    80002cd0:	69a2                	ld	s3,8(sp)
    80002cd2:	6a02                	ld	s4,0(sp)
    80002cd4:	6145                	addi	sp,sp,48
    80002cd6:	8082                	ret

0000000080002cd8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002cd8:	7179                	addi	sp,sp,-48
    80002cda:	f406                	sd	ra,40(sp)
    80002cdc:	f022                	sd	s0,32(sp)
    80002cde:	ec26                	sd	s1,24(sp)
    80002ce0:	e84a                	sd	s2,16(sp)
    80002ce2:	e44e                	sd	s3,8(sp)
    80002ce4:	1800                	addi	s0,sp,48
    80002ce6:	892a                	mv	s2,a0
    80002ce8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002cea:	00063517          	auipc	a0,0x63
    80002cee:	e1650513          	addi	a0,a0,-490 # 80065b00 <bcache>
    80002cf2:	f05fd0ef          	jal	80000bf6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002cf6:	0006b497          	auipc	s1,0x6b
    80002cfa:	0c24b483          	ld	s1,194(s1) # 8006ddb8 <bcache+0x82b8>
    80002cfe:	0006b797          	auipc	a5,0x6b
    80002d02:	06a78793          	addi	a5,a5,106 # 8006dd68 <bcache+0x8268>
    80002d06:	02f48b63          	beq	s1,a5,80002d3c <bread+0x64>
    80002d0a:	873e                	mv	a4,a5
    80002d0c:	a021                	j	80002d14 <bread+0x3c>
    80002d0e:	68a4                	ld	s1,80(s1)
    80002d10:	02e48663          	beq	s1,a4,80002d3c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002d14:	449c                	lw	a5,8(s1)
    80002d16:	ff279ce3          	bne	a5,s2,80002d0e <bread+0x36>
    80002d1a:	44dc                	lw	a5,12(s1)
    80002d1c:	ff3799e3          	bne	a5,s3,80002d0e <bread+0x36>
      b->refcnt++;
    80002d20:	40bc                	lw	a5,64(s1)
    80002d22:	2785                	addiw	a5,a5,1
    80002d24:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d26:	00063517          	auipc	a0,0x63
    80002d2a:	dda50513          	addi	a0,a0,-550 # 80065b00 <bcache>
    80002d2e:	f5dfd0ef          	jal	80000c8a <release>
      acquiresleep(&b->lock);
    80002d32:	01048513          	addi	a0,s1,16
    80002d36:	1f6010ef          	jal	80003f2c <acquiresleep>
      return b;
    80002d3a:	a889                	j	80002d8c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d3c:	0006b497          	auipc	s1,0x6b
    80002d40:	0744b483          	ld	s1,116(s1) # 8006ddb0 <bcache+0x82b0>
    80002d44:	0006b797          	auipc	a5,0x6b
    80002d48:	02478793          	addi	a5,a5,36 # 8006dd68 <bcache+0x8268>
    80002d4c:	00f48863          	beq	s1,a5,80002d5c <bread+0x84>
    80002d50:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d52:	40bc                	lw	a5,64(s1)
    80002d54:	cb91                	beqz	a5,80002d68 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d56:	64a4                	ld	s1,72(s1)
    80002d58:	fee49de3          	bne	s1,a4,80002d52 <bread+0x7a>
  panic("bget: no buffers");
    80002d5c:	00004517          	auipc	a0,0x4
    80002d60:	75450513          	addi	a0,a0,1876 # 800074b0 <etext+0x4b0>
    80002d64:	a3bfd0ef          	jal	8000079e <panic>
      b->dev = dev;
    80002d68:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d6c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d70:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d74:	4785                	li	a5,1
    80002d76:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d78:	00063517          	auipc	a0,0x63
    80002d7c:	d8850513          	addi	a0,a0,-632 # 80065b00 <bcache>
    80002d80:	f0bfd0ef          	jal	80000c8a <release>
      acquiresleep(&b->lock);
    80002d84:	01048513          	addi	a0,s1,16
    80002d88:	1a4010ef          	jal	80003f2c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d8c:	409c                	lw	a5,0(s1)
    80002d8e:	cb89                	beqz	a5,80002da0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d90:	8526                	mv	a0,s1
    80002d92:	70a2                	ld	ra,40(sp)
    80002d94:	7402                	ld	s0,32(sp)
    80002d96:	64e2                	ld	s1,24(sp)
    80002d98:	6942                	ld	s2,16(sp)
    80002d9a:	69a2                	ld	s3,8(sp)
    80002d9c:	6145                	addi	sp,sp,48
    80002d9e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002da0:	4581                	li	a1,0
    80002da2:	8526                	mv	a0,s1
    80002da4:	1fd020ef          	jal	800057a0 <virtio_disk_rw>
    b->valid = 1;
    80002da8:	4785                	li	a5,1
    80002daa:	c09c                	sw	a5,0(s1)
  return b;
    80002dac:	b7d5                	j	80002d90 <bread+0xb8>

0000000080002dae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002dae:	1101                	addi	sp,sp,-32
    80002db0:	ec06                	sd	ra,24(sp)
    80002db2:	e822                	sd	s0,16(sp)
    80002db4:	e426                	sd	s1,8(sp)
    80002db6:	1000                	addi	s0,sp,32
    80002db8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002dba:	0541                	addi	a0,a0,16
    80002dbc:	1ee010ef          	jal	80003faa <holdingsleep>
    80002dc0:	c911                	beqz	a0,80002dd4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002dc2:	4585                	li	a1,1
    80002dc4:	8526                	mv	a0,s1
    80002dc6:	1db020ef          	jal	800057a0 <virtio_disk_rw>
}
    80002dca:	60e2                	ld	ra,24(sp)
    80002dcc:	6442                	ld	s0,16(sp)
    80002dce:	64a2                	ld	s1,8(sp)
    80002dd0:	6105                	addi	sp,sp,32
    80002dd2:	8082                	ret
    panic("bwrite");
    80002dd4:	00004517          	auipc	a0,0x4
    80002dd8:	6f450513          	addi	a0,a0,1780 # 800074c8 <etext+0x4c8>
    80002ddc:	9c3fd0ef          	jal	8000079e <panic>

0000000080002de0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002de0:	1101                	addi	sp,sp,-32
    80002de2:	ec06                	sd	ra,24(sp)
    80002de4:	e822                	sd	s0,16(sp)
    80002de6:	e426                	sd	s1,8(sp)
    80002de8:	e04a                	sd	s2,0(sp)
    80002dea:	1000                	addi	s0,sp,32
    80002dec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002dee:	01050913          	addi	s2,a0,16
    80002df2:	854a                	mv	a0,s2
    80002df4:	1b6010ef          	jal	80003faa <holdingsleep>
    80002df8:	c125                	beqz	a0,80002e58 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	176010ef          	jal	80003f72 <releasesleep>

  acquire(&bcache.lock);
    80002e00:	00063517          	auipc	a0,0x63
    80002e04:	d0050513          	addi	a0,a0,-768 # 80065b00 <bcache>
    80002e08:	deffd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002e0c:	40bc                	lw	a5,64(s1)
    80002e0e:	37fd                	addiw	a5,a5,-1
    80002e10:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e12:	e79d                	bnez	a5,80002e40 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e14:	68b8                	ld	a4,80(s1)
    80002e16:	64bc                	ld	a5,72(s1)
    80002e18:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e1a:	68b8                	ld	a4,80(s1)
    80002e1c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e1e:	0006b797          	auipc	a5,0x6b
    80002e22:	ce278793          	addi	a5,a5,-798 # 8006db00 <bcache+0x8000>
    80002e26:	2b87b703          	ld	a4,696(a5)
    80002e2a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e2c:	0006b717          	auipc	a4,0x6b
    80002e30:	f3c70713          	addi	a4,a4,-196 # 8006dd68 <bcache+0x8268>
    80002e34:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e36:	2b87b703          	ld	a4,696(a5)
    80002e3a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e3c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002e40:	00063517          	auipc	a0,0x63
    80002e44:	cc050513          	addi	a0,a0,-832 # 80065b00 <bcache>
    80002e48:	e43fd0ef          	jal	80000c8a <release>
}
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	64a2                	ld	s1,8(sp)
    80002e52:	6902                	ld	s2,0(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret
    panic("brelse");
    80002e58:	00004517          	auipc	a0,0x4
    80002e5c:	67850513          	addi	a0,a0,1656 # 800074d0 <etext+0x4d0>
    80002e60:	93ffd0ef          	jal	8000079e <panic>

0000000080002e64 <bpin>:

void
bpin(struct buf *b) {
    80002e64:	1101                	addi	sp,sp,-32
    80002e66:	ec06                	sd	ra,24(sp)
    80002e68:	e822                	sd	s0,16(sp)
    80002e6a:	e426                	sd	s1,8(sp)
    80002e6c:	1000                	addi	s0,sp,32
    80002e6e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e70:	00063517          	auipc	a0,0x63
    80002e74:	c9050513          	addi	a0,a0,-880 # 80065b00 <bcache>
    80002e78:	d7ffd0ef          	jal	80000bf6 <acquire>
  b->refcnt++;
    80002e7c:	40bc                	lw	a5,64(s1)
    80002e7e:	2785                	addiw	a5,a5,1
    80002e80:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e82:	00063517          	auipc	a0,0x63
    80002e86:	c7e50513          	addi	a0,a0,-898 # 80065b00 <bcache>
    80002e8a:	e01fd0ef          	jal	80000c8a <release>
}
    80002e8e:	60e2                	ld	ra,24(sp)
    80002e90:	6442                	ld	s0,16(sp)
    80002e92:	64a2                	ld	s1,8(sp)
    80002e94:	6105                	addi	sp,sp,32
    80002e96:	8082                	ret

0000000080002e98 <bunpin>:

void
bunpin(struct buf *b) {
    80002e98:	1101                	addi	sp,sp,-32
    80002e9a:	ec06                	sd	ra,24(sp)
    80002e9c:	e822                	sd	s0,16(sp)
    80002e9e:	e426                	sd	s1,8(sp)
    80002ea0:	1000                	addi	s0,sp,32
    80002ea2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ea4:	00063517          	auipc	a0,0x63
    80002ea8:	c5c50513          	addi	a0,a0,-932 # 80065b00 <bcache>
    80002eac:	d4bfd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002eb0:	40bc                	lw	a5,64(s1)
    80002eb2:	37fd                	addiw	a5,a5,-1
    80002eb4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002eb6:	00063517          	auipc	a0,0x63
    80002eba:	c4a50513          	addi	a0,a0,-950 # 80065b00 <bcache>
    80002ebe:	dcdfd0ef          	jal	80000c8a <release>
}
    80002ec2:	60e2                	ld	ra,24(sp)
    80002ec4:	6442                	ld	s0,16(sp)
    80002ec6:	64a2                	ld	s1,8(sp)
    80002ec8:	6105                	addi	sp,sp,32
    80002eca:	8082                	ret

0000000080002ecc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	e04a                	sd	s2,0(sp)
    80002ed6:	1000                	addi	s0,sp,32
    80002ed8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002eda:	00d5d79b          	srliw	a5,a1,0xd
    80002ede:	0006b597          	auipc	a1,0x6b
    80002ee2:	2fe5a583          	lw	a1,766(a1) # 8006e1dc <sb+0x1c>
    80002ee6:	9dbd                	addw	a1,a1,a5
    80002ee8:	df1ff0ef          	jal	80002cd8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002eec:	0074f713          	andi	a4,s1,7
    80002ef0:	4785                	li	a5,1
    80002ef2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002ef6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002ef8:	90d9                	srli	s1,s1,0x36
    80002efa:	00950733          	add	a4,a0,s1
    80002efe:	05874703          	lbu	a4,88(a4)
    80002f02:	00e7f6b3          	and	a3,a5,a4
    80002f06:	c29d                	beqz	a3,80002f2c <bfree+0x60>
    80002f08:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002f0a:	94aa                	add	s1,s1,a0
    80002f0c:	fff7c793          	not	a5,a5
    80002f10:	8f7d                	and	a4,a4,a5
    80002f12:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f16:	711000ef          	jal	80003e26 <log_write>
  brelse(bp);
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	ec5ff0ef          	jal	80002de0 <brelse>
}
    80002f20:	60e2                	ld	ra,24(sp)
    80002f22:	6442                	ld	s0,16(sp)
    80002f24:	64a2                	ld	s1,8(sp)
    80002f26:	6902                	ld	s2,0(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret
    panic("freeing free block");
    80002f2c:	00004517          	auipc	a0,0x4
    80002f30:	5ac50513          	addi	a0,a0,1452 # 800074d8 <etext+0x4d8>
    80002f34:	86bfd0ef          	jal	8000079e <panic>

0000000080002f38 <balloc>:
{
    80002f38:	715d                	addi	sp,sp,-80
    80002f3a:	e486                	sd	ra,72(sp)
    80002f3c:	e0a2                	sd	s0,64(sp)
    80002f3e:	fc26                	sd	s1,56(sp)
    80002f40:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002f42:	0006b797          	auipc	a5,0x6b
    80002f46:	2827a783          	lw	a5,642(a5) # 8006e1c4 <sb+0x4>
    80002f4a:	0e078863          	beqz	a5,8000303a <balloc+0x102>
    80002f4e:	f84a                	sd	s2,48(sp)
    80002f50:	f44e                	sd	s3,40(sp)
    80002f52:	f052                	sd	s4,32(sp)
    80002f54:	ec56                	sd	s5,24(sp)
    80002f56:	e85a                	sd	s6,16(sp)
    80002f58:	e45e                	sd	s7,8(sp)
    80002f5a:	e062                	sd	s8,0(sp)
    80002f5c:	8baa                	mv	s7,a0
    80002f5e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f60:	0006bb17          	auipc	s6,0x6b
    80002f64:	260b0b13          	addi	s6,s6,608 # 8006e1c0 <sb>
      m = 1 << (bi % 8);
    80002f68:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f6a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f6c:	6c09                	lui	s8,0x2
    80002f6e:	a09d                	j	80002fd4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f70:	97ca                	add	a5,a5,s2
    80002f72:	8e55                	or	a2,a2,a3
    80002f74:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f78:	854a                	mv	a0,s2
    80002f7a:	6ad000ef          	jal	80003e26 <log_write>
        brelse(bp);
    80002f7e:	854a                	mv	a0,s2
    80002f80:	e61ff0ef          	jal	80002de0 <brelse>
  bp = bread(dev, bno);
    80002f84:	85a6                	mv	a1,s1
    80002f86:	855e                	mv	a0,s7
    80002f88:	d51ff0ef          	jal	80002cd8 <bread>
    80002f8c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f8e:	40000613          	li	a2,1024
    80002f92:	4581                	li	a1,0
    80002f94:	05850513          	addi	a0,a0,88
    80002f98:	d2ffd0ef          	jal	80000cc6 <memset>
  log_write(bp);
    80002f9c:	854a                	mv	a0,s2
    80002f9e:	689000ef          	jal	80003e26 <log_write>
  brelse(bp);
    80002fa2:	854a                	mv	a0,s2
    80002fa4:	e3dff0ef          	jal	80002de0 <brelse>
}
    80002fa8:	7942                	ld	s2,48(sp)
    80002faa:	79a2                	ld	s3,40(sp)
    80002fac:	7a02                	ld	s4,32(sp)
    80002fae:	6ae2                	ld	s5,24(sp)
    80002fb0:	6b42                	ld	s6,16(sp)
    80002fb2:	6ba2                	ld	s7,8(sp)
    80002fb4:	6c02                	ld	s8,0(sp)
}
    80002fb6:	8526                	mv	a0,s1
    80002fb8:	60a6                	ld	ra,72(sp)
    80002fba:	6406                	ld	s0,64(sp)
    80002fbc:	74e2                	ld	s1,56(sp)
    80002fbe:	6161                	addi	sp,sp,80
    80002fc0:	8082                	ret
    brelse(bp);
    80002fc2:	854a                	mv	a0,s2
    80002fc4:	e1dff0ef          	jal	80002de0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002fc8:	015c0abb          	addw	s5,s8,s5
    80002fcc:	004b2783          	lw	a5,4(s6)
    80002fd0:	04fafe63          	bgeu	s5,a5,8000302c <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80002fd4:	41fad79b          	sraiw	a5,s5,0x1f
    80002fd8:	0137d79b          	srliw	a5,a5,0x13
    80002fdc:	015787bb          	addw	a5,a5,s5
    80002fe0:	40d7d79b          	sraiw	a5,a5,0xd
    80002fe4:	01cb2583          	lw	a1,28(s6)
    80002fe8:	9dbd                	addw	a1,a1,a5
    80002fea:	855e                	mv	a0,s7
    80002fec:	cedff0ef          	jal	80002cd8 <bread>
    80002ff0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ff2:	004b2503          	lw	a0,4(s6)
    80002ff6:	84d6                	mv	s1,s5
    80002ff8:	4701                	li	a4,0
    80002ffa:	fca4f4e3          	bgeu	s1,a0,80002fc2 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002ffe:	00777693          	andi	a3,a4,7
    80003002:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003006:	41f7579b          	sraiw	a5,a4,0x1f
    8000300a:	01d7d79b          	srliw	a5,a5,0x1d
    8000300e:	9fb9                	addw	a5,a5,a4
    80003010:	4037d79b          	sraiw	a5,a5,0x3
    80003014:	00f90633          	add	a2,s2,a5
    80003018:	05864603          	lbu	a2,88(a2)
    8000301c:	00c6f5b3          	and	a1,a3,a2
    80003020:	d9a1                	beqz	a1,80002f70 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003022:	2705                	addiw	a4,a4,1
    80003024:	2485                	addiw	s1,s1,1
    80003026:	fd471ae3          	bne	a4,s4,80002ffa <balloc+0xc2>
    8000302a:	bf61                	j	80002fc2 <balloc+0x8a>
    8000302c:	7942                	ld	s2,48(sp)
    8000302e:	79a2                	ld	s3,40(sp)
    80003030:	7a02                	ld	s4,32(sp)
    80003032:	6ae2                	ld	s5,24(sp)
    80003034:	6b42                	ld	s6,16(sp)
    80003036:	6ba2                	ld	s7,8(sp)
    80003038:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000303a:	00004517          	auipc	a0,0x4
    8000303e:	4b650513          	addi	a0,a0,1206 # 800074f0 <etext+0x4f0>
    80003042:	c8cfd0ef          	jal	800004ce <printf>
  return 0;
    80003046:	4481                	li	s1,0
    80003048:	b7bd                	j	80002fb6 <balloc+0x7e>

000000008000304a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000304a:	7179                	addi	sp,sp,-48
    8000304c:	f406                	sd	ra,40(sp)
    8000304e:	f022                	sd	s0,32(sp)
    80003050:	ec26                	sd	s1,24(sp)
    80003052:	e84a                	sd	s2,16(sp)
    80003054:	e44e                	sd	s3,8(sp)
    80003056:	1800                	addi	s0,sp,48
    80003058:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000305a:	47ad                	li	a5,11
    8000305c:	02b7e363          	bltu	a5,a1,80003082 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003060:	02059793          	slli	a5,a1,0x20
    80003064:	01e7d593          	srli	a1,a5,0x1e
    80003068:	00b504b3          	add	s1,a0,a1
    8000306c:	0504a903          	lw	s2,80(s1)
    80003070:	06091363          	bnez	s2,800030d6 <bmap+0x8c>
      addr = balloc(ip->dev);
    80003074:	4108                	lw	a0,0(a0)
    80003076:	ec3ff0ef          	jal	80002f38 <balloc>
    8000307a:	892a                	mv	s2,a0
      if(addr == 0)
    8000307c:	cd29                	beqz	a0,800030d6 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    8000307e:	c8a8                	sw	a0,80(s1)
    80003080:	a899                	j	800030d6 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003082:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003086:	0ff00793          	li	a5,255
    8000308a:	0697e963          	bltu	a5,s1,800030fc <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000308e:	08052903          	lw	s2,128(a0)
    80003092:	00091b63          	bnez	s2,800030a8 <bmap+0x5e>
      addr = balloc(ip->dev);
    80003096:	4108                	lw	a0,0(a0)
    80003098:	ea1ff0ef          	jal	80002f38 <balloc>
    8000309c:	892a                	mv	s2,a0
      if(addr == 0)
    8000309e:	cd05                	beqz	a0,800030d6 <bmap+0x8c>
    800030a0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800030a2:	08a9a023          	sw	a0,128(s3)
    800030a6:	a011                	j	800030aa <bmap+0x60>
    800030a8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800030aa:	85ca                	mv	a1,s2
    800030ac:	0009a503          	lw	a0,0(s3)
    800030b0:	c29ff0ef          	jal	80002cd8 <bread>
    800030b4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800030b6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800030ba:	02049713          	slli	a4,s1,0x20
    800030be:	01e75593          	srli	a1,a4,0x1e
    800030c2:	00b784b3          	add	s1,a5,a1
    800030c6:	0004a903          	lw	s2,0(s1)
    800030ca:	00090e63          	beqz	s2,800030e6 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800030ce:	8552                	mv	a0,s4
    800030d0:	d11ff0ef          	jal	80002de0 <brelse>
    return addr;
    800030d4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800030d6:	854a                	mv	a0,s2
    800030d8:	70a2                	ld	ra,40(sp)
    800030da:	7402                	ld	s0,32(sp)
    800030dc:	64e2                	ld	s1,24(sp)
    800030de:	6942                	ld	s2,16(sp)
    800030e0:	69a2                	ld	s3,8(sp)
    800030e2:	6145                	addi	sp,sp,48
    800030e4:	8082                	ret
      addr = balloc(ip->dev);
    800030e6:	0009a503          	lw	a0,0(s3)
    800030ea:	e4fff0ef          	jal	80002f38 <balloc>
    800030ee:	892a                	mv	s2,a0
      if(addr){
    800030f0:	dd79                	beqz	a0,800030ce <bmap+0x84>
        a[bn] = addr;
    800030f2:	c088                	sw	a0,0(s1)
        log_write(bp);
    800030f4:	8552                	mv	a0,s4
    800030f6:	531000ef          	jal	80003e26 <log_write>
    800030fa:	bfd1                	j	800030ce <bmap+0x84>
    800030fc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800030fe:	00004517          	auipc	a0,0x4
    80003102:	40a50513          	addi	a0,a0,1034 # 80007508 <etext+0x508>
    80003106:	e98fd0ef          	jal	8000079e <panic>

000000008000310a <iget>:
{
    8000310a:	7179                	addi	sp,sp,-48
    8000310c:	f406                	sd	ra,40(sp)
    8000310e:	f022                	sd	s0,32(sp)
    80003110:	ec26                	sd	s1,24(sp)
    80003112:	e84a                	sd	s2,16(sp)
    80003114:	e44e                	sd	s3,8(sp)
    80003116:	e052                	sd	s4,0(sp)
    80003118:	1800                	addi	s0,sp,48
    8000311a:	89aa                	mv	s3,a0
    8000311c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000311e:	0006b517          	auipc	a0,0x6b
    80003122:	0c250513          	addi	a0,a0,194 # 8006e1e0 <itable>
    80003126:	ad1fd0ef          	jal	80000bf6 <acquire>
  empty = 0;
    8000312a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000312c:	0006b497          	auipc	s1,0x6b
    80003130:	0cc48493          	addi	s1,s1,204 # 8006e1f8 <itable+0x18>
    80003134:	0006d697          	auipc	a3,0x6d
    80003138:	b5468693          	addi	a3,a3,-1196 # 8006fc88 <log>
    8000313c:	a039                	j	8000314a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000313e:	02090963          	beqz	s2,80003170 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003142:	08848493          	addi	s1,s1,136
    80003146:	02d48863          	beq	s1,a3,80003176 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000314a:	449c                	lw	a5,8(s1)
    8000314c:	fef059e3          	blez	a5,8000313e <iget+0x34>
    80003150:	4098                	lw	a4,0(s1)
    80003152:	ff3716e3          	bne	a4,s3,8000313e <iget+0x34>
    80003156:	40d8                	lw	a4,4(s1)
    80003158:	ff4713e3          	bne	a4,s4,8000313e <iget+0x34>
      ip->ref++;
    8000315c:	2785                	addiw	a5,a5,1
    8000315e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003160:	0006b517          	auipc	a0,0x6b
    80003164:	08050513          	addi	a0,a0,128 # 8006e1e0 <itable>
    80003168:	b23fd0ef          	jal	80000c8a <release>
      return ip;
    8000316c:	8926                	mv	s2,s1
    8000316e:	a02d                	j	80003198 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003170:	fbe9                	bnez	a5,80003142 <iget+0x38>
      empty = ip;
    80003172:	8926                	mv	s2,s1
    80003174:	b7f9                	j	80003142 <iget+0x38>
  if(empty == 0)
    80003176:	02090a63          	beqz	s2,800031aa <iget+0xa0>
  ip->dev = dev;
    8000317a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000317e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003182:	4785                	li	a5,1
    80003184:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003188:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000318c:	0006b517          	auipc	a0,0x6b
    80003190:	05450513          	addi	a0,a0,84 # 8006e1e0 <itable>
    80003194:	af7fd0ef          	jal	80000c8a <release>
}
    80003198:	854a                	mv	a0,s2
    8000319a:	70a2                	ld	ra,40(sp)
    8000319c:	7402                	ld	s0,32(sp)
    8000319e:	64e2                	ld	s1,24(sp)
    800031a0:	6942                	ld	s2,16(sp)
    800031a2:	69a2                	ld	s3,8(sp)
    800031a4:	6a02                	ld	s4,0(sp)
    800031a6:	6145                	addi	sp,sp,48
    800031a8:	8082                	ret
    panic("iget: no inodes");
    800031aa:	00004517          	auipc	a0,0x4
    800031ae:	37650513          	addi	a0,a0,886 # 80007520 <etext+0x520>
    800031b2:	decfd0ef          	jal	8000079e <panic>

00000000800031b6 <fsinit>:
fsinit(int dev) {
    800031b6:	7179                	addi	sp,sp,-48
    800031b8:	f406                	sd	ra,40(sp)
    800031ba:	f022                	sd	s0,32(sp)
    800031bc:	ec26                	sd	s1,24(sp)
    800031be:	e84a                	sd	s2,16(sp)
    800031c0:	e44e                	sd	s3,8(sp)
    800031c2:	1800                	addi	s0,sp,48
    800031c4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800031c6:	4585                	li	a1,1
    800031c8:	b11ff0ef          	jal	80002cd8 <bread>
    800031cc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800031ce:	0006b997          	auipc	s3,0x6b
    800031d2:	ff298993          	addi	s3,s3,-14 # 8006e1c0 <sb>
    800031d6:	02000613          	li	a2,32
    800031da:	05850593          	addi	a1,a0,88
    800031de:	854e                	mv	a0,s3
    800031e0:	b4bfd0ef          	jal	80000d2a <memmove>
  brelse(bp);
    800031e4:	8526                	mv	a0,s1
    800031e6:	bfbff0ef          	jal	80002de0 <brelse>
  if(sb.magic != FSMAGIC)
    800031ea:	0009a703          	lw	a4,0(s3)
    800031ee:	102037b7          	lui	a5,0x10203
    800031f2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031f6:	02f71063          	bne	a4,a5,80003216 <fsinit+0x60>
  initlog(dev, &sb);
    800031fa:	0006b597          	auipc	a1,0x6b
    800031fe:	fc658593          	addi	a1,a1,-58 # 8006e1c0 <sb>
    80003202:	854a                	mv	a0,s2
    80003204:	215000ef          	jal	80003c18 <initlog>
}
    80003208:	70a2                	ld	ra,40(sp)
    8000320a:	7402                	ld	s0,32(sp)
    8000320c:	64e2                	ld	s1,24(sp)
    8000320e:	6942                	ld	s2,16(sp)
    80003210:	69a2                	ld	s3,8(sp)
    80003212:	6145                	addi	sp,sp,48
    80003214:	8082                	ret
    panic("invalid file system");
    80003216:	00004517          	auipc	a0,0x4
    8000321a:	31a50513          	addi	a0,a0,794 # 80007530 <etext+0x530>
    8000321e:	d80fd0ef          	jal	8000079e <panic>

0000000080003222 <iinit>:
{
    80003222:	7179                	addi	sp,sp,-48
    80003224:	f406                	sd	ra,40(sp)
    80003226:	f022                	sd	s0,32(sp)
    80003228:	ec26                	sd	s1,24(sp)
    8000322a:	e84a                	sd	s2,16(sp)
    8000322c:	e44e                	sd	s3,8(sp)
    8000322e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003230:	00004597          	auipc	a1,0x4
    80003234:	31858593          	addi	a1,a1,792 # 80007548 <etext+0x548>
    80003238:	0006b517          	auipc	a0,0x6b
    8000323c:	fa850513          	addi	a0,a0,-88 # 8006e1e0 <itable>
    80003240:	933fd0ef          	jal	80000b72 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003244:	0006b497          	auipc	s1,0x6b
    80003248:	fc448493          	addi	s1,s1,-60 # 8006e208 <itable+0x28>
    8000324c:	0006d997          	auipc	s3,0x6d
    80003250:	a4c98993          	addi	s3,s3,-1460 # 8006fc98 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003254:	00004917          	auipc	s2,0x4
    80003258:	2fc90913          	addi	s2,s2,764 # 80007550 <etext+0x550>
    8000325c:	85ca                	mv	a1,s2
    8000325e:	8526                	mv	a0,s1
    80003260:	497000ef          	jal	80003ef6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003264:	08848493          	addi	s1,s1,136
    80003268:	ff349ae3          	bne	s1,s3,8000325c <iinit+0x3a>
}
    8000326c:	70a2                	ld	ra,40(sp)
    8000326e:	7402                	ld	s0,32(sp)
    80003270:	64e2                	ld	s1,24(sp)
    80003272:	6942                	ld	s2,16(sp)
    80003274:	69a2                	ld	s3,8(sp)
    80003276:	6145                	addi	sp,sp,48
    80003278:	8082                	ret

000000008000327a <ialloc>:
{
    8000327a:	7139                	addi	sp,sp,-64
    8000327c:	fc06                	sd	ra,56(sp)
    8000327e:	f822                	sd	s0,48(sp)
    80003280:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003282:	0006b717          	auipc	a4,0x6b
    80003286:	f4a72703          	lw	a4,-182(a4) # 8006e1cc <sb+0xc>
    8000328a:	4785                	li	a5,1
    8000328c:	06e7f063          	bgeu	a5,a4,800032ec <ialloc+0x72>
    80003290:	f426                	sd	s1,40(sp)
    80003292:	f04a                	sd	s2,32(sp)
    80003294:	ec4e                	sd	s3,24(sp)
    80003296:	e852                	sd	s4,16(sp)
    80003298:	e456                	sd	s5,8(sp)
    8000329a:	e05a                	sd	s6,0(sp)
    8000329c:	8aaa                	mv	s5,a0
    8000329e:	8b2e                	mv	s6,a1
    800032a0:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800032a2:	0006ba17          	auipc	s4,0x6b
    800032a6:	f1ea0a13          	addi	s4,s4,-226 # 8006e1c0 <sb>
    800032aa:	00495593          	srli	a1,s2,0x4
    800032ae:	018a2783          	lw	a5,24(s4)
    800032b2:	9dbd                	addw	a1,a1,a5
    800032b4:	8556                	mv	a0,s5
    800032b6:	a23ff0ef          	jal	80002cd8 <bread>
    800032ba:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800032bc:	05850993          	addi	s3,a0,88
    800032c0:	00f97793          	andi	a5,s2,15
    800032c4:	079a                	slli	a5,a5,0x6
    800032c6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800032c8:	00099783          	lh	a5,0(s3)
    800032cc:	cb9d                	beqz	a5,80003302 <ialloc+0x88>
    brelse(bp);
    800032ce:	b13ff0ef          	jal	80002de0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800032d2:	0905                	addi	s2,s2,1
    800032d4:	00ca2703          	lw	a4,12(s4)
    800032d8:	0009079b          	sext.w	a5,s2
    800032dc:	fce7e7e3          	bltu	a5,a4,800032aa <ialloc+0x30>
    800032e0:	74a2                	ld	s1,40(sp)
    800032e2:	7902                	ld	s2,32(sp)
    800032e4:	69e2                	ld	s3,24(sp)
    800032e6:	6a42                	ld	s4,16(sp)
    800032e8:	6aa2                	ld	s5,8(sp)
    800032ea:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800032ec:	00004517          	auipc	a0,0x4
    800032f0:	26c50513          	addi	a0,a0,620 # 80007558 <etext+0x558>
    800032f4:	9dafd0ef          	jal	800004ce <printf>
  return 0;
    800032f8:	4501                	li	a0,0
}
    800032fa:	70e2                	ld	ra,56(sp)
    800032fc:	7442                	ld	s0,48(sp)
    800032fe:	6121                	addi	sp,sp,64
    80003300:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003302:	04000613          	li	a2,64
    80003306:	4581                	li	a1,0
    80003308:	854e                	mv	a0,s3
    8000330a:	9bdfd0ef          	jal	80000cc6 <memset>
      dip->type = type;
    8000330e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003312:	8526                	mv	a0,s1
    80003314:	313000ef          	jal	80003e26 <log_write>
      brelse(bp);
    80003318:	8526                	mv	a0,s1
    8000331a:	ac7ff0ef          	jal	80002de0 <brelse>
      return iget(dev, inum);
    8000331e:	0009059b          	sext.w	a1,s2
    80003322:	8556                	mv	a0,s5
    80003324:	de7ff0ef          	jal	8000310a <iget>
    80003328:	74a2                	ld	s1,40(sp)
    8000332a:	7902                	ld	s2,32(sp)
    8000332c:	69e2                	ld	s3,24(sp)
    8000332e:	6a42                	ld	s4,16(sp)
    80003330:	6aa2                	ld	s5,8(sp)
    80003332:	6b02                	ld	s6,0(sp)
    80003334:	b7d9                	j	800032fa <ialloc+0x80>

0000000080003336 <iupdate>:
{
    80003336:	1101                	addi	sp,sp,-32
    80003338:	ec06                	sd	ra,24(sp)
    8000333a:	e822                	sd	s0,16(sp)
    8000333c:	e426                	sd	s1,8(sp)
    8000333e:	e04a                	sd	s2,0(sp)
    80003340:	1000                	addi	s0,sp,32
    80003342:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003344:	415c                	lw	a5,4(a0)
    80003346:	0047d79b          	srliw	a5,a5,0x4
    8000334a:	0006b597          	auipc	a1,0x6b
    8000334e:	e8e5a583          	lw	a1,-370(a1) # 8006e1d8 <sb+0x18>
    80003352:	9dbd                	addw	a1,a1,a5
    80003354:	4108                	lw	a0,0(a0)
    80003356:	983ff0ef          	jal	80002cd8 <bread>
    8000335a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000335c:	05850793          	addi	a5,a0,88
    80003360:	40d8                	lw	a4,4(s1)
    80003362:	8b3d                	andi	a4,a4,15
    80003364:	071a                	slli	a4,a4,0x6
    80003366:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003368:	04449703          	lh	a4,68(s1)
    8000336c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003370:	04649703          	lh	a4,70(s1)
    80003374:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003378:	04849703          	lh	a4,72(s1)
    8000337c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003380:	04a49703          	lh	a4,74(s1)
    80003384:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003388:	44f8                	lw	a4,76(s1)
    8000338a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000338c:	03400613          	li	a2,52
    80003390:	05048593          	addi	a1,s1,80
    80003394:	00c78513          	addi	a0,a5,12
    80003398:	993fd0ef          	jal	80000d2a <memmove>
  log_write(bp);
    8000339c:	854a                	mv	a0,s2
    8000339e:	289000ef          	jal	80003e26 <log_write>
  brelse(bp);
    800033a2:	854a                	mv	a0,s2
    800033a4:	a3dff0ef          	jal	80002de0 <brelse>
}
    800033a8:	60e2                	ld	ra,24(sp)
    800033aa:	6442                	ld	s0,16(sp)
    800033ac:	64a2                	ld	s1,8(sp)
    800033ae:	6902                	ld	s2,0(sp)
    800033b0:	6105                	addi	sp,sp,32
    800033b2:	8082                	ret

00000000800033b4 <idup>:
{
    800033b4:	1101                	addi	sp,sp,-32
    800033b6:	ec06                	sd	ra,24(sp)
    800033b8:	e822                	sd	s0,16(sp)
    800033ba:	e426                	sd	s1,8(sp)
    800033bc:	1000                	addi	s0,sp,32
    800033be:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033c0:	0006b517          	auipc	a0,0x6b
    800033c4:	e2050513          	addi	a0,a0,-480 # 8006e1e0 <itable>
    800033c8:	82ffd0ef          	jal	80000bf6 <acquire>
  ip->ref++;
    800033cc:	449c                	lw	a5,8(s1)
    800033ce:	2785                	addiw	a5,a5,1
    800033d0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033d2:	0006b517          	auipc	a0,0x6b
    800033d6:	e0e50513          	addi	a0,a0,-498 # 8006e1e0 <itable>
    800033da:	8b1fd0ef          	jal	80000c8a <release>
}
    800033de:	8526                	mv	a0,s1
    800033e0:	60e2                	ld	ra,24(sp)
    800033e2:	6442                	ld	s0,16(sp)
    800033e4:	64a2                	ld	s1,8(sp)
    800033e6:	6105                	addi	sp,sp,32
    800033e8:	8082                	ret

00000000800033ea <ilock>:
{
    800033ea:	1101                	addi	sp,sp,-32
    800033ec:	ec06                	sd	ra,24(sp)
    800033ee:	e822                	sd	s0,16(sp)
    800033f0:	e426                	sd	s1,8(sp)
    800033f2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800033f4:	cd19                	beqz	a0,80003412 <ilock+0x28>
    800033f6:	84aa                	mv	s1,a0
    800033f8:	451c                	lw	a5,8(a0)
    800033fa:	00f05c63          	blez	a5,80003412 <ilock+0x28>
  acquiresleep(&ip->lock);
    800033fe:	0541                	addi	a0,a0,16
    80003400:	32d000ef          	jal	80003f2c <acquiresleep>
  if(ip->valid == 0){
    80003404:	40bc                	lw	a5,64(s1)
    80003406:	cf89                	beqz	a5,80003420 <ilock+0x36>
}
    80003408:	60e2                	ld	ra,24(sp)
    8000340a:	6442                	ld	s0,16(sp)
    8000340c:	64a2                	ld	s1,8(sp)
    8000340e:	6105                	addi	sp,sp,32
    80003410:	8082                	ret
    80003412:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003414:	00004517          	auipc	a0,0x4
    80003418:	15c50513          	addi	a0,a0,348 # 80007570 <etext+0x570>
    8000341c:	b82fd0ef          	jal	8000079e <panic>
    80003420:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003422:	40dc                	lw	a5,4(s1)
    80003424:	0047d79b          	srliw	a5,a5,0x4
    80003428:	0006b597          	auipc	a1,0x6b
    8000342c:	db05a583          	lw	a1,-592(a1) # 8006e1d8 <sb+0x18>
    80003430:	9dbd                	addw	a1,a1,a5
    80003432:	4088                	lw	a0,0(s1)
    80003434:	8a5ff0ef          	jal	80002cd8 <bread>
    80003438:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000343a:	05850593          	addi	a1,a0,88
    8000343e:	40dc                	lw	a5,4(s1)
    80003440:	8bbd                	andi	a5,a5,15
    80003442:	079a                	slli	a5,a5,0x6
    80003444:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003446:	00059783          	lh	a5,0(a1)
    8000344a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000344e:	00259783          	lh	a5,2(a1)
    80003452:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003456:	00459783          	lh	a5,4(a1)
    8000345a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000345e:	00659783          	lh	a5,6(a1)
    80003462:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003466:	459c                	lw	a5,8(a1)
    80003468:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000346a:	03400613          	li	a2,52
    8000346e:	05b1                	addi	a1,a1,12
    80003470:	05048513          	addi	a0,s1,80
    80003474:	8b7fd0ef          	jal	80000d2a <memmove>
    brelse(bp);
    80003478:	854a                	mv	a0,s2
    8000347a:	967ff0ef          	jal	80002de0 <brelse>
    ip->valid = 1;
    8000347e:	4785                	li	a5,1
    80003480:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003482:	04449783          	lh	a5,68(s1)
    80003486:	c399                	beqz	a5,8000348c <ilock+0xa2>
    80003488:	6902                	ld	s2,0(sp)
    8000348a:	bfbd                	j	80003408 <ilock+0x1e>
      panic("ilock: no type");
    8000348c:	00004517          	auipc	a0,0x4
    80003490:	0ec50513          	addi	a0,a0,236 # 80007578 <etext+0x578>
    80003494:	b0afd0ef          	jal	8000079e <panic>

0000000080003498 <iunlock>:
{
    80003498:	1101                	addi	sp,sp,-32
    8000349a:	ec06                	sd	ra,24(sp)
    8000349c:	e822                	sd	s0,16(sp)
    8000349e:	e426                	sd	s1,8(sp)
    800034a0:	e04a                	sd	s2,0(sp)
    800034a2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034a4:	c505                	beqz	a0,800034cc <iunlock+0x34>
    800034a6:	84aa                	mv	s1,a0
    800034a8:	01050913          	addi	s2,a0,16
    800034ac:	854a                	mv	a0,s2
    800034ae:	2fd000ef          	jal	80003faa <holdingsleep>
    800034b2:	cd09                	beqz	a0,800034cc <iunlock+0x34>
    800034b4:	449c                	lw	a5,8(s1)
    800034b6:	00f05b63          	blez	a5,800034cc <iunlock+0x34>
  releasesleep(&ip->lock);
    800034ba:	854a                	mv	a0,s2
    800034bc:	2b7000ef          	jal	80003f72 <releasesleep>
}
    800034c0:	60e2                	ld	ra,24(sp)
    800034c2:	6442                	ld	s0,16(sp)
    800034c4:	64a2                	ld	s1,8(sp)
    800034c6:	6902                	ld	s2,0(sp)
    800034c8:	6105                	addi	sp,sp,32
    800034ca:	8082                	ret
    panic("iunlock");
    800034cc:	00004517          	auipc	a0,0x4
    800034d0:	0bc50513          	addi	a0,a0,188 # 80007588 <etext+0x588>
    800034d4:	acafd0ef          	jal	8000079e <panic>

00000000800034d8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800034d8:	7179                	addi	sp,sp,-48
    800034da:	f406                	sd	ra,40(sp)
    800034dc:	f022                	sd	s0,32(sp)
    800034de:	ec26                	sd	s1,24(sp)
    800034e0:	e84a                	sd	s2,16(sp)
    800034e2:	e44e                	sd	s3,8(sp)
    800034e4:	1800                	addi	s0,sp,48
    800034e6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800034e8:	05050493          	addi	s1,a0,80
    800034ec:	08050913          	addi	s2,a0,128
    800034f0:	a021                	j	800034f8 <itrunc+0x20>
    800034f2:	0491                	addi	s1,s1,4
    800034f4:	01248b63          	beq	s1,s2,8000350a <itrunc+0x32>
    if(ip->addrs[i]){
    800034f8:	408c                	lw	a1,0(s1)
    800034fa:	dde5                	beqz	a1,800034f2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800034fc:	0009a503          	lw	a0,0(s3)
    80003500:	9cdff0ef          	jal	80002ecc <bfree>
      ip->addrs[i] = 0;
    80003504:	0004a023          	sw	zero,0(s1)
    80003508:	b7ed                	j	800034f2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000350a:	0809a583          	lw	a1,128(s3)
    8000350e:	ed89                	bnez	a1,80003528 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003510:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003514:	854e                	mv	a0,s3
    80003516:	e21ff0ef          	jal	80003336 <iupdate>
}
    8000351a:	70a2                	ld	ra,40(sp)
    8000351c:	7402                	ld	s0,32(sp)
    8000351e:	64e2                	ld	s1,24(sp)
    80003520:	6942                	ld	s2,16(sp)
    80003522:	69a2                	ld	s3,8(sp)
    80003524:	6145                	addi	sp,sp,48
    80003526:	8082                	ret
    80003528:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000352a:	0009a503          	lw	a0,0(s3)
    8000352e:	faaff0ef          	jal	80002cd8 <bread>
    80003532:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003534:	05850493          	addi	s1,a0,88
    80003538:	45850913          	addi	s2,a0,1112
    8000353c:	a021                	j	80003544 <itrunc+0x6c>
    8000353e:	0491                	addi	s1,s1,4
    80003540:	01248963          	beq	s1,s2,80003552 <itrunc+0x7a>
      if(a[j])
    80003544:	408c                	lw	a1,0(s1)
    80003546:	dde5                	beqz	a1,8000353e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003548:	0009a503          	lw	a0,0(s3)
    8000354c:	981ff0ef          	jal	80002ecc <bfree>
    80003550:	b7fd                	j	8000353e <itrunc+0x66>
    brelse(bp);
    80003552:	8552                	mv	a0,s4
    80003554:	88dff0ef          	jal	80002de0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003558:	0809a583          	lw	a1,128(s3)
    8000355c:	0009a503          	lw	a0,0(s3)
    80003560:	96dff0ef          	jal	80002ecc <bfree>
    ip->addrs[NDIRECT] = 0;
    80003564:	0809a023          	sw	zero,128(s3)
    80003568:	6a02                	ld	s4,0(sp)
    8000356a:	b75d                	j	80003510 <itrunc+0x38>

000000008000356c <iput>:
{
    8000356c:	1101                	addi	sp,sp,-32
    8000356e:	ec06                	sd	ra,24(sp)
    80003570:	e822                	sd	s0,16(sp)
    80003572:	e426                	sd	s1,8(sp)
    80003574:	1000                	addi	s0,sp,32
    80003576:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003578:	0006b517          	auipc	a0,0x6b
    8000357c:	c6850513          	addi	a0,a0,-920 # 8006e1e0 <itable>
    80003580:	e76fd0ef          	jal	80000bf6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003584:	4498                	lw	a4,8(s1)
    80003586:	4785                	li	a5,1
    80003588:	02f70063          	beq	a4,a5,800035a8 <iput+0x3c>
  ip->ref--;
    8000358c:	449c                	lw	a5,8(s1)
    8000358e:	37fd                	addiw	a5,a5,-1
    80003590:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003592:	0006b517          	auipc	a0,0x6b
    80003596:	c4e50513          	addi	a0,a0,-946 # 8006e1e0 <itable>
    8000359a:	ef0fd0ef          	jal	80000c8a <release>
}
    8000359e:	60e2                	ld	ra,24(sp)
    800035a0:	6442                	ld	s0,16(sp)
    800035a2:	64a2                	ld	s1,8(sp)
    800035a4:	6105                	addi	sp,sp,32
    800035a6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035a8:	40bc                	lw	a5,64(s1)
    800035aa:	d3ed                	beqz	a5,8000358c <iput+0x20>
    800035ac:	04a49783          	lh	a5,74(s1)
    800035b0:	fff1                	bnez	a5,8000358c <iput+0x20>
    800035b2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800035b4:	01048913          	addi	s2,s1,16
    800035b8:	854a                	mv	a0,s2
    800035ba:	173000ef          	jal	80003f2c <acquiresleep>
    release(&itable.lock);
    800035be:	0006b517          	auipc	a0,0x6b
    800035c2:	c2250513          	addi	a0,a0,-990 # 8006e1e0 <itable>
    800035c6:	ec4fd0ef          	jal	80000c8a <release>
    itrunc(ip);
    800035ca:	8526                	mv	a0,s1
    800035cc:	f0dff0ef          	jal	800034d8 <itrunc>
    ip->type = 0;
    800035d0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800035d4:	8526                	mv	a0,s1
    800035d6:	d61ff0ef          	jal	80003336 <iupdate>
    ip->valid = 0;
    800035da:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800035de:	854a                	mv	a0,s2
    800035e0:	193000ef          	jal	80003f72 <releasesleep>
    acquire(&itable.lock);
    800035e4:	0006b517          	auipc	a0,0x6b
    800035e8:	bfc50513          	addi	a0,a0,-1028 # 8006e1e0 <itable>
    800035ec:	e0afd0ef          	jal	80000bf6 <acquire>
    800035f0:	6902                	ld	s2,0(sp)
    800035f2:	bf69                	j	8000358c <iput+0x20>

00000000800035f4 <iunlockput>:
{
    800035f4:	1101                	addi	sp,sp,-32
    800035f6:	ec06                	sd	ra,24(sp)
    800035f8:	e822                	sd	s0,16(sp)
    800035fa:	e426                	sd	s1,8(sp)
    800035fc:	1000                	addi	s0,sp,32
    800035fe:	84aa                	mv	s1,a0
  iunlock(ip);
    80003600:	e99ff0ef          	jal	80003498 <iunlock>
  iput(ip);
    80003604:	8526                	mv	a0,s1
    80003606:	f67ff0ef          	jal	8000356c <iput>
}
    8000360a:	60e2                	ld	ra,24(sp)
    8000360c:	6442                	ld	s0,16(sp)
    8000360e:	64a2                	ld	s1,8(sp)
    80003610:	6105                	addi	sp,sp,32
    80003612:	8082                	ret

0000000080003614 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003614:	1141                	addi	sp,sp,-16
    80003616:	e406                	sd	ra,8(sp)
    80003618:	e022                	sd	s0,0(sp)
    8000361a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000361c:	411c                	lw	a5,0(a0)
    8000361e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003620:	415c                	lw	a5,4(a0)
    80003622:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003624:	04451783          	lh	a5,68(a0)
    80003628:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000362c:	04a51783          	lh	a5,74(a0)
    80003630:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003634:	04c56783          	lwu	a5,76(a0)
    80003638:	e99c                	sd	a5,16(a1)
}
    8000363a:	60a2                	ld	ra,8(sp)
    8000363c:	6402                	ld	s0,0(sp)
    8000363e:	0141                	addi	sp,sp,16
    80003640:	8082                	ret

0000000080003642 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003642:	457c                	lw	a5,76(a0)
    80003644:	0ed7e663          	bltu	a5,a3,80003730 <readi+0xee>
{
    80003648:	7159                	addi	sp,sp,-112
    8000364a:	f486                	sd	ra,104(sp)
    8000364c:	f0a2                	sd	s0,96(sp)
    8000364e:	eca6                	sd	s1,88(sp)
    80003650:	e0d2                	sd	s4,64(sp)
    80003652:	fc56                	sd	s5,56(sp)
    80003654:	f85a                	sd	s6,48(sp)
    80003656:	f45e                	sd	s7,40(sp)
    80003658:	1880                	addi	s0,sp,112
    8000365a:	8b2a                	mv	s6,a0
    8000365c:	8bae                	mv	s7,a1
    8000365e:	8a32                	mv	s4,a2
    80003660:	84b6                	mv	s1,a3
    80003662:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003664:	9f35                	addw	a4,a4,a3
    return 0;
    80003666:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003668:	0ad76b63          	bltu	a4,a3,8000371e <readi+0xdc>
    8000366c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000366e:	00e7f463          	bgeu	a5,a4,80003676 <readi+0x34>
    n = ip->size - off;
    80003672:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003676:	080a8b63          	beqz	s5,8000370c <readi+0xca>
    8000367a:	e8ca                	sd	s2,80(sp)
    8000367c:	f062                	sd	s8,32(sp)
    8000367e:	ec66                	sd	s9,24(sp)
    80003680:	e86a                	sd	s10,16(sp)
    80003682:	e46e                	sd	s11,8(sp)
    80003684:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003686:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000368a:	5c7d                	li	s8,-1
    8000368c:	a80d                	j	800036be <readi+0x7c>
    8000368e:	020d1d93          	slli	s11,s10,0x20
    80003692:	020ddd93          	srli	s11,s11,0x20
    80003696:	05890613          	addi	a2,s2,88
    8000369a:	86ee                	mv	a3,s11
    8000369c:	963e                	add	a2,a2,a5
    8000369e:	85d2                	mv	a1,s4
    800036a0:	855e                	mv	a0,s7
    800036a2:	c89fe0ef          	jal	8000232a <either_copyout>
    800036a6:	05850363          	beq	a0,s8,800036ec <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800036aa:	854a                	mv	a0,s2
    800036ac:	f34ff0ef          	jal	80002de0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036b0:	013d09bb          	addw	s3,s10,s3
    800036b4:	009d04bb          	addw	s1,s10,s1
    800036b8:	9a6e                	add	s4,s4,s11
    800036ba:	0559f363          	bgeu	s3,s5,80003700 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800036be:	00a4d59b          	srliw	a1,s1,0xa
    800036c2:	855a                	mv	a0,s6
    800036c4:	987ff0ef          	jal	8000304a <bmap>
    800036c8:	85aa                	mv	a1,a0
    if(addr == 0)
    800036ca:	c139                	beqz	a0,80003710 <readi+0xce>
    bp = bread(ip->dev, addr);
    800036cc:	000b2503          	lw	a0,0(s6)
    800036d0:	e08ff0ef          	jal	80002cd8 <bread>
    800036d4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800036d6:	3ff4f793          	andi	a5,s1,1023
    800036da:	40fc873b          	subw	a4,s9,a5
    800036de:	413a86bb          	subw	a3,s5,s3
    800036e2:	8d3a                	mv	s10,a4
    800036e4:	fae6f5e3          	bgeu	a3,a4,8000368e <readi+0x4c>
    800036e8:	8d36                	mv	s10,a3
    800036ea:	b755                	j	8000368e <readi+0x4c>
      brelse(bp);
    800036ec:	854a                	mv	a0,s2
    800036ee:	ef2ff0ef          	jal	80002de0 <brelse>
      tot = -1;
    800036f2:	59fd                	li	s3,-1
      break;
    800036f4:	6946                	ld	s2,80(sp)
    800036f6:	7c02                	ld	s8,32(sp)
    800036f8:	6ce2                	ld	s9,24(sp)
    800036fa:	6d42                	ld	s10,16(sp)
    800036fc:	6da2                	ld	s11,8(sp)
    800036fe:	a831                	j	8000371a <readi+0xd8>
    80003700:	6946                	ld	s2,80(sp)
    80003702:	7c02                	ld	s8,32(sp)
    80003704:	6ce2                	ld	s9,24(sp)
    80003706:	6d42                	ld	s10,16(sp)
    80003708:	6da2                	ld	s11,8(sp)
    8000370a:	a801                	j	8000371a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000370c:	89d6                	mv	s3,s5
    8000370e:	a031                	j	8000371a <readi+0xd8>
    80003710:	6946                	ld	s2,80(sp)
    80003712:	7c02                	ld	s8,32(sp)
    80003714:	6ce2                	ld	s9,24(sp)
    80003716:	6d42                	ld	s10,16(sp)
    80003718:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000371a:	854e                	mv	a0,s3
    8000371c:	69a6                	ld	s3,72(sp)
}
    8000371e:	70a6                	ld	ra,104(sp)
    80003720:	7406                	ld	s0,96(sp)
    80003722:	64e6                	ld	s1,88(sp)
    80003724:	6a06                	ld	s4,64(sp)
    80003726:	7ae2                	ld	s5,56(sp)
    80003728:	7b42                	ld	s6,48(sp)
    8000372a:	7ba2                	ld	s7,40(sp)
    8000372c:	6165                	addi	sp,sp,112
    8000372e:	8082                	ret
    return 0;
    80003730:	4501                	li	a0,0
}
    80003732:	8082                	ret

0000000080003734 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003734:	457c                	lw	a5,76(a0)
    80003736:	0ed7eb63          	bltu	a5,a3,8000382c <writei+0xf8>
{
    8000373a:	7159                	addi	sp,sp,-112
    8000373c:	f486                	sd	ra,104(sp)
    8000373e:	f0a2                	sd	s0,96(sp)
    80003740:	e8ca                	sd	s2,80(sp)
    80003742:	e0d2                	sd	s4,64(sp)
    80003744:	fc56                	sd	s5,56(sp)
    80003746:	f85a                	sd	s6,48(sp)
    80003748:	f45e                	sd	s7,40(sp)
    8000374a:	1880                	addi	s0,sp,112
    8000374c:	8aaa                	mv	s5,a0
    8000374e:	8bae                	mv	s7,a1
    80003750:	8a32                	mv	s4,a2
    80003752:	8936                	mv	s2,a3
    80003754:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003756:	00e687bb          	addw	a5,a3,a4
    8000375a:	0cd7eb63          	bltu	a5,a3,80003830 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000375e:	00043737          	lui	a4,0x43
    80003762:	0cf76963          	bltu	a4,a5,80003834 <writei+0x100>
    80003766:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003768:	0a0b0a63          	beqz	s6,8000381c <writei+0xe8>
    8000376c:	eca6                	sd	s1,88(sp)
    8000376e:	f062                	sd	s8,32(sp)
    80003770:	ec66                	sd	s9,24(sp)
    80003772:	e86a                	sd	s10,16(sp)
    80003774:	e46e                	sd	s11,8(sp)
    80003776:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003778:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000377c:	5c7d                	li	s8,-1
    8000377e:	a825                	j	800037b6 <writei+0x82>
    80003780:	020d1d93          	slli	s11,s10,0x20
    80003784:	020ddd93          	srli	s11,s11,0x20
    80003788:	05848513          	addi	a0,s1,88
    8000378c:	86ee                	mv	a3,s11
    8000378e:	8652                	mv	a2,s4
    80003790:	85de                	mv	a1,s7
    80003792:	953e                	add	a0,a0,a5
    80003794:	be1fe0ef          	jal	80002374 <either_copyin>
    80003798:	05850663          	beq	a0,s8,800037e4 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000379c:	8526                	mv	a0,s1
    8000379e:	688000ef          	jal	80003e26 <log_write>
    brelse(bp);
    800037a2:	8526                	mv	a0,s1
    800037a4:	e3cff0ef          	jal	80002de0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037a8:	013d09bb          	addw	s3,s10,s3
    800037ac:	012d093b          	addw	s2,s10,s2
    800037b0:	9a6e                	add	s4,s4,s11
    800037b2:	0369fc63          	bgeu	s3,s6,800037ea <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800037b6:	00a9559b          	srliw	a1,s2,0xa
    800037ba:	8556                	mv	a0,s5
    800037bc:	88fff0ef          	jal	8000304a <bmap>
    800037c0:	85aa                	mv	a1,a0
    if(addr == 0)
    800037c2:	c505                	beqz	a0,800037ea <writei+0xb6>
    bp = bread(ip->dev, addr);
    800037c4:	000aa503          	lw	a0,0(s5)
    800037c8:	d10ff0ef          	jal	80002cd8 <bread>
    800037cc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800037ce:	3ff97793          	andi	a5,s2,1023
    800037d2:	40fc873b          	subw	a4,s9,a5
    800037d6:	413b06bb          	subw	a3,s6,s3
    800037da:	8d3a                	mv	s10,a4
    800037dc:	fae6f2e3          	bgeu	a3,a4,80003780 <writei+0x4c>
    800037e0:	8d36                	mv	s10,a3
    800037e2:	bf79                	j	80003780 <writei+0x4c>
      brelse(bp);
    800037e4:	8526                	mv	a0,s1
    800037e6:	dfaff0ef          	jal	80002de0 <brelse>
  }

  if(off > ip->size)
    800037ea:	04caa783          	lw	a5,76(s5)
    800037ee:	0327f963          	bgeu	a5,s2,80003820 <writei+0xec>
    ip->size = off;
    800037f2:	052aa623          	sw	s2,76(s5)
    800037f6:	64e6                	ld	s1,88(sp)
    800037f8:	7c02                	ld	s8,32(sp)
    800037fa:	6ce2                	ld	s9,24(sp)
    800037fc:	6d42                	ld	s10,16(sp)
    800037fe:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003800:	8556                	mv	a0,s5
    80003802:	b35ff0ef          	jal	80003336 <iupdate>

  return tot;
    80003806:	854e                	mv	a0,s3
    80003808:	69a6                	ld	s3,72(sp)
}
    8000380a:	70a6                	ld	ra,104(sp)
    8000380c:	7406                	ld	s0,96(sp)
    8000380e:	6946                	ld	s2,80(sp)
    80003810:	6a06                	ld	s4,64(sp)
    80003812:	7ae2                	ld	s5,56(sp)
    80003814:	7b42                	ld	s6,48(sp)
    80003816:	7ba2                	ld	s7,40(sp)
    80003818:	6165                	addi	sp,sp,112
    8000381a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000381c:	89da                	mv	s3,s6
    8000381e:	b7cd                	j	80003800 <writei+0xcc>
    80003820:	64e6                	ld	s1,88(sp)
    80003822:	7c02                	ld	s8,32(sp)
    80003824:	6ce2                	ld	s9,24(sp)
    80003826:	6d42                	ld	s10,16(sp)
    80003828:	6da2                	ld	s11,8(sp)
    8000382a:	bfd9                	j	80003800 <writei+0xcc>
    return -1;
    8000382c:	557d                	li	a0,-1
}
    8000382e:	8082                	ret
    return -1;
    80003830:	557d                	li	a0,-1
    80003832:	bfe1                	j	8000380a <writei+0xd6>
    return -1;
    80003834:	557d                	li	a0,-1
    80003836:	bfd1                	j	8000380a <writei+0xd6>

0000000080003838 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003838:	1141                	addi	sp,sp,-16
    8000383a:	e406                	sd	ra,8(sp)
    8000383c:	e022                	sd	s0,0(sp)
    8000383e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003840:	4639                	li	a2,14
    80003842:	d5cfd0ef          	jal	80000d9e <strncmp>
}
    80003846:	60a2                	ld	ra,8(sp)
    80003848:	6402                	ld	s0,0(sp)
    8000384a:	0141                	addi	sp,sp,16
    8000384c:	8082                	ret

000000008000384e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000384e:	711d                	addi	sp,sp,-96
    80003850:	ec86                	sd	ra,88(sp)
    80003852:	e8a2                	sd	s0,80(sp)
    80003854:	e4a6                	sd	s1,72(sp)
    80003856:	e0ca                	sd	s2,64(sp)
    80003858:	fc4e                	sd	s3,56(sp)
    8000385a:	f852                	sd	s4,48(sp)
    8000385c:	f456                	sd	s5,40(sp)
    8000385e:	f05a                	sd	s6,32(sp)
    80003860:	ec5e                	sd	s7,24(sp)
    80003862:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003864:	04451703          	lh	a4,68(a0)
    80003868:	4785                	li	a5,1
    8000386a:	00f71f63          	bne	a4,a5,80003888 <dirlookup+0x3a>
    8000386e:	892a                	mv	s2,a0
    80003870:	8aae                	mv	s5,a1
    80003872:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003874:	457c                	lw	a5,76(a0)
    80003876:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003878:	fa040a13          	addi	s4,s0,-96
    8000387c:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000387e:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003882:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003884:	e39d                	bnez	a5,800038aa <dirlookup+0x5c>
    80003886:	a8b9                	j	800038e4 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003888:	00004517          	auipc	a0,0x4
    8000388c:	d0850513          	addi	a0,a0,-760 # 80007590 <etext+0x590>
    80003890:	f0ffc0ef          	jal	8000079e <panic>
      panic("dirlookup read");
    80003894:	00004517          	auipc	a0,0x4
    80003898:	d1450513          	addi	a0,a0,-748 # 800075a8 <etext+0x5a8>
    8000389c:	f03fc0ef          	jal	8000079e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038a0:	24c1                	addiw	s1,s1,16
    800038a2:	04c92783          	lw	a5,76(s2)
    800038a6:	02f4fe63          	bgeu	s1,a5,800038e2 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038aa:	874e                	mv	a4,s3
    800038ac:	86a6                	mv	a3,s1
    800038ae:	8652                	mv	a2,s4
    800038b0:	4581                	li	a1,0
    800038b2:	854a                	mv	a0,s2
    800038b4:	d8fff0ef          	jal	80003642 <readi>
    800038b8:	fd351ee3          	bne	a0,s3,80003894 <dirlookup+0x46>
    if(de.inum == 0)
    800038bc:	fa045783          	lhu	a5,-96(s0)
    800038c0:	d3e5                	beqz	a5,800038a0 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    800038c2:	85da                	mv	a1,s6
    800038c4:	8556                	mv	a0,s5
    800038c6:	f73ff0ef          	jal	80003838 <namecmp>
    800038ca:	f979                	bnez	a0,800038a0 <dirlookup+0x52>
      if(poff)
    800038cc:	000b8463          	beqz	s7,800038d4 <dirlookup+0x86>
        *poff = off;
    800038d0:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800038d4:	fa045583          	lhu	a1,-96(s0)
    800038d8:	00092503          	lw	a0,0(s2)
    800038dc:	82fff0ef          	jal	8000310a <iget>
    800038e0:	a011                	j	800038e4 <dirlookup+0x96>
  return 0;
    800038e2:	4501                	li	a0,0
}
    800038e4:	60e6                	ld	ra,88(sp)
    800038e6:	6446                	ld	s0,80(sp)
    800038e8:	64a6                	ld	s1,72(sp)
    800038ea:	6906                	ld	s2,64(sp)
    800038ec:	79e2                	ld	s3,56(sp)
    800038ee:	7a42                	ld	s4,48(sp)
    800038f0:	7aa2                	ld	s5,40(sp)
    800038f2:	7b02                	ld	s6,32(sp)
    800038f4:	6be2                	ld	s7,24(sp)
    800038f6:	6125                	addi	sp,sp,96
    800038f8:	8082                	ret

00000000800038fa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800038fa:	711d                	addi	sp,sp,-96
    800038fc:	ec86                	sd	ra,88(sp)
    800038fe:	e8a2                	sd	s0,80(sp)
    80003900:	e4a6                	sd	s1,72(sp)
    80003902:	e0ca                	sd	s2,64(sp)
    80003904:	fc4e                	sd	s3,56(sp)
    80003906:	f852                	sd	s4,48(sp)
    80003908:	f456                	sd	s5,40(sp)
    8000390a:	f05a                	sd	s6,32(sp)
    8000390c:	ec5e                	sd	s7,24(sp)
    8000390e:	e862                	sd	s8,16(sp)
    80003910:	e466                	sd	s9,8(sp)
    80003912:	e06a                	sd	s10,0(sp)
    80003914:	1080                	addi	s0,sp,96
    80003916:	84aa                	mv	s1,a0
    80003918:	8b2e                	mv	s6,a1
    8000391a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000391c:	00054703          	lbu	a4,0(a0)
    80003920:	02f00793          	li	a5,47
    80003924:	00f70f63          	beq	a4,a5,80003942 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003928:	8a4fe0ef          	jal	800019cc <myproc>
    8000392c:	15053503          	ld	a0,336(a0)
    80003930:	a85ff0ef          	jal	800033b4 <idup>
    80003934:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003936:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000393a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000393c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000393e:	4b85                	li	s7,1
    80003940:	a879                	j	800039de <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003942:	4585                	li	a1,1
    80003944:	852e                	mv	a0,a1
    80003946:	fc4ff0ef          	jal	8000310a <iget>
    8000394a:	8a2a                	mv	s4,a0
    8000394c:	b7ed                	j	80003936 <namex+0x3c>
      iunlockput(ip);
    8000394e:	8552                	mv	a0,s4
    80003950:	ca5ff0ef          	jal	800035f4 <iunlockput>
      return 0;
    80003954:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003956:	8552                	mv	a0,s4
    80003958:	60e6                	ld	ra,88(sp)
    8000395a:	6446                	ld	s0,80(sp)
    8000395c:	64a6                	ld	s1,72(sp)
    8000395e:	6906                	ld	s2,64(sp)
    80003960:	79e2                	ld	s3,56(sp)
    80003962:	7a42                	ld	s4,48(sp)
    80003964:	7aa2                	ld	s5,40(sp)
    80003966:	7b02                	ld	s6,32(sp)
    80003968:	6be2                	ld	s7,24(sp)
    8000396a:	6c42                	ld	s8,16(sp)
    8000396c:	6ca2                	ld	s9,8(sp)
    8000396e:	6d02                	ld	s10,0(sp)
    80003970:	6125                	addi	sp,sp,96
    80003972:	8082                	ret
      iunlock(ip);
    80003974:	8552                	mv	a0,s4
    80003976:	b23ff0ef          	jal	80003498 <iunlock>
      return ip;
    8000397a:	bff1                	j	80003956 <namex+0x5c>
      iunlockput(ip);
    8000397c:	8552                	mv	a0,s4
    8000397e:	c77ff0ef          	jal	800035f4 <iunlockput>
      return 0;
    80003982:	8a4e                	mv	s4,s3
    80003984:	bfc9                	j	80003956 <namex+0x5c>
  len = path - s;
    80003986:	40998633          	sub	a2,s3,s1
    8000398a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000398e:	09ac5063          	bge	s8,s10,80003a0e <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003992:	8666                	mv	a2,s9
    80003994:	85a6                	mv	a1,s1
    80003996:	8556                	mv	a0,s5
    80003998:	b92fd0ef          	jal	80000d2a <memmove>
    8000399c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000399e:	0004c783          	lbu	a5,0(s1)
    800039a2:	01279763          	bne	a5,s2,800039b0 <namex+0xb6>
    path++;
    800039a6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800039a8:	0004c783          	lbu	a5,0(s1)
    800039ac:	ff278de3          	beq	a5,s2,800039a6 <namex+0xac>
    ilock(ip);
    800039b0:	8552                	mv	a0,s4
    800039b2:	a39ff0ef          	jal	800033ea <ilock>
    if(ip->type != T_DIR){
    800039b6:	044a1783          	lh	a5,68(s4)
    800039ba:	f9779ae3          	bne	a5,s7,8000394e <namex+0x54>
    if(nameiparent && *path == '\0'){
    800039be:	000b0563          	beqz	s6,800039c8 <namex+0xce>
    800039c2:	0004c783          	lbu	a5,0(s1)
    800039c6:	d7dd                	beqz	a5,80003974 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800039c8:	4601                	li	a2,0
    800039ca:	85d6                	mv	a1,s5
    800039cc:	8552                	mv	a0,s4
    800039ce:	e81ff0ef          	jal	8000384e <dirlookup>
    800039d2:	89aa                	mv	s3,a0
    800039d4:	d545                	beqz	a0,8000397c <namex+0x82>
    iunlockput(ip);
    800039d6:	8552                	mv	a0,s4
    800039d8:	c1dff0ef          	jal	800035f4 <iunlockput>
    ip = next;
    800039dc:	8a4e                	mv	s4,s3
  while(*path == '/')
    800039de:	0004c783          	lbu	a5,0(s1)
    800039e2:	01279763          	bne	a5,s2,800039f0 <namex+0xf6>
    path++;
    800039e6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800039e8:	0004c783          	lbu	a5,0(s1)
    800039ec:	ff278de3          	beq	a5,s2,800039e6 <namex+0xec>
  if(*path == 0)
    800039f0:	cb8d                	beqz	a5,80003a22 <namex+0x128>
  while(*path != '/' && *path != 0)
    800039f2:	0004c783          	lbu	a5,0(s1)
    800039f6:	89a6                	mv	s3,s1
  len = path - s;
    800039f8:	4d01                	li	s10,0
    800039fa:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800039fc:	01278963          	beq	a5,s2,80003a0e <namex+0x114>
    80003a00:	d3d9                	beqz	a5,80003986 <namex+0x8c>
    path++;
    80003a02:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003a04:	0009c783          	lbu	a5,0(s3)
    80003a08:	ff279ce3          	bne	a5,s2,80003a00 <namex+0x106>
    80003a0c:	bfad                	j	80003986 <namex+0x8c>
    memmove(name, s, len);
    80003a0e:	2601                	sext.w	a2,a2
    80003a10:	85a6                	mv	a1,s1
    80003a12:	8556                	mv	a0,s5
    80003a14:	b16fd0ef          	jal	80000d2a <memmove>
    name[len] = 0;
    80003a18:	9d56                	add	s10,s10,s5
    80003a1a:	000d0023          	sb	zero,0(s10)
    80003a1e:	84ce                	mv	s1,s3
    80003a20:	bfbd                	j	8000399e <namex+0xa4>
  if(nameiparent){
    80003a22:	f20b0ae3          	beqz	s6,80003956 <namex+0x5c>
    iput(ip);
    80003a26:	8552                	mv	a0,s4
    80003a28:	b45ff0ef          	jal	8000356c <iput>
    return 0;
    80003a2c:	4a01                	li	s4,0
    80003a2e:	b725                	j	80003956 <namex+0x5c>

0000000080003a30 <dirlink>:
{
    80003a30:	715d                	addi	sp,sp,-80
    80003a32:	e486                	sd	ra,72(sp)
    80003a34:	e0a2                	sd	s0,64(sp)
    80003a36:	f84a                	sd	s2,48(sp)
    80003a38:	ec56                	sd	s5,24(sp)
    80003a3a:	e85a                	sd	s6,16(sp)
    80003a3c:	0880                	addi	s0,sp,80
    80003a3e:	892a                	mv	s2,a0
    80003a40:	8aae                	mv	s5,a1
    80003a42:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003a44:	4601                	li	a2,0
    80003a46:	e09ff0ef          	jal	8000384e <dirlookup>
    80003a4a:	ed1d                	bnez	a0,80003a88 <dirlink+0x58>
    80003a4c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a4e:	04c92483          	lw	s1,76(s2)
    80003a52:	c4b9                	beqz	s1,80003aa0 <dirlink+0x70>
    80003a54:	f44e                	sd	s3,40(sp)
    80003a56:	f052                	sd	s4,32(sp)
    80003a58:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a5a:	fb040a13          	addi	s4,s0,-80
    80003a5e:	49c1                	li	s3,16
    80003a60:	874e                	mv	a4,s3
    80003a62:	86a6                	mv	a3,s1
    80003a64:	8652                	mv	a2,s4
    80003a66:	4581                	li	a1,0
    80003a68:	854a                	mv	a0,s2
    80003a6a:	bd9ff0ef          	jal	80003642 <readi>
    80003a6e:	03351163          	bne	a0,s3,80003a90 <dirlink+0x60>
    if(de.inum == 0)
    80003a72:	fb045783          	lhu	a5,-80(s0)
    80003a76:	c39d                	beqz	a5,80003a9c <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a78:	24c1                	addiw	s1,s1,16
    80003a7a:	04c92783          	lw	a5,76(s2)
    80003a7e:	fef4e1e3          	bltu	s1,a5,80003a60 <dirlink+0x30>
    80003a82:	79a2                	ld	s3,40(sp)
    80003a84:	7a02                	ld	s4,32(sp)
    80003a86:	a829                	j	80003aa0 <dirlink+0x70>
    iput(ip);
    80003a88:	ae5ff0ef          	jal	8000356c <iput>
    return -1;
    80003a8c:	557d                	li	a0,-1
    80003a8e:	a83d                	j	80003acc <dirlink+0x9c>
      panic("dirlink read");
    80003a90:	00004517          	auipc	a0,0x4
    80003a94:	b2850513          	addi	a0,a0,-1240 # 800075b8 <etext+0x5b8>
    80003a98:	d07fc0ef          	jal	8000079e <panic>
    80003a9c:	79a2                	ld	s3,40(sp)
    80003a9e:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003aa0:	4639                	li	a2,14
    80003aa2:	85d6                	mv	a1,s5
    80003aa4:	fb240513          	addi	a0,s0,-78
    80003aa8:	b30fd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003aac:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ab0:	4741                	li	a4,16
    80003ab2:	86a6                	mv	a3,s1
    80003ab4:	fb040613          	addi	a2,s0,-80
    80003ab8:	4581                	li	a1,0
    80003aba:	854a                	mv	a0,s2
    80003abc:	c79ff0ef          	jal	80003734 <writei>
    80003ac0:	1541                	addi	a0,a0,-16
    80003ac2:	00a03533          	snez	a0,a0
    80003ac6:	40a0053b          	negw	a0,a0
    80003aca:	74e2                	ld	s1,56(sp)
}
    80003acc:	60a6                	ld	ra,72(sp)
    80003ace:	6406                	ld	s0,64(sp)
    80003ad0:	7942                	ld	s2,48(sp)
    80003ad2:	6ae2                	ld	s5,24(sp)
    80003ad4:	6b42                	ld	s6,16(sp)
    80003ad6:	6161                	addi	sp,sp,80
    80003ad8:	8082                	ret

0000000080003ada <namei>:

struct inode*
namei(char *path)
{
    80003ada:	1101                	addi	sp,sp,-32
    80003adc:	ec06                	sd	ra,24(sp)
    80003ade:	e822                	sd	s0,16(sp)
    80003ae0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ae2:	fe040613          	addi	a2,s0,-32
    80003ae6:	4581                	li	a1,0
    80003ae8:	e13ff0ef          	jal	800038fa <namex>
}
    80003aec:	60e2                	ld	ra,24(sp)
    80003aee:	6442                	ld	s0,16(sp)
    80003af0:	6105                	addi	sp,sp,32
    80003af2:	8082                	ret

0000000080003af4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003af4:	1141                	addi	sp,sp,-16
    80003af6:	e406                	sd	ra,8(sp)
    80003af8:	e022                	sd	s0,0(sp)
    80003afa:	0800                	addi	s0,sp,16
    80003afc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003afe:	4585                	li	a1,1
    80003b00:	dfbff0ef          	jal	800038fa <namex>
}
    80003b04:	60a2                	ld	ra,8(sp)
    80003b06:	6402                	ld	s0,0(sp)
    80003b08:	0141                	addi	sp,sp,16
    80003b0a:	8082                	ret

0000000080003b0c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b0c:	1101                	addi	sp,sp,-32
    80003b0e:	ec06                	sd	ra,24(sp)
    80003b10:	e822                	sd	s0,16(sp)
    80003b12:	e426                	sd	s1,8(sp)
    80003b14:	e04a                	sd	s2,0(sp)
    80003b16:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b18:	0006c917          	auipc	s2,0x6c
    80003b1c:	17090913          	addi	s2,s2,368 # 8006fc88 <log>
    80003b20:	01892583          	lw	a1,24(s2)
    80003b24:	02892503          	lw	a0,40(s2)
    80003b28:	9b0ff0ef          	jal	80002cd8 <bread>
    80003b2c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003b2e:	02c92603          	lw	a2,44(s2)
    80003b32:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b34:	00c05f63          	blez	a2,80003b52 <write_head+0x46>
    80003b38:	0006c717          	auipc	a4,0x6c
    80003b3c:	18070713          	addi	a4,a4,384 # 8006fcb8 <log+0x30>
    80003b40:	87aa                	mv	a5,a0
    80003b42:	060a                	slli	a2,a2,0x2
    80003b44:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b46:	4314                	lw	a3,0(a4)
    80003b48:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003b4a:	0711                	addi	a4,a4,4
    80003b4c:	0791                	addi	a5,a5,4
    80003b4e:	fec79ce3          	bne	a5,a2,80003b46 <write_head+0x3a>
  }
  bwrite(buf);
    80003b52:	8526                	mv	a0,s1
    80003b54:	a5aff0ef          	jal	80002dae <bwrite>
  brelse(buf);
    80003b58:	8526                	mv	a0,s1
    80003b5a:	a86ff0ef          	jal	80002de0 <brelse>
}
    80003b5e:	60e2                	ld	ra,24(sp)
    80003b60:	6442                	ld	s0,16(sp)
    80003b62:	64a2                	ld	s1,8(sp)
    80003b64:	6902                	ld	s2,0(sp)
    80003b66:	6105                	addi	sp,sp,32
    80003b68:	8082                	ret

0000000080003b6a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b6a:	0006c797          	auipc	a5,0x6c
    80003b6e:	14a7a783          	lw	a5,330(a5) # 8006fcb4 <log+0x2c>
    80003b72:	0af05263          	blez	a5,80003c16 <install_trans+0xac>
{
    80003b76:	715d                	addi	sp,sp,-80
    80003b78:	e486                	sd	ra,72(sp)
    80003b7a:	e0a2                	sd	s0,64(sp)
    80003b7c:	fc26                	sd	s1,56(sp)
    80003b7e:	f84a                	sd	s2,48(sp)
    80003b80:	f44e                	sd	s3,40(sp)
    80003b82:	f052                	sd	s4,32(sp)
    80003b84:	ec56                	sd	s5,24(sp)
    80003b86:	e85a                	sd	s6,16(sp)
    80003b88:	e45e                	sd	s7,8(sp)
    80003b8a:	0880                	addi	s0,sp,80
    80003b8c:	8b2a                	mv	s6,a0
    80003b8e:	0006ca97          	auipc	s5,0x6c
    80003b92:	12aa8a93          	addi	s5,s5,298 # 8006fcb8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b96:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b98:	0006c997          	auipc	s3,0x6c
    80003b9c:	0f098993          	addi	s3,s3,240 # 8006fc88 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ba0:	40000b93          	li	s7,1024
    80003ba4:	a829                	j	80003bbe <install_trans+0x54>
    brelse(lbuf);
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	a38ff0ef          	jal	80002de0 <brelse>
    brelse(dbuf);
    80003bac:	8526                	mv	a0,s1
    80003bae:	a32ff0ef          	jal	80002de0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bb2:	2a05                	addiw	s4,s4,1
    80003bb4:	0a91                	addi	s5,s5,4
    80003bb6:	02c9a783          	lw	a5,44(s3)
    80003bba:	04fa5363          	bge	s4,a5,80003c00 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003bbe:	0189a583          	lw	a1,24(s3)
    80003bc2:	014585bb          	addw	a1,a1,s4
    80003bc6:	2585                	addiw	a1,a1,1
    80003bc8:	0289a503          	lw	a0,40(s3)
    80003bcc:	90cff0ef          	jal	80002cd8 <bread>
    80003bd0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003bd2:	000aa583          	lw	a1,0(s5)
    80003bd6:	0289a503          	lw	a0,40(s3)
    80003bda:	8feff0ef          	jal	80002cd8 <bread>
    80003bde:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003be0:	865e                	mv	a2,s7
    80003be2:	05890593          	addi	a1,s2,88
    80003be6:	05850513          	addi	a0,a0,88
    80003bea:	940fd0ef          	jal	80000d2a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003bee:	8526                	mv	a0,s1
    80003bf0:	9beff0ef          	jal	80002dae <bwrite>
    if(recovering == 0)
    80003bf4:	fa0b19e3          	bnez	s6,80003ba6 <install_trans+0x3c>
      bunpin(dbuf);
    80003bf8:	8526                	mv	a0,s1
    80003bfa:	a9eff0ef          	jal	80002e98 <bunpin>
    80003bfe:	b765                	j	80003ba6 <install_trans+0x3c>
}
    80003c00:	60a6                	ld	ra,72(sp)
    80003c02:	6406                	ld	s0,64(sp)
    80003c04:	74e2                	ld	s1,56(sp)
    80003c06:	7942                	ld	s2,48(sp)
    80003c08:	79a2                	ld	s3,40(sp)
    80003c0a:	7a02                	ld	s4,32(sp)
    80003c0c:	6ae2                	ld	s5,24(sp)
    80003c0e:	6b42                	ld	s6,16(sp)
    80003c10:	6ba2                	ld	s7,8(sp)
    80003c12:	6161                	addi	sp,sp,80
    80003c14:	8082                	ret
    80003c16:	8082                	ret

0000000080003c18 <initlog>:
{
    80003c18:	7179                	addi	sp,sp,-48
    80003c1a:	f406                	sd	ra,40(sp)
    80003c1c:	f022                	sd	s0,32(sp)
    80003c1e:	ec26                	sd	s1,24(sp)
    80003c20:	e84a                	sd	s2,16(sp)
    80003c22:	e44e                	sd	s3,8(sp)
    80003c24:	1800                	addi	s0,sp,48
    80003c26:	892a                	mv	s2,a0
    80003c28:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c2a:	0006c497          	auipc	s1,0x6c
    80003c2e:	05e48493          	addi	s1,s1,94 # 8006fc88 <log>
    80003c32:	00004597          	auipc	a1,0x4
    80003c36:	99658593          	addi	a1,a1,-1642 # 800075c8 <etext+0x5c8>
    80003c3a:	8526                	mv	a0,s1
    80003c3c:	f37fc0ef          	jal	80000b72 <initlock>
  log.start = sb->logstart;
    80003c40:	0149a583          	lw	a1,20(s3)
    80003c44:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003c46:	0109a783          	lw	a5,16(s3)
    80003c4a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003c4c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003c50:	854a                	mv	a0,s2
    80003c52:	886ff0ef          	jal	80002cd8 <bread>
  log.lh.n = lh->n;
    80003c56:	4d30                	lw	a2,88(a0)
    80003c58:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003c5a:	00c05f63          	blez	a2,80003c78 <initlog+0x60>
    80003c5e:	87aa                	mv	a5,a0
    80003c60:	0006c717          	auipc	a4,0x6c
    80003c64:	05870713          	addi	a4,a4,88 # 8006fcb8 <log+0x30>
    80003c68:	060a                	slli	a2,a2,0x2
    80003c6a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c6c:	4ff4                	lw	a3,92(a5)
    80003c6e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c70:	0791                	addi	a5,a5,4
    80003c72:	0711                	addi	a4,a4,4
    80003c74:	fec79ce3          	bne	a5,a2,80003c6c <initlog+0x54>
  brelse(buf);
    80003c78:	968ff0ef          	jal	80002de0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c7c:	4505                	li	a0,1
    80003c7e:	eedff0ef          	jal	80003b6a <install_trans>
  log.lh.n = 0;
    80003c82:	0006c797          	auipc	a5,0x6c
    80003c86:	0207a923          	sw	zero,50(a5) # 8006fcb4 <log+0x2c>
  write_head(); // clear the log
    80003c8a:	e83ff0ef          	jal	80003b0c <write_head>
}
    80003c8e:	70a2                	ld	ra,40(sp)
    80003c90:	7402                	ld	s0,32(sp)
    80003c92:	64e2                	ld	s1,24(sp)
    80003c94:	6942                	ld	s2,16(sp)
    80003c96:	69a2                	ld	s3,8(sp)
    80003c98:	6145                	addi	sp,sp,48
    80003c9a:	8082                	ret

0000000080003c9c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c9c:	1101                	addi	sp,sp,-32
    80003c9e:	ec06                	sd	ra,24(sp)
    80003ca0:	e822                	sd	s0,16(sp)
    80003ca2:	e426                	sd	s1,8(sp)
    80003ca4:	e04a                	sd	s2,0(sp)
    80003ca6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ca8:	0006c517          	auipc	a0,0x6c
    80003cac:	fe050513          	addi	a0,a0,-32 # 8006fc88 <log>
    80003cb0:	f47fc0ef          	jal	80000bf6 <acquire>
  while(1){
    if(log.committing){
    80003cb4:	0006c497          	auipc	s1,0x6c
    80003cb8:	fd448493          	addi	s1,s1,-44 # 8006fc88 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003cbc:	4979                	li	s2,30
    80003cbe:	a029                	j	80003cc8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003cc0:	85a6                	mv	a1,s1
    80003cc2:	8526                	mv	a0,s1
    80003cc4:	b10fe0ef          	jal	80001fd4 <sleep>
    if(log.committing){
    80003cc8:	50dc                	lw	a5,36(s1)
    80003cca:	fbfd                	bnez	a5,80003cc0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ccc:	5098                	lw	a4,32(s1)
    80003cce:	2705                	addiw	a4,a4,1
    80003cd0:	0027179b          	slliw	a5,a4,0x2
    80003cd4:	9fb9                	addw	a5,a5,a4
    80003cd6:	0017979b          	slliw	a5,a5,0x1
    80003cda:	54d4                	lw	a3,44(s1)
    80003cdc:	9fb5                	addw	a5,a5,a3
    80003cde:	00f95763          	bge	s2,a5,80003cec <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003ce2:	85a6                	mv	a1,s1
    80003ce4:	8526                	mv	a0,s1
    80003ce6:	aeefe0ef          	jal	80001fd4 <sleep>
    80003cea:	bff9                	j	80003cc8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003cec:	0006c517          	auipc	a0,0x6c
    80003cf0:	f9c50513          	addi	a0,a0,-100 # 8006fc88 <log>
    80003cf4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003cf6:	f95fc0ef          	jal	80000c8a <release>
      break;
    }
  }
}
    80003cfa:	60e2                	ld	ra,24(sp)
    80003cfc:	6442                	ld	s0,16(sp)
    80003cfe:	64a2                	ld	s1,8(sp)
    80003d00:	6902                	ld	s2,0(sp)
    80003d02:	6105                	addi	sp,sp,32
    80003d04:	8082                	ret

0000000080003d06 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d06:	7139                	addi	sp,sp,-64
    80003d08:	fc06                	sd	ra,56(sp)
    80003d0a:	f822                	sd	s0,48(sp)
    80003d0c:	f426                	sd	s1,40(sp)
    80003d0e:	f04a                	sd	s2,32(sp)
    80003d10:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d12:	0006c497          	auipc	s1,0x6c
    80003d16:	f7648493          	addi	s1,s1,-138 # 8006fc88 <log>
    80003d1a:	8526                	mv	a0,s1
    80003d1c:	edbfc0ef          	jal	80000bf6 <acquire>
  log.outstanding -= 1;
    80003d20:	509c                	lw	a5,32(s1)
    80003d22:	37fd                	addiw	a5,a5,-1
    80003d24:	893e                	mv	s2,a5
    80003d26:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003d28:	50dc                	lw	a5,36(s1)
    80003d2a:	ef9d                	bnez	a5,80003d68 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003d2c:	04091863          	bnez	s2,80003d7c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003d30:	0006c497          	auipc	s1,0x6c
    80003d34:	f5848493          	addi	s1,s1,-168 # 8006fc88 <log>
    80003d38:	4785                	li	a5,1
    80003d3a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d3c:	8526                	mv	a0,s1
    80003d3e:	f4dfc0ef          	jal	80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d42:	54dc                	lw	a5,44(s1)
    80003d44:	04f04c63          	bgtz	a5,80003d9c <end_op+0x96>
    acquire(&log.lock);
    80003d48:	0006c497          	auipc	s1,0x6c
    80003d4c:	f4048493          	addi	s1,s1,-192 # 8006fc88 <log>
    80003d50:	8526                	mv	a0,s1
    80003d52:	ea5fc0ef          	jal	80000bf6 <acquire>
    log.committing = 0;
    80003d56:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003d5a:	8526                	mv	a0,s1
    80003d5c:	ac4fe0ef          	jal	80002020 <wakeup>
    release(&log.lock);
    80003d60:	8526                	mv	a0,s1
    80003d62:	f29fc0ef          	jal	80000c8a <release>
}
    80003d66:	a02d                	j	80003d90 <end_op+0x8a>
    80003d68:	ec4e                	sd	s3,24(sp)
    80003d6a:	e852                	sd	s4,16(sp)
    80003d6c:	e456                	sd	s5,8(sp)
    80003d6e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003d70:	00004517          	auipc	a0,0x4
    80003d74:	86050513          	addi	a0,a0,-1952 # 800075d0 <etext+0x5d0>
    80003d78:	a27fc0ef          	jal	8000079e <panic>
    wakeup(&log);
    80003d7c:	0006c497          	auipc	s1,0x6c
    80003d80:	f0c48493          	addi	s1,s1,-244 # 8006fc88 <log>
    80003d84:	8526                	mv	a0,s1
    80003d86:	a9afe0ef          	jal	80002020 <wakeup>
  release(&log.lock);
    80003d8a:	8526                	mv	a0,s1
    80003d8c:	efffc0ef          	jal	80000c8a <release>
}
    80003d90:	70e2                	ld	ra,56(sp)
    80003d92:	7442                	ld	s0,48(sp)
    80003d94:	74a2                	ld	s1,40(sp)
    80003d96:	7902                	ld	s2,32(sp)
    80003d98:	6121                	addi	sp,sp,64
    80003d9a:	8082                	ret
    80003d9c:	ec4e                	sd	s3,24(sp)
    80003d9e:	e852                	sd	s4,16(sp)
    80003da0:	e456                	sd	s5,8(sp)
    80003da2:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003da4:	0006ca97          	auipc	s5,0x6c
    80003da8:	f14a8a93          	addi	s5,s5,-236 # 8006fcb8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003dac:	0006ca17          	auipc	s4,0x6c
    80003db0:	edca0a13          	addi	s4,s4,-292 # 8006fc88 <log>
    memmove(to->data, from->data, BSIZE);
    80003db4:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003db8:	018a2583          	lw	a1,24(s4)
    80003dbc:	012585bb          	addw	a1,a1,s2
    80003dc0:	2585                	addiw	a1,a1,1
    80003dc2:	028a2503          	lw	a0,40(s4)
    80003dc6:	f13fe0ef          	jal	80002cd8 <bread>
    80003dca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003dcc:	000aa583          	lw	a1,0(s5)
    80003dd0:	028a2503          	lw	a0,40(s4)
    80003dd4:	f05fe0ef          	jal	80002cd8 <bread>
    80003dd8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003dda:	865a                	mv	a2,s6
    80003ddc:	05850593          	addi	a1,a0,88
    80003de0:	05848513          	addi	a0,s1,88
    80003de4:	f47fc0ef          	jal	80000d2a <memmove>
    bwrite(to);  // write the log
    80003de8:	8526                	mv	a0,s1
    80003dea:	fc5fe0ef          	jal	80002dae <bwrite>
    brelse(from);
    80003dee:	854e                	mv	a0,s3
    80003df0:	ff1fe0ef          	jal	80002de0 <brelse>
    brelse(to);
    80003df4:	8526                	mv	a0,s1
    80003df6:	febfe0ef          	jal	80002de0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dfa:	2905                	addiw	s2,s2,1
    80003dfc:	0a91                	addi	s5,s5,4
    80003dfe:	02ca2783          	lw	a5,44(s4)
    80003e02:	faf94be3          	blt	s2,a5,80003db8 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003e06:	d07ff0ef          	jal	80003b0c <write_head>
    install_trans(0); // Now install writes to home locations
    80003e0a:	4501                	li	a0,0
    80003e0c:	d5fff0ef          	jal	80003b6a <install_trans>
    log.lh.n = 0;
    80003e10:	0006c797          	auipc	a5,0x6c
    80003e14:	ea07a223          	sw	zero,-348(a5) # 8006fcb4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003e18:	cf5ff0ef          	jal	80003b0c <write_head>
    80003e1c:	69e2                	ld	s3,24(sp)
    80003e1e:	6a42                	ld	s4,16(sp)
    80003e20:	6aa2                	ld	s5,8(sp)
    80003e22:	6b02                	ld	s6,0(sp)
    80003e24:	b715                	j	80003d48 <end_op+0x42>

0000000080003e26 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e26:	1101                	addi	sp,sp,-32
    80003e28:	ec06                	sd	ra,24(sp)
    80003e2a:	e822                	sd	s0,16(sp)
    80003e2c:	e426                	sd	s1,8(sp)
    80003e2e:	e04a                	sd	s2,0(sp)
    80003e30:	1000                	addi	s0,sp,32
    80003e32:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e34:	0006c917          	auipc	s2,0x6c
    80003e38:	e5490913          	addi	s2,s2,-428 # 8006fc88 <log>
    80003e3c:	854a                	mv	a0,s2
    80003e3e:	db9fc0ef          	jal	80000bf6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003e42:	02c92603          	lw	a2,44(s2)
    80003e46:	47f5                	li	a5,29
    80003e48:	06c7c363          	blt	a5,a2,80003eae <log_write+0x88>
    80003e4c:	0006c797          	auipc	a5,0x6c
    80003e50:	e587a783          	lw	a5,-424(a5) # 8006fca4 <log+0x1c>
    80003e54:	37fd                	addiw	a5,a5,-1
    80003e56:	04f65c63          	bge	a2,a5,80003eae <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e5a:	0006c797          	auipc	a5,0x6c
    80003e5e:	e4e7a783          	lw	a5,-434(a5) # 8006fca8 <log+0x20>
    80003e62:	04f05c63          	blez	a5,80003eba <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e66:	4781                	li	a5,0
    80003e68:	04c05f63          	blez	a2,80003ec6 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e6c:	44cc                	lw	a1,12(s1)
    80003e6e:	0006c717          	auipc	a4,0x6c
    80003e72:	e4a70713          	addi	a4,a4,-438 # 8006fcb8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003e76:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e78:	4314                	lw	a3,0(a4)
    80003e7a:	04b68663          	beq	a3,a1,80003ec6 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003e7e:	2785                	addiw	a5,a5,1
    80003e80:	0711                	addi	a4,a4,4
    80003e82:	fef61be3          	bne	a2,a5,80003e78 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e86:	0621                	addi	a2,a2,8
    80003e88:	060a                	slli	a2,a2,0x2
    80003e8a:	0006c797          	auipc	a5,0x6c
    80003e8e:	dfe78793          	addi	a5,a5,-514 # 8006fc88 <log>
    80003e92:	97b2                	add	a5,a5,a2
    80003e94:	44d8                	lw	a4,12(s1)
    80003e96:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e98:	8526                	mv	a0,s1
    80003e9a:	fcbfe0ef          	jal	80002e64 <bpin>
    log.lh.n++;
    80003e9e:	0006c717          	auipc	a4,0x6c
    80003ea2:	dea70713          	addi	a4,a4,-534 # 8006fc88 <log>
    80003ea6:	575c                	lw	a5,44(a4)
    80003ea8:	2785                	addiw	a5,a5,1
    80003eaa:	d75c                	sw	a5,44(a4)
    80003eac:	a80d                	j	80003ede <log_write+0xb8>
    panic("too big a transaction");
    80003eae:	00003517          	auipc	a0,0x3
    80003eb2:	73250513          	addi	a0,a0,1842 # 800075e0 <etext+0x5e0>
    80003eb6:	8e9fc0ef          	jal	8000079e <panic>
    panic("log_write outside of trans");
    80003eba:	00003517          	auipc	a0,0x3
    80003ebe:	73e50513          	addi	a0,a0,1854 # 800075f8 <etext+0x5f8>
    80003ec2:	8ddfc0ef          	jal	8000079e <panic>
  log.lh.block[i] = b->blockno;
    80003ec6:	00878693          	addi	a3,a5,8
    80003eca:	068a                	slli	a3,a3,0x2
    80003ecc:	0006c717          	auipc	a4,0x6c
    80003ed0:	dbc70713          	addi	a4,a4,-580 # 8006fc88 <log>
    80003ed4:	9736                	add	a4,a4,a3
    80003ed6:	44d4                	lw	a3,12(s1)
    80003ed8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003eda:	faf60fe3          	beq	a2,a5,80003e98 <log_write+0x72>
  }
  release(&log.lock);
    80003ede:	0006c517          	auipc	a0,0x6c
    80003ee2:	daa50513          	addi	a0,a0,-598 # 8006fc88 <log>
    80003ee6:	da5fc0ef          	jal	80000c8a <release>
}
    80003eea:	60e2                	ld	ra,24(sp)
    80003eec:	6442                	ld	s0,16(sp)
    80003eee:	64a2                	ld	s1,8(sp)
    80003ef0:	6902                	ld	s2,0(sp)
    80003ef2:	6105                	addi	sp,sp,32
    80003ef4:	8082                	ret

0000000080003ef6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ef6:	1101                	addi	sp,sp,-32
    80003ef8:	ec06                	sd	ra,24(sp)
    80003efa:	e822                	sd	s0,16(sp)
    80003efc:	e426                	sd	s1,8(sp)
    80003efe:	e04a                	sd	s2,0(sp)
    80003f00:	1000                	addi	s0,sp,32
    80003f02:	84aa                	mv	s1,a0
    80003f04:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003f06:	00003597          	auipc	a1,0x3
    80003f0a:	71258593          	addi	a1,a1,1810 # 80007618 <etext+0x618>
    80003f0e:	0521                	addi	a0,a0,8
    80003f10:	c63fc0ef          	jal	80000b72 <initlock>
  lk->name = name;
    80003f14:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f18:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f1c:	0204a423          	sw	zero,40(s1)
}
    80003f20:	60e2                	ld	ra,24(sp)
    80003f22:	6442                	ld	s0,16(sp)
    80003f24:	64a2                	ld	s1,8(sp)
    80003f26:	6902                	ld	s2,0(sp)
    80003f28:	6105                	addi	sp,sp,32
    80003f2a:	8082                	ret

0000000080003f2c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f2c:	1101                	addi	sp,sp,-32
    80003f2e:	ec06                	sd	ra,24(sp)
    80003f30:	e822                	sd	s0,16(sp)
    80003f32:	e426                	sd	s1,8(sp)
    80003f34:	e04a                	sd	s2,0(sp)
    80003f36:	1000                	addi	s0,sp,32
    80003f38:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f3a:	00850913          	addi	s2,a0,8
    80003f3e:	854a                	mv	a0,s2
    80003f40:	cb7fc0ef          	jal	80000bf6 <acquire>
  while (lk->locked) {
    80003f44:	409c                	lw	a5,0(s1)
    80003f46:	c799                	beqz	a5,80003f54 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003f48:	85ca                	mv	a1,s2
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	888fe0ef          	jal	80001fd4 <sleep>
  while (lk->locked) {
    80003f50:	409c                	lw	a5,0(s1)
    80003f52:	fbfd                	bnez	a5,80003f48 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003f54:	4785                	li	a5,1
    80003f56:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003f58:	a75fd0ef          	jal	800019cc <myproc>
    80003f5c:	591c                	lw	a5,48(a0)
    80003f5e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003f60:	854a                	mv	a0,s2
    80003f62:	d29fc0ef          	jal	80000c8a <release>
}
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6902                	ld	s2,0(sp)
    80003f6e:	6105                	addi	sp,sp,32
    80003f70:	8082                	ret

0000000080003f72 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003f72:	1101                	addi	sp,sp,-32
    80003f74:	ec06                	sd	ra,24(sp)
    80003f76:	e822                	sd	s0,16(sp)
    80003f78:	e426                	sd	s1,8(sp)
    80003f7a:	e04a                	sd	s2,0(sp)
    80003f7c:	1000                	addi	s0,sp,32
    80003f7e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f80:	00850913          	addi	s2,a0,8
    80003f84:	854a                	mv	a0,s2
    80003f86:	c71fc0ef          	jal	80000bf6 <acquire>
  lk->locked = 0;
    80003f8a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f8e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f92:	8526                	mv	a0,s1
    80003f94:	88cfe0ef          	jal	80002020 <wakeup>
  release(&lk->lk);
    80003f98:	854a                	mv	a0,s2
    80003f9a:	cf1fc0ef          	jal	80000c8a <release>
}
    80003f9e:	60e2                	ld	ra,24(sp)
    80003fa0:	6442                	ld	s0,16(sp)
    80003fa2:	64a2                	ld	s1,8(sp)
    80003fa4:	6902                	ld	s2,0(sp)
    80003fa6:	6105                	addi	sp,sp,32
    80003fa8:	8082                	ret

0000000080003faa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003faa:	7179                	addi	sp,sp,-48
    80003fac:	f406                	sd	ra,40(sp)
    80003fae:	f022                	sd	s0,32(sp)
    80003fb0:	ec26                	sd	s1,24(sp)
    80003fb2:	e84a                	sd	s2,16(sp)
    80003fb4:	1800                	addi	s0,sp,48
    80003fb6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003fb8:	00850913          	addi	s2,a0,8
    80003fbc:	854a                	mv	a0,s2
    80003fbe:	c39fc0ef          	jal	80000bf6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003fc2:	409c                	lw	a5,0(s1)
    80003fc4:	ef81                	bnez	a5,80003fdc <holdingsleep+0x32>
    80003fc6:	4481                	li	s1,0
  release(&lk->lk);
    80003fc8:	854a                	mv	a0,s2
    80003fca:	cc1fc0ef          	jal	80000c8a <release>
  return r;
}
    80003fce:	8526                	mv	a0,s1
    80003fd0:	70a2                	ld	ra,40(sp)
    80003fd2:	7402                	ld	s0,32(sp)
    80003fd4:	64e2                	ld	s1,24(sp)
    80003fd6:	6942                	ld	s2,16(sp)
    80003fd8:	6145                	addi	sp,sp,48
    80003fda:	8082                	ret
    80003fdc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003fde:	0284a983          	lw	s3,40(s1)
    80003fe2:	9ebfd0ef          	jal	800019cc <myproc>
    80003fe6:	5904                	lw	s1,48(a0)
    80003fe8:	413484b3          	sub	s1,s1,s3
    80003fec:	0014b493          	seqz	s1,s1
    80003ff0:	69a2                	ld	s3,8(sp)
    80003ff2:	bfd9                	j	80003fc8 <holdingsleep+0x1e>

0000000080003ff4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ff4:	1141                	addi	sp,sp,-16
    80003ff6:	e406                	sd	ra,8(sp)
    80003ff8:	e022                	sd	s0,0(sp)
    80003ffa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ffc:	00003597          	auipc	a1,0x3
    80004000:	62c58593          	addi	a1,a1,1580 # 80007628 <etext+0x628>
    80004004:	0006c517          	auipc	a0,0x6c
    80004008:	dcc50513          	addi	a0,a0,-564 # 8006fdd0 <ftable>
    8000400c:	b67fc0ef          	jal	80000b72 <initlock>
}
    80004010:	60a2                	ld	ra,8(sp)
    80004012:	6402                	ld	s0,0(sp)
    80004014:	0141                	addi	sp,sp,16
    80004016:	8082                	ret

0000000080004018 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004018:	1101                	addi	sp,sp,-32
    8000401a:	ec06                	sd	ra,24(sp)
    8000401c:	e822                	sd	s0,16(sp)
    8000401e:	e426                	sd	s1,8(sp)
    80004020:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004022:	0006c517          	auipc	a0,0x6c
    80004026:	dae50513          	addi	a0,a0,-594 # 8006fdd0 <ftable>
    8000402a:	bcdfc0ef          	jal	80000bf6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000402e:	0006c497          	auipc	s1,0x6c
    80004032:	dba48493          	addi	s1,s1,-582 # 8006fde8 <ftable+0x18>
    80004036:	0006d717          	auipc	a4,0x6d
    8000403a:	d5270713          	addi	a4,a4,-686 # 80070d88 <disk>
    if(f->ref == 0){
    8000403e:	40dc                	lw	a5,4(s1)
    80004040:	cf89                	beqz	a5,8000405a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004042:	02848493          	addi	s1,s1,40
    80004046:	fee49ce3          	bne	s1,a4,8000403e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000404a:	0006c517          	auipc	a0,0x6c
    8000404e:	d8650513          	addi	a0,a0,-634 # 8006fdd0 <ftable>
    80004052:	c39fc0ef          	jal	80000c8a <release>
  return 0;
    80004056:	4481                	li	s1,0
    80004058:	a809                	j	8000406a <filealloc+0x52>
      f->ref = 1;
    8000405a:	4785                	li	a5,1
    8000405c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000405e:	0006c517          	auipc	a0,0x6c
    80004062:	d7250513          	addi	a0,a0,-654 # 8006fdd0 <ftable>
    80004066:	c25fc0ef          	jal	80000c8a <release>
}
    8000406a:	8526                	mv	a0,s1
    8000406c:	60e2                	ld	ra,24(sp)
    8000406e:	6442                	ld	s0,16(sp)
    80004070:	64a2                	ld	s1,8(sp)
    80004072:	6105                	addi	sp,sp,32
    80004074:	8082                	ret

0000000080004076 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004076:	1101                	addi	sp,sp,-32
    80004078:	ec06                	sd	ra,24(sp)
    8000407a:	e822                	sd	s0,16(sp)
    8000407c:	e426                	sd	s1,8(sp)
    8000407e:	1000                	addi	s0,sp,32
    80004080:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004082:	0006c517          	auipc	a0,0x6c
    80004086:	d4e50513          	addi	a0,a0,-690 # 8006fdd0 <ftable>
    8000408a:	b6dfc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    8000408e:	40dc                	lw	a5,4(s1)
    80004090:	02f05063          	blez	a5,800040b0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004094:	2785                	addiw	a5,a5,1
    80004096:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004098:	0006c517          	auipc	a0,0x6c
    8000409c:	d3850513          	addi	a0,a0,-712 # 8006fdd0 <ftable>
    800040a0:	bebfc0ef          	jal	80000c8a <release>
  return f;
}
    800040a4:	8526                	mv	a0,s1
    800040a6:	60e2                	ld	ra,24(sp)
    800040a8:	6442                	ld	s0,16(sp)
    800040aa:	64a2                	ld	s1,8(sp)
    800040ac:	6105                	addi	sp,sp,32
    800040ae:	8082                	ret
    panic("filedup");
    800040b0:	00003517          	auipc	a0,0x3
    800040b4:	58050513          	addi	a0,a0,1408 # 80007630 <etext+0x630>
    800040b8:	ee6fc0ef          	jal	8000079e <panic>

00000000800040bc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800040bc:	7139                	addi	sp,sp,-64
    800040be:	fc06                	sd	ra,56(sp)
    800040c0:	f822                	sd	s0,48(sp)
    800040c2:	f426                	sd	s1,40(sp)
    800040c4:	0080                	addi	s0,sp,64
    800040c6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800040c8:	0006c517          	auipc	a0,0x6c
    800040cc:	d0850513          	addi	a0,a0,-760 # 8006fdd0 <ftable>
    800040d0:	b27fc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    800040d4:	40dc                	lw	a5,4(s1)
    800040d6:	04f05863          	blez	a5,80004126 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800040da:	37fd                	addiw	a5,a5,-1
    800040dc:	c0dc                	sw	a5,4(s1)
    800040de:	04f04e63          	bgtz	a5,8000413a <fileclose+0x7e>
    800040e2:	f04a                	sd	s2,32(sp)
    800040e4:	ec4e                	sd	s3,24(sp)
    800040e6:	e852                	sd	s4,16(sp)
    800040e8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800040ea:	0004a903          	lw	s2,0(s1)
    800040ee:	0094ca83          	lbu	s5,9(s1)
    800040f2:	0104ba03          	ld	s4,16(s1)
    800040f6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800040fa:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800040fe:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004102:	0006c517          	auipc	a0,0x6c
    80004106:	cce50513          	addi	a0,a0,-818 # 8006fdd0 <ftable>
    8000410a:	b81fc0ef          	jal	80000c8a <release>

  if(ff.type == FD_PIPE){
    8000410e:	4785                	li	a5,1
    80004110:	04f90063          	beq	s2,a5,80004150 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004114:	3979                	addiw	s2,s2,-2
    80004116:	4785                	li	a5,1
    80004118:	0527f563          	bgeu	a5,s2,80004162 <fileclose+0xa6>
    8000411c:	7902                	ld	s2,32(sp)
    8000411e:	69e2                	ld	s3,24(sp)
    80004120:	6a42                	ld	s4,16(sp)
    80004122:	6aa2                	ld	s5,8(sp)
    80004124:	a00d                	j	80004146 <fileclose+0x8a>
    80004126:	f04a                	sd	s2,32(sp)
    80004128:	ec4e                	sd	s3,24(sp)
    8000412a:	e852                	sd	s4,16(sp)
    8000412c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000412e:	00003517          	auipc	a0,0x3
    80004132:	50a50513          	addi	a0,a0,1290 # 80007638 <etext+0x638>
    80004136:	e68fc0ef          	jal	8000079e <panic>
    release(&ftable.lock);
    8000413a:	0006c517          	auipc	a0,0x6c
    8000413e:	c9650513          	addi	a0,a0,-874 # 8006fdd0 <ftable>
    80004142:	b49fc0ef          	jal	80000c8a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004146:	70e2                	ld	ra,56(sp)
    80004148:	7442                	ld	s0,48(sp)
    8000414a:	74a2                	ld	s1,40(sp)
    8000414c:	6121                	addi	sp,sp,64
    8000414e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004150:	85d6                	mv	a1,s5
    80004152:	8552                	mv	a0,s4
    80004154:	340000ef          	jal	80004494 <pipeclose>
    80004158:	7902                	ld	s2,32(sp)
    8000415a:	69e2                	ld	s3,24(sp)
    8000415c:	6a42                	ld	s4,16(sp)
    8000415e:	6aa2                	ld	s5,8(sp)
    80004160:	b7dd                	j	80004146 <fileclose+0x8a>
    begin_op();
    80004162:	b3bff0ef          	jal	80003c9c <begin_op>
    iput(ff.ip);
    80004166:	854e                	mv	a0,s3
    80004168:	c04ff0ef          	jal	8000356c <iput>
    end_op();
    8000416c:	b9bff0ef          	jal	80003d06 <end_op>
    80004170:	7902                	ld	s2,32(sp)
    80004172:	69e2                	ld	s3,24(sp)
    80004174:	6a42                	ld	s4,16(sp)
    80004176:	6aa2                	ld	s5,8(sp)
    80004178:	b7f9                	j	80004146 <fileclose+0x8a>

000000008000417a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000417a:	715d                	addi	sp,sp,-80
    8000417c:	e486                	sd	ra,72(sp)
    8000417e:	e0a2                	sd	s0,64(sp)
    80004180:	fc26                	sd	s1,56(sp)
    80004182:	f44e                	sd	s3,40(sp)
    80004184:	0880                	addi	s0,sp,80
    80004186:	84aa                	mv	s1,a0
    80004188:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000418a:	843fd0ef          	jal	800019cc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000418e:	409c                	lw	a5,0(s1)
    80004190:	37f9                	addiw	a5,a5,-2
    80004192:	4705                	li	a4,1
    80004194:	04f76263          	bltu	a4,a5,800041d8 <filestat+0x5e>
    80004198:	f84a                	sd	s2,48(sp)
    8000419a:	f052                	sd	s4,32(sp)
    8000419c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000419e:	6c88                	ld	a0,24(s1)
    800041a0:	a4aff0ef          	jal	800033ea <ilock>
    stati(f->ip, &st);
    800041a4:	fb840a13          	addi	s4,s0,-72
    800041a8:	85d2                	mv	a1,s4
    800041aa:	6c88                	ld	a0,24(s1)
    800041ac:	c68ff0ef          	jal	80003614 <stati>
    iunlock(f->ip);
    800041b0:	6c88                	ld	a0,24(s1)
    800041b2:	ae6ff0ef          	jal	80003498 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800041b6:	46e1                	li	a3,24
    800041b8:	8652                	mv	a2,s4
    800041ba:	85ce                	mv	a1,s3
    800041bc:	05093503          	ld	a0,80(s2)
    800041c0:	bccfd0ef          	jal	8000158c <copyout>
    800041c4:	41f5551b          	sraiw	a0,a0,0x1f
    800041c8:	7942                	ld	s2,48(sp)
    800041ca:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800041cc:	60a6                	ld	ra,72(sp)
    800041ce:	6406                	ld	s0,64(sp)
    800041d0:	74e2                	ld	s1,56(sp)
    800041d2:	79a2                	ld	s3,40(sp)
    800041d4:	6161                	addi	sp,sp,80
    800041d6:	8082                	ret
  return -1;
    800041d8:	557d                	li	a0,-1
    800041da:	bfcd                	j	800041cc <filestat+0x52>

00000000800041dc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800041dc:	7179                	addi	sp,sp,-48
    800041de:	f406                	sd	ra,40(sp)
    800041e0:	f022                	sd	s0,32(sp)
    800041e2:	e84a                	sd	s2,16(sp)
    800041e4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800041e6:	00854783          	lbu	a5,8(a0)
    800041ea:	cfd1                	beqz	a5,80004286 <fileread+0xaa>
    800041ec:	ec26                	sd	s1,24(sp)
    800041ee:	e44e                	sd	s3,8(sp)
    800041f0:	84aa                	mv	s1,a0
    800041f2:	89ae                	mv	s3,a1
    800041f4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800041f6:	411c                	lw	a5,0(a0)
    800041f8:	4705                	li	a4,1
    800041fa:	04e78363          	beq	a5,a4,80004240 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800041fe:	470d                	li	a4,3
    80004200:	04e78763          	beq	a5,a4,8000424e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004204:	4709                	li	a4,2
    80004206:	06e79a63          	bne	a5,a4,8000427a <fileread+0x9e>
    ilock(f->ip);
    8000420a:	6d08                	ld	a0,24(a0)
    8000420c:	9deff0ef          	jal	800033ea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004210:	874a                	mv	a4,s2
    80004212:	5094                	lw	a3,32(s1)
    80004214:	864e                	mv	a2,s3
    80004216:	4585                	li	a1,1
    80004218:	6c88                	ld	a0,24(s1)
    8000421a:	c28ff0ef          	jal	80003642 <readi>
    8000421e:	892a                	mv	s2,a0
    80004220:	00a05563          	blez	a0,8000422a <fileread+0x4e>
      f->off += r;
    80004224:	509c                	lw	a5,32(s1)
    80004226:	9fa9                	addw	a5,a5,a0
    80004228:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000422a:	6c88                	ld	a0,24(s1)
    8000422c:	a6cff0ef          	jal	80003498 <iunlock>
    80004230:	64e2                	ld	s1,24(sp)
    80004232:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004234:	854a                	mv	a0,s2
    80004236:	70a2                	ld	ra,40(sp)
    80004238:	7402                	ld	s0,32(sp)
    8000423a:	6942                	ld	s2,16(sp)
    8000423c:	6145                	addi	sp,sp,48
    8000423e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004240:	6908                	ld	a0,16(a0)
    80004242:	3a2000ef          	jal	800045e4 <piperead>
    80004246:	892a                	mv	s2,a0
    80004248:	64e2                	ld	s1,24(sp)
    8000424a:	69a2                	ld	s3,8(sp)
    8000424c:	b7e5                	j	80004234 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000424e:	02451783          	lh	a5,36(a0)
    80004252:	03079693          	slli	a3,a5,0x30
    80004256:	92c1                	srli	a3,a3,0x30
    80004258:	4725                	li	a4,9
    8000425a:	02d76863          	bltu	a4,a3,8000428a <fileread+0xae>
    8000425e:	0792                	slli	a5,a5,0x4
    80004260:	0006c717          	auipc	a4,0x6c
    80004264:	ad070713          	addi	a4,a4,-1328 # 8006fd30 <devsw>
    80004268:	97ba                	add	a5,a5,a4
    8000426a:	639c                	ld	a5,0(a5)
    8000426c:	c39d                	beqz	a5,80004292 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000426e:	4505                	li	a0,1
    80004270:	9782                	jalr	a5
    80004272:	892a                	mv	s2,a0
    80004274:	64e2                	ld	s1,24(sp)
    80004276:	69a2                	ld	s3,8(sp)
    80004278:	bf75                	j	80004234 <fileread+0x58>
    panic("fileread");
    8000427a:	00003517          	auipc	a0,0x3
    8000427e:	3ce50513          	addi	a0,a0,974 # 80007648 <etext+0x648>
    80004282:	d1cfc0ef          	jal	8000079e <panic>
    return -1;
    80004286:	597d                	li	s2,-1
    80004288:	b775                	j	80004234 <fileread+0x58>
      return -1;
    8000428a:	597d                	li	s2,-1
    8000428c:	64e2                	ld	s1,24(sp)
    8000428e:	69a2                	ld	s3,8(sp)
    80004290:	b755                	j	80004234 <fileread+0x58>
    80004292:	597d                	li	s2,-1
    80004294:	64e2                	ld	s1,24(sp)
    80004296:	69a2                	ld	s3,8(sp)
    80004298:	bf71                	j	80004234 <fileread+0x58>

000000008000429a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000429a:	00954783          	lbu	a5,9(a0)
    8000429e:	10078e63          	beqz	a5,800043ba <filewrite+0x120>
{
    800042a2:	711d                	addi	sp,sp,-96
    800042a4:	ec86                	sd	ra,88(sp)
    800042a6:	e8a2                	sd	s0,80(sp)
    800042a8:	e0ca                	sd	s2,64(sp)
    800042aa:	f456                	sd	s5,40(sp)
    800042ac:	f05a                	sd	s6,32(sp)
    800042ae:	1080                	addi	s0,sp,96
    800042b0:	892a                	mv	s2,a0
    800042b2:	8b2e                	mv	s6,a1
    800042b4:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800042b6:	411c                	lw	a5,0(a0)
    800042b8:	4705                	li	a4,1
    800042ba:	02e78963          	beq	a5,a4,800042ec <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800042be:	470d                	li	a4,3
    800042c0:	02e78a63          	beq	a5,a4,800042f4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800042c4:	4709                	li	a4,2
    800042c6:	0ce79e63          	bne	a5,a4,800043a2 <filewrite+0x108>
    800042ca:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800042cc:	0ac05963          	blez	a2,8000437e <filewrite+0xe4>
    800042d0:	e4a6                	sd	s1,72(sp)
    800042d2:	fc4e                	sd	s3,56(sp)
    800042d4:	ec5e                	sd	s7,24(sp)
    800042d6:	e862                	sd	s8,16(sp)
    800042d8:	e466                	sd	s9,8(sp)
    int i = 0;
    800042da:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800042dc:	6b85                	lui	s7,0x1
    800042de:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800042e2:	6c85                	lui	s9,0x1
    800042e4:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800042e8:	4c05                	li	s8,1
    800042ea:	a8ad                	j	80004364 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    800042ec:	6908                	ld	a0,16(a0)
    800042ee:	1fe000ef          	jal	800044ec <pipewrite>
    800042f2:	a04d                	j	80004394 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800042f4:	02451783          	lh	a5,36(a0)
    800042f8:	03079693          	slli	a3,a5,0x30
    800042fc:	92c1                	srli	a3,a3,0x30
    800042fe:	4725                	li	a4,9
    80004300:	0ad76f63          	bltu	a4,a3,800043be <filewrite+0x124>
    80004304:	0792                	slli	a5,a5,0x4
    80004306:	0006c717          	auipc	a4,0x6c
    8000430a:	a2a70713          	addi	a4,a4,-1494 # 8006fd30 <devsw>
    8000430e:	97ba                	add	a5,a5,a4
    80004310:	679c                	ld	a5,8(a5)
    80004312:	cbc5                	beqz	a5,800043c2 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004314:	4505                	li	a0,1
    80004316:	9782                	jalr	a5
    80004318:	a8b5                	j	80004394 <filewrite+0xfa>
      if(n1 > max)
    8000431a:	2981                	sext.w	s3,s3
      begin_op();
    8000431c:	981ff0ef          	jal	80003c9c <begin_op>
      ilock(f->ip);
    80004320:	01893503          	ld	a0,24(s2)
    80004324:	8c6ff0ef          	jal	800033ea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004328:	874e                	mv	a4,s3
    8000432a:	02092683          	lw	a3,32(s2)
    8000432e:	016a0633          	add	a2,s4,s6
    80004332:	85e2                	mv	a1,s8
    80004334:	01893503          	ld	a0,24(s2)
    80004338:	bfcff0ef          	jal	80003734 <writei>
    8000433c:	84aa                	mv	s1,a0
    8000433e:	00a05763          	blez	a0,8000434c <filewrite+0xb2>
        f->off += r;
    80004342:	02092783          	lw	a5,32(s2)
    80004346:	9fa9                	addw	a5,a5,a0
    80004348:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000434c:	01893503          	ld	a0,24(s2)
    80004350:	948ff0ef          	jal	80003498 <iunlock>
      end_op();
    80004354:	9b3ff0ef          	jal	80003d06 <end_op>

      if(r != n1){
    80004358:	02999563          	bne	s3,s1,80004382 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000435c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004360:	015a5963          	bge	s4,s5,80004372 <filewrite+0xd8>
      int n1 = n - i;
    80004364:	414a87bb          	subw	a5,s5,s4
    80004368:	89be                	mv	s3,a5
      if(n1 > max)
    8000436a:	fafbd8e3          	bge	s7,a5,8000431a <filewrite+0x80>
    8000436e:	89e6                	mv	s3,s9
    80004370:	b76d                	j	8000431a <filewrite+0x80>
    80004372:	64a6                	ld	s1,72(sp)
    80004374:	79e2                	ld	s3,56(sp)
    80004376:	6be2                	ld	s7,24(sp)
    80004378:	6c42                	ld	s8,16(sp)
    8000437a:	6ca2                	ld	s9,8(sp)
    8000437c:	a801                	j	8000438c <filewrite+0xf2>
    int i = 0;
    8000437e:	4a01                	li	s4,0
    80004380:	a031                	j	8000438c <filewrite+0xf2>
    80004382:	64a6                	ld	s1,72(sp)
    80004384:	79e2                	ld	s3,56(sp)
    80004386:	6be2                	ld	s7,24(sp)
    80004388:	6c42                	ld	s8,16(sp)
    8000438a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000438c:	034a9d63          	bne	s5,s4,800043c6 <filewrite+0x12c>
    80004390:	8556                	mv	a0,s5
    80004392:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004394:	60e6                	ld	ra,88(sp)
    80004396:	6446                	ld	s0,80(sp)
    80004398:	6906                	ld	s2,64(sp)
    8000439a:	7aa2                	ld	s5,40(sp)
    8000439c:	7b02                	ld	s6,32(sp)
    8000439e:	6125                	addi	sp,sp,96
    800043a0:	8082                	ret
    800043a2:	e4a6                	sd	s1,72(sp)
    800043a4:	fc4e                	sd	s3,56(sp)
    800043a6:	f852                	sd	s4,48(sp)
    800043a8:	ec5e                	sd	s7,24(sp)
    800043aa:	e862                	sd	s8,16(sp)
    800043ac:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800043ae:	00003517          	auipc	a0,0x3
    800043b2:	2aa50513          	addi	a0,a0,682 # 80007658 <etext+0x658>
    800043b6:	be8fc0ef          	jal	8000079e <panic>
    return -1;
    800043ba:	557d                	li	a0,-1
}
    800043bc:	8082                	ret
      return -1;
    800043be:	557d                	li	a0,-1
    800043c0:	bfd1                	j	80004394 <filewrite+0xfa>
    800043c2:	557d                	li	a0,-1
    800043c4:	bfc1                	j	80004394 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800043c6:	557d                	li	a0,-1
    800043c8:	7a42                	ld	s4,48(sp)
    800043ca:	b7e9                	j	80004394 <filewrite+0xfa>

00000000800043cc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800043cc:	7179                	addi	sp,sp,-48
    800043ce:	f406                	sd	ra,40(sp)
    800043d0:	f022                	sd	s0,32(sp)
    800043d2:	ec26                	sd	s1,24(sp)
    800043d4:	e052                	sd	s4,0(sp)
    800043d6:	1800                	addi	s0,sp,48
    800043d8:	84aa                	mv	s1,a0
    800043da:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800043dc:	0005b023          	sd	zero,0(a1)
    800043e0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800043e4:	c35ff0ef          	jal	80004018 <filealloc>
    800043e8:	e088                	sd	a0,0(s1)
    800043ea:	c549                	beqz	a0,80004474 <pipealloc+0xa8>
    800043ec:	c2dff0ef          	jal	80004018 <filealloc>
    800043f0:	00aa3023          	sd	a0,0(s4)
    800043f4:	cd25                	beqz	a0,8000446c <pipealloc+0xa0>
    800043f6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800043f8:	f2afc0ef          	jal	80000b22 <kalloc>
    800043fc:	892a                	mv	s2,a0
    800043fe:	c12d                	beqz	a0,80004460 <pipealloc+0x94>
    80004400:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004402:	4985                	li	s3,1
    80004404:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004408:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000440c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004410:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004414:	00003597          	auipc	a1,0x3
    80004418:	25458593          	addi	a1,a1,596 # 80007668 <etext+0x668>
    8000441c:	f56fc0ef          	jal	80000b72 <initlock>
  (*f0)->type = FD_PIPE;
    80004420:	609c                	ld	a5,0(s1)
    80004422:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004426:	609c                	ld	a5,0(s1)
    80004428:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000442c:	609c                	ld	a5,0(s1)
    8000442e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004432:	609c                	ld	a5,0(s1)
    80004434:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004438:	000a3783          	ld	a5,0(s4)
    8000443c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004440:	000a3783          	ld	a5,0(s4)
    80004444:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004448:	000a3783          	ld	a5,0(s4)
    8000444c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004450:	000a3783          	ld	a5,0(s4)
    80004454:	0127b823          	sd	s2,16(a5)
  return 0;
    80004458:	4501                	li	a0,0
    8000445a:	6942                	ld	s2,16(sp)
    8000445c:	69a2                	ld	s3,8(sp)
    8000445e:	a01d                	j	80004484 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004460:	6088                	ld	a0,0(s1)
    80004462:	c119                	beqz	a0,80004468 <pipealloc+0x9c>
    80004464:	6942                	ld	s2,16(sp)
    80004466:	a029                	j	80004470 <pipealloc+0xa4>
    80004468:	6942                	ld	s2,16(sp)
    8000446a:	a029                	j	80004474 <pipealloc+0xa8>
    8000446c:	6088                	ld	a0,0(s1)
    8000446e:	c10d                	beqz	a0,80004490 <pipealloc+0xc4>
    fileclose(*f0);
    80004470:	c4dff0ef          	jal	800040bc <fileclose>
  if(*f1)
    80004474:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004478:	557d                	li	a0,-1
  if(*f1)
    8000447a:	c789                	beqz	a5,80004484 <pipealloc+0xb8>
    fileclose(*f1);
    8000447c:	853e                	mv	a0,a5
    8000447e:	c3fff0ef          	jal	800040bc <fileclose>
  return -1;
    80004482:	557d                	li	a0,-1
}
    80004484:	70a2                	ld	ra,40(sp)
    80004486:	7402                	ld	s0,32(sp)
    80004488:	64e2                	ld	s1,24(sp)
    8000448a:	6a02                	ld	s4,0(sp)
    8000448c:	6145                	addi	sp,sp,48
    8000448e:	8082                	ret
  return -1;
    80004490:	557d                	li	a0,-1
    80004492:	bfcd                	j	80004484 <pipealloc+0xb8>

0000000080004494 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004494:	1101                	addi	sp,sp,-32
    80004496:	ec06                	sd	ra,24(sp)
    80004498:	e822                	sd	s0,16(sp)
    8000449a:	e426                	sd	s1,8(sp)
    8000449c:	e04a                	sd	s2,0(sp)
    8000449e:	1000                	addi	s0,sp,32
    800044a0:	84aa                	mv	s1,a0
    800044a2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800044a4:	f52fc0ef          	jal	80000bf6 <acquire>
  if(writable){
    800044a8:	02090763          	beqz	s2,800044d6 <pipeclose+0x42>
    pi->writeopen = 0;
    800044ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800044b0:	21848513          	addi	a0,s1,536
    800044b4:	b6dfd0ef          	jal	80002020 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800044b8:	2204b783          	ld	a5,544(s1)
    800044bc:	e785                	bnez	a5,800044e4 <pipeclose+0x50>
    release(&pi->lock);
    800044be:	8526                	mv	a0,s1
    800044c0:	fcafc0ef          	jal	80000c8a <release>
    kfree((char*)pi);
    800044c4:	8526                	mv	a0,s1
    800044c6:	d7afc0ef          	jal	80000a40 <kfree>
  } else
    release(&pi->lock);
}
    800044ca:	60e2                	ld	ra,24(sp)
    800044cc:	6442                	ld	s0,16(sp)
    800044ce:	64a2                	ld	s1,8(sp)
    800044d0:	6902                	ld	s2,0(sp)
    800044d2:	6105                	addi	sp,sp,32
    800044d4:	8082                	ret
    pi->readopen = 0;
    800044d6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800044da:	21c48513          	addi	a0,s1,540
    800044de:	b43fd0ef          	jal	80002020 <wakeup>
    800044e2:	bfd9                	j	800044b8 <pipeclose+0x24>
    release(&pi->lock);
    800044e4:	8526                	mv	a0,s1
    800044e6:	fa4fc0ef          	jal	80000c8a <release>
}
    800044ea:	b7c5                	j	800044ca <pipeclose+0x36>

00000000800044ec <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800044ec:	7159                	addi	sp,sp,-112
    800044ee:	f486                	sd	ra,104(sp)
    800044f0:	f0a2                	sd	s0,96(sp)
    800044f2:	eca6                	sd	s1,88(sp)
    800044f4:	e8ca                	sd	s2,80(sp)
    800044f6:	e4ce                	sd	s3,72(sp)
    800044f8:	e0d2                	sd	s4,64(sp)
    800044fa:	fc56                	sd	s5,56(sp)
    800044fc:	1880                	addi	s0,sp,112
    800044fe:	84aa                	mv	s1,a0
    80004500:	8aae                	mv	s5,a1
    80004502:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004504:	cc8fd0ef          	jal	800019cc <myproc>
    80004508:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000450a:	8526                	mv	a0,s1
    8000450c:	eeafc0ef          	jal	80000bf6 <acquire>
  while(i < n){
    80004510:	0d405263          	blez	s4,800045d4 <pipewrite+0xe8>
    80004514:	f85a                	sd	s6,48(sp)
    80004516:	f45e                	sd	s7,40(sp)
    80004518:	f062                	sd	s8,32(sp)
    8000451a:	ec66                	sd	s9,24(sp)
    8000451c:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000451e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004520:	f9f40c13          	addi	s8,s0,-97
    80004524:	4b85                	li	s7,1
    80004526:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004528:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000452c:	21c48c93          	addi	s9,s1,540
    80004530:	a82d                	j	8000456a <pipewrite+0x7e>
      release(&pi->lock);
    80004532:	8526                	mv	a0,s1
    80004534:	f56fc0ef          	jal	80000c8a <release>
      return -1;
    80004538:	597d                	li	s2,-1
    8000453a:	7b42                	ld	s6,48(sp)
    8000453c:	7ba2                	ld	s7,40(sp)
    8000453e:	7c02                	ld	s8,32(sp)
    80004540:	6ce2                	ld	s9,24(sp)
    80004542:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004544:	854a                	mv	a0,s2
    80004546:	70a6                	ld	ra,104(sp)
    80004548:	7406                	ld	s0,96(sp)
    8000454a:	64e6                	ld	s1,88(sp)
    8000454c:	6946                	ld	s2,80(sp)
    8000454e:	69a6                	ld	s3,72(sp)
    80004550:	6a06                	ld	s4,64(sp)
    80004552:	7ae2                	ld	s5,56(sp)
    80004554:	6165                	addi	sp,sp,112
    80004556:	8082                	ret
      wakeup(&pi->nread);
    80004558:	856a                	mv	a0,s10
    8000455a:	ac7fd0ef          	jal	80002020 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000455e:	85a6                	mv	a1,s1
    80004560:	8566                	mv	a0,s9
    80004562:	a73fd0ef          	jal	80001fd4 <sleep>
  while(i < n){
    80004566:	05495a63          	bge	s2,s4,800045ba <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000456a:	2204a783          	lw	a5,544(s1)
    8000456e:	d3f1                	beqz	a5,80004532 <pipewrite+0x46>
    80004570:	854e                	mv	a0,s3
    80004572:	c9bfd0ef          	jal	8000220c <killed>
    80004576:	fd55                	bnez	a0,80004532 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004578:	2184a783          	lw	a5,536(s1)
    8000457c:	21c4a703          	lw	a4,540(s1)
    80004580:	2007879b          	addiw	a5,a5,512
    80004584:	fcf70ae3          	beq	a4,a5,80004558 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004588:	86de                	mv	a3,s7
    8000458a:	01590633          	add	a2,s2,s5
    8000458e:	85e2                	mv	a1,s8
    80004590:	0509b503          	ld	a0,80(s3)
    80004594:	8a8fd0ef          	jal	8000163c <copyin>
    80004598:	05650063          	beq	a0,s6,800045d8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000459c:	21c4a783          	lw	a5,540(s1)
    800045a0:	0017871b          	addiw	a4,a5,1
    800045a4:	20e4ae23          	sw	a4,540(s1)
    800045a8:	1ff7f793          	andi	a5,a5,511
    800045ac:	97a6                	add	a5,a5,s1
    800045ae:	f9f44703          	lbu	a4,-97(s0)
    800045b2:	00e78c23          	sb	a4,24(a5)
      i++;
    800045b6:	2905                	addiw	s2,s2,1
    800045b8:	b77d                	j	80004566 <pipewrite+0x7a>
    800045ba:	7b42                	ld	s6,48(sp)
    800045bc:	7ba2                	ld	s7,40(sp)
    800045be:	7c02                	ld	s8,32(sp)
    800045c0:	6ce2                	ld	s9,24(sp)
    800045c2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800045c4:	21848513          	addi	a0,s1,536
    800045c8:	a59fd0ef          	jal	80002020 <wakeup>
  release(&pi->lock);
    800045cc:	8526                	mv	a0,s1
    800045ce:	ebcfc0ef          	jal	80000c8a <release>
  return i;
    800045d2:	bf8d                	j	80004544 <pipewrite+0x58>
  int i = 0;
    800045d4:	4901                	li	s2,0
    800045d6:	b7fd                	j	800045c4 <pipewrite+0xd8>
    800045d8:	7b42                	ld	s6,48(sp)
    800045da:	7ba2                	ld	s7,40(sp)
    800045dc:	7c02                	ld	s8,32(sp)
    800045de:	6ce2                	ld	s9,24(sp)
    800045e0:	6d42                	ld	s10,16(sp)
    800045e2:	b7cd                	j	800045c4 <pipewrite+0xd8>

00000000800045e4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800045e4:	711d                	addi	sp,sp,-96
    800045e6:	ec86                	sd	ra,88(sp)
    800045e8:	e8a2                	sd	s0,80(sp)
    800045ea:	e4a6                	sd	s1,72(sp)
    800045ec:	e0ca                	sd	s2,64(sp)
    800045ee:	fc4e                	sd	s3,56(sp)
    800045f0:	f852                	sd	s4,48(sp)
    800045f2:	f456                	sd	s5,40(sp)
    800045f4:	1080                	addi	s0,sp,96
    800045f6:	84aa                	mv	s1,a0
    800045f8:	892e                	mv	s2,a1
    800045fa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800045fc:	bd0fd0ef          	jal	800019cc <myproc>
    80004600:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004602:	8526                	mv	a0,s1
    80004604:	df2fc0ef          	jal	80000bf6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004608:	2184a703          	lw	a4,536(s1)
    8000460c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004610:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004614:	02f71763          	bne	a4,a5,80004642 <piperead+0x5e>
    80004618:	2244a783          	lw	a5,548(s1)
    8000461c:	cf85                	beqz	a5,80004654 <piperead+0x70>
    if(killed(pr)){
    8000461e:	8552                	mv	a0,s4
    80004620:	bedfd0ef          	jal	8000220c <killed>
    80004624:	e11d                	bnez	a0,8000464a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004626:	85a6                	mv	a1,s1
    80004628:	854e                	mv	a0,s3
    8000462a:	9abfd0ef          	jal	80001fd4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000462e:	2184a703          	lw	a4,536(s1)
    80004632:	21c4a783          	lw	a5,540(s1)
    80004636:	fef701e3          	beq	a4,a5,80004618 <piperead+0x34>
    8000463a:	f05a                	sd	s6,32(sp)
    8000463c:	ec5e                	sd	s7,24(sp)
    8000463e:	e862                	sd	s8,16(sp)
    80004640:	a829                	j	8000465a <piperead+0x76>
    80004642:	f05a                	sd	s6,32(sp)
    80004644:	ec5e                	sd	s7,24(sp)
    80004646:	e862                	sd	s8,16(sp)
    80004648:	a809                	j	8000465a <piperead+0x76>
      release(&pi->lock);
    8000464a:	8526                	mv	a0,s1
    8000464c:	e3efc0ef          	jal	80000c8a <release>
      return -1;
    80004650:	59fd                	li	s3,-1
    80004652:	a0a5                	j	800046ba <piperead+0xd6>
    80004654:	f05a                	sd	s6,32(sp)
    80004656:	ec5e                	sd	s7,24(sp)
    80004658:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000465a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000465c:	faf40c13          	addi	s8,s0,-81
    80004660:	4b85                	li	s7,1
    80004662:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004664:	05505163          	blez	s5,800046a6 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80004668:	2184a783          	lw	a5,536(s1)
    8000466c:	21c4a703          	lw	a4,540(s1)
    80004670:	02f70b63          	beq	a4,a5,800046a6 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004674:	0017871b          	addiw	a4,a5,1
    80004678:	20e4ac23          	sw	a4,536(s1)
    8000467c:	1ff7f793          	andi	a5,a5,511
    80004680:	97a6                	add	a5,a5,s1
    80004682:	0187c783          	lbu	a5,24(a5)
    80004686:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000468a:	86de                	mv	a3,s7
    8000468c:	8662                	mv	a2,s8
    8000468e:	85ca                	mv	a1,s2
    80004690:	050a3503          	ld	a0,80(s4)
    80004694:	ef9fc0ef          	jal	8000158c <copyout>
    80004698:	01650763          	beq	a0,s6,800046a6 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000469c:	2985                	addiw	s3,s3,1
    8000469e:	0905                	addi	s2,s2,1
    800046a0:	fd3a94e3          	bne	s5,s3,80004668 <piperead+0x84>
    800046a4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800046a6:	21c48513          	addi	a0,s1,540
    800046aa:	977fd0ef          	jal	80002020 <wakeup>
  release(&pi->lock);
    800046ae:	8526                	mv	a0,s1
    800046b0:	ddafc0ef          	jal	80000c8a <release>
    800046b4:	7b02                	ld	s6,32(sp)
    800046b6:	6be2                	ld	s7,24(sp)
    800046b8:	6c42                	ld	s8,16(sp)
  return i;
}
    800046ba:	854e                	mv	a0,s3
    800046bc:	60e6                	ld	ra,88(sp)
    800046be:	6446                	ld	s0,80(sp)
    800046c0:	64a6                	ld	s1,72(sp)
    800046c2:	6906                	ld	s2,64(sp)
    800046c4:	79e2                	ld	s3,56(sp)
    800046c6:	7a42                	ld	s4,48(sp)
    800046c8:	7aa2                	ld	s5,40(sp)
    800046ca:	6125                	addi	sp,sp,96
    800046cc:	8082                	ret

00000000800046ce <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800046ce:	1141                	addi	sp,sp,-16
    800046d0:	e406                	sd	ra,8(sp)
    800046d2:	e022                	sd	s0,0(sp)
    800046d4:	0800                	addi	s0,sp,16
    800046d6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800046d8:	0035151b          	slliw	a0,a0,0x3
    800046dc:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800046de:	8b89                	andi	a5,a5,2
    800046e0:	c399                	beqz	a5,800046e6 <flags2perm+0x18>
      perm |= PTE_W;
    800046e2:	00456513          	ori	a0,a0,4
    return perm;
}
    800046e6:	60a2                	ld	ra,8(sp)
    800046e8:	6402                	ld	s0,0(sp)
    800046ea:	0141                	addi	sp,sp,16
    800046ec:	8082                	ret

00000000800046ee <exec>:

int
exec(char *path, char **argv)
{
    800046ee:	de010113          	addi	sp,sp,-544
    800046f2:	20113c23          	sd	ra,536(sp)
    800046f6:	20813823          	sd	s0,528(sp)
    800046fa:	20913423          	sd	s1,520(sp)
    800046fe:	21213023          	sd	s2,512(sp)
    80004702:	1400                	addi	s0,sp,544
    80004704:	892a                	mv	s2,a0
    80004706:	dea43823          	sd	a0,-528(s0)
    8000470a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000470e:	abefd0ef          	jal	800019cc <myproc>
    80004712:	84aa                	mv	s1,a0

  begin_op();
    80004714:	d88ff0ef          	jal	80003c9c <begin_op>

  if((ip = namei(path)) == 0){
    80004718:	854a                	mv	a0,s2
    8000471a:	bc0ff0ef          	jal	80003ada <namei>
    8000471e:	cd21                	beqz	a0,80004776 <exec+0x88>
    80004720:	fbd2                	sd	s4,496(sp)
    80004722:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004724:	cc7fe0ef          	jal	800033ea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004728:	04000713          	li	a4,64
    8000472c:	4681                	li	a3,0
    8000472e:	e5040613          	addi	a2,s0,-432
    80004732:	4581                	li	a1,0
    80004734:	8552                	mv	a0,s4
    80004736:	f0dfe0ef          	jal	80003642 <readi>
    8000473a:	04000793          	li	a5,64
    8000473e:	00f51a63          	bne	a0,a5,80004752 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004742:	e5042703          	lw	a4,-432(s0)
    80004746:	464c47b7          	lui	a5,0x464c4
    8000474a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000474e:	02f70863          	beq	a4,a5,8000477e <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004752:	8552                	mv	a0,s4
    80004754:	ea1fe0ef          	jal	800035f4 <iunlockput>
    end_op();
    80004758:	daeff0ef          	jal	80003d06 <end_op>
  }
  return -1;
    8000475c:	557d                	li	a0,-1
    8000475e:	7a5e                	ld	s4,496(sp)
}
    80004760:	21813083          	ld	ra,536(sp)
    80004764:	21013403          	ld	s0,528(sp)
    80004768:	20813483          	ld	s1,520(sp)
    8000476c:	20013903          	ld	s2,512(sp)
    80004770:	22010113          	addi	sp,sp,544
    80004774:	8082                	ret
    end_op();
    80004776:	d90ff0ef          	jal	80003d06 <end_op>
    return -1;
    8000477a:	557d                	li	a0,-1
    8000477c:	b7d5                	j	80004760 <exec+0x72>
    8000477e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004780:	8526                	mv	a0,s1
    80004782:	b2afd0ef          	jal	80001aac <proc_pagetable>
    80004786:	8b2a                	mv	s6,a0
    80004788:	26050d63          	beqz	a0,80004a02 <exec+0x314>
    8000478c:	ffce                	sd	s3,504(sp)
    8000478e:	f7d6                	sd	s5,488(sp)
    80004790:	efde                	sd	s7,472(sp)
    80004792:	ebe2                	sd	s8,464(sp)
    80004794:	e7e6                	sd	s9,456(sp)
    80004796:	e3ea                	sd	s10,448(sp)
    80004798:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000479a:	e7042683          	lw	a3,-400(s0)
    8000479e:	e8845783          	lhu	a5,-376(s0)
    800047a2:	0e078763          	beqz	a5,80004890 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047a6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800047a8:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800047aa:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800047ae:	6c85                	lui	s9,0x1
    800047b0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800047b4:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800047b8:	6a85                	lui	s5,0x1
    800047ba:	a085                	j	8000481a <exec+0x12c>
      panic("loadseg: address should exist");
    800047bc:	00003517          	auipc	a0,0x3
    800047c0:	eb450513          	addi	a0,a0,-332 # 80007670 <etext+0x670>
    800047c4:	fdbfb0ef          	jal	8000079e <panic>
    if(sz - i < PGSIZE)
    800047c8:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800047ca:	874a                	mv	a4,s2
    800047cc:	009c06bb          	addw	a3,s8,s1
    800047d0:	4581                	li	a1,0
    800047d2:	8552                	mv	a0,s4
    800047d4:	e6ffe0ef          	jal	80003642 <readi>
    800047d8:	22a91963          	bne	s2,a0,80004a0a <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    800047dc:	009a84bb          	addw	s1,s5,s1
    800047e0:	0334f263          	bgeu	s1,s3,80004804 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    800047e4:	02049593          	slli	a1,s1,0x20
    800047e8:	9181                	srli	a1,a1,0x20
    800047ea:	95de                	add	a1,a1,s7
    800047ec:	855a                	mv	a0,s6
    800047ee:	817fc0ef          	jal	80001004 <walkaddr>
    800047f2:	862a                	mv	a2,a0
    if(pa == 0)
    800047f4:	d561                	beqz	a0,800047bc <exec+0xce>
    if(sz - i < PGSIZE)
    800047f6:	409987bb          	subw	a5,s3,s1
    800047fa:	893e                	mv	s2,a5
    800047fc:	fcfcf6e3          	bgeu	s9,a5,800047c8 <exec+0xda>
    80004800:	8956                	mv	s2,s5
    80004802:	b7d9                	j	800047c8 <exec+0xda>
    sz = sz1;
    80004804:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004808:	2d05                	addiw	s10,s10,1
    8000480a:	e0843783          	ld	a5,-504(s0)
    8000480e:	0387869b          	addiw	a3,a5,56
    80004812:	e8845783          	lhu	a5,-376(s0)
    80004816:	06fd5e63          	bge	s10,a5,80004892 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000481a:	e0d43423          	sd	a3,-504(s0)
    8000481e:	876e                	mv	a4,s11
    80004820:	e1840613          	addi	a2,s0,-488
    80004824:	4581                	li	a1,0
    80004826:	8552                	mv	a0,s4
    80004828:	e1bfe0ef          	jal	80003642 <readi>
    8000482c:	1db51d63          	bne	a0,s11,80004a06 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80004830:	e1842783          	lw	a5,-488(s0)
    80004834:	4705                	li	a4,1
    80004836:	fce799e3          	bne	a5,a4,80004808 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    8000483a:	e4043483          	ld	s1,-448(s0)
    8000483e:	e3843783          	ld	a5,-456(s0)
    80004842:	1ef4e263          	bltu	s1,a5,80004a26 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004846:	e2843783          	ld	a5,-472(s0)
    8000484a:	94be                	add	s1,s1,a5
    8000484c:	1ef4e063          	bltu	s1,a5,80004a2c <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80004850:	de843703          	ld	a4,-536(s0)
    80004854:	8ff9                	and	a5,a5,a4
    80004856:	1c079e63          	bnez	a5,80004a32 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000485a:	e1c42503          	lw	a0,-484(s0)
    8000485e:	e71ff0ef          	jal	800046ce <flags2perm>
    80004862:	86aa                	mv	a3,a0
    80004864:	8626                	mv	a2,s1
    80004866:	85ca                	mv	a1,s2
    80004868:	855a                	mv	a0,s6
    8000486a:	b03fc0ef          	jal	8000136c <uvmalloc>
    8000486e:	dea43c23          	sd	a0,-520(s0)
    80004872:	1c050363          	beqz	a0,80004a38 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004876:	e2843b83          	ld	s7,-472(s0)
    8000487a:	e2042c03          	lw	s8,-480(s0)
    8000487e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004882:	00098463          	beqz	s3,8000488a <exec+0x19c>
    80004886:	4481                	li	s1,0
    80004888:	bfb1                	j	800047e4 <exec+0xf6>
    sz = sz1;
    8000488a:	df843903          	ld	s2,-520(s0)
    8000488e:	bfad                	j	80004808 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004890:	4901                	li	s2,0
  iunlockput(ip);
    80004892:	8552                	mv	a0,s4
    80004894:	d61fe0ef          	jal	800035f4 <iunlockput>
  end_op();
    80004898:	c6eff0ef          	jal	80003d06 <end_op>
  p = myproc();
    8000489c:	930fd0ef          	jal	800019cc <myproc>
    800048a0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800048a2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800048a6:	6985                	lui	s3,0x1
    800048a8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800048aa:	99ca                	add	s3,s3,s2
    800048ac:	77fd                	lui	a5,0xfffff
    800048ae:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800048b2:	4691                	li	a3,4
    800048b4:	6609                	lui	a2,0x2
    800048b6:	964e                	add	a2,a2,s3
    800048b8:	85ce                	mv	a1,s3
    800048ba:	855a                	mv	a0,s6
    800048bc:	ab1fc0ef          	jal	8000136c <uvmalloc>
    800048c0:	8a2a                	mv	s4,a0
    800048c2:	e105                	bnez	a0,800048e2 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800048c4:	85ce                	mv	a1,s3
    800048c6:	855a                	mv	a0,s6
    800048c8:	a68fd0ef          	jal	80001b30 <proc_freepagetable>
  return -1;
    800048cc:	557d                	li	a0,-1
    800048ce:	79fe                	ld	s3,504(sp)
    800048d0:	7a5e                	ld	s4,496(sp)
    800048d2:	7abe                	ld	s5,488(sp)
    800048d4:	7b1e                	ld	s6,480(sp)
    800048d6:	6bfe                	ld	s7,472(sp)
    800048d8:	6c5e                	ld	s8,464(sp)
    800048da:	6cbe                	ld	s9,456(sp)
    800048dc:	6d1e                	ld	s10,448(sp)
    800048de:	7dfa                	ld	s11,440(sp)
    800048e0:	b541                	j	80004760 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800048e2:	75f9                	lui	a1,0xffffe
    800048e4:	95aa                	add	a1,a1,a0
    800048e6:	855a                	mv	a0,s6
    800048e8:	c7bfc0ef          	jal	80001562 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800048ec:	7bfd                	lui	s7,0xfffff
    800048ee:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800048f0:	e0043783          	ld	a5,-512(s0)
    800048f4:	6388                	ld	a0,0(a5)
  sp = sz;
    800048f6:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800048f8:	4481                	li	s1,0
    ustack[argc] = sp;
    800048fa:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800048fe:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004902:	cd21                	beqz	a0,8000495a <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80004904:	d4afc0ef          	jal	80000e4e <strlen>
    80004908:	0015079b          	addiw	a5,a0,1
    8000490c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004910:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004914:	13796563          	bltu	s2,s7,80004a3e <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004918:	e0043d83          	ld	s11,-512(s0)
    8000491c:	000db983          	ld	s3,0(s11)
    80004920:	854e                	mv	a0,s3
    80004922:	d2cfc0ef          	jal	80000e4e <strlen>
    80004926:	0015069b          	addiw	a3,a0,1
    8000492a:	864e                	mv	a2,s3
    8000492c:	85ca                	mv	a1,s2
    8000492e:	855a                	mv	a0,s6
    80004930:	c5dfc0ef          	jal	8000158c <copyout>
    80004934:	10054763          	bltz	a0,80004a42 <exec+0x354>
    ustack[argc] = sp;
    80004938:	00349793          	slli	a5,s1,0x3
    8000493c:	97e6                	add	a5,a5,s9
    8000493e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff8e138>
  for(argc = 0; argv[argc]; argc++) {
    80004942:	0485                	addi	s1,s1,1
    80004944:	008d8793          	addi	a5,s11,8
    80004948:	e0f43023          	sd	a5,-512(s0)
    8000494c:	008db503          	ld	a0,8(s11)
    80004950:	c509                	beqz	a0,8000495a <exec+0x26c>
    if(argc >= MAXARG)
    80004952:	fb8499e3          	bne	s1,s8,80004904 <exec+0x216>
  sz = sz1;
    80004956:	89d2                	mv	s3,s4
    80004958:	b7b5                	j	800048c4 <exec+0x1d6>
  ustack[argc] = 0;
    8000495a:	00349793          	slli	a5,s1,0x3
    8000495e:	f9078793          	addi	a5,a5,-112
    80004962:	97a2                	add	a5,a5,s0
    80004964:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004968:	00148693          	addi	a3,s1,1
    8000496c:	068e                	slli	a3,a3,0x3
    8000496e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004972:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004976:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004978:	f57966e3          	bltu	s2,s7,800048c4 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000497c:	e9040613          	addi	a2,s0,-368
    80004980:	85ca                	mv	a1,s2
    80004982:	855a                	mv	a0,s6
    80004984:	c09fc0ef          	jal	8000158c <copyout>
    80004988:	f2054ee3          	bltz	a0,800048c4 <exec+0x1d6>
  p->trapframe->a1 = sp;
    8000498c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004990:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004994:	df043783          	ld	a5,-528(s0)
    80004998:	0007c703          	lbu	a4,0(a5)
    8000499c:	cf11                	beqz	a4,800049b8 <exec+0x2ca>
    8000499e:	0785                	addi	a5,a5,1
    if(*s == '/')
    800049a0:	02f00693          	li	a3,47
    800049a4:	a029                	j	800049ae <exec+0x2c0>
  for(last=s=path; *s; s++)
    800049a6:	0785                	addi	a5,a5,1
    800049a8:	fff7c703          	lbu	a4,-1(a5)
    800049ac:	c711                	beqz	a4,800049b8 <exec+0x2ca>
    if(*s == '/')
    800049ae:	fed71ce3          	bne	a4,a3,800049a6 <exec+0x2b8>
      last = s+1;
    800049b2:	def43823          	sd	a5,-528(s0)
    800049b6:	bfc5                	j	800049a6 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    800049b8:	4641                	li	a2,16
    800049ba:	df043583          	ld	a1,-528(s0)
    800049be:	158a8513          	addi	a0,s5,344
    800049c2:	c56fc0ef          	jal	80000e18 <safestrcpy>
  oldpagetable = p->pagetable;
    800049c6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800049ca:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800049ce:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800049d2:	058ab783          	ld	a5,88(s5)
    800049d6:	e6843703          	ld	a4,-408(s0)
    800049da:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800049dc:	058ab783          	ld	a5,88(s5)
    800049e0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800049e4:	85ea                	mv	a1,s10
    800049e6:	94afd0ef          	jal	80001b30 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800049ea:	0004851b          	sext.w	a0,s1
    800049ee:	79fe                	ld	s3,504(sp)
    800049f0:	7a5e                	ld	s4,496(sp)
    800049f2:	7abe                	ld	s5,488(sp)
    800049f4:	7b1e                	ld	s6,480(sp)
    800049f6:	6bfe                	ld	s7,472(sp)
    800049f8:	6c5e                	ld	s8,464(sp)
    800049fa:	6cbe                	ld	s9,456(sp)
    800049fc:	6d1e                	ld	s10,448(sp)
    800049fe:	7dfa                	ld	s11,440(sp)
    80004a00:	b385                	j	80004760 <exec+0x72>
    80004a02:	7b1e                	ld	s6,480(sp)
    80004a04:	b3b9                	j	80004752 <exec+0x64>
    80004a06:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004a0a:	df843583          	ld	a1,-520(s0)
    80004a0e:	855a                	mv	a0,s6
    80004a10:	920fd0ef          	jal	80001b30 <proc_freepagetable>
  if(ip){
    80004a14:	79fe                	ld	s3,504(sp)
    80004a16:	7abe                	ld	s5,488(sp)
    80004a18:	7b1e                	ld	s6,480(sp)
    80004a1a:	6bfe                	ld	s7,472(sp)
    80004a1c:	6c5e                	ld	s8,464(sp)
    80004a1e:	6cbe                	ld	s9,456(sp)
    80004a20:	6d1e                	ld	s10,448(sp)
    80004a22:	7dfa                	ld	s11,440(sp)
    80004a24:	b33d                	j	80004752 <exec+0x64>
    80004a26:	df243c23          	sd	s2,-520(s0)
    80004a2a:	b7c5                	j	80004a0a <exec+0x31c>
    80004a2c:	df243c23          	sd	s2,-520(s0)
    80004a30:	bfe9                	j	80004a0a <exec+0x31c>
    80004a32:	df243c23          	sd	s2,-520(s0)
    80004a36:	bfd1                	j	80004a0a <exec+0x31c>
    80004a38:	df243c23          	sd	s2,-520(s0)
    80004a3c:	b7f9                	j	80004a0a <exec+0x31c>
  sz = sz1;
    80004a3e:	89d2                	mv	s3,s4
    80004a40:	b551                	j	800048c4 <exec+0x1d6>
    80004a42:	89d2                	mv	s3,s4
    80004a44:	b541                	j	800048c4 <exec+0x1d6>

0000000080004a46 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004a46:	7179                	addi	sp,sp,-48
    80004a48:	f406                	sd	ra,40(sp)
    80004a4a:	f022                	sd	s0,32(sp)
    80004a4c:	ec26                	sd	s1,24(sp)
    80004a4e:	e84a                	sd	s2,16(sp)
    80004a50:	1800                	addi	s0,sp,48
    80004a52:	892e                	mv	s2,a1
    80004a54:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a56:	fdc40593          	addi	a1,s0,-36
    80004a5a:	f05fd0ef          	jal	8000295e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004a5e:	fdc42703          	lw	a4,-36(s0)
    80004a62:	47bd                	li	a5,15
    80004a64:	02e7e963          	bltu	a5,a4,80004a96 <argfd+0x50>
    80004a68:	f65fc0ef          	jal	800019cc <myproc>
    80004a6c:	fdc42703          	lw	a4,-36(s0)
    80004a70:	01a70793          	addi	a5,a4,26
    80004a74:	078e                	slli	a5,a5,0x3
    80004a76:	953e                	add	a0,a0,a5
    80004a78:	611c                	ld	a5,0(a0)
    80004a7a:	c385                	beqz	a5,80004a9a <argfd+0x54>
    return -1;
  if(pfd)
    80004a7c:	00090463          	beqz	s2,80004a84 <argfd+0x3e>
    *pfd = fd;
    80004a80:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004a84:	4501                	li	a0,0
  if(pf)
    80004a86:	c091                	beqz	s1,80004a8a <argfd+0x44>
    *pf = f;
    80004a88:	e09c                	sd	a5,0(s1)
}
    80004a8a:	70a2                	ld	ra,40(sp)
    80004a8c:	7402                	ld	s0,32(sp)
    80004a8e:	64e2                	ld	s1,24(sp)
    80004a90:	6942                	ld	s2,16(sp)
    80004a92:	6145                	addi	sp,sp,48
    80004a94:	8082                	ret
    return -1;
    80004a96:	557d                	li	a0,-1
    80004a98:	bfcd                	j	80004a8a <argfd+0x44>
    80004a9a:	557d                	li	a0,-1
    80004a9c:	b7fd                	j	80004a8a <argfd+0x44>

0000000080004a9e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a9e:	1101                	addi	sp,sp,-32
    80004aa0:	ec06                	sd	ra,24(sp)
    80004aa2:	e822                	sd	s0,16(sp)
    80004aa4:	e426                	sd	s1,8(sp)
    80004aa6:	1000                	addi	s0,sp,32
    80004aa8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004aaa:	f23fc0ef          	jal	800019cc <myproc>
    80004aae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ab0:	0d050793          	addi	a5,a0,208
    80004ab4:	4501                	li	a0,0
    80004ab6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004ab8:	6398                	ld	a4,0(a5)
    80004aba:	cb19                	beqz	a4,80004ad0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004abc:	2505                	addiw	a0,a0,1
    80004abe:	07a1                	addi	a5,a5,8
    80004ac0:	fed51ce3          	bne	a0,a3,80004ab8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004ac4:	557d                	li	a0,-1
}
    80004ac6:	60e2                	ld	ra,24(sp)
    80004ac8:	6442                	ld	s0,16(sp)
    80004aca:	64a2                	ld	s1,8(sp)
    80004acc:	6105                	addi	sp,sp,32
    80004ace:	8082                	ret
      p->ofile[fd] = f;
    80004ad0:	01a50793          	addi	a5,a0,26
    80004ad4:	078e                	slli	a5,a5,0x3
    80004ad6:	963e                	add	a2,a2,a5
    80004ad8:	e204                	sd	s1,0(a2)
      return fd;
    80004ada:	b7f5                	j	80004ac6 <fdalloc+0x28>

0000000080004adc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004adc:	715d                	addi	sp,sp,-80
    80004ade:	e486                	sd	ra,72(sp)
    80004ae0:	e0a2                	sd	s0,64(sp)
    80004ae2:	fc26                	sd	s1,56(sp)
    80004ae4:	f84a                	sd	s2,48(sp)
    80004ae6:	f44e                	sd	s3,40(sp)
    80004ae8:	ec56                	sd	s5,24(sp)
    80004aea:	e85a                	sd	s6,16(sp)
    80004aec:	0880                	addi	s0,sp,80
    80004aee:	8b2e                	mv	s6,a1
    80004af0:	89b2                	mv	s3,a2
    80004af2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004af4:	fb040593          	addi	a1,s0,-80
    80004af8:	ffdfe0ef          	jal	80003af4 <nameiparent>
    80004afc:	84aa                	mv	s1,a0
    80004afe:	10050a63          	beqz	a0,80004c12 <create+0x136>
    return 0;

  ilock(dp);
    80004b02:	8e9fe0ef          	jal	800033ea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004b06:	4601                	li	a2,0
    80004b08:	fb040593          	addi	a1,s0,-80
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	d41fe0ef          	jal	8000384e <dirlookup>
    80004b12:	8aaa                	mv	s5,a0
    80004b14:	c129                	beqz	a0,80004b56 <create+0x7a>
    iunlockput(dp);
    80004b16:	8526                	mv	a0,s1
    80004b18:	addfe0ef          	jal	800035f4 <iunlockput>
    ilock(ip);
    80004b1c:	8556                	mv	a0,s5
    80004b1e:	8cdfe0ef          	jal	800033ea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004b22:	4789                	li	a5,2
    80004b24:	02fb1463          	bne	s6,a5,80004b4c <create+0x70>
    80004b28:	044ad783          	lhu	a5,68(s5)
    80004b2c:	37f9                	addiw	a5,a5,-2
    80004b2e:	17c2                	slli	a5,a5,0x30
    80004b30:	93c1                	srli	a5,a5,0x30
    80004b32:	4705                	li	a4,1
    80004b34:	00f76c63          	bltu	a4,a5,80004b4c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004b38:	8556                	mv	a0,s5
    80004b3a:	60a6                	ld	ra,72(sp)
    80004b3c:	6406                	ld	s0,64(sp)
    80004b3e:	74e2                	ld	s1,56(sp)
    80004b40:	7942                	ld	s2,48(sp)
    80004b42:	79a2                	ld	s3,40(sp)
    80004b44:	6ae2                	ld	s5,24(sp)
    80004b46:	6b42                	ld	s6,16(sp)
    80004b48:	6161                	addi	sp,sp,80
    80004b4a:	8082                	ret
    iunlockput(ip);
    80004b4c:	8556                	mv	a0,s5
    80004b4e:	aa7fe0ef          	jal	800035f4 <iunlockput>
    return 0;
    80004b52:	4a81                	li	s5,0
    80004b54:	b7d5                	j	80004b38 <create+0x5c>
    80004b56:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004b58:	85da                	mv	a1,s6
    80004b5a:	4088                	lw	a0,0(s1)
    80004b5c:	f1efe0ef          	jal	8000327a <ialloc>
    80004b60:	8a2a                	mv	s4,a0
    80004b62:	cd15                	beqz	a0,80004b9e <create+0xc2>
  ilock(ip);
    80004b64:	887fe0ef          	jal	800033ea <ilock>
  ip->major = major;
    80004b68:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004b6c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004b70:	4905                	li	s2,1
    80004b72:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004b76:	8552                	mv	a0,s4
    80004b78:	fbefe0ef          	jal	80003336 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004b7c:	032b0763          	beq	s6,s2,80004baa <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b80:	004a2603          	lw	a2,4(s4)
    80004b84:	fb040593          	addi	a1,s0,-80
    80004b88:	8526                	mv	a0,s1
    80004b8a:	ea7fe0ef          	jal	80003a30 <dirlink>
    80004b8e:	06054563          	bltz	a0,80004bf8 <create+0x11c>
  iunlockput(dp);
    80004b92:	8526                	mv	a0,s1
    80004b94:	a61fe0ef          	jal	800035f4 <iunlockput>
  return ip;
    80004b98:	8ad2                	mv	s5,s4
    80004b9a:	7a02                	ld	s4,32(sp)
    80004b9c:	bf71                	j	80004b38 <create+0x5c>
    iunlockput(dp);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	a55fe0ef          	jal	800035f4 <iunlockput>
    return 0;
    80004ba4:	8ad2                	mv	s5,s4
    80004ba6:	7a02                	ld	s4,32(sp)
    80004ba8:	bf41                	j	80004b38 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004baa:	004a2603          	lw	a2,4(s4)
    80004bae:	00003597          	auipc	a1,0x3
    80004bb2:	ae258593          	addi	a1,a1,-1310 # 80007690 <etext+0x690>
    80004bb6:	8552                	mv	a0,s4
    80004bb8:	e79fe0ef          	jal	80003a30 <dirlink>
    80004bbc:	02054e63          	bltz	a0,80004bf8 <create+0x11c>
    80004bc0:	40d0                	lw	a2,4(s1)
    80004bc2:	00003597          	auipc	a1,0x3
    80004bc6:	ad658593          	addi	a1,a1,-1322 # 80007698 <etext+0x698>
    80004bca:	8552                	mv	a0,s4
    80004bcc:	e65fe0ef          	jal	80003a30 <dirlink>
    80004bd0:	02054463          	bltz	a0,80004bf8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004bd4:	004a2603          	lw	a2,4(s4)
    80004bd8:	fb040593          	addi	a1,s0,-80
    80004bdc:	8526                	mv	a0,s1
    80004bde:	e53fe0ef          	jal	80003a30 <dirlink>
    80004be2:	00054b63          	bltz	a0,80004bf8 <create+0x11c>
    dp->nlink++;  // for ".."
    80004be6:	04a4d783          	lhu	a5,74(s1)
    80004bea:	2785                	addiw	a5,a5,1
    80004bec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	f44fe0ef          	jal	80003336 <iupdate>
    80004bf6:	bf71                	j	80004b92 <create+0xb6>
  ip->nlink = 0;
    80004bf8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004bfc:	8552                	mv	a0,s4
    80004bfe:	f38fe0ef          	jal	80003336 <iupdate>
  iunlockput(ip);
    80004c02:	8552                	mv	a0,s4
    80004c04:	9f1fe0ef          	jal	800035f4 <iunlockput>
  iunlockput(dp);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	9ebfe0ef          	jal	800035f4 <iunlockput>
  return 0;
    80004c0e:	7a02                	ld	s4,32(sp)
    80004c10:	b725                	j	80004b38 <create+0x5c>
    return 0;
    80004c12:	8aaa                	mv	s5,a0
    80004c14:	b715                	j	80004b38 <create+0x5c>

0000000080004c16 <sys_dup>:
{
    80004c16:	7179                	addi	sp,sp,-48
    80004c18:	f406                	sd	ra,40(sp)
    80004c1a:	f022                	sd	s0,32(sp)
    80004c1c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004c1e:	fd840613          	addi	a2,s0,-40
    80004c22:	4581                	li	a1,0
    80004c24:	4501                	li	a0,0
    80004c26:	e21ff0ef          	jal	80004a46 <argfd>
    return -1;
    80004c2a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004c2c:	02054363          	bltz	a0,80004c52 <sys_dup+0x3c>
    80004c30:	ec26                	sd	s1,24(sp)
    80004c32:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004c34:	fd843903          	ld	s2,-40(s0)
    80004c38:	854a                	mv	a0,s2
    80004c3a:	e65ff0ef          	jal	80004a9e <fdalloc>
    80004c3e:	84aa                	mv	s1,a0
    return -1;
    80004c40:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004c42:	00054d63          	bltz	a0,80004c5c <sys_dup+0x46>
  filedup(f);
    80004c46:	854a                	mv	a0,s2
    80004c48:	c2eff0ef          	jal	80004076 <filedup>
  return fd;
    80004c4c:	87a6                	mv	a5,s1
    80004c4e:	64e2                	ld	s1,24(sp)
    80004c50:	6942                	ld	s2,16(sp)
}
    80004c52:	853e                	mv	a0,a5
    80004c54:	70a2                	ld	ra,40(sp)
    80004c56:	7402                	ld	s0,32(sp)
    80004c58:	6145                	addi	sp,sp,48
    80004c5a:	8082                	ret
    80004c5c:	64e2                	ld	s1,24(sp)
    80004c5e:	6942                	ld	s2,16(sp)
    80004c60:	bfcd                	j	80004c52 <sys_dup+0x3c>

0000000080004c62 <sys_read>:
{
    80004c62:	7179                	addi	sp,sp,-48
    80004c64:	f406                	sd	ra,40(sp)
    80004c66:	f022                	sd	s0,32(sp)
    80004c68:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c6a:	fd840593          	addi	a1,s0,-40
    80004c6e:	4505                	li	a0,1
    80004c70:	d0bfd0ef          	jal	8000297a <argaddr>
  argint(2, &n);
    80004c74:	fe440593          	addi	a1,s0,-28
    80004c78:	4509                	li	a0,2
    80004c7a:	ce5fd0ef          	jal	8000295e <argint>
  if(argfd(0, 0, &f) < 0)
    80004c7e:	fe840613          	addi	a2,s0,-24
    80004c82:	4581                	li	a1,0
    80004c84:	4501                	li	a0,0
    80004c86:	dc1ff0ef          	jal	80004a46 <argfd>
    80004c8a:	87aa                	mv	a5,a0
    return -1;
    80004c8c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c8e:	0007ca63          	bltz	a5,80004ca2 <sys_read+0x40>
  return fileread(f, p, n);
    80004c92:	fe442603          	lw	a2,-28(s0)
    80004c96:	fd843583          	ld	a1,-40(s0)
    80004c9a:	fe843503          	ld	a0,-24(s0)
    80004c9e:	d3eff0ef          	jal	800041dc <fileread>
}
    80004ca2:	70a2                	ld	ra,40(sp)
    80004ca4:	7402                	ld	s0,32(sp)
    80004ca6:	6145                	addi	sp,sp,48
    80004ca8:	8082                	ret

0000000080004caa <sys_write>:
{
    80004caa:	7179                	addi	sp,sp,-48
    80004cac:	f406                	sd	ra,40(sp)
    80004cae:	f022                	sd	s0,32(sp)
    80004cb0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004cb2:	fd840593          	addi	a1,s0,-40
    80004cb6:	4505                	li	a0,1
    80004cb8:	cc3fd0ef          	jal	8000297a <argaddr>
  argint(2, &n);
    80004cbc:	fe440593          	addi	a1,s0,-28
    80004cc0:	4509                	li	a0,2
    80004cc2:	c9dfd0ef          	jal	8000295e <argint>
  if(argfd(0, 0, &f) < 0)
    80004cc6:	fe840613          	addi	a2,s0,-24
    80004cca:	4581                	li	a1,0
    80004ccc:	4501                	li	a0,0
    80004cce:	d79ff0ef          	jal	80004a46 <argfd>
    80004cd2:	87aa                	mv	a5,a0
    return -1;
    80004cd4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cd6:	0007ca63          	bltz	a5,80004cea <sys_write+0x40>
  return filewrite(f, p, n);
    80004cda:	fe442603          	lw	a2,-28(s0)
    80004cde:	fd843583          	ld	a1,-40(s0)
    80004ce2:	fe843503          	ld	a0,-24(s0)
    80004ce6:	db4ff0ef          	jal	8000429a <filewrite>
}
    80004cea:	70a2                	ld	ra,40(sp)
    80004cec:	7402                	ld	s0,32(sp)
    80004cee:	6145                	addi	sp,sp,48
    80004cf0:	8082                	ret

0000000080004cf2 <sys_close>:
{
    80004cf2:	1101                	addi	sp,sp,-32
    80004cf4:	ec06                	sd	ra,24(sp)
    80004cf6:	e822                	sd	s0,16(sp)
    80004cf8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004cfa:	fe040613          	addi	a2,s0,-32
    80004cfe:	fec40593          	addi	a1,s0,-20
    80004d02:	4501                	li	a0,0
    80004d04:	d43ff0ef          	jal	80004a46 <argfd>
    return -1;
    80004d08:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004d0a:	02054063          	bltz	a0,80004d2a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004d0e:	cbffc0ef          	jal	800019cc <myproc>
    80004d12:	fec42783          	lw	a5,-20(s0)
    80004d16:	07e9                	addi	a5,a5,26
    80004d18:	078e                	slli	a5,a5,0x3
    80004d1a:	953e                	add	a0,a0,a5
    80004d1c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004d20:	fe043503          	ld	a0,-32(s0)
    80004d24:	b98ff0ef          	jal	800040bc <fileclose>
  return 0;
    80004d28:	4781                	li	a5,0
}
    80004d2a:	853e                	mv	a0,a5
    80004d2c:	60e2                	ld	ra,24(sp)
    80004d2e:	6442                	ld	s0,16(sp)
    80004d30:	6105                	addi	sp,sp,32
    80004d32:	8082                	ret

0000000080004d34 <sys_fstat>:
{
    80004d34:	1101                	addi	sp,sp,-32
    80004d36:	ec06                	sd	ra,24(sp)
    80004d38:	e822                	sd	s0,16(sp)
    80004d3a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004d3c:	fe040593          	addi	a1,s0,-32
    80004d40:	4505                	li	a0,1
    80004d42:	c39fd0ef          	jal	8000297a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004d46:	fe840613          	addi	a2,s0,-24
    80004d4a:	4581                	li	a1,0
    80004d4c:	4501                	li	a0,0
    80004d4e:	cf9ff0ef          	jal	80004a46 <argfd>
    80004d52:	87aa                	mv	a5,a0
    return -1;
    80004d54:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d56:	0007c863          	bltz	a5,80004d66 <sys_fstat+0x32>
  return filestat(f, st);
    80004d5a:	fe043583          	ld	a1,-32(s0)
    80004d5e:	fe843503          	ld	a0,-24(s0)
    80004d62:	c18ff0ef          	jal	8000417a <filestat>
}
    80004d66:	60e2                	ld	ra,24(sp)
    80004d68:	6442                	ld	s0,16(sp)
    80004d6a:	6105                	addi	sp,sp,32
    80004d6c:	8082                	ret

0000000080004d6e <sys_link>:
{
    80004d6e:	7169                	addi	sp,sp,-304
    80004d70:	f606                	sd	ra,296(sp)
    80004d72:	f222                	sd	s0,288(sp)
    80004d74:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d76:	08000613          	li	a2,128
    80004d7a:	ed040593          	addi	a1,s0,-304
    80004d7e:	4501                	li	a0,0
    80004d80:	c17fd0ef          	jal	80002996 <argstr>
    return -1;
    80004d84:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d86:	0c054e63          	bltz	a0,80004e62 <sys_link+0xf4>
    80004d8a:	08000613          	li	a2,128
    80004d8e:	f5040593          	addi	a1,s0,-176
    80004d92:	4505                	li	a0,1
    80004d94:	c03fd0ef          	jal	80002996 <argstr>
    return -1;
    80004d98:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d9a:	0c054463          	bltz	a0,80004e62 <sys_link+0xf4>
    80004d9e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004da0:	efdfe0ef          	jal	80003c9c <begin_op>
  if((ip = namei(old)) == 0){
    80004da4:	ed040513          	addi	a0,s0,-304
    80004da8:	d33fe0ef          	jal	80003ada <namei>
    80004dac:	84aa                	mv	s1,a0
    80004dae:	c53d                	beqz	a0,80004e1c <sys_link+0xae>
  ilock(ip);
    80004db0:	e3afe0ef          	jal	800033ea <ilock>
  if(ip->type == T_DIR){
    80004db4:	04449703          	lh	a4,68(s1)
    80004db8:	4785                	li	a5,1
    80004dba:	06f70663          	beq	a4,a5,80004e26 <sys_link+0xb8>
    80004dbe:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004dc0:	04a4d783          	lhu	a5,74(s1)
    80004dc4:	2785                	addiw	a5,a5,1
    80004dc6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dca:	8526                	mv	a0,s1
    80004dcc:	d6afe0ef          	jal	80003336 <iupdate>
  iunlock(ip);
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	ec6fe0ef          	jal	80003498 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004dd6:	fd040593          	addi	a1,s0,-48
    80004dda:	f5040513          	addi	a0,s0,-176
    80004dde:	d17fe0ef          	jal	80003af4 <nameiparent>
    80004de2:	892a                	mv	s2,a0
    80004de4:	cd21                	beqz	a0,80004e3c <sys_link+0xce>
  ilock(dp);
    80004de6:	e04fe0ef          	jal	800033ea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004dea:	00092703          	lw	a4,0(s2)
    80004dee:	409c                	lw	a5,0(s1)
    80004df0:	04f71363          	bne	a4,a5,80004e36 <sys_link+0xc8>
    80004df4:	40d0                	lw	a2,4(s1)
    80004df6:	fd040593          	addi	a1,s0,-48
    80004dfa:	854a                	mv	a0,s2
    80004dfc:	c35fe0ef          	jal	80003a30 <dirlink>
    80004e00:	02054b63          	bltz	a0,80004e36 <sys_link+0xc8>
  iunlockput(dp);
    80004e04:	854a                	mv	a0,s2
    80004e06:	feefe0ef          	jal	800035f4 <iunlockput>
  iput(ip);
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	f60fe0ef          	jal	8000356c <iput>
  end_op();
    80004e10:	ef7fe0ef          	jal	80003d06 <end_op>
  return 0;
    80004e14:	4781                	li	a5,0
    80004e16:	64f2                	ld	s1,280(sp)
    80004e18:	6952                	ld	s2,272(sp)
    80004e1a:	a0a1                	j	80004e62 <sys_link+0xf4>
    end_op();
    80004e1c:	eebfe0ef          	jal	80003d06 <end_op>
    return -1;
    80004e20:	57fd                	li	a5,-1
    80004e22:	64f2                	ld	s1,280(sp)
    80004e24:	a83d                	j	80004e62 <sys_link+0xf4>
    iunlockput(ip);
    80004e26:	8526                	mv	a0,s1
    80004e28:	fccfe0ef          	jal	800035f4 <iunlockput>
    end_op();
    80004e2c:	edbfe0ef          	jal	80003d06 <end_op>
    return -1;
    80004e30:	57fd                	li	a5,-1
    80004e32:	64f2                	ld	s1,280(sp)
    80004e34:	a03d                	j	80004e62 <sys_link+0xf4>
    iunlockput(dp);
    80004e36:	854a                	mv	a0,s2
    80004e38:	fbcfe0ef          	jal	800035f4 <iunlockput>
  ilock(ip);
    80004e3c:	8526                	mv	a0,s1
    80004e3e:	dacfe0ef          	jal	800033ea <ilock>
  ip->nlink--;
    80004e42:	04a4d783          	lhu	a5,74(s1)
    80004e46:	37fd                	addiw	a5,a5,-1
    80004e48:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e4c:	8526                	mv	a0,s1
    80004e4e:	ce8fe0ef          	jal	80003336 <iupdate>
  iunlockput(ip);
    80004e52:	8526                	mv	a0,s1
    80004e54:	fa0fe0ef          	jal	800035f4 <iunlockput>
  end_op();
    80004e58:	eaffe0ef          	jal	80003d06 <end_op>
  return -1;
    80004e5c:	57fd                	li	a5,-1
    80004e5e:	64f2                	ld	s1,280(sp)
    80004e60:	6952                	ld	s2,272(sp)
}
    80004e62:	853e                	mv	a0,a5
    80004e64:	70b2                	ld	ra,296(sp)
    80004e66:	7412                	ld	s0,288(sp)
    80004e68:	6155                	addi	sp,sp,304
    80004e6a:	8082                	ret

0000000080004e6c <sys_unlink>:
{
    80004e6c:	7111                	addi	sp,sp,-256
    80004e6e:	fd86                	sd	ra,248(sp)
    80004e70:	f9a2                	sd	s0,240(sp)
    80004e72:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004e74:	08000613          	li	a2,128
    80004e78:	f2040593          	addi	a1,s0,-224
    80004e7c:	4501                	li	a0,0
    80004e7e:	b19fd0ef          	jal	80002996 <argstr>
    80004e82:	16054663          	bltz	a0,80004fee <sys_unlink+0x182>
    80004e86:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004e88:	e15fe0ef          	jal	80003c9c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004e8c:	fa040593          	addi	a1,s0,-96
    80004e90:	f2040513          	addi	a0,s0,-224
    80004e94:	c61fe0ef          	jal	80003af4 <nameiparent>
    80004e98:	84aa                	mv	s1,a0
    80004e9a:	c955                	beqz	a0,80004f4e <sys_unlink+0xe2>
  ilock(dp);
    80004e9c:	d4efe0ef          	jal	800033ea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ea0:	00002597          	auipc	a1,0x2
    80004ea4:	7f058593          	addi	a1,a1,2032 # 80007690 <etext+0x690>
    80004ea8:	fa040513          	addi	a0,s0,-96
    80004eac:	98dfe0ef          	jal	80003838 <namecmp>
    80004eb0:	12050463          	beqz	a0,80004fd8 <sys_unlink+0x16c>
    80004eb4:	00002597          	auipc	a1,0x2
    80004eb8:	7e458593          	addi	a1,a1,2020 # 80007698 <etext+0x698>
    80004ebc:	fa040513          	addi	a0,s0,-96
    80004ec0:	979fe0ef          	jal	80003838 <namecmp>
    80004ec4:	10050a63          	beqz	a0,80004fd8 <sys_unlink+0x16c>
    80004ec8:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004eca:	f1c40613          	addi	a2,s0,-228
    80004ece:	fa040593          	addi	a1,s0,-96
    80004ed2:	8526                	mv	a0,s1
    80004ed4:	97bfe0ef          	jal	8000384e <dirlookup>
    80004ed8:	892a                	mv	s2,a0
    80004eda:	0e050e63          	beqz	a0,80004fd6 <sys_unlink+0x16a>
    80004ede:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004ee0:	d0afe0ef          	jal	800033ea <ilock>
  if(ip->nlink < 1)
    80004ee4:	04a91783          	lh	a5,74(s2)
    80004ee8:	06f05863          	blez	a5,80004f58 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004eec:	04491703          	lh	a4,68(s2)
    80004ef0:	4785                	li	a5,1
    80004ef2:	06f70b63          	beq	a4,a5,80004f68 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004ef6:	fb040993          	addi	s3,s0,-80
    80004efa:	4641                	li	a2,16
    80004efc:	4581                	li	a1,0
    80004efe:	854e                	mv	a0,s3
    80004f00:	dc7fb0ef          	jal	80000cc6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f04:	4741                	li	a4,16
    80004f06:	f1c42683          	lw	a3,-228(s0)
    80004f0a:	864e                	mv	a2,s3
    80004f0c:	4581                	li	a1,0
    80004f0e:	8526                	mv	a0,s1
    80004f10:	825fe0ef          	jal	80003734 <writei>
    80004f14:	47c1                	li	a5,16
    80004f16:	08f51f63          	bne	a0,a5,80004fb4 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    80004f1a:	04491703          	lh	a4,68(s2)
    80004f1e:	4785                	li	a5,1
    80004f20:	0af70263          	beq	a4,a5,80004fc4 <sys_unlink+0x158>
  iunlockput(dp);
    80004f24:	8526                	mv	a0,s1
    80004f26:	ecefe0ef          	jal	800035f4 <iunlockput>
  ip->nlink--;
    80004f2a:	04a95783          	lhu	a5,74(s2)
    80004f2e:	37fd                	addiw	a5,a5,-1
    80004f30:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004f34:	854a                	mv	a0,s2
    80004f36:	c00fe0ef          	jal	80003336 <iupdate>
  iunlockput(ip);
    80004f3a:	854a                	mv	a0,s2
    80004f3c:	eb8fe0ef          	jal	800035f4 <iunlockput>
  end_op();
    80004f40:	dc7fe0ef          	jal	80003d06 <end_op>
  return 0;
    80004f44:	4501                	li	a0,0
    80004f46:	74ae                	ld	s1,232(sp)
    80004f48:	790e                	ld	s2,224(sp)
    80004f4a:	69ee                	ld	s3,216(sp)
    80004f4c:	a869                	j	80004fe6 <sys_unlink+0x17a>
    end_op();
    80004f4e:	db9fe0ef          	jal	80003d06 <end_op>
    return -1;
    80004f52:	557d                	li	a0,-1
    80004f54:	74ae                	ld	s1,232(sp)
    80004f56:	a841                	j	80004fe6 <sys_unlink+0x17a>
    80004f58:	e9d2                	sd	s4,208(sp)
    80004f5a:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004f5c:	00002517          	auipc	a0,0x2
    80004f60:	74450513          	addi	a0,a0,1860 # 800076a0 <etext+0x6a0>
    80004f64:	83bfb0ef          	jal	8000079e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f68:	04c92703          	lw	a4,76(s2)
    80004f6c:	02000793          	li	a5,32
    80004f70:	f8e7f3e3          	bgeu	a5,a4,80004ef6 <sys_unlink+0x8a>
    80004f74:	e9d2                	sd	s4,208(sp)
    80004f76:	e5d6                	sd	s5,200(sp)
    80004f78:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f7a:	f0840a93          	addi	s5,s0,-248
    80004f7e:	4a41                	li	s4,16
    80004f80:	8752                	mv	a4,s4
    80004f82:	86ce                	mv	a3,s3
    80004f84:	8656                	mv	a2,s5
    80004f86:	4581                	li	a1,0
    80004f88:	854a                	mv	a0,s2
    80004f8a:	eb8fe0ef          	jal	80003642 <readi>
    80004f8e:	01451d63          	bne	a0,s4,80004fa8 <sys_unlink+0x13c>
    if(de.inum != 0)
    80004f92:	f0845783          	lhu	a5,-248(s0)
    80004f96:	efb1                	bnez	a5,80004ff2 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f98:	29c1                	addiw	s3,s3,16
    80004f9a:	04c92783          	lw	a5,76(s2)
    80004f9e:	fef9e1e3          	bltu	s3,a5,80004f80 <sys_unlink+0x114>
    80004fa2:	6a4e                	ld	s4,208(sp)
    80004fa4:	6aae                	ld	s5,200(sp)
    80004fa6:	bf81                	j	80004ef6 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004fa8:	00002517          	auipc	a0,0x2
    80004fac:	71050513          	addi	a0,a0,1808 # 800076b8 <etext+0x6b8>
    80004fb0:	feefb0ef          	jal	8000079e <panic>
    80004fb4:	e9d2                	sd	s4,208(sp)
    80004fb6:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004fb8:	00002517          	auipc	a0,0x2
    80004fbc:	71850513          	addi	a0,a0,1816 # 800076d0 <etext+0x6d0>
    80004fc0:	fdefb0ef          	jal	8000079e <panic>
    dp->nlink--;
    80004fc4:	04a4d783          	lhu	a5,74(s1)
    80004fc8:	37fd                	addiw	a5,a5,-1
    80004fca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	b66fe0ef          	jal	80003336 <iupdate>
    80004fd4:	bf81                	j	80004f24 <sys_unlink+0xb8>
    80004fd6:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	e1afe0ef          	jal	800035f4 <iunlockput>
  end_op();
    80004fde:	d29fe0ef          	jal	80003d06 <end_op>
  return -1;
    80004fe2:	557d                	li	a0,-1
    80004fe4:	74ae                	ld	s1,232(sp)
}
    80004fe6:	70ee                	ld	ra,248(sp)
    80004fe8:	744e                	ld	s0,240(sp)
    80004fea:	6111                	addi	sp,sp,256
    80004fec:	8082                	ret
    return -1;
    80004fee:	557d                	li	a0,-1
    80004ff0:	bfdd                	j	80004fe6 <sys_unlink+0x17a>
    iunlockput(ip);
    80004ff2:	854a                	mv	a0,s2
    80004ff4:	e00fe0ef          	jal	800035f4 <iunlockput>
    goto bad;
    80004ff8:	790e                	ld	s2,224(sp)
    80004ffa:	69ee                	ld	s3,216(sp)
    80004ffc:	6a4e                	ld	s4,208(sp)
    80004ffe:	6aae                	ld	s5,200(sp)
    80005000:	bfe1                	j	80004fd8 <sys_unlink+0x16c>

0000000080005002 <sys_open>:

uint64
sys_open(void)
{
    80005002:	7131                	addi	sp,sp,-192
    80005004:	fd06                	sd	ra,184(sp)
    80005006:	f922                	sd	s0,176(sp)
    80005008:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000500a:	f4c40593          	addi	a1,s0,-180
    8000500e:	4505                	li	a0,1
    80005010:	94ffd0ef          	jal	8000295e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005014:	08000613          	li	a2,128
    80005018:	f5040593          	addi	a1,s0,-176
    8000501c:	4501                	li	a0,0
    8000501e:	979fd0ef          	jal	80002996 <argstr>
    80005022:	87aa                	mv	a5,a0
    return -1;
    80005024:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005026:	0a07c363          	bltz	a5,800050cc <sys_open+0xca>
    8000502a:	f526                	sd	s1,168(sp)

  begin_op();
    8000502c:	c71fe0ef          	jal	80003c9c <begin_op>

  if(omode & O_CREATE){
    80005030:	f4c42783          	lw	a5,-180(s0)
    80005034:	2007f793          	andi	a5,a5,512
    80005038:	c3dd                	beqz	a5,800050de <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000503a:	4681                	li	a3,0
    8000503c:	4601                	li	a2,0
    8000503e:	4589                	li	a1,2
    80005040:	f5040513          	addi	a0,s0,-176
    80005044:	a99ff0ef          	jal	80004adc <create>
    80005048:	84aa                	mv	s1,a0
    if(ip == 0){
    8000504a:	c549                	beqz	a0,800050d4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000504c:	04449703          	lh	a4,68(s1)
    80005050:	478d                	li	a5,3
    80005052:	00f71763          	bne	a4,a5,80005060 <sys_open+0x5e>
    80005056:	0464d703          	lhu	a4,70(s1)
    8000505a:	47a5                	li	a5,9
    8000505c:	0ae7ee63          	bltu	a5,a4,80005118 <sys_open+0x116>
    80005060:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005062:	fb7fe0ef          	jal	80004018 <filealloc>
    80005066:	892a                	mv	s2,a0
    80005068:	c561                	beqz	a0,80005130 <sys_open+0x12e>
    8000506a:	ed4e                	sd	s3,152(sp)
    8000506c:	a33ff0ef          	jal	80004a9e <fdalloc>
    80005070:	89aa                	mv	s3,a0
    80005072:	0a054b63          	bltz	a0,80005128 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005076:	04449703          	lh	a4,68(s1)
    8000507a:	478d                	li	a5,3
    8000507c:	0cf70363          	beq	a4,a5,80005142 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005080:	4789                	li	a5,2
    80005082:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005086:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000508a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000508e:	f4c42783          	lw	a5,-180(s0)
    80005092:	0017f713          	andi	a4,a5,1
    80005096:	00174713          	xori	a4,a4,1
    8000509a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000509e:	0037f713          	andi	a4,a5,3
    800050a2:	00e03733          	snez	a4,a4
    800050a6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800050aa:	4007f793          	andi	a5,a5,1024
    800050ae:	c791                	beqz	a5,800050ba <sys_open+0xb8>
    800050b0:	04449703          	lh	a4,68(s1)
    800050b4:	4789                	li	a5,2
    800050b6:	08f70d63          	beq	a4,a5,80005150 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800050ba:	8526                	mv	a0,s1
    800050bc:	bdcfe0ef          	jal	80003498 <iunlock>
  end_op();
    800050c0:	c47fe0ef          	jal	80003d06 <end_op>

  return fd;
    800050c4:	854e                	mv	a0,s3
    800050c6:	74aa                	ld	s1,168(sp)
    800050c8:	790a                	ld	s2,160(sp)
    800050ca:	69ea                	ld	s3,152(sp)
}
    800050cc:	70ea                	ld	ra,184(sp)
    800050ce:	744a                	ld	s0,176(sp)
    800050d0:	6129                	addi	sp,sp,192
    800050d2:	8082                	ret
      end_op();
    800050d4:	c33fe0ef          	jal	80003d06 <end_op>
      return -1;
    800050d8:	557d                	li	a0,-1
    800050da:	74aa                	ld	s1,168(sp)
    800050dc:	bfc5                	j	800050cc <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800050de:	f5040513          	addi	a0,s0,-176
    800050e2:	9f9fe0ef          	jal	80003ada <namei>
    800050e6:	84aa                	mv	s1,a0
    800050e8:	c11d                	beqz	a0,8000510e <sys_open+0x10c>
    ilock(ip);
    800050ea:	b00fe0ef          	jal	800033ea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800050ee:	04449703          	lh	a4,68(s1)
    800050f2:	4785                	li	a5,1
    800050f4:	f4f71ce3          	bne	a4,a5,8000504c <sys_open+0x4a>
    800050f8:	f4c42783          	lw	a5,-180(s0)
    800050fc:	d3b5                	beqz	a5,80005060 <sys_open+0x5e>
      iunlockput(ip);
    800050fe:	8526                	mv	a0,s1
    80005100:	cf4fe0ef          	jal	800035f4 <iunlockput>
      end_op();
    80005104:	c03fe0ef          	jal	80003d06 <end_op>
      return -1;
    80005108:	557d                	li	a0,-1
    8000510a:	74aa                	ld	s1,168(sp)
    8000510c:	b7c1                	j	800050cc <sys_open+0xca>
      end_op();
    8000510e:	bf9fe0ef          	jal	80003d06 <end_op>
      return -1;
    80005112:	557d                	li	a0,-1
    80005114:	74aa                	ld	s1,168(sp)
    80005116:	bf5d                	j	800050cc <sys_open+0xca>
    iunlockput(ip);
    80005118:	8526                	mv	a0,s1
    8000511a:	cdafe0ef          	jal	800035f4 <iunlockput>
    end_op();
    8000511e:	be9fe0ef          	jal	80003d06 <end_op>
    return -1;
    80005122:	557d                	li	a0,-1
    80005124:	74aa                	ld	s1,168(sp)
    80005126:	b75d                	j	800050cc <sys_open+0xca>
      fileclose(f);
    80005128:	854a                	mv	a0,s2
    8000512a:	f93fe0ef          	jal	800040bc <fileclose>
    8000512e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005130:	8526                	mv	a0,s1
    80005132:	cc2fe0ef          	jal	800035f4 <iunlockput>
    end_op();
    80005136:	bd1fe0ef          	jal	80003d06 <end_op>
    return -1;
    8000513a:	557d                	li	a0,-1
    8000513c:	74aa                	ld	s1,168(sp)
    8000513e:	790a                	ld	s2,160(sp)
    80005140:	b771                	j	800050cc <sys_open+0xca>
    f->type = FD_DEVICE;
    80005142:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005146:	04649783          	lh	a5,70(s1)
    8000514a:	02f91223          	sh	a5,36(s2)
    8000514e:	bf35                	j	8000508a <sys_open+0x88>
    itrunc(ip);
    80005150:	8526                	mv	a0,s1
    80005152:	b86fe0ef          	jal	800034d8 <itrunc>
    80005156:	b795                	j	800050ba <sys_open+0xb8>

0000000080005158 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005158:	7175                	addi	sp,sp,-144
    8000515a:	e506                	sd	ra,136(sp)
    8000515c:	e122                	sd	s0,128(sp)
    8000515e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005160:	b3dfe0ef          	jal	80003c9c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005164:	08000613          	li	a2,128
    80005168:	f7040593          	addi	a1,s0,-144
    8000516c:	4501                	li	a0,0
    8000516e:	829fd0ef          	jal	80002996 <argstr>
    80005172:	02054363          	bltz	a0,80005198 <sys_mkdir+0x40>
    80005176:	4681                	li	a3,0
    80005178:	4601                	li	a2,0
    8000517a:	4585                	li	a1,1
    8000517c:	f7040513          	addi	a0,s0,-144
    80005180:	95dff0ef          	jal	80004adc <create>
    80005184:	c911                	beqz	a0,80005198 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005186:	c6efe0ef          	jal	800035f4 <iunlockput>
  end_op();
    8000518a:	b7dfe0ef          	jal	80003d06 <end_op>
  return 0;
    8000518e:	4501                	li	a0,0
}
    80005190:	60aa                	ld	ra,136(sp)
    80005192:	640a                	ld	s0,128(sp)
    80005194:	6149                	addi	sp,sp,144
    80005196:	8082                	ret
    end_op();
    80005198:	b6ffe0ef          	jal	80003d06 <end_op>
    return -1;
    8000519c:	557d                	li	a0,-1
    8000519e:	bfcd                	j	80005190 <sys_mkdir+0x38>

00000000800051a0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800051a0:	7135                	addi	sp,sp,-160
    800051a2:	ed06                	sd	ra,152(sp)
    800051a4:	e922                	sd	s0,144(sp)
    800051a6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800051a8:	af5fe0ef          	jal	80003c9c <begin_op>
  argint(1, &major);
    800051ac:	f6c40593          	addi	a1,s0,-148
    800051b0:	4505                	li	a0,1
    800051b2:	facfd0ef          	jal	8000295e <argint>
  argint(2, &minor);
    800051b6:	f6840593          	addi	a1,s0,-152
    800051ba:	4509                	li	a0,2
    800051bc:	fa2fd0ef          	jal	8000295e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051c0:	08000613          	li	a2,128
    800051c4:	f7040593          	addi	a1,s0,-144
    800051c8:	4501                	li	a0,0
    800051ca:	fccfd0ef          	jal	80002996 <argstr>
    800051ce:	02054563          	bltz	a0,800051f8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800051d2:	f6841683          	lh	a3,-152(s0)
    800051d6:	f6c41603          	lh	a2,-148(s0)
    800051da:	458d                	li	a1,3
    800051dc:	f7040513          	addi	a0,s0,-144
    800051e0:	8fdff0ef          	jal	80004adc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051e4:	c911                	beqz	a0,800051f8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800051e6:	c0efe0ef          	jal	800035f4 <iunlockput>
  end_op();
    800051ea:	b1dfe0ef          	jal	80003d06 <end_op>
  return 0;
    800051ee:	4501                	li	a0,0
}
    800051f0:	60ea                	ld	ra,152(sp)
    800051f2:	644a                	ld	s0,144(sp)
    800051f4:	610d                	addi	sp,sp,160
    800051f6:	8082                	ret
    end_op();
    800051f8:	b0ffe0ef          	jal	80003d06 <end_op>
    return -1;
    800051fc:	557d                	li	a0,-1
    800051fe:	bfcd                	j	800051f0 <sys_mknod+0x50>

0000000080005200 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005200:	7135                	addi	sp,sp,-160
    80005202:	ed06                	sd	ra,152(sp)
    80005204:	e922                	sd	s0,144(sp)
    80005206:	e14a                	sd	s2,128(sp)
    80005208:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000520a:	fc2fc0ef          	jal	800019cc <myproc>
    8000520e:	892a                	mv	s2,a0
  
  begin_op();
    80005210:	a8dfe0ef          	jal	80003c9c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005214:	08000613          	li	a2,128
    80005218:	f6040593          	addi	a1,s0,-160
    8000521c:	4501                	li	a0,0
    8000521e:	f78fd0ef          	jal	80002996 <argstr>
    80005222:	04054363          	bltz	a0,80005268 <sys_chdir+0x68>
    80005226:	e526                	sd	s1,136(sp)
    80005228:	f6040513          	addi	a0,s0,-160
    8000522c:	8affe0ef          	jal	80003ada <namei>
    80005230:	84aa                	mv	s1,a0
    80005232:	c915                	beqz	a0,80005266 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005234:	9b6fe0ef          	jal	800033ea <ilock>
  if(ip->type != T_DIR){
    80005238:	04449703          	lh	a4,68(s1)
    8000523c:	4785                	li	a5,1
    8000523e:	02f71963          	bne	a4,a5,80005270 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005242:	8526                	mv	a0,s1
    80005244:	a54fe0ef          	jal	80003498 <iunlock>
  iput(p->cwd);
    80005248:	15093503          	ld	a0,336(s2)
    8000524c:	b20fe0ef          	jal	8000356c <iput>
  end_op();
    80005250:	ab7fe0ef          	jal	80003d06 <end_op>
  p->cwd = ip;
    80005254:	14993823          	sd	s1,336(s2)
  return 0;
    80005258:	4501                	li	a0,0
    8000525a:	64aa                	ld	s1,136(sp)
}
    8000525c:	60ea                	ld	ra,152(sp)
    8000525e:	644a                	ld	s0,144(sp)
    80005260:	690a                	ld	s2,128(sp)
    80005262:	610d                	addi	sp,sp,160
    80005264:	8082                	ret
    80005266:	64aa                	ld	s1,136(sp)
    end_op();
    80005268:	a9ffe0ef          	jal	80003d06 <end_op>
    return -1;
    8000526c:	557d                	li	a0,-1
    8000526e:	b7fd                	j	8000525c <sys_chdir+0x5c>
    iunlockput(ip);
    80005270:	8526                	mv	a0,s1
    80005272:	b82fe0ef          	jal	800035f4 <iunlockput>
    end_op();
    80005276:	a91fe0ef          	jal	80003d06 <end_op>
    return -1;
    8000527a:	557d                	li	a0,-1
    8000527c:	64aa                	ld	s1,136(sp)
    8000527e:	bff9                	j	8000525c <sys_chdir+0x5c>

0000000080005280 <sys_exec>:

uint64
sys_exec(void)
{
    80005280:	7105                	addi	sp,sp,-480
    80005282:	ef86                	sd	ra,472(sp)
    80005284:	eba2                	sd	s0,464(sp)
    80005286:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005288:	e2840593          	addi	a1,s0,-472
    8000528c:	4505                	li	a0,1
    8000528e:	eecfd0ef          	jal	8000297a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005292:	08000613          	li	a2,128
    80005296:	f3040593          	addi	a1,s0,-208
    8000529a:	4501                	li	a0,0
    8000529c:	efafd0ef          	jal	80002996 <argstr>
    800052a0:	87aa                	mv	a5,a0
    return -1;
    800052a2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800052a4:	0e07c063          	bltz	a5,80005384 <sys_exec+0x104>
    800052a8:	e7a6                	sd	s1,456(sp)
    800052aa:	e3ca                	sd	s2,448(sp)
    800052ac:	ff4e                	sd	s3,440(sp)
    800052ae:	fb52                	sd	s4,432(sp)
    800052b0:	f756                	sd	s5,424(sp)
    800052b2:	f35a                	sd	s6,416(sp)
    800052b4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800052b6:	e3040a13          	addi	s4,s0,-464
    800052ba:	10000613          	li	a2,256
    800052be:	4581                	li	a1,0
    800052c0:	8552                	mv	a0,s4
    800052c2:	a05fb0ef          	jal	80000cc6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800052c6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800052c8:	89d2                	mv	s3,s4
    800052ca:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800052cc:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052d0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800052d2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800052d6:	00391513          	slli	a0,s2,0x3
    800052da:	85d6                	mv	a1,s5
    800052dc:	e2843783          	ld	a5,-472(s0)
    800052e0:	953e                	add	a0,a0,a5
    800052e2:	df2fd0ef          	jal	800028d4 <fetchaddr>
    800052e6:	02054663          	bltz	a0,80005312 <sys_exec+0x92>
    if(uarg == 0){
    800052ea:	e2043783          	ld	a5,-480(s0)
    800052ee:	c7a1                	beqz	a5,80005336 <sys_exec+0xb6>
    argv[i] = kalloc();
    800052f0:	833fb0ef          	jal	80000b22 <kalloc>
    800052f4:	85aa                	mv	a1,a0
    800052f6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800052fa:	cd01                	beqz	a0,80005312 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052fc:	865a                	mv	a2,s6
    800052fe:	e2043503          	ld	a0,-480(s0)
    80005302:	e1cfd0ef          	jal	8000291e <fetchstr>
    80005306:	00054663          	bltz	a0,80005312 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000530a:	0905                	addi	s2,s2,1
    8000530c:	09a1                	addi	s3,s3,8
    8000530e:	fd7914e3          	bne	s2,s7,800052d6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005312:	100a0a13          	addi	s4,s4,256
    80005316:	6088                	ld	a0,0(s1)
    80005318:	cd31                	beqz	a0,80005374 <sys_exec+0xf4>
    kfree(argv[i]);
    8000531a:	f26fb0ef          	jal	80000a40 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000531e:	04a1                	addi	s1,s1,8
    80005320:	ff449be3          	bne	s1,s4,80005316 <sys_exec+0x96>
  return -1;
    80005324:	557d                	li	a0,-1
    80005326:	64be                	ld	s1,456(sp)
    80005328:	691e                	ld	s2,448(sp)
    8000532a:	79fa                	ld	s3,440(sp)
    8000532c:	7a5a                	ld	s4,432(sp)
    8000532e:	7aba                	ld	s5,424(sp)
    80005330:	7b1a                	ld	s6,416(sp)
    80005332:	6bfa                	ld	s7,408(sp)
    80005334:	a881                	j	80005384 <sys_exec+0x104>
      argv[i] = 0;
    80005336:	0009079b          	sext.w	a5,s2
    8000533a:	e3040593          	addi	a1,s0,-464
    8000533e:	078e                	slli	a5,a5,0x3
    80005340:	97ae                	add	a5,a5,a1
    80005342:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80005346:	f3040513          	addi	a0,s0,-208
    8000534a:	ba4ff0ef          	jal	800046ee <exec>
    8000534e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005350:	100a0a13          	addi	s4,s4,256
    80005354:	6088                	ld	a0,0(s1)
    80005356:	c511                	beqz	a0,80005362 <sys_exec+0xe2>
    kfree(argv[i]);
    80005358:	ee8fb0ef          	jal	80000a40 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000535c:	04a1                	addi	s1,s1,8
    8000535e:	ff449be3          	bne	s1,s4,80005354 <sys_exec+0xd4>
  return ret;
    80005362:	854a                	mv	a0,s2
    80005364:	64be                	ld	s1,456(sp)
    80005366:	691e                	ld	s2,448(sp)
    80005368:	79fa                	ld	s3,440(sp)
    8000536a:	7a5a                	ld	s4,432(sp)
    8000536c:	7aba                	ld	s5,424(sp)
    8000536e:	7b1a                	ld	s6,416(sp)
    80005370:	6bfa                	ld	s7,408(sp)
    80005372:	a809                	j	80005384 <sys_exec+0x104>
  return -1;
    80005374:	557d                	li	a0,-1
    80005376:	64be                	ld	s1,456(sp)
    80005378:	691e                	ld	s2,448(sp)
    8000537a:	79fa                	ld	s3,440(sp)
    8000537c:	7a5a                	ld	s4,432(sp)
    8000537e:	7aba                	ld	s5,424(sp)
    80005380:	7b1a                	ld	s6,416(sp)
    80005382:	6bfa                	ld	s7,408(sp)
}
    80005384:	60fe                	ld	ra,472(sp)
    80005386:	645e                	ld	s0,464(sp)
    80005388:	613d                	addi	sp,sp,480
    8000538a:	8082                	ret

000000008000538c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000538c:	7139                	addi	sp,sp,-64
    8000538e:	fc06                	sd	ra,56(sp)
    80005390:	f822                	sd	s0,48(sp)
    80005392:	f426                	sd	s1,40(sp)
    80005394:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005396:	e36fc0ef          	jal	800019cc <myproc>
    8000539a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000539c:	fd840593          	addi	a1,s0,-40
    800053a0:	4501                	li	a0,0
    800053a2:	dd8fd0ef          	jal	8000297a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800053a6:	fc840593          	addi	a1,s0,-56
    800053aa:	fd040513          	addi	a0,s0,-48
    800053ae:	81eff0ef          	jal	800043cc <pipealloc>
    return -1;
    800053b2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800053b4:	0a054463          	bltz	a0,8000545c <sys_pipe+0xd0>
  fd0 = -1;
    800053b8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800053bc:	fd043503          	ld	a0,-48(s0)
    800053c0:	edeff0ef          	jal	80004a9e <fdalloc>
    800053c4:	fca42223          	sw	a0,-60(s0)
    800053c8:	08054163          	bltz	a0,8000544a <sys_pipe+0xbe>
    800053cc:	fc843503          	ld	a0,-56(s0)
    800053d0:	eceff0ef          	jal	80004a9e <fdalloc>
    800053d4:	fca42023          	sw	a0,-64(s0)
    800053d8:	06054063          	bltz	a0,80005438 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053dc:	4691                	li	a3,4
    800053de:	fc440613          	addi	a2,s0,-60
    800053e2:	fd843583          	ld	a1,-40(s0)
    800053e6:	68a8                	ld	a0,80(s1)
    800053e8:	9a4fc0ef          	jal	8000158c <copyout>
    800053ec:	00054e63          	bltz	a0,80005408 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800053f0:	4691                	li	a3,4
    800053f2:	fc040613          	addi	a2,s0,-64
    800053f6:	fd843583          	ld	a1,-40(s0)
    800053fa:	95b6                	add	a1,a1,a3
    800053fc:	68a8                	ld	a0,80(s1)
    800053fe:	98efc0ef          	jal	8000158c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005402:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005404:	04055c63          	bgez	a0,8000545c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005408:	fc442783          	lw	a5,-60(s0)
    8000540c:	07e9                	addi	a5,a5,26
    8000540e:	078e                	slli	a5,a5,0x3
    80005410:	97a6                	add	a5,a5,s1
    80005412:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005416:	fc042783          	lw	a5,-64(s0)
    8000541a:	07e9                	addi	a5,a5,26
    8000541c:	078e                	slli	a5,a5,0x3
    8000541e:	94be                	add	s1,s1,a5
    80005420:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005424:	fd043503          	ld	a0,-48(s0)
    80005428:	c95fe0ef          	jal	800040bc <fileclose>
    fileclose(wf);
    8000542c:	fc843503          	ld	a0,-56(s0)
    80005430:	c8dfe0ef          	jal	800040bc <fileclose>
    return -1;
    80005434:	57fd                	li	a5,-1
    80005436:	a01d                	j	8000545c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005438:	fc442783          	lw	a5,-60(s0)
    8000543c:	0007c763          	bltz	a5,8000544a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005440:	07e9                	addi	a5,a5,26
    80005442:	078e                	slli	a5,a5,0x3
    80005444:	97a6                	add	a5,a5,s1
    80005446:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000544a:	fd043503          	ld	a0,-48(s0)
    8000544e:	c6ffe0ef          	jal	800040bc <fileclose>
    fileclose(wf);
    80005452:	fc843503          	ld	a0,-56(s0)
    80005456:	c67fe0ef          	jal	800040bc <fileclose>
    return -1;
    8000545a:	57fd                	li	a5,-1
}
    8000545c:	853e                	mv	a0,a5
    8000545e:	70e2                	ld	ra,56(sp)
    80005460:	7442                	ld	s0,48(sp)
    80005462:	74a2                	ld	s1,40(sp)
    80005464:	6121                	addi	sp,sp,64
    80005466:	8082                	ret
	...

0000000080005470 <kernelvec>:
    80005470:	7111                	addi	sp,sp,-256
    80005472:	e006                	sd	ra,0(sp)
    80005474:	e40a                	sd	sp,8(sp)
    80005476:	e80e                	sd	gp,16(sp)
    80005478:	ec12                	sd	tp,24(sp)
    8000547a:	f016                	sd	t0,32(sp)
    8000547c:	f41a                	sd	t1,40(sp)
    8000547e:	f81e                	sd	t2,48(sp)
    80005480:	e4aa                	sd	a0,72(sp)
    80005482:	e8ae                	sd	a1,80(sp)
    80005484:	ecb2                	sd	a2,88(sp)
    80005486:	f0b6                	sd	a3,96(sp)
    80005488:	f4ba                	sd	a4,104(sp)
    8000548a:	f8be                	sd	a5,112(sp)
    8000548c:	fcc2                	sd	a6,120(sp)
    8000548e:	e146                	sd	a7,128(sp)
    80005490:	edf2                	sd	t3,216(sp)
    80005492:	f1f6                	sd	t4,224(sp)
    80005494:	f5fa                	sd	t5,232(sp)
    80005496:	f9fe                	sd	t6,240(sp)
    80005498:	b4cfd0ef          	jal	800027e4 <kerneltrap>
    8000549c:	6082                	ld	ra,0(sp)
    8000549e:	6122                	ld	sp,8(sp)
    800054a0:	61c2                	ld	gp,16(sp)
    800054a2:	7282                	ld	t0,32(sp)
    800054a4:	7322                	ld	t1,40(sp)
    800054a6:	73c2                	ld	t2,48(sp)
    800054a8:	6526                	ld	a0,72(sp)
    800054aa:	65c6                	ld	a1,80(sp)
    800054ac:	6666                	ld	a2,88(sp)
    800054ae:	7686                	ld	a3,96(sp)
    800054b0:	7726                	ld	a4,104(sp)
    800054b2:	77c6                	ld	a5,112(sp)
    800054b4:	7866                	ld	a6,120(sp)
    800054b6:	688a                	ld	a7,128(sp)
    800054b8:	6e6e                	ld	t3,216(sp)
    800054ba:	7e8e                	ld	t4,224(sp)
    800054bc:	7f2e                	ld	t5,232(sp)
    800054be:	7fce                	ld	t6,240(sp)
    800054c0:	6111                	addi	sp,sp,256
    800054c2:	10200073          	sret
	...

00000000800054ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054ce:	1141                	addi	sp,sp,-16
    800054d0:	e406                	sd	ra,8(sp)
    800054d2:	e022                	sd	s0,0(sp)
    800054d4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054d6:	0c000737          	lui	a4,0xc000
    800054da:	4785                	li	a5,1
    800054dc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054de:	c35c                	sw	a5,4(a4)
}
    800054e0:	60a2                	ld	ra,8(sp)
    800054e2:	6402                	ld	s0,0(sp)
    800054e4:	0141                	addi	sp,sp,16
    800054e6:	8082                	ret

00000000800054e8 <plicinithart>:

void
plicinithart(void)
{
    800054e8:	1141                	addi	sp,sp,-16
    800054ea:	e406                	sd	ra,8(sp)
    800054ec:	e022                	sd	s0,0(sp)
    800054ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054f0:	ca8fc0ef          	jal	80001998 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054f4:	0085171b          	slliw	a4,a0,0x8
    800054f8:	0c0027b7          	lui	a5,0xc002
    800054fc:	97ba                	add	a5,a5,a4
    800054fe:	40200713          	li	a4,1026
    80005502:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005506:	00d5151b          	slliw	a0,a0,0xd
    8000550a:	0c2017b7          	lui	a5,0xc201
    8000550e:	97aa                	add	a5,a5,a0
    80005510:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005514:	60a2                	ld	ra,8(sp)
    80005516:	6402                	ld	s0,0(sp)
    80005518:	0141                	addi	sp,sp,16
    8000551a:	8082                	ret

000000008000551c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000551c:	1141                	addi	sp,sp,-16
    8000551e:	e406                	sd	ra,8(sp)
    80005520:	e022                	sd	s0,0(sp)
    80005522:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005524:	c74fc0ef          	jal	80001998 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005528:	00d5151b          	slliw	a0,a0,0xd
    8000552c:	0c2017b7          	lui	a5,0xc201
    80005530:	97aa                	add	a5,a5,a0
  return irq;
}
    80005532:	43c8                	lw	a0,4(a5)
    80005534:	60a2                	ld	ra,8(sp)
    80005536:	6402                	ld	s0,0(sp)
    80005538:	0141                	addi	sp,sp,16
    8000553a:	8082                	ret

000000008000553c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000553c:	1101                	addi	sp,sp,-32
    8000553e:	ec06                	sd	ra,24(sp)
    80005540:	e822                	sd	s0,16(sp)
    80005542:	e426                	sd	s1,8(sp)
    80005544:	1000                	addi	s0,sp,32
    80005546:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005548:	c50fc0ef          	jal	80001998 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000554c:	00d5179b          	slliw	a5,a0,0xd
    80005550:	0c201737          	lui	a4,0xc201
    80005554:	97ba                	add	a5,a5,a4
    80005556:	c3c4                	sw	s1,4(a5)
}
    80005558:	60e2                	ld	ra,24(sp)
    8000555a:	6442                	ld	s0,16(sp)
    8000555c:	64a2                	ld	s1,8(sp)
    8000555e:	6105                	addi	sp,sp,32
    80005560:	8082                	ret

0000000080005562 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005562:	1141                	addi	sp,sp,-16
    80005564:	e406                	sd	ra,8(sp)
    80005566:	e022                	sd	s0,0(sp)
    80005568:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000556a:	479d                	li	a5,7
    8000556c:	04a7ca63          	blt	a5,a0,800055c0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005570:	0006c797          	auipc	a5,0x6c
    80005574:	81878793          	addi	a5,a5,-2024 # 80070d88 <disk>
    80005578:	97aa                	add	a5,a5,a0
    8000557a:	0187c783          	lbu	a5,24(a5)
    8000557e:	e7b9                	bnez	a5,800055cc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005580:	00451693          	slli	a3,a0,0x4
    80005584:	0006c797          	auipc	a5,0x6c
    80005588:	80478793          	addi	a5,a5,-2044 # 80070d88 <disk>
    8000558c:	6398                	ld	a4,0(a5)
    8000558e:	9736                	add	a4,a4,a3
    80005590:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005594:	6398                	ld	a4,0(a5)
    80005596:	9736                	add	a4,a4,a3
    80005598:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000559c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800055a0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800055a4:	97aa                	add	a5,a5,a0
    800055a6:	4705                	li	a4,1
    800055a8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800055ac:	0006b517          	auipc	a0,0x6b
    800055b0:	7f450513          	addi	a0,a0,2036 # 80070da0 <disk+0x18>
    800055b4:	a6dfc0ef          	jal	80002020 <wakeup>
}
    800055b8:	60a2                	ld	ra,8(sp)
    800055ba:	6402                	ld	s0,0(sp)
    800055bc:	0141                	addi	sp,sp,16
    800055be:	8082                	ret
    panic("free_desc 1");
    800055c0:	00002517          	auipc	a0,0x2
    800055c4:	12050513          	addi	a0,a0,288 # 800076e0 <etext+0x6e0>
    800055c8:	9d6fb0ef          	jal	8000079e <panic>
    panic("free_desc 2");
    800055cc:	00002517          	auipc	a0,0x2
    800055d0:	12450513          	addi	a0,a0,292 # 800076f0 <etext+0x6f0>
    800055d4:	9cafb0ef          	jal	8000079e <panic>

00000000800055d8 <virtio_disk_init>:
{
    800055d8:	1101                	addi	sp,sp,-32
    800055da:	ec06                	sd	ra,24(sp)
    800055dc:	e822                	sd	s0,16(sp)
    800055de:	e426                	sd	s1,8(sp)
    800055e0:	e04a                	sd	s2,0(sp)
    800055e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055e4:	00002597          	auipc	a1,0x2
    800055e8:	11c58593          	addi	a1,a1,284 # 80007700 <etext+0x700>
    800055ec:	0006c517          	auipc	a0,0x6c
    800055f0:	8c450513          	addi	a0,a0,-1852 # 80070eb0 <disk+0x128>
    800055f4:	d7efb0ef          	jal	80000b72 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	4398                	lw	a4,0(a5)
    800055fe:	2701                	sext.w	a4,a4
    80005600:	747277b7          	lui	a5,0x74727
    80005604:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005608:	14f71863          	bne	a4,a5,80005758 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	43dc                	lw	a5,4(a5)
    80005612:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005614:	4709                	li	a4,2
    80005616:	14e79163          	bne	a5,a4,80005758 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000561a:	100017b7          	lui	a5,0x10001
    8000561e:	479c                	lw	a5,8(a5)
    80005620:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005622:	12e79b63          	bne	a5,a4,80005758 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005626:	100017b7          	lui	a5,0x10001
    8000562a:	47d8                	lw	a4,12(a5)
    8000562c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000562e:	554d47b7          	lui	a5,0x554d4
    80005632:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005636:	12f71163          	bne	a4,a5,80005758 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563a:	100017b7          	lui	a5,0x10001
    8000563e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005642:	4705                	li	a4,1
    80005644:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005646:	470d                	li	a4,3
    80005648:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000564a:	10001737          	lui	a4,0x10001
    8000564e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005650:	c7ffe6b7          	lui	a3,0xc7ffe
    80005654:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f8d897>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005658:	8f75                	and	a4,a4,a3
    8000565a:	100016b7          	lui	a3,0x10001
    8000565e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005660:	472d                	li	a4,11
    80005662:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005664:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005668:	439c                	lw	a5,0(a5)
    8000566a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000566e:	8ba1                	andi	a5,a5,8
    80005670:	0e078a63          	beqz	a5,80005764 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005674:	100017b7          	lui	a5,0x10001
    80005678:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000567c:	43fc                	lw	a5,68(a5)
    8000567e:	2781                	sext.w	a5,a5
    80005680:	0e079863          	bnez	a5,80005770 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005684:	100017b7          	lui	a5,0x10001
    80005688:	5bdc                	lw	a5,52(a5)
    8000568a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000568c:	0e078863          	beqz	a5,8000577c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005690:	471d                	li	a4,7
    80005692:	0ef77b63          	bgeu	a4,a5,80005788 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005696:	c8cfb0ef          	jal	80000b22 <kalloc>
    8000569a:	0006b497          	auipc	s1,0x6b
    8000569e:	6ee48493          	addi	s1,s1,1774 # 80070d88 <disk>
    800056a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056a4:	c7efb0ef          	jal	80000b22 <kalloc>
    800056a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056aa:	c78fb0ef          	jal	80000b22 <kalloc>
    800056ae:	87aa                	mv	a5,a0
    800056b0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056b2:	6088                	ld	a0,0(s1)
    800056b4:	0e050063          	beqz	a0,80005794 <virtio_disk_init+0x1bc>
    800056b8:	0006b717          	auipc	a4,0x6b
    800056bc:	6d873703          	ld	a4,1752(a4) # 80070d90 <disk+0x8>
    800056c0:	cb71                	beqz	a4,80005794 <virtio_disk_init+0x1bc>
    800056c2:	cbe9                	beqz	a5,80005794 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800056c4:	6605                	lui	a2,0x1
    800056c6:	4581                	li	a1,0
    800056c8:	dfefb0ef          	jal	80000cc6 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056cc:	0006b497          	auipc	s1,0x6b
    800056d0:	6bc48493          	addi	s1,s1,1724 # 80070d88 <disk>
    800056d4:	6605                	lui	a2,0x1
    800056d6:	4581                	li	a1,0
    800056d8:	6488                	ld	a0,8(s1)
    800056da:	decfb0ef          	jal	80000cc6 <memset>
  memset(disk.used, 0, PGSIZE);
    800056de:	6605                	lui	a2,0x1
    800056e0:	4581                	li	a1,0
    800056e2:	6888                	ld	a0,16(s1)
    800056e4:	de2fb0ef          	jal	80000cc6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056e8:	100017b7          	lui	a5,0x10001
    800056ec:	4721                	li	a4,8
    800056ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056f0:	4098                	lw	a4,0(s1)
    800056f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056f6:	40d8                	lw	a4,4(s1)
    800056f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056fc:	649c                	ld	a5,8(s1)
    800056fe:	0007869b          	sext.w	a3,a5
    80005702:	10001737          	lui	a4,0x10001
    80005706:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000570a:	9781                	srai	a5,a5,0x20
    8000570c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005710:	689c                	ld	a5,16(s1)
    80005712:	0007869b          	sext.w	a3,a5
    80005716:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000571a:	9781                	srai	a5,a5,0x20
    8000571c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005720:	4785                	li	a5,1
    80005722:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005724:	00f48c23          	sb	a5,24(s1)
    80005728:	00f48ca3          	sb	a5,25(s1)
    8000572c:	00f48d23          	sb	a5,26(s1)
    80005730:	00f48da3          	sb	a5,27(s1)
    80005734:	00f48e23          	sb	a5,28(s1)
    80005738:	00f48ea3          	sb	a5,29(s1)
    8000573c:	00f48f23          	sb	a5,30(s1)
    80005740:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005744:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005748:	07272823          	sw	s2,112(a4)
}
    8000574c:	60e2                	ld	ra,24(sp)
    8000574e:	6442                	ld	s0,16(sp)
    80005750:	64a2                	ld	s1,8(sp)
    80005752:	6902                	ld	s2,0(sp)
    80005754:	6105                	addi	sp,sp,32
    80005756:	8082                	ret
    panic("could not find virtio disk");
    80005758:	00002517          	auipc	a0,0x2
    8000575c:	fb850513          	addi	a0,a0,-72 # 80007710 <etext+0x710>
    80005760:	83efb0ef          	jal	8000079e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005764:	00002517          	auipc	a0,0x2
    80005768:	fcc50513          	addi	a0,a0,-52 # 80007730 <etext+0x730>
    8000576c:	832fb0ef          	jal	8000079e <panic>
    panic("virtio disk should not be ready");
    80005770:	00002517          	auipc	a0,0x2
    80005774:	fe050513          	addi	a0,a0,-32 # 80007750 <etext+0x750>
    80005778:	826fb0ef          	jal	8000079e <panic>
    panic("virtio disk has no queue 0");
    8000577c:	00002517          	auipc	a0,0x2
    80005780:	ff450513          	addi	a0,a0,-12 # 80007770 <etext+0x770>
    80005784:	81afb0ef          	jal	8000079e <panic>
    panic("virtio disk max queue too short");
    80005788:	00002517          	auipc	a0,0x2
    8000578c:	00850513          	addi	a0,a0,8 # 80007790 <etext+0x790>
    80005790:	80efb0ef          	jal	8000079e <panic>
    panic("virtio disk kalloc");
    80005794:	00002517          	auipc	a0,0x2
    80005798:	01c50513          	addi	a0,a0,28 # 800077b0 <etext+0x7b0>
    8000579c:	802fb0ef          	jal	8000079e <panic>

00000000800057a0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057a0:	711d                	addi	sp,sp,-96
    800057a2:	ec86                	sd	ra,88(sp)
    800057a4:	e8a2                	sd	s0,80(sp)
    800057a6:	e4a6                	sd	s1,72(sp)
    800057a8:	e0ca                	sd	s2,64(sp)
    800057aa:	fc4e                	sd	s3,56(sp)
    800057ac:	f852                	sd	s4,48(sp)
    800057ae:	f456                	sd	s5,40(sp)
    800057b0:	f05a                	sd	s6,32(sp)
    800057b2:	ec5e                	sd	s7,24(sp)
    800057b4:	e862                	sd	s8,16(sp)
    800057b6:	1080                	addi	s0,sp,96
    800057b8:	89aa                	mv	s3,a0
    800057ba:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057bc:	00c52b83          	lw	s7,12(a0)
    800057c0:	001b9b9b          	slliw	s7,s7,0x1
    800057c4:	1b82                	slli	s7,s7,0x20
    800057c6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800057ca:	0006b517          	auipc	a0,0x6b
    800057ce:	6e650513          	addi	a0,a0,1766 # 80070eb0 <disk+0x128>
    800057d2:	c24fb0ef          	jal	80000bf6 <acquire>
  for(int i = 0; i < NUM; i++){
    800057d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057d8:	0006ba97          	auipc	s5,0x6b
    800057dc:	5b0a8a93          	addi	s5,s5,1456 # 80070d88 <disk>
  for(int i = 0; i < 3; i++){
    800057e0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800057e2:	5c7d                	li	s8,-1
    800057e4:	a095                	j	80005848 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800057e6:	00fa8733          	add	a4,s5,a5
    800057ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057ee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057f0:	0207c563          	bltz	a5,8000581a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800057f4:	2905                	addiw	s2,s2,1
    800057f6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800057f8:	05490c63          	beq	s2,s4,80005850 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800057fc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800057fe:	0006b717          	auipc	a4,0x6b
    80005802:	58a70713          	addi	a4,a4,1418 # 80070d88 <disk>
    80005806:	4781                	li	a5,0
    if(disk.free[i]){
    80005808:	01874683          	lbu	a3,24(a4)
    8000580c:	fee9                	bnez	a3,800057e6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000580e:	2785                	addiw	a5,a5,1
    80005810:	0705                	addi	a4,a4,1
    80005812:	fe979be3          	bne	a5,s1,80005808 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005816:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000581a:	01205d63          	blez	s2,80005834 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000581e:	fa042503          	lw	a0,-96(s0)
    80005822:	d41ff0ef          	jal	80005562 <free_desc>
      for(int j = 0; j < i; j++)
    80005826:	4785                	li	a5,1
    80005828:	0127d663          	bge	a5,s2,80005834 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000582c:	fa442503          	lw	a0,-92(s0)
    80005830:	d33ff0ef          	jal	80005562 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005834:	0006b597          	auipc	a1,0x6b
    80005838:	67c58593          	addi	a1,a1,1660 # 80070eb0 <disk+0x128>
    8000583c:	0006b517          	auipc	a0,0x6b
    80005840:	56450513          	addi	a0,a0,1380 # 80070da0 <disk+0x18>
    80005844:	f90fc0ef          	jal	80001fd4 <sleep>
  for(int i = 0; i < 3; i++){
    80005848:	fa040613          	addi	a2,s0,-96
    8000584c:	4901                	li	s2,0
    8000584e:	b77d                	j	800057fc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005850:	fa042503          	lw	a0,-96(s0)
    80005854:	00451693          	slli	a3,a0,0x4

  if(write)
    80005858:	0006b797          	auipc	a5,0x6b
    8000585c:	53078793          	addi	a5,a5,1328 # 80070d88 <disk>
    80005860:	00a50713          	addi	a4,a0,10
    80005864:	0712                	slli	a4,a4,0x4
    80005866:	973e                	add	a4,a4,a5
    80005868:	01603633          	snez	a2,s6
    8000586c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000586e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005872:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005876:	6398                	ld	a4,0(a5)
    80005878:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000587a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    8000587e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005880:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005882:	6390                	ld	a2,0(a5)
    80005884:	00d605b3          	add	a1,a2,a3
    80005888:	4741                	li	a4,16
    8000588a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000588c:	4805                	li	a6,1
    8000588e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005892:	fa442703          	lw	a4,-92(s0)
    80005896:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000589a:	0712                	slli	a4,a4,0x4
    8000589c:	963a                	add	a2,a2,a4
    8000589e:	05898593          	addi	a1,s3,88
    800058a2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058a4:	0007b883          	ld	a7,0(a5)
    800058a8:	9746                	add	a4,a4,a7
    800058aa:	40000613          	li	a2,1024
    800058ae:	c710                	sw	a2,8(a4)
  if(write)
    800058b0:	001b3613          	seqz	a2,s6
    800058b4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058b8:	01066633          	or	a2,a2,a6
    800058bc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800058c0:	fa842583          	lw	a1,-88(s0)
    800058c4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058c8:	00250613          	addi	a2,a0,2
    800058cc:	0612                	slli	a2,a2,0x4
    800058ce:	963e                	add	a2,a2,a5
    800058d0:	577d                	li	a4,-1
    800058d2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058d6:	0592                	slli	a1,a1,0x4
    800058d8:	98ae                	add	a7,a7,a1
    800058da:	03068713          	addi	a4,a3,48
    800058de:	973e                	add	a4,a4,a5
    800058e0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800058e4:	6398                	ld	a4,0(a5)
    800058e6:	972e                	add	a4,a4,a1
    800058e8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058ec:	4689                	li	a3,2
    800058ee:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800058f2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058f6:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800058fa:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058fe:	6794                	ld	a3,8(a5)
    80005900:	0026d703          	lhu	a4,2(a3)
    80005904:	8b1d                	andi	a4,a4,7
    80005906:	0706                	slli	a4,a4,0x1
    80005908:	96ba                	add	a3,a3,a4
    8000590a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000590e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005912:	6798                	ld	a4,8(a5)
    80005914:	00275783          	lhu	a5,2(a4)
    80005918:	2785                	addiw	a5,a5,1
    8000591a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000591e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005922:	100017b7          	lui	a5,0x10001
    80005926:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000592a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    8000592e:	0006b917          	auipc	s2,0x6b
    80005932:	58290913          	addi	s2,s2,1410 # 80070eb0 <disk+0x128>
  while(b->disk == 1) {
    80005936:	84c2                	mv	s1,a6
    80005938:	01079a63          	bne	a5,a6,8000594c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    8000593c:	85ca                	mv	a1,s2
    8000593e:	854e                	mv	a0,s3
    80005940:	e94fc0ef          	jal	80001fd4 <sleep>
  while(b->disk == 1) {
    80005944:	0049a783          	lw	a5,4(s3)
    80005948:	fe978ae3          	beq	a5,s1,8000593c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    8000594c:	fa042903          	lw	s2,-96(s0)
    80005950:	00290713          	addi	a4,s2,2
    80005954:	0712                	slli	a4,a4,0x4
    80005956:	0006b797          	auipc	a5,0x6b
    8000595a:	43278793          	addi	a5,a5,1074 # 80070d88 <disk>
    8000595e:	97ba                	add	a5,a5,a4
    80005960:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005964:	0006b997          	auipc	s3,0x6b
    80005968:	42498993          	addi	s3,s3,1060 # 80070d88 <disk>
    8000596c:	00491713          	slli	a4,s2,0x4
    80005970:	0009b783          	ld	a5,0(s3)
    80005974:	97ba                	add	a5,a5,a4
    80005976:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000597a:	854a                	mv	a0,s2
    8000597c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005980:	be3ff0ef          	jal	80005562 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005984:	8885                	andi	s1,s1,1
    80005986:	f0fd                	bnez	s1,8000596c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005988:	0006b517          	auipc	a0,0x6b
    8000598c:	52850513          	addi	a0,a0,1320 # 80070eb0 <disk+0x128>
    80005990:	afafb0ef          	jal	80000c8a <release>
}
    80005994:	60e6                	ld	ra,88(sp)
    80005996:	6446                	ld	s0,80(sp)
    80005998:	64a6                	ld	s1,72(sp)
    8000599a:	6906                	ld	s2,64(sp)
    8000599c:	79e2                	ld	s3,56(sp)
    8000599e:	7a42                	ld	s4,48(sp)
    800059a0:	7aa2                	ld	s5,40(sp)
    800059a2:	7b02                	ld	s6,32(sp)
    800059a4:	6be2                	ld	s7,24(sp)
    800059a6:	6c42                	ld	s8,16(sp)
    800059a8:	6125                	addi	sp,sp,96
    800059aa:	8082                	ret

00000000800059ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059ac:	1101                	addi	sp,sp,-32
    800059ae:	ec06                	sd	ra,24(sp)
    800059b0:	e822                	sd	s0,16(sp)
    800059b2:	e426                	sd	s1,8(sp)
    800059b4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059b6:	0006b497          	auipc	s1,0x6b
    800059ba:	3d248493          	addi	s1,s1,978 # 80070d88 <disk>
    800059be:	0006b517          	auipc	a0,0x6b
    800059c2:	4f250513          	addi	a0,a0,1266 # 80070eb0 <disk+0x128>
    800059c6:	a30fb0ef          	jal	80000bf6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059ca:	100017b7          	lui	a5,0x10001
    800059ce:	53bc                	lw	a5,96(a5)
    800059d0:	8b8d                	andi	a5,a5,3
    800059d2:	10001737          	lui	a4,0x10001
    800059d6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059d8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059dc:	689c                	ld	a5,16(s1)
    800059de:	0204d703          	lhu	a4,32(s1)
    800059e2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800059e6:	04f70663          	beq	a4,a5,80005a32 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800059ea:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059ee:	6898                	ld	a4,16(s1)
    800059f0:	0204d783          	lhu	a5,32(s1)
    800059f4:	8b9d                	andi	a5,a5,7
    800059f6:	078e                	slli	a5,a5,0x3
    800059f8:	97ba                	add	a5,a5,a4
    800059fa:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059fc:	00278713          	addi	a4,a5,2
    80005a00:	0712                	slli	a4,a4,0x4
    80005a02:	9726                	add	a4,a4,s1
    80005a04:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a08:	e321                	bnez	a4,80005a48 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a0a:	0789                	addi	a5,a5,2
    80005a0c:	0792                	slli	a5,a5,0x4
    80005a0e:	97a6                	add	a5,a5,s1
    80005a10:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a12:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a16:	e0afc0ef          	jal	80002020 <wakeup>

    disk.used_idx += 1;
    80005a1a:	0204d783          	lhu	a5,32(s1)
    80005a1e:	2785                	addiw	a5,a5,1
    80005a20:	17c2                	slli	a5,a5,0x30
    80005a22:	93c1                	srli	a5,a5,0x30
    80005a24:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a28:	6898                	ld	a4,16(s1)
    80005a2a:	00275703          	lhu	a4,2(a4)
    80005a2e:	faf71ee3          	bne	a4,a5,800059ea <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a32:	0006b517          	auipc	a0,0x6b
    80005a36:	47e50513          	addi	a0,a0,1150 # 80070eb0 <disk+0x128>
    80005a3a:	a50fb0ef          	jal	80000c8a <release>
}
    80005a3e:	60e2                	ld	ra,24(sp)
    80005a40:	6442                	ld	s0,16(sp)
    80005a42:	64a2                	ld	s1,8(sp)
    80005a44:	6105                	addi	sp,sp,32
    80005a46:	8082                	ret
      panic("virtio_disk_intr status");
    80005a48:	00002517          	auipc	a0,0x2
    80005a4c:	d8050513          	addi	a0,a0,-640 # 800077c8 <etext+0x7c8>
    80005a50:	d4ffa0ef          	jal	8000079e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
