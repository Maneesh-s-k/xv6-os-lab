
user/_loop:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(void) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    while(1) {
   8:	a001                	j	8 <main+0x8>

000000000000000a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
   a:	1141                	addi	sp,sp,-16
   c:	e406                	sd	ra,8(sp)
   e:	e022                	sd	s0,0(sp)
  10:	0800                	addi	s0,sp,16
  extern int main();
  main();
  12:	fefff0ef          	jal	0 <main>
  exit(0);
  16:	4501                	li	a0,0
  18:	290000ef          	jal	2a8 <exit>

000000000000001c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  24:	87aa                	mv	a5,a0
  26:	0585                	addi	a1,a1,1
  28:	0785                	addi	a5,a5,1
  2a:	fff5c703          	lbu	a4,-1(a1)
  2e:	fee78fa3          	sb	a4,-1(a5)
  32:	fb75                	bnez	a4,26 <strcpy+0xa>
    ;
  return os;
}
  34:	60a2                	ld	ra,8(sp)
  36:	6402                	ld	s0,0(sp)
  38:	0141                	addi	sp,sp,16
  3a:	8082                	ret

000000000000003c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  44:	00054783          	lbu	a5,0(a0)
  48:	cb91                	beqz	a5,5c <strcmp+0x20>
  4a:	0005c703          	lbu	a4,0(a1)
  4e:	00f71763          	bne	a4,a5,5c <strcmp+0x20>
    p++, q++;
  52:	0505                	addi	a0,a0,1
  54:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	fbe5                	bnez	a5,4a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  5c:	0005c503          	lbu	a0,0(a1)
}
  60:	40a7853b          	subw	a0,a5,a0
  64:	60a2                	ld	ra,8(sp)
  66:	6402                	ld	s0,0(sp)
  68:	0141                	addi	sp,sp,16
  6a:	8082                	ret

000000000000006c <strlen>:

uint
strlen(const char *s)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  74:	00054783          	lbu	a5,0(a0)
  78:	cf99                	beqz	a5,96 <strlen+0x2a>
  7a:	0505                	addi	a0,a0,1
  7c:	87aa                	mv	a5,a0
  7e:	86be                	mv	a3,a5
  80:	0785                	addi	a5,a5,1
  82:	fff7c703          	lbu	a4,-1(a5)
  86:	ff65                	bnez	a4,7e <strlen+0x12>
  88:	40a6853b          	subw	a0,a3,a0
  8c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfdd                	j	8e <strlen+0x22>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1e>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x14>
  }
  return dst;
}
  b8:	60a2                	ld	ra,8(sp)
  ba:	6402                	ld	s0,0(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strchr>:

char*
strchr(const char *s, char c)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cf81                	beqz	a5,e4 <strchr+0x24>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1c>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xe>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfdd                	j	dc <strchr+0x1c>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	7159                	addi	sp,sp,-112
  ea:	f486                	sd	ra,104(sp)
  ec:	f0a2                	sd	s0,96(sp)
  ee:	eca6                	sd	s1,88(sp)
  f0:	e8ca                	sd	s2,80(sp)
  f2:	e4ce                	sd	s3,72(sp)
  f4:	e0d2                	sd	s4,64(sp)
  f6:	fc56                	sd	s5,56(sp)
  f8:	f85a                	sd	s6,48(sp)
  fa:	f45e                	sd	s7,40(sp)
  fc:	f062                	sd	s8,32(sp)
  fe:	ec66                	sd	s9,24(sp)
 100:	e86a                	sd	s10,16(sp)
 102:	1880                	addi	s0,sp,112
 104:	8caa                	mv	s9,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10c:	f9f40b13          	addi	s6,s0,-97
 110:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 112:	4ba9                	li	s7,10
 114:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 116:	8d26                	mv	s10,s1
 118:	0014899b          	addiw	s3,s1,1
 11c:	84ce                	mv	s1,s3
 11e:	0349d563          	bge	s3,s4,148 <gets+0x60>
    cc = read(0, &c, 1);
 122:	8656                	mv	a2,s5
 124:	85da                	mv	a1,s6
 126:	4501                	li	a0,0
 128:	198000ef          	jal	2c0 <read>
    if(cc < 1)
 12c:	00a05e63          	blez	a0,148 <gets+0x60>
    buf[i++] = c;
 130:	f9f44783          	lbu	a5,-97(s0)
 134:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 138:	01778763          	beq	a5,s7,146 <gets+0x5e>
 13c:	0905                	addi	s2,s2,1
 13e:	fd879ce3          	bne	a5,s8,116 <gets+0x2e>
    buf[i++] = c;
 142:	8d4e                	mv	s10,s3
 144:	a011                	j	148 <gets+0x60>
 146:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 148:	9d66                	add	s10,s10,s9
 14a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 14e:	8566                	mv	a0,s9
 150:	70a6                	ld	ra,104(sp)
 152:	7406                	ld	s0,96(sp)
 154:	64e6                	ld	s1,88(sp)
 156:	6946                	ld	s2,80(sp)
 158:	69a6                	ld	s3,72(sp)
 15a:	6a06                	ld	s4,64(sp)
 15c:	7ae2                	ld	s5,56(sp)
 15e:	7b42                	ld	s6,48(sp)
 160:	7ba2                	ld	s7,40(sp)
 162:	7c02                	ld	s8,32(sp)
 164:	6ce2                	ld	s9,24(sp)
 166:	6d42                	ld	s10,16(sp)
 168:	6165                	addi	sp,sp,112
 16a:	8082                	ret

000000000000016c <stat>:

int
stat(const char *n, struct stat *st)
{
 16c:	1101                	addi	sp,sp,-32
 16e:	ec06                	sd	ra,24(sp)
 170:	e822                	sd	s0,16(sp)
 172:	e04a                	sd	s2,0(sp)
 174:	1000                	addi	s0,sp,32
 176:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 178:	4581                	li	a1,0
 17a:	16e000ef          	jal	2e8 <open>
  if(fd < 0)
 17e:	02054263          	bltz	a0,1a2 <stat+0x36>
 182:	e426                	sd	s1,8(sp)
 184:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 186:	85ca                	mv	a1,s2
 188:	178000ef          	jal	300 <fstat>
 18c:	892a                	mv	s2,a0
  close(fd);
 18e:	8526                	mv	a0,s1
 190:	140000ef          	jal	2d0 <close>
  return r;
 194:	64a2                	ld	s1,8(sp)
}
 196:	854a                	mv	a0,s2
 198:	60e2                	ld	ra,24(sp)
 19a:	6442                	ld	s0,16(sp)
 19c:	6902                	ld	s2,0(sp)
 19e:	6105                	addi	sp,sp,32
 1a0:	8082                	ret
    return -1;
 1a2:	597d                	li	s2,-1
 1a4:	bfcd                	j	196 <stat+0x2a>

00000000000001a6 <atoi>:

int
atoi(const char *s)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e406                	sd	ra,8(sp)
 1aa:	e022                	sd	s0,0(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ae:	00054683          	lbu	a3,0(a0)
 1b2:	fd06879b          	addiw	a5,a3,-48
 1b6:	0ff7f793          	zext.b	a5,a5
 1ba:	4625                	li	a2,9
 1bc:	02f66963          	bltu	a2,a5,1ee <atoi+0x48>
 1c0:	872a                	mv	a4,a0
  n = 0;
 1c2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c4:	0705                	addi	a4,a4,1
 1c6:	0025179b          	slliw	a5,a0,0x2
 1ca:	9fa9                	addw	a5,a5,a0
 1cc:	0017979b          	slliw	a5,a5,0x1
 1d0:	9fb5                	addw	a5,a5,a3
 1d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d6:	00074683          	lbu	a3,0(a4)
 1da:	fd06879b          	addiw	a5,a3,-48
 1de:	0ff7f793          	zext.b	a5,a5
 1e2:	fef671e3          	bgeu	a2,a5,1c4 <atoi+0x1e>
  return n;
}
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  n = 0;
 1ee:	4501                	li	a0,0
 1f0:	bfdd                	j	1e6 <atoi+0x40>

00000000000001f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fa:	02b57563          	bgeu	a0,a1,224 <memmove+0x32>
    while(n-- > 0)
 1fe:	00c05f63          	blez	a2,21c <memmove+0x2a>
 202:	1602                	slli	a2,a2,0x20
 204:	9201                	srli	a2,a2,0x20
 206:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20a:	872a                	mv	a4,a0
      *dst++ = *src++;
 20c:	0585                	addi	a1,a1,1
 20e:	0705                	addi	a4,a4,1
 210:	fff5c683          	lbu	a3,-1(a1)
 214:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 218:	fee79ae3          	bne	a5,a4,20c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
    dst += n;
 224:	00c50733          	add	a4,a0,a2
    src += n;
 228:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 22a:	fec059e3          	blez	a2,21c <memmove+0x2a>
 22e:	fff6079b          	addiw	a5,a2,-1
 232:	1782                	slli	a5,a5,0x20
 234:	9381                	srli	a5,a5,0x20
 236:	fff7c793          	not	a5,a5
 23a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 23c:	15fd                	addi	a1,a1,-1
 23e:	177d                	addi	a4,a4,-1
 240:	0005c683          	lbu	a3,0(a1)
 244:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 248:	fef71ae3          	bne	a4,a5,23c <memmove+0x4a>
 24c:	bfc1                	j	21c <memmove+0x2a>

000000000000024e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 256:	ca0d                	beqz	a2,288 <memcmp+0x3a>
 258:	fff6069b          	addiw	a3,a2,-1
 25c:	1682                	slli	a3,a3,0x20
 25e:	9281                	srli	a3,a3,0x20
 260:	0685                	addi	a3,a3,1
 262:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 264:	00054783          	lbu	a5,0(a0)
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00e79863          	bne	a5,a4,27c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 270:	0505                	addi	a0,a0,1
    p2++;
 272:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 274:	fed518e3          	bne	a0,a3,264 <memcmp+0x16>
  }
  return 0;
 278:	4501                	li	a0,0
 27a:	a019                	j	280 <memcmp+0x32>
      return *p1 - *p2;
 27c:	40e7853b          	subw	a0,a5,a4
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
  return 0;
 288:	4501                	li	a0,0
 28a:	bfdd                	j	280 <memcmp+0x32>

000000000000028c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 294:	f5fff0ef          	jal	1f2 <memmove>
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a0:	4885                	li	a7,1
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a8:	4889                	li	a7,2
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b0:	488d                	li	a7,3
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b8:	4891                	li	a7,4
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <read>:
.global read
read:
 li a7, SYS_read
 2c0:	4895                	li	a7,5
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <write>:
.global write
write:
 li a7, SYS_write
 2c8:	48c1                	li	a7,16
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <close>:
.global close
close:
 li a7, SYS_close
 2d0:	48d5                	li	a7,21
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d8:	4899                	li	a7,6
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e0:	489d                	li	a7,7
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <open>:
.global open
open:
 li a7, SYS_open
 2e8:	48bd                	li	a7,15
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f0:	48c5                	li	a7,17
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f8:	48c9                	li	a7,18
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 300:	48a1                	li	a7,8
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <link>:
.global link
link:
 li a7, SYS_link
 308:	48cd                	li	a7,19
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 310:	48d1                	li	a7,20
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 318:	48a5                	li	a7,9
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <dup>:
.global dup
dup:
 li a7, SYS_dup
 320:	48a9                	li	a7,10
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 328:	48ad                	li	a7,11
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 330:	48b1                	li	a7,12
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 338:	48b5                	li	a7,13
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 340:	48b9                	li	a7,14
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 348:	48d9                	li	a7,22
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 350:	1101                	addi	sp,sp,-32
 352:	ec06                	sd	ra,24(sp)
 354:	e822                	sd	s0,16(sp)
 356:	1000                	addi	s0,sp,32
 358:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35c:	4605                	li	a2,1
 35e:	fef40593          	addi	a1,s0,-17
 362:	f67ff0ef          	jal	2c8 <write>
}
 366:	60e2                	ld	ra,24(sp)
 368:	6442                	ld	s0,16(sp)
 36a:	6105                	addi	sp,sp,32
 36c:	8082                	ret

000000000000036e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 36e:	715d                	addi	sp,sp,-80
 370:	e486                	sd	ra,72(sp)
 372:	e0a2                	sd	s0,64(sp)
 374:	fc26                	sd	s1,56(sp)
 376:	f84a                	sd	s2,48(sp)
 378:	f44e                	sd	s3,40(sp)
 37a:	0880                	addi	s0,sp,80
 37c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37e:	c299                	beqz	a3,384 <printint+0x16>
 380:	0605cf63          	bltz	a1,3fe <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 384:	2581                	sext.w	a1,a1
  neg = 0;
 386:	4e01                	li	t3,0
  }

  i = 0;
 388:	fb840313          	addi	t1,s0,-72
  neg = 0;
 38c:	869a                	mv	a3,t1
  i = 0;
 38e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 390:	00000817          	auipc	a6,0x0
 394:	4d880813          	addi	a6,a6,1240 # 868 <digits>
 398:	88be                	mv	a7,a5
 39a:	0017851b          	addiw	a0,a5,1
 39e:	87aa                	mv	a5,a0
 3a0:	02c5f73b          	remuw	a4,a1,a2
 3a4:	1702                	slli	a4,a4,0x20
 3a6:	9301                	srli	a4,a4,0x20
 3a8:	9742                	add	a4,a4,a6
 3aa:	00074703          	lbu	a4,0(a4)
 3ae:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3b2:	872e                	mv	a4,a1
 3b4:	02c5d5bb          	divuw	a1,a1,a2
 3b8:	0685                	addi	a3,a3,1
 3ba:	fcc77fe3          	bgeu	a4,a2,398 <printint+0x2a>
  if(neg)
 3be:	000e0c63          	beqz	t3,3d6 <printint+0x68>
    buf[i++] = '-';
 3c2:	fd050793          	addi	a5,a0,-48
 3c6:	00878533          	add	a0,a5,s0
 3ca:	02d00793          	li	a5,45
 3ce:	fef50423          	sb	a5,-24(a0)
 3d2:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3d6:	fff7899b          	addiw	s3,a5,-1
 3da:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3de:	fff4c583          	lbu	a1,-1(s1)
 3e2:	854a                	mv	a0,s2
 3e4:	f6dff0ef          	jal	350 <putc>
  while(--i >= 0)
 3e8:	39fd                	addiw	s3,s3,-1
 3ea:	14fd                	addi	s1,s1,-1
 3ec:	fe09d9e3          	bgez	s3,3de <printint+0x70>
}
 3f0:	60a6                	ld	ra,72(sp)
 3f2:	6406                	ld	s0,64(sp)
 3f4:	74e2                	ld	s1,56(sp)
 3f6:	7942                	ld	s2,48(sp)
 3f8:	79a2                	ld	s3,40(sp)
 3fa:	6161                	addi	sp,sp,80
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4e05                	li	t3,1
    x = -xx;
 404:	b751                	j	388 <printint+0x1a>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	711d                	addi	sp,sp,-96
 408:	ec86                	sd	ra,88(sp)
 40a:	e8a2                	sd	s0,80(sp)
 40c:	e4a6                	sd	s1,72(sp)
 40e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 410:	0005c483          	lbu	s1,0(a1)
 414:	26048663          	beqz	s1,680 <vprintf+0x27a>
 418:	e0ca                	sd	s2,64(sp)
 41a:	fc4e                	sd	s3,56(sp)
 41c:	f852                	sd	s4,48(sp)
 41e:	f456                	sd	s5,40(sp)
 420:	f05a                	sd	s6,32(sp)
 422:	ec5e                	sd	s7,24(sp)
 424:	e862                	sd	s8,16(sp)
 426:	e466                	sd	s9,8(sp)
 428:	8b2a                	mv	s6,a0
 42a:	8a2e                	mv	s4,a1
 42c:	8bb2                	mv	s7,a2
  state = 0;
 42e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 430:	4901                	li	s2,0
 432:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 434:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 438:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 43c:	06c00c93          	li	s9,108
 440:	a00d                	j	462 <vprintf+0x5c>
        putc(fd, c0);
 442:	85a6                	mv	a1,s1
 444:	855a                	mv	a0,s6
 446:	f0bff0ef          	jal	350 <putc>
 44a:	a019                	j	450 <vprintf+0x4a>
    } else if(state == '%'){
 44c:	03598363          	beq	s3,s5,472 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 450:	0019079b          	addiw	a5,s2,1
 454:	893e                	mv	s2,a5
 456:	873e                	mv	a4,a5
 458:	97d2                	add	a5,a5,s4
 45a:	0007c483          	lbu	s1,0(a5)
 45e:	20048963          	beqz	s1,670 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 462:	0004879b          	sext.w	a5,s1
    if(state == 0){
 466:	fe0993e3          	bnez	s3,44c <vprintf+0x46>
      if(c0 == '%'){
 46a:	fd579ce3          	bne	a5,s5,442 <vprintf+0x3c>
        state = '%';
 46e:	89be                	mv	s3,a5
 470:	b7c5                	j	450 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 472:	00ea06b3          	add	a3,s4,a4
 476:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 47a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 47c:	c681                	beqz	a3,484 <vprintf+0x7e>
 47e:	9752                	add	a4,a4,s4
 480:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 484:	03878e63          	beq	a5,s8,4c0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 488:	05978863          	beq	a5,s9,4d8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 48c:	07500713          	li	a4,117
 490:	0ee78263          	beq	a5,a4,574 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 494:	07800713          	li	a4,120
 498:	12e78463          	beq	a5,a4,5c0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 49c:	07000713          	li	a4,112
 4a0:	14e78963          	beq	a5,a4,5f2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4a4:	07300713          	li	a4,115
 4a8:	18e78863          	beq	a5,a4,638 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ac:	02500713          	li	a4,37
 4b0:	04e79463          	bne	a5,a4,4f8 <vprintf+0xf2>
        putc(fd, '%');
 4b4:	85ba                	mv	a1,a4
 4b6:	855a                	mv	a0,s6
 4b8:	e99ff0ef          	jal	350 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	bf49                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4c0:	008b8493          	addi	s1,s7,8
 4c4:	4685                	li	a3,1
 4c6:	4629                	li	a2,10
 4c8:	000ba583          	lw	a1,0(s7)
 4cc:	855a                	mv	a0,s6
 4ce:	ea1ff0ef          	jal	36e <printint>
 4d2:	8ba6                	mv	s7,s1
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	bfad                	j	450 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4d8:	06400793          	li	a5,100
 4dc:	02f68963          	beq	a3,a5,50e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4e0:	06c00793          	li	a5,108
 4e4:	04f68263          	beq	a3,a5,528 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4e8:	07500793          	li	a5,117
 4ec:	0af68063          	beq	a3,a5,58c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4f0:	07800793          	li	a5,120
 4f4:	0ef68263          	beq	a3,a5,5d8 <vprintf+0x1d2>
        putc(fd, '%');
 4f8:	02500593          	li	a1,37
 4fc:	855a                	mv	a0,s6
 4fe:	e53ff0ef          	jal	350 <putc>
        putc(fd, c0);
 502:	85a6                	mv	a1,s1
 504:	855a                	mv	a0,s6
 506:	e4bff0ef          	jal	350 <putc>
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b791                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	008b8493          	addi	s1,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000bb583          	ld	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	e53ff0ef          	jal	36e <printint>
        i += 1;
 520:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 522:	8ba6                	mv	s7,s1
      state = 0;
 524:	4981                	li	s3,0
        i += 1;
 526:	b72d                	j	450 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 528:	06400793          	li	a5,100
 52c:	02f60763          	beq	a2,a5,55a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 530:	07500793          	li	a5,117
 534:	06f60963          	beq	a2,a5,5a6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 538:	07800793          	li	a5,120
 53c:	faf61ee3          	bne	a2,a5,4f8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 540:	008b8493          	addi	s1,s7,8
 544:	4681                	li	a3,0
 546:	4641                	li	a2,16
 548:	000bb583          	ld	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e21ff0ef          	jal	36e <printint>
        i += 2;
 552:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 554:	8ba6                	mv	s7,s1
      state = 0;
 556:	4981                	li	s3,0
        i += 2;
 558:	bde5                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000bb583          	ld	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e07ff0ef          	jal	36e <printint>
        i += 2;
 56c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
        i += 2;
 572:	bdf9                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 574:	008b8493          	addi	s1,s7,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	dedff0ef          	jal	36e <printint>
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	b5d9                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000bb583          	ld	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	dd5ff0ef          	jal	36e <printint>
        i += 1;
 59e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
        i += 1;
 5a4:	b575                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000bb583          	ld	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	dbbff0ef          	jal	36e <printint>
        i += 2;
 5b8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
        i += 2;
 5be:	bd49                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	da1ff0ef          	jal	36e <printint>
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bdad                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	d89ff0ef          	jal	36e <printint>
        i += 1;
 5ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
        i += 1;
 5f0:	b585                	j	450 <vprintf+0x4a>
 5f2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f4:	008b8d13          	addi	s10,s7,8
 5f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fc:	03000593          	li	a1,48
 600:	855a                	mv	a0,s6
 602:	d4fff0ef          	jal	350 <putc>
  putc(fd, 'x');
 606:	07800593          	li	a1,120
 60a:	855a                	mv	a0,s6
 60c:	d45ff0ef          	jal	350 <putc>
 610:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 612:	00000b97          	auipc	s7,0x0
 616:	256b8b93          	addi	s7,s7,598 # 868 <digits>
 61a:	03c9d793          	srli	a5,s3,0x3c
 61e:	97de                	add	a5,a5,s7
 620:	0007c583          	lbu	a1,0(a5)
 624:	855a                	mv	a0,s6
 626:	d2bff0ef          	jal	350 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62a:	0992                	slli	s3,s3,0x4
 62c:	34fd                	addiw	s1,s1,-1
 62e:	f4f5                	bnez	s1,61a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 630:	8bea                	mv	s7,s10
      state = 0;
 632:	4981                	li	s3,0
 634:	6d02                	ld	s10,0(sp)
 636:	bd29                	j	450 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 638:	008b8993          	addi	s3,s7,8
 63c:	000bb483          	ld	s1,0(s7)
 640:	cc91                	beqz	s1,65c <vprintf+0x256>
        for(; *s; s++)
 642:	0004c583          	lbu	a1,0(s1)
 646:	c195                	beqz	a1,66a <vprintf+0x264>
          putc(fd, *s);
 648:	855a                	mv	a0,s6
 64a:	d07ff0ef          	jal	350 <putc>
        for(; *s; s++)
 64e:	0485                	addi	s1,s1,1
 650:	0004c583          	lbu	a1,0(s1)
 654:	f9f5                	bnez	a1,648 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 656:	8bce                	mv	s7,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	bbdd                	j	450 <vprintf+0x4a>
          s = "(null)";
 65c:	00000497          	auipc	s1,0x0
 660:	20448493          	addi	s1,s1,516 # 860 <malloc+0xf4>
        for(; *s; s++)
 664:	02800593          	li	a1,40
 668:	b7c5                	j	648 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 66a:	8bce                	mv	s7,s3
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b3cd                	j	450 <vprintf+0x4a>
 670:	6906                	ld	s2,64(sp)
 672:	79e2                	ld	s3,56(sp)
 674:	7a42                	ld	s4,48(sp)
 676:	7aa2                	ld	s5,40(sp)
 678:	7b02                	ld	s6,32(sp)
 67a:	6be2                	ld	s7,24(sp)
 67c:	6c42                	ld	s8,16(sp)
 67e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 680:	60e6                	ld	ra,88(sp)
 682:	6446                	ld	s0,80(sp)
 684:	64a6                	ld	s1,72(sp)
 686:	6125                	addi	sp,sp,96
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	8622                	mv	a2,s0
 6a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a8:	d5fff0ef          	jal	406 <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6161                	addi	sp,sp,80
 6b2:	8082                	ret

00000000000006b4 <printf>:

void
printf(const char *fmt, ...)
{
 6b4:	711d                	addi	sp,sp,-96
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	e40c                	sd	a1,8(s0)
 6be:	e810                	sd	a2,16(s0)
 6c0:	ec14                	sd	a3,24(s0)
 6c2:	f018                	sd	a4,32(s0)
 6c4:	f41c                	sd	a5,40(s0)
 6c6:	03043823          	sd	a6,48(s0)
 6ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	00840613          	addi	a2,s0,8
 6d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d6:	85aa                	mv	a1,a0
 6d8:	4505                	li	a0,1
 6da:	d2dff0ef          	jal	406 <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6125                	addi	sp,sp,96
 6e4:	8082                	ret

00000000000006e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e406                	sd	ra,8(sp)
 6ea:	e022                	sd	s0,0(sp)
 6ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	00001797          	auipc	a5,0x1
 6f6:	90e7b783          	ld	a5,-1778(a5) # 1000 <freep>
 6fa:	a02d                	j	724 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fc:	4618                	lw	a4,8(a2)
 6fe:	9f2d                	addw	a4,a4,a1
 700:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	6398                	ld	a4,0(a5)
 706:	6310                	ld	a2,0(a4)
 708:	a83d                	j	746 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70a:	ff852703          	lw	a4,-8(a0)
 70e:	9f31                	addw	a4,a4,a2
 710:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 712:	ff053683          	ld	a3,-16(a0)
 716:	a091                	j	75a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	6398                	ld	a4,0(a5)
 71a:	00e7e463          	bltu	a5,a4,722 <free+0x3c>
 71e:	00e6ea63          	bltu	a3,a4,732 <free+0x4c>
{
 722:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	fed7fae3          	bgeu	a5,a3,718 <free+0x32>
 728:	6398                	ld	a4,0(a5)
 72a:	00e6e463          	bltu	a3,a4,732 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	fee7eae3          	bltu	a5,a4,722 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 732:	ff852583          	lw	a1,-8(a0)
 736:	6390                	ld	a2,0(a5)
 738:	02059813          	slli	a6,a1,0x20
 73c:	01c85713          	srli	a4,a6,0x1c
 740:	9736                	add	a4,a4,a3
 742:	fae60de3          	beq	a2,a4,6fc <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74a:	4790                	lw	a2,8(a5)
 74c:	02061593          	slli	a1,a2,0x20
 750:	01c5d713          	srli	a4,a1,0x1c
 754:	973e                	add	a4,a4,a5
 756:	fae68ae3          	beq	a3,a4,70a <free+0x24>
    p->s.ptr = bp->s.ptr;
 75a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 75c:	00001717          	auipc	a4,0x1
 760:	8af73223          	sd	a5,-1884(a4) # 1000 <freep>
}
 764:	60a2                	ld	ra,8(sp)
 766:	6402                	ld	s0,0(sp)
 768:	0141                	addi	sp,sp,16
 76a:	8082                	ret

000000000000076c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76c:	7139                	addi	sp,sp,-64
 76e:	fc06                	sd	ra,56(sp)
 770:	f822                	sd	s0,48(sp)
 772:	f04a                	sd	s2,32(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051993          	slli	s3,a0,0x20
 77c:	0209d993          	srli	s3,s3,0x20
 780:	09bd                	addi	s3,s3,15
 782:	0049d993          	srli	s3,s3,0x4
 786:	2985                	addiw	s3,s3,1
 788:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 78a:	00001517          	auipc	a0,0x1
 78e:	87653503          	ld	a0,-1930(a0) # 1000 <freep>
 792:	c905                	beqz	a0,7c2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 794:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 796:	4798                	lw	a4,8(a5)
 798:	09377663          	bgeu	a4,s3,824 <malloc+0xb8>
 79c:	f426                	sd	s1,40(sp)
 79e:	e852                	sd	s4,16(sp)
 7a0:	e456                	sd	s5,8(sp)
 7a2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7a4:	8a4e                	mv	s4,s3
 7a6:	6705                	lui	a4,0x1
 7a8:	00e9f363          	bgeu	s3,a4,7ae <malloc+0x42>
 7ac:	6a05                	lui	s4,0x1
 7ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b6:	00001497          	auipc	s1,0x1
 7ba:	84a48493          	addi	s1,s1,-1974 # 1000 <freep>
  if(p == (char*)-1)
 7be:	5afd                	li	s5,-1
 7c0:	a83d                	j	7fe <malloc+0x92>
 7c2:	f426                	sd	s1,40(sp)
 7c4:	e852                	sd	s4,16(sp)
 7c6:	e456                	sd	s5,8(sp)
 7c8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ca:	00001797          	auipc	a5,0x1
 7ce:	84678793          	addi	a5,a5,-1978 # 1010 <base>
 7d2:	00001717          	auipc	a4,0x1
 7d6:	82f73723          	sd	a5,-2002(a4) # 1000 <freep>
 7da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e0:	b7d1                	j	7a4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7e2:	6398                	ld	a4,0(a5)
 7e4:	e118                	sd	a4,0(a0)
 7e6:	a899                	j	83c <malloc+0xd0>
  hp->s.size = nu;
 7e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ec:	0541                	addi	a0,a0,16
 7ee:	ef9ff0ef          	jal	6e6 <free>
  return freep;
 7f2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7f4:	c125                	beqz	a0,854 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	03277163          	bgeu	a4,s2,81c <malloc+0xb0>
    if(p == freep)
 7fe:	6098                	ld	a4,0(s1)
 800:	853e                	mv	a0,a5
 802:	fef71ae3          	bne	a4,a5,7f6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 806:	8552                	mv	a0,s4
 808:	b29ff0ef          	jal	330 <sbrk>
  if(p == (char*)-1)
 80c:	fd551ee3          	bne	a0,s5,7e8 <malloc+0x7c>
        return 0;
 810:	4501                	li	a0,0
 812:	74a2                	ld	s1,40(sp)
 814:	6a42                	ld	s4,16(sp)
 816:	6aa2                	ld	s5,8(sp)
 818:	6b02                	ld	s6,0(sp)
 81a:	a03d                	j	848 <malloc+0xdc>
 81c:	74a2                	ld	s1,40(sp)
 81e:	6a42                	ld	s4,16(sp)
 820:	6aa2                	ld	s5,8(sp)
 822:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 824:	fae90fe3          	beq	s2,a4,7e2 <malloc+0x76>
        p->s.size -= nunits;
 828:	4137073b          	subw	a4,a4,s3
 82c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82e:	02071693          	slli	a3,a4,0x20
 832:	01c6d713          	srli	a4,a3,0x1c
 836:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 838:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83c:	00000717          	auipc	a4,0x0
 840:	7ca73223          	sd	a0,1988(a4) # 1000 <freep>
      return (void*)(p + 1);
 844:	01078513          	addi	a0,a5,16
  }
}
 848:	70e2                	ld	ra,56(sp)
 84a:	7442                	ld	s0,48(sp)
 84c:	7902                	ld	s2,32(sp)
 84e:	69e2                	ld	s3,24(sp)
 850:	6121                	addi	sp,sp,64
 852:	8082                	ret
 854:	74a2                	ld	s1,40(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
 85c:	b7f5                	j	848 <malloc+0xdc>
