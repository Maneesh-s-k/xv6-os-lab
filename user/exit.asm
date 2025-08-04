
user/_exit:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	872a                	mv	a4,a0
    int status = 0;
    if(argc > 1) {
   a:	4785                	li	a5,1
    int status = 0;
   c:	4501                	li	a0,0
    if(argc > 1) {
   e:	00e7c463          	blt	a5,a4,16 <main+0x16>
        status = atoi(argv[1]);
    }
    exit(status);
  12:	2aa000ef          	jal	2bc <exit>
        status = atoi(argv[1]);
  16:	6588                	ld	a0,8(a1)
  18:	1a2000ef          	jal	1ba <atoi>
  1c:	bfdd                	j	12 <main+0x12>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	290000ef          	jal	2bc <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0xa>
    ;
  return os;
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x20>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x20>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf99                	beqz	a5,aa <strlen+0x2a>
  8e:	0505                	addi	a0,a0,1
  90:	87aa                	mv	a5,a0
  92:	86be                	mv	a3,a5
  94:	0785                	addi	a5,a5,1
  96:	fff7c703          	lbu	a4,-1(a5)
  9a:	ff65                	bnez	a4,92 <strlen+0x12>
  9c:	40a6853b          	subw	a0,a3,a0
  a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  for(n = 0; s[n]; n++)
  aa:	4501                	li	a0,0
  ac:	bfdd                	j	a2 <strlen+0x22>

00000000000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b6:	ca19                	beqz	a2,cc <memset+0x1e>
  b8:	87aa                	mv	a5,a0
  ba:	1602                	slli	a2,a2,0x20
  bc:	9201                	srli	a2,a2,0x20
  be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c6:	0785                	addi	a5,a5,1
  c8:	fee79de3          	bne	a5,a4,c2 <memset+0x14>
  }
  return dst;
}
  cc:	60a2                	ld	ra,8(sp)
  ce:	6402                	ld	s0,0(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf81                	beqz	a5,f8 <strchr+0x24>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1c>
  for(; *s; s++)
  e6:	0505                	addi	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xe>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfdd                	j	f0 <strchr+0x1c>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	7159                	addi	sp,sp,-112
  fe:	f486                	sd	ra,104(sp)
 100:	f0a2                	sd	s0,96(sp)
 102:	eca6                	sd	s1,88(sp)
 104:	e8ca                	sd	s2,80(sp)
 106:	e4ce                	sd	s3,72(sp)
 108:	e0d2                	sd	s4,64(sp)
 10a:	fc56                	sd	s5,56(sp)
 10c:	f85a                	sd	s6,48(sp)
 10e:	f45e                	sd	s7,40(sp)
 110:	f062                	sd	s8,32(sp)
 112:	ec66                	sd	s9,24(sp)
 114:	e86a                	sd	s10,16(sp)
 116:	1880                	addi	s0,sp,112
 118:	8caa                	mv	s9,a0
 11a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11c:	892a                	mv	s2,a0
 11e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 120:	f9f40b13          	addi	s6,s0,-97
 124:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 126:	4ba9                	li	s7,10
 128:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 12a:	8d26                	mv	s10,s1
 12c:	0014899b          	addiw	s3,s1,1
 130:	84ce                	mv	s1,s3
 132:	0349d563          	bge	s3,s4,15c <gets+0x60>
    cc = read(0, &c, 1);
 136:	8656                	mv	a2,s5
 138:	85da                	mv	a1,s6
 13a:	4501                	li	a0,0
 13c:	198000ef          	jal	2d4 <read>
    if(cc < 1)
 140:	00a05e63          	blez	a0,15c <gets+0x60>
    buf[i++] = c;
 144:	f9f44783          	lbu	a5,-97(s0)
 148:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14c:	01778763          	beq	a5,s7,15a <gets+0x5e>
 150:	0905                	addi	s2,s2,1
 152:	fd879ce3          	bne	a5,s8,12a <gets+0x2e>
    buf[i++] = c;
 156:	8d4e                	mv	s10,s3
 158:	a011                	j	15c <gets+0x60>
 15a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 15c:	9d66                	add	s10,s10,s9
 15e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 162:	8566                	mv	a0,s9
 164:	70a6                	ld	ra,104(sp)
 166:	7406                	ld	s0,96(sp)
 168:	64e6                	ld	s1,88(sp)
 16a:	6946                	ld	s2,80(sp)
 16c:	69a6                	ld	s3,72(sp)
 16e:	6a06                	ld	s4,64(sp)
 170:	7ae2                	ld	s5,56(sp)
 172:	7b42                	ld	s6,48(sp)
 174:	7ba2                	ld	s7,40(sp)
 176:	7c02                	ld	s8,32(sp)
 178:	6ce2                	ld	s9,24(sp)
 17a:	6d42                	ld	s10,16(sp)
 17c:	6165                	addi	sp,sp,112
 17e:	8082                	ret

0000000000000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	1101                	addi	sp,sp,-32
 182:	ec06                	sd	ra,24(sp)
 184:	e822                	sd	s0,16(sp)
 186:	e04a                	sd	s2,0(sp)
 188:	1000                	addi	s0,sp,32
 18a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18c:	4581                	li	a1,0
 18e:	16e000ef          	jal	2fc <open>
  if(fd < 0)
 192:	02054263          	bltz	a0,1b6 <stat+0x36>
 196:	e426                	sd	s1,8(sp)
 198:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19a:	85ca                	mv	a1,s2
 19c:	178000ef          	jal	314 <fstat>
 1a0:	892a                	mv	s2,a0
  close(fd);
 1a2:	8526                	mv	a0,s1
 1a4:	140000ef          	jal	2e4 <close>
  return r;
 1a8:	64a2                	ld	s1,8(sp)
}
 1aa:	854a                	mv	a0,s2
 1ac:	60e2                	ld	ra,24(sp)
 1ae:	6442                	ld	s0,16(sp)
 1b0:	6902                	ld	s2,0(sp)
 1b2:	6105                	addi	sp,sp,32
 1b4:	8082                	ret
    return -1;
 1b6:	597d                	li	s2,-1
 1b8:	bfcd                	j	1aa <stat+0x2a>

00000000000001ba <atoi>:

int
atoi(const char *s)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e406                	sd	ra,8(sp)
 1be:	e022                	sd	s0,0(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c2:	00054683          	lbu	a3,0(a0)
 1c6:	fd06879b          	addiw	a5,a3,-48
 1ca:	0ff7f793          	zext.b	a5,a5
 1ce:	4625                	li	a2,9
 1d0:	02f66963          	bltu	a2,a5,202 <atoi+0x48>
 1d4:	872a                	mv	a4,a0
  n = 0;
 1d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d8:	0705                	addi	a4,a4,1
 1da:	0025179b          	slliw	a5,a0,0x2
 1de:	9fa9                	addw	a5,a5,a0
 1e0:	0017979b          	slliw	a5,a5,0x1
 1e4:	9fb5                	addw	a5,a5,a3
 1e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ea:	00074683          	lbu	a3,0(a4)
 1ee:	fd06879b          	addiw	a5,a3,-48
 1f2:	0ff7f793          	zext.b	a5,a5
 1f6:	fef671e3          	bgeu	a2,a5,1d8 <atoi+0x1e>
  return n;
}
 1fa:	60a2                	ld	ra,8(sp)
 1fc:	6402                	ld	s0,0(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  n = 0;
 202:	4501                	li	a0,0
 204:	bfdd                	j	1fa <atoi+0x40>

0000000000000206 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 206:	1141                	addi	sp,sp,-16
 208:	e406                	sd	ra,8(sp)
 20a:	e022                	sd	s0,0(sp)
 20c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20e:	02b57563          	bgeu	a0,a1,238 <memmove+0x32>
    while(n-- > 0)
 212:	00c05f63          	blez	a2,230 <memmove+0x2a>
 216:	1602                	slli	a2,a2,0x20
 218:	9201                	srli	a2,a2,0x20
 21a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21e:	872a                	mv	a4,a0
      *dst++ = *src++;
 220:	0585                	addi	a1,a1,1
 222:	0705                	addi	a4,a4,1
 224:	fff5c683          	lbu	a3,-1(a1)
 228:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 230:	60a2                	ld	ra,8(sp)
 232:	6402                	ld	s0,0(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec059e3          	blez	a2,230 <memmove+0x2a>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fef71ae3          	bne	a4,a5,250 <memmove+0x4a>
 260:	bfc1                	j	230 <memmove+0x2a>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26a:	ca0d                	beqz	a2,29c <memcmp+0x3a>
 26c:	fff6069b          	addiw	a3,a2,-1
 270:	1682                	slli	a3,a3,0x20
 272:	9281                	srli	a3,a3,0x20
 274:	0685                	addi	a3,a3,1
 276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	addi	a0,a0,1
    p2++;
 286:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x16>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x32>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  return 0;
 29c:	4501                	li	a0,0
 29e:	bfdd                	j	294 <memcmp+0x32>

00000000000002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a8:	f5fff0ef          	jal	206 <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b4:	4885                	li	a7,1
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2bc:	4889                	li	a7,2
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c4:	488d                	li	a7,3
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2cc:	4891                	li	a7,4
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <read>:
.global read
read:
 li a7, SYS_read
 2d4:	4895                	li	a7,5
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <write>:
.global write
write:
 li a7, SYS_write
 2dc:	48c1                	li	a7,16
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <close>:
.global close
close:
 li a7, SYS_close
 2e4:	48d5                	li	a7,21
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ec:	4899                	li	a7,6
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f4:	489d                	li	a7,7
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <open>:
.global open
open:
 li a7, SYS_open
 2fc:	48bd                	li	a7,15
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 304:	48c5                	li	a7,17
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30c:	48c9                	li	a7,18
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 314:	48a1                	li	a7,8
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <link>:
.global link
link:
 li a7, SYS_link
 31c:	48cd                	li	a7,19
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 324:	48d1                	li	a7,20
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32c:	48a5                	li	a7,9
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <dup>:
.global dup
dup:
 li a7, SYS_dup
 334:	48a9                	li	a7,10
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33c:	48ad                	li	a7,11
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 344:	48b1                	li	a7,12
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34c:	48b5                	li	a7,13
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 354:	48b9                	li	a7,14
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35c:	1101                	addi	sp,sp,-32
 35e:	ec06                	sd	ra,24(sp)
 360:	e822                	sd	s0,16(sp)
 362:	1000                	addi	s0,sp,32
 364:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 368:	4605                	li	a2,1
 36a:	fef40593          	addi	a1,s0,-17
 36e:	f6fff0ef          	jal	2dc <write>
}
 372:	60e2                	ld	ra,24(sp)
 374:	6442                	ld	s0,16(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret

000000000000037a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 37a:	715d                	addi	sp,sp,-80
 37c:	e486                	sd	ra,72(sp)
 37e:	e0a2                	sd	s0,64(sp)
 380:	fc26                	sd	s1,56(sp)
 382:	f84a                	sd	s2,48(sp)
 384:	f44e                	sd	s3,40(sp)
 386:	0880                	addi	s0,sp,80
 388:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38a:	c299                	beqz	a3,390 <printint+0x16>
 38c:	0605cf63          	bltz	a1,40a <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 390:	2581                	sext.w	a1,a1
  neg = 0;
 392:	4e01                	li	t3,0
  }

  i = 0;
 394:	fb840313          	addi	t1,s0,-72
  neg = 0;
 398:	869a                	mv	a3,t1
  i = 0;
 39a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 39c:	00000817          	auipc	a6,0x0
 3a0:	4dc80813          	addi	a6,a6,1244 # 878 <digits>
 3a4:	88be                	mv	a7,a5
 3a6:	0017851b          	addiw	a0,a5,1
 3aa:	87aa                	mv	a5,a0
 3ac:	02c5f73b          	remuw	a4,a1,a2
 3b0:	1702                	slli	a4,a4,0x20
 3b2:	9301                	srli	a4,a4,0x20
 3b4:	9742                	add	a4,a4,a6
 3b6:	00074703          	lbu	a4,0(a4)
 3ba:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3be:	872e                	mv	a4,a1
 3c0:	02c5d5bb          	divuw	a1,a1,a2
 3c4:	0685                	addi	a3,a3,1
 3c6:	fcc77fe3          	bgeu	a4,a2,3a4 <printint+0x2a>
  if(neg)
 3ca:	000e0c63          	beqz	t3,3e2 <printint+0x68>
    buf[i++] = '-';
 3ce:	fd050793          	addi	a5,a0,-48
 3d2:	00878533          	add	a0,a5,s0
 3d6:	02d00793          	li	a5,45
 3da:	fef50423          	sb	a5,-24(a0)
 3de:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3e2:	fff7899b          	addiw	s3,a5,-1
 3e6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3ea:	fff4c583          	lbu	a1,-1(s1)
 3ee:	854a                	mv	a0,s2
 3f0:	f6dff0ef          	jal	35c <putc>
  while(--i >= 0)
 3f4:	39fd                	addiw	s3,s3,-1
 3f6:	14fd                	addi	s1,s1,-1
 3f8:	fe09d9e3          	bgez	s3,3ea <printint+0x70>
}
 3fc:	60a6                	ld	ra,72(sp)
 3fe:	6406                	ld	s0,64(sp)
 400:	74e2                	ld	s1,56(sp)
 402:	7942                	ld	s2,48(sp)
 404:	79a2                	ld	s3,40(sp)
 406:	6161                	addi	sp,sp,80
 408:	8082                	ret
    x = -xx;
 40a:	40b005bb          	negw	a1,a1
    neg = 1;
 40e:	4e05                	li	t3,1
    x = -xx;
 410:	b751                	j	394 <printint+0x1a>

0000000000000412 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 412:	711d                	addi	sp,sp,-96
 414:	ec86                	sd	ra,88(sp)
 416:	e8a2                	sd	s0,80(sp)
 418:	e4a6                	sd	s1,72(sp)
 41a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 41c:	0005c483          	lbu	s1,0(a1)
 420:	26048663          	beqz	s1,68c <vprintf+0x27a>
 424:	e0ca                	sd	s2,64(sp)
 426:	fc4e                	sd	s3,56(sp)
 428:	f852                	sd	s4,48(sp)
 42a:	f456                	sd	s5,40(sp)
 42c:	f05a                	sd	s6,32(sp)
 42e:	ec5e                	sd	s7,24(sp)
 430:	e862                	sd	s8,16(sp)
 432:	e466                	sd	s9,8(sp)
 434:	8b2a                	mv	s6,a0
 436:	8a2e                	mv	s4,a1
 438:	8bb2                	mv	s7,a2
  state = 0;
 43a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 43c:	4901                	li	s2,0
 43e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 440:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 444:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 448:	06c00c93          	li	s9,108
 44c:	a00d                	j	46e <vprintf+0x5c>
        putc(fd, c0);
 44e:	85a6                	mv	a1,s1
 450:	855a                	mv	a0,s6
 452:	f0bff0ef          	jal	35c <putc>
 456:	a019                	j	45c <vprintf+0x4a>
    } else if(state == '%'){
 458:	03598363          	beq	s3,s5,47e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 45c:	0019079b          	addiw	a5,s2,1
 460:	893e                	mv	s2,a5
 462:	873e                	mv	a4,a5
 464:	97d2                	add	a5,a5,s4
 466:	0007c483          	lbu	s1,0(a5)
 46a:	20048963          	beqz	s1,67c <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 46e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 472:	fe0993e3          	bnez	s3,458 <vprintf+0x46>
      if(c0 == '%'){
 476:	fd579ce3          	bne	a5,s5,44e <vprintf+0x3c>
        state = '%';
 47a:	89be                	mv	s3,a5
 47c:	b7c5                	j	45c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 47e:	00ea06b3          	add	a3,s4,a4
 482:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 486:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 488:	c681                	beqz	a3,490 <vprintf+0x7e>
 48a:	9752                	add	a4,a4,s4
 48c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 490:	03878e63          	beq	a5,s8,4cc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 494:	05978863          	beq	a5,s9,4e4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 498:	07500713          	li	a4,117
 49c:	0ee78263          	beq	a5,a4,580 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a0:	07800713          	li	a4,120
 4a4:	12e78463          	beq	a5,a4,5cc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4a8:	07000713          	li	a4,112
 4ac:	14e78963          	beq	a5,a4,5fe <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4b0:	07300713          	li	a4,115
 4b4:	18e78863          	beq	a5,a4,644 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4b8:	02500713          	li	a4,37
 4bc:	04e79463          	bne	a5,a4,504 <vprintf+0xf2>
        putc(fd, '%');
 4c0:	85ba                	mv	a1,a4
 4c2:	855a                	mv	a0,s6
 4c4:	e99ff0ef          	jal	35c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	bf49                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4cc:	008b8493          	addi	s1,s7,8
 4d0:	4685                	li	a3,1
 4d2:	4629                	li	a2,10
 4d4:	000ba583          	lw	a1,0(s7)
 4d8:	855a                	mv	a0,s6
 4da:	ea1ff0ef          	jal	37a <printint>
 4de:	8ba6                	mv	s7,s1
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	bfad                	j	45c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4e4:	06400793          	li	a5,100
 4e8:	02f68963          	beq	a3,a5,51a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4ec:	06c00793          	li	a5,108
 4f0:	04f68263          	beq	a3,a5,534 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4f4:	07500793          	li	a5,117
 4f8:	0af68063          	beq	a3,a5,598 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4fc:	07800793          	li	a5,120
 500:	0ef68263          	beq	a3,a5,5e4 <vprintf+0x1d2>
        putc(fd, '%');
 504:	02500593          	li	a1,37
 508:	855a                	mv	a0,s6
 50a:	e53ff0ef          	jal	35c <putc>
        putc(fd, c0);
 50e:	85a6                	mv	a1,s1
 510:	855a                	mv	a0,s6
 512:	e4bff0ef          	jal	35c <putc>
      state = 0;
 516:	4981                	li	s3,0
 518:	b791                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51a:	008b8493          	addi	s1,s7,8
 51e:	4685                	li	a3,1
 520:	4629                	li	a2,10
 522:	000bb583          	ld	a1,0(s7)
 526:	855a                	mv	a0,s6
 528:	e53ff0ef          	jal	37a <printint>
        i += 1;
 52c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 52e:	8ba6                	mv	s7,s1
      state = 0;
 530:	4981                	li	s3,0
        i += 1;
 532:	b72d                	j	45c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 534:	06400793          	li	a5,100
 538:	02f60763          	beq	a2,a5,566 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 53c:	07500793          	li	a5,117
 540:	06f60963          	beq	a2,a5,5b2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 544:	07800793          	li	a5,120
 548:	faf61ee3          	bne	a2,a5,504 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 54c:	008b8493          	addi	s1,s7,8
 550:	4681                	li	a3,0
 552:	4641                	li	a2,16
 554:	000bb583          	ld	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	e21ff0ef          	jal	37a <printint>
        i += 2;
 55e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 560:	8ba6                	mv	s7,s1
      state = 0;
 562:	4981                	li	s3,0
        i += 2;
 564:	bde5                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	008b8493          	addi	s1,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000bb583          	ld	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	e07ff0ef          	jal	37a <printint>
        i += 2;
 578:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	8ba6                	mv	s7,s1
      state = 0;
 57c:	4981                	li	s3,0
        i += 2;
 57e:	bdf9                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 580:	008b8493          	addi	s1,s7,8
 584:	4681                	li	a3,0
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	dedff0ef          	jal	37a <printint>
 592:	8ba6                	mv	s7,s1
      state = 0;
 594:	4981                	li	s3,0
 596:	b5d9                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 598:	008b8493          	addi	s1,s7,8
 59c:	4681                	li	a3,0
 59e:	4629                	li	a2,10
 5a0:	000bb583          	ld	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	dd5ff0ef          	jal	37a <printint>
        i += 1;
 5aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ac:	8ba6                	mv	s7,s1
      state = 0;
 5ae:	4981                	li	s3,0
        i += 1;
 5b0:	b575                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	008b8493          	addi	s1,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000bb583          	ld	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	dbbff0ef          	jal	37a <printint>
        i += 2;
 5c4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	8ba6                	mv	s7,s1
      state = 0;
 5c8:	4981                	li	s3,0
        i += 2;
 5ca:	bd49                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5cc:	008b8493          	addi	s1,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4641                	li	a2,16
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	da1ff0ef          	jal	37a <printint>
 5de:	8ba6                	mv	s7,s1
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bdad                	j	45c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	d89ff0ef          	jal	37a <printint>
        i += 1;
 5f6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f8:	8ba6                	mv	s7,s1
      state = 0;
 5fa:	4981                	li	s3,0
        i += 1;
 5fc:	b585                	j	45c <vprintf+0x4a>
 5fe:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 600:	008b8d13          	addi	s10,s7,8
 604:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 608:	03000593          	li	a1,48
 60c:	855a                	mv	a0,s6
 60e:	d4fff0ef          	jal	35c <putc>
  putc(fd, 'x');
 612:	07800593          	li	a1,120
 616:	855a                	mv	a0,s6
 618:	d45ff0ef          	jal	35c <putc>
 61c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61e:	00000b97          	auipc	s7,0x0
 622:	25ab8b93          	addi	s7,s7,602 # 878 <digits>
 626:	03c9d793          	srli	a5,s3,0x3c
 62a:	97de                	add	a5,a5,s7
 62c:	0007c583          	lbu	a1,0(a5)
 630:	855a                	mv	a0,s6
 632:	d2bff0ef          	jal	35c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 636:	0992                	slli	s3,s3,0x4
 638:	34fd                	addiw	s1,s1,-1
 63a:	f4f5                	bnez	s1,626 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 63c:	8bea                	mv	s7,s10
      state = 0;
 63e:	4981                	li	s3,0
 640:	6d02                	ld	s10,0(sp)
 642:	bd29                	j	45c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 644:	008b8993          	addi	s3,s7,8
 648:	000bb483          	ld	s1,0(s7)
 64c:	cc91                	beqz	s1,668 <vprintf+0x256>
        for(; *s; s++)
 64e:	0004c583          	lbu	a1,0(s1)
 652:	c195                	beqz	a1,676 <vprintf+0x264>
          putc(fd, *s);
 654:	855a                	mv	a0,s6
 656:	d07ff0ef          	jal	35c <putc>
        for(; *s; s++)
 65a:	0485                	addi	s1,s1,1
 65c:	0004c583          	lbu	a1,0(s1)
 660:	f9f5                	bnez	a1,654 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 662:	8bce                	mv	s7,s3
      state = 0;
 664:	4981                	li	s3,0
 666:	bbdd                	j	45c <vprintf+0x4a>
          s = "(null)";
 668:	00000497          	auipc	s1,0x0
 66c:	20848493          	addi	s1,s1,520 # 870 <malloc+0xf8>
        for(; *s; s++)
 670:	02800593          	li	a1,40
 674:	b7c5                	j	654 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	b3cd                	j	45c <vprintf+0x4a>
 67c:	6906                	ld	s2,64(sp)
 67e:	79e2                	ld	s3,56(sp)
 680:	7a42                	ld	s4,48(sp)
 682:	7aa2                	ld	s5,40(sp)
 684:	7b02                	ld	s6,32(sp)
 686:	6be2                	ld	s7,24(sp)
 688:	6c42                	ld	s8,16(sp)
 68a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 68c:	60e6                	ld	ra,88(sp)
 68e:	6446                	ld	s0,80(sp)
 690:	64a6                	ld	s1,72(sp)
 692:	6125                	addi	sp,sp,96
 694:	8082                	ret

0000000000000696 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 696:	715d                	addi	sp,sp,-80
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e010                	sd	a2,0(s0)
 6a0:	e414                	sd	a3,8(s0)
 6a2:	e818                	sd	a4,16(s0)
 6a4:	ec1c                	sd	a5,24(s0)
 6a6:	03043023          	sd	a6,32(s0)
 6aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	8622                	mv	a2,s0
 6b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b4:	d5fff0ef          	jal	412 <vprintf>
}
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	6161                	addi	sp,sp,80
 6be:	8082                	ret

00000000000006c0 <printf>:

void
printf(const char *fmt, ...)
{
 6c0:	711d                	addi	sp,sp,-96
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	e40c                	sd	a1,8(s0)
 6ca:	e810                	sd	a2,16(s0)
 6cc:	ec14                	sd	a3,24(s0)
 6ce:	f018                	sd	a4,32(s0)
 6d0:	f41c                	sd	a5,40(s0)
 6d2:	03043823          	sd	a6,48(s0)
 6d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	00840613          	addi	a2,s0,8
 6de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e2:	85aa                	mv	a1,a0
 6e4:	4505                	li	a0,1
 6e6:	d2dff0ef          	jal	412 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6125                	addi	sp,sp,96
 6f0:	8082                	ret

00000000000006f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f2:	1141                	addi	sp,sp,-16
 6f4:	e406                	sd	ra,8(sp)
 6f6:	e022                	sd	s0,0(sp)
 6f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	00001797          	auipc	a5,0x1
 702:	9027b783          	ld	a5,-1790(a5) # 1000 <freep>
 706:	a02d                	j	730 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 708:	4618                	lw	a4,8(a2)
 70a:	9f2d                	addw	a4,a4,a1
 70c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	6398                	ld	a4,0(a5)
 712:	6310                	ld	a2,0(a4)
 714:	a83d                	j	752 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 716:	ff852703          	lw	a4,-8(a0)
 71a:	9f31                	addw	a4,a4,a2
 71c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71e:	ff053683          	ld	a3,-16(a0)
 722:	a091                	j	766 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x3c>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x4c>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x32>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059813          	slli	a6,a1,0x20
 748:	01c85713          	srli	a4,a6,0x1c
 74c:	9736                	add	a4,a4,a3
 74e:	fae60de3          	beq	a2,a4,708 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061593          	slli	a1,a2,0x20
 75c:	01c5d713          	srli	a4,a1,0x1c
 760:	973e                	add	a4,a4,a5
 762:	fae68ae3          	beq	a3,a4,716 <free+0x24>
    p->s.ptr = bp->s.ptr;
 766:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 768:	00001717          	auipc	a4,0x1
 76c:	88f73c23          	sd	a5,-1896(a4) # 1000 <freep>
}
 770:	60a2                	ld	ra,8(sp)
 772:	6402                	ld	s0,0(sp)
 774:	0141                	addi	sp,sp,16
 776:	8082                	ret

0000000000000778 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 778:	7139                	addi	sp,sp,-64
 77a:	fc06                	sd	ra,56(sp)
 77c:	f822                	sd	s0,48(sp)
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 784:	02051993          	slli	s3,a0,0x20
 788:	0209d993          	srli	s3,s3,0x20
 78c:	09bd                	addi	s3,s3,15
 78e:	0049d993          	srli	s3,s3,0x4
 792:	2985                	addiw	s3,s3,1
 794:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 796:	00001517          	auipc	a0,0x1
 79a:	86a53503          	ld	a0,-1942(a0) # 1000 <freep>
 79e:	c905                	beqz	a0,7ce <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a2:	4798                	lw	a4,8(a5)
 7a4:	09377663          	bgeu	a4,s3,830 <malloc+0xb8>
 7a8:	f426                	sd	s1,40(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b0:	8a4e                	mv	s4,s3
 7b2:	6705                	lui	a4,0x1
 7b4:	00e9f363          	bgeu	s3,a4,7ba <malloc+0x42>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00001497          	auipc	s1,0x1
 7c6:	83e48493          	addi	s1,s1,-1986 # 1000 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a83d                	j	80a <malloc+0x92>
 7ce:	f426                	sd	s1,40(sp)
 7d0:	e852                	sd	s4,16(sp)
 7d2:	e456                	sd	s5,8(sp)
 7d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d6:	00001797          	auipc	a5,0x1
 7da:	83a78793          	addi	a5,a5,-1990 # 1010 <base>
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
 7e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ec:	b7d1                	j	7b0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	e118                	sd	a4,0(a0)
 7f2:	a899                	j	848 <malloc+0xd0>
  hp->s.size = nu;
 7f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f8:	0541                	addi	a0,a0,16
 7fa:	ef9ff0ef          	jal	6f2 <free>
  return freep;
 7fe:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 800:	c125                	beqz	a0,860 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	03277163          	bgeu	a4,s2,828 <malloc+0xb0>
    if(p == freep)
 80a:	6098                	ld	a4,0(s1)
 80c:	853e                	mv	a0,a5
 80e:	fef71ae3          	bne	a4,a5,802 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 812:	8552                	mv	a0,s4
 814:	b31ff0ef          	jal	344 <sbrk>
  if(p == (char*)-1)
 818:	fd551ee3          	bne	a0,s5,7f4 <malloc+0x7c>
        return 0;
 81c:	4501                	li	a0,0
 81e:	74a2                	ld	s1,40(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
 826:	a03d                	j	854 <malloc+0xdc>
 828:	74a2                	ld	s1,40(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 830:	fae90fe3          	beq	s2,a4,7ee <malloc+0x76>
        p->s.size -= nunits;
 834:	4137073b          	subw	a4,a4,s3
 838:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83a:	02071693          	slli	a3,a4,0x20
 83e:	01c6d713          	srli	a4,a3,0x1c
 842:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 844:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 848:	00000717          	auipc	a4,0x0
 84c:	7aa73c23          	sd	a0,1976(a4) # 1000 <freep>
      return (void*)(p + 1);
 850:	01078513          	addi	a0,a5,16
  }
}
 854:	70e2                	ld	ra,56(sp)
 856:	7442                	ld	s0,48(sp)
 858:	7902                	ld	s2,32(sp)
 85a:	69e2                	ld	s3,24(sp)
 85c:	6121                	addi	sp,sp,64
 85e:	8082                	ret
 860:	74a2                	ld	s1,40(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
 868:	b7f5                	j	854 <malloc+0xdc>
