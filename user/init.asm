
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	90250513          	addi	a0,a0,-1790 # 910 <malloc+0xf2>
  16:	384000ef          	jal	39a <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3b2000ef          	jal	3d2 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3ac000ef          	jal	3d2 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	8ee90913          	addi	s2,s2,-1810 # 918 <malloc+0xfa>
  32:	854a                	mv	a0,s2
  34:	732000ef          	jal	766 <printf>
    pid = fork();
  38:	31a000ef          	jal	352 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	31c000ef          	jal	362 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	91650513          	addi	a0,a0,-1770 # 968 <malloc+0x14a>
  5a:	70c000ef          	jal	766 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2fa000ef          	jal	35a <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8a850513          	addi	a0,a0,-1880 # 910 <malloc+0xf2>
  70:	332000ef          	jal	3a2 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	89a50513          	addi	a0,a0,-1894 # 910 <malloc+0xf2>
  7e:	31c000ef          	jal	39a <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8ac50513          	addi	a0,a0,-1876 # 930 <malloc+0x112>
  8c:	6da000ef          	jal	766 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2c8000ef          	jal	35a <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8aa50513          	addi	a0,a0,-1878 # 948 <malloc+0x12a>
  a6:	2ec000ef          	jal	392 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8a650513          	addi	a0,a0,-1882 # 950 <malloc+0x132>
  b2:	6b4000ef          	jal	766 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2a2000ef          	jal	35a <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	290000ef          	jal	35a <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0xa>
    ;
  return os;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x20>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x20>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf99                	beqz	a5,148 <strlen+0x2a>
 12c:	0505                	addi	a0,a0,1
 12e:	87aa                	mv	a5,a0
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x12>
 13a:	40a6853b          	subw	a0,a3,a0
 13e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  for(n = 0; s[n]; n++)
 148:	4501                	li	a0,0
 14a:	bfdd                	j	140 <strlen+0x22>

000000000000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 154:	ca19                	beqz	a2,16a <memset+0x1e>
 156:	87aa                	mv	a5,a0
 158:	1602                	slli	a2,a2,0x20
 15a:	9201                	srli	a2,a2,0x20
 15c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 164:	0785                	addi	a5,a5,1
 166:	fee79de3          	bne	a5,a4,160 <memset+0x14>
  }
  return dst;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strchr>:

char*
strchr(const char *s, char c)
{
 172:	1141                	addi	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	cf81                	beqz	a5,196 <strchr+0x24>
    if(*s == c)
 180:	00f58763          	beq	a1,a5,18e <strchr+0x1c>
  for(; *s; s++)
 184:	0505                	addi	a0,a0,1
 186:	00054783          	lbu	a5,0(a0)
 18a:	fbfd                	bnez	a5,180 <strchr+0xe>
      return (char*)s;
  return 0;
 18c:	4501                	li	a0,0
}
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  return 0;
 196:	4501                	li	a0,0
 198:	bfdd                	j	18e <strchr+0x1c>

000000000000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	7159                	addi	sp,sp,-112
 19c:	f486                	sd	ra,104(sp)
 19e:	f0a2                	sd	s0,96(sp)
 1a0:	eca6                	sd	s1,88(sp)
 1a2:	e8ca                	sd	s2,80(sp)
 1a4:	e4ce                	sd	s3,72(sp)
 1a6:	e0d2                	sd	s4,64(sp)
 1a8:	fc56                	sd	s5,56(sp)
 1aa:	f85a                	sd	s6,48(sp)
 1ac:	f45e                	sd	s7,40(sp)
 1ae:	f062                	sd	s8,32(sp)
 1b0:	ec66                	sd	s9,24(sp)
 1b2:	e86a                	sd	s10,16(sp)
 1b4:	1880                	addi	s0,sp,112
 1b6:	8caa                	mv	s9,a0
 1b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	892a                	mv	s2,a0
 1bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1be:	f9f40b13          	addi	s6,s0,-97
 1c2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c4:	4ba9                	li	s7,10
 1c6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1c8:	8d26                	mv	s10,s1
 1ca:	0014899b          	addiw	s3,s1,1
 1ce:	84ce                	mv	s1,s3
 1d0:	0349d563          	bge	s3,s4,1fa <gets+0x60>
    cc = read(0, &c, 1);
 1d4:	8656                	mv	a2,s5
 1d6:	85da                	mv	a1,s6
 1d8:	4501                	li	a0,0
 1da:	198000ef          	jal	372 <read>
    if(cc < 1)
 1de:	00a05e63          	blez	a0,1fa <gets+0x60>
    buf[i++] = c;
 1e2:	f9f44783          	lbu	a5,-97(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	01778763          	beq	a5,s7,1f8 <gets+0x5e>
 1ee:	0905                	addi	s2,s2,1
 1f0:	fd879ce3          	bne	a5,s8,1c8 <gets+0x2e>
    buf[i++] = c;
 1f4:	8d4e                	mv	s10,s3
 1f6:	a011                	j	1fa <gets+0x60>
 1f8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1fa:	9d66                	add	s10,s10,s9
 1fc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 200:	8566                	mv	a0,s9
 202:	70a6                	ld	ra,104(sp)
 204:	7406                	ld	s0,96(sp)
 206:	64e6                	ld	s1,88(sp)
 208:	6946                	ld	s2,80(sp)
 20a:	69a6                	ld	s3,72(sp)
 20c:	6a06                	ld	s4,64(sp)
 20e:	7ae2                	ld	s5,56(sp)
 210:	7b42                	ld	s6,48(sp)
 212:	7ba2                	ld	s7,40(sp)
 214:	7c02                	ld	s8,32(sp)
 216:	6ce2                	ld	s9,24(sp)
 218:	6d42                	ld	s10,16(sp)
 21a:	6165                	addi	sp,sp,112
 21c:	8082                	ret

000000000000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	addi	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	16e000ef          	jal	39a <open>
  if(fd < 0)
 230:	02054263          	bltz	a0,254 <stat+0x36>
 234:	e426                	sd	s1,8(sp)
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	178000ef          	jal	3b2 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	140000ef          	jal	382 <close>
  return r;
 246:	64a2                	ld	s1,8(sp)
}
 248:	854a                	mv	a0,s2
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	6902                	ld	s2,0(sp)
 250:	6105                	addi	sp,sp,32
 252:	8082                	ret
    return -1;
 254:	597d                	li	s2,-1
 256:	bfcd                	j	248 <stat+0x2a>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054683          	lbu	a3,0(a0)
 264:	fd06879b          	addiw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	4625                	li	a2,9
 26e:	02f66963          	bltu	a2,a5,2a0 <atoi+0x48>
 272:	872a                	mv	a4,a0
  n = 0;
 274:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 276:	0705                	addi	a4,a4,1
 278:	0025179b          	slliw	a5,a0,0x2
 27c:	9fa9                	addw	a5,a5,a0
 27e:	0017979b          	slliw	a5,a5,0x1
 282:	9fb5                	addw	a5,a5,a3
 284:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 288:	00074683          	lbu	a3,0(a4)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	fef671e3          	bgeu	a2,a5,276 <atoi+0x1e>
  return n;
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfdd                	j	298 <atoi+0x40>

00000000000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57563          	bgeu	a0,a1,2d6 <memmove+0x32>
    while(n-- > 0)
 2b0:	00c05f63          	blez	a2,2ce <memmove+0x2a>
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2be:	0585                	addi	a1,a1,1
 2c0:	0705                	addi	a4,a4,1
 2c2:	fff5c683          	lbu	a3,-1(a1)
 2c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
    dst += n;
 2d6:	00c50733          	add	a4,a0,a2
    src += n;
 2da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2dc:	fec059e3          	blez	a2,2ce <memmove+0x2a>
 2e0:	fff6079b          	addiw	a5,a2,-1
 2e4:	1782                	slli	a5,a5,0x20
 2e6:	9381                	srli	a5,a5,0x20
 2e8:	fff7c793          	not	a5,a5
 2ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ee:	15fd                	addi	a1,a1,-1
 2f0:	177d                	addi	a4,a4,-1
 2f2:	0005c683          	lbu	a3,0(a1)
 2f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fa:	fef71ae3          	bne	a4,a5,2ee <memmove+0x4a>
 2fe:	bfc1                	j	2ce <memmove+0x2a>

0000000000000300 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca0d                	beqz	a2,33a <memcmp+0x3a>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x16>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x32>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfdd                	j	332 <memcmp+0x32>

000000000000033e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 346:	f5fff0ef          	jal	2a4 <memmove>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 352:	4885                	li	a7,1
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exit>:
.global exit
exit:
 li a7, SYS_exit
 35a:	4889                	li	a7,2
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait>:
.global wait
wait:
 li a7, SYS_wait
 362:	488d                	li	a7,3
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36a:	4891                	li	a7,4
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <read>:
.global read
read:
 li a7, SYS_read
 372:	4895                	li	a7,5
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <write>:
.global write
write:
 li a7, SYS_write
 37a:	48c1                	li	a7,16
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <close>:
.global close
close:
 li a7, SYS_close
 382:	48d5                	li	a7,21
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <kill>:
.global kill
kill:
 li a7, SYS_kill
 38a:	4899                	li	a7,6
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exec>:
.global exec
exec:
 li a7, SYS_exec
 392:	489d                	li	a7,7
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <open>:
.global open
open:
 li a7, SYS_open
 39a:	48bd                	li	a7,15
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a2:	48c5                	li	a7,17
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3aa:	48c9                	li	a7,18
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <link>:
.global link
link:
 li a7, SYS_link
 3ba:	48cd                	li	a7,19
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c2:	48d1                	li	a7,20
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ca:	48a5                	li	a7,9
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d2:	48a9                	li	a7,10
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3da:	48ad                	li	a7,11
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e2:	48b1                	li	a7,12
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ea:	48b5                	li	a7,13
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f2:	48b9                	li	a7,14
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 3fa:	48d9                	li	a7,22
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 402:	1101                	addi	sp,sp,-32
 404:	ec06                	sd	ra,24(sp)
 406:	e822                	sd	s0,16(sp)
 408:	1000                	addi	s0,sp,32
 40a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40e:	4605                	li	a2,1
 410:	fef40593          	addi	a1,s0,-17
 414:	f67ff0ef          	jal	37a <write>
}
 418:	60e2                	ld	ra,24(sp)
 41a:	6442                	ld	s0,16(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret

0000000000000420 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 420:	715d                	addi	sp,sp,-80
 422:	e486                	sd	ra,72(sp)
 424:	e0a2                	sd	s0,64(sp)
 426:	fc26                	sd	s1,56(sp)
 428:	f84a                	sd	s2,48(sp)
 42a:	f44e                	sd	s3,40(sp)
 42c:	0880                	addi	s0,sp,80
 42e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 430:	c299                	beqz	a3,436 <printint+0x16>
 432:	0605cf63          	bltz	a1,4b0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 436:	2581                	sext.w	a1,a1
  neg = 0;
 438:	4e01                	li	t3,0
  }

  i = 0;
 43a:	fb840313          	addi	t1,s0,-72
  neg = 0;
 43e:	869a                	mv	a3,t1
  i = 0;
 440:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 442:	00000817          	auipc	a6,0x0
 446:	54e80813          	addi	a6,a6,1358 # 990 <digits>
 44a:	88be                	mv	a7,a5
 44c:	0017851b          	addiw	a0,a5,1
 450:	87aa                	mv	a5,a0
 452:	02c5f73b          	remuw	a4,a1,a2
 456:	1702                	slli	a4,a4,0x20
 458:	9301                	srli	a4,a4,0x20
 45a:	9742                	add	a4,a4,a6
 45c:	00074703          	lbu	a4,0(a4)
 460:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 464:	872e                	mv	a4,a1
 466:	02c5d5bb          	divuw	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fcc77fe3          	bgeu	a4,a2,44a <printint+0x2a>
  if(neg)
 470:	000e0c63          	beqz	t3,488 <printint+0x68>
    buf[i++] = '-';
 474:	fd050793          	addi	a5,a0,-48
 478:	00878533          	add	a0,a5,s0
 47c:	02d00793          	li	a5,45
 480:	fef50423          	sb	a5,-24(a0)
 484:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 488:	fff7899b          	addiw	s3,a5,-1
 48c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 490:	fff4c583          	lbu	a1,-1(s1)
 494:	854a                	mv	a0,s2
 496:	f6dff0ef          	jal	402 <putc>
  while(--i >= 0)
 49a:	39fd                	addiw	s3,s3,-1
 49c:	14fd                	addi	s1,s1,-1
 49e:	fe09d9e3          	bgez	s3,490 <printint+0x70>
}
 4a2:	60a6                	ld	ra,72(sp)
 4a4:	6406                	ld	s0,64(sp)
 4a6:	74e2                	ld	s1,56(sp)
 4a8:	7942                	ld	s2,48(sp)
 4aa:	79a2                	ld	s3,40(sp)
 4ac:	6161                	addi	sp,sp,80
 4ae:	8082                	ret
    x = -xx;
 4b0:	40b005bb          	negw	a1,a1
    neg = 1;
 4b4:	4e05                	li	t3,1
    x = -xx;
 4b6:	b751                	j	43a <printint+0x1a>

00000000000004b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b8:	711d                	addi	sp,sp,-96
 4ba:	ec86                	sd	ra,88(sp)
 4bc:	e8a2                	sd	s0,80(sp)
 4be:	e4a6                	sd	s1,72(sp)
 4c0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c2:	0005c483          	lbu	s1,0(a1)
 4c6:	26048663          	beqz	s1,732 <vprintf+0x27a>
 4ca:	e0ca                	sd	s2,64(sp)
 4cc:	fc4e                	sd	s3,56(sp)
 4ce:	f852                	sd	s4,48(sp)
 4d0:	f456                	sd	s5,40(sp)
 4d2:	f05a                	sd	s6,32(sp)
 4d4:	ec5e                	sd	s7,24(sp)
 4d6:	e862                	sd	s8,16(sp)
 4d8:	e466                	sd	s9,8(sp)
 4da:	8b2a                	mv	s6,a0
 4dc:	8a2e                	mv	s4,a1
 4de:	8bb2                	mv	s7,a2
  state = 0;
 4e0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e2:	4901                	li	s2,0
 4e4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ee:	06c00c93          	li	s9,108
 4f2:	a00d                	j	514 <vprintf+0x5c>
        putc(fd, c0);
 4f4:	85a6                	mv	a1,s1
 4f6:	855a                	mv	a0,s6
 4f8:	f0bff0ef          	jal	402 <putc>
 4fc:	a019                	j	502 <vprintf+0x4a>
    } else if(state == '%'){
 4fe:	03598363          	beq	s3,s5,524 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 502:	0019079b          	addiw	a5,s2,1
 506:	893e                	mv	s2,a5
 508:	873e                	mv	a4,a5
 50a:	97d2                	add	a5,a5,s4
 50c:	0007c483          	lbu	s1,0(a5)
 510:	20048963          	beqz	s1,722 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 514:	0004879b          	sext.w	a5,s1
    if(state == 0){
 518:	fe0993e3          	bnez	s3,4fe <vprintf+0x46>
      if(c0 == '%'){
 51c:	fd579ce3          	bne	a5,s5,4f4 <vprintf+0x3c>
        state = '%';
 520:	89be                	mv	s3,a5
 522:	b7c5                	j	502 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 524:	00ea06b3          	add	a3,s4,a4
 528:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 52c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 52e:	c681                	beqz	a3,536 <vprintf+0x7e>
 530:	9752                	add	a4,a4,s4
 532:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 536:	03878e63          	beq	a5,s8,572 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	05978863          	beq	a5,s9,58a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 53e:	07500713          	li	a4,117
 542:	0ee78263          	beq	a5,a4,626 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 546:	07800713          	li	a4,120
 54a:	12e78463          	beq	a5,a4,672 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 54e:	07000713          	li	a4,112
 552:	14e78963          	beq	a5,a4,6a4 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 556:	07300713          	li	a4,115
 55a:	18e78863          	beq	a5,a4,6ea <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 55e:	02500713          	li	a4,37
 562:	04e79463          	bne	a5,a4,5aa <vprintf+0xf2>
        putc(fd, '%');
 566:	85ba                	mv	a1,a4
 568:	855a                	mv	a0,s6
 56a:	e99ff0ef          	jal	402 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 56e:	4981                	li	s3,0
 570:	bf49                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b8493          	addi	s1,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	ea1ff0ef          	jal	420 <printint>
 584:	8ba6                	mv	s7,s1
      state = 0;
 586:	4981                	li	s3,0
 588:	bfad                	j	502 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 58a:	06400793          	li	a5,100
 58e:	02f68963          	beq	a3,a5,5c0 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 592:	06c00793          	li	a5,108
 596:	04f68263          	beq	a3,a5,5da <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 59a:	07500793          	li	a5,117
 59e:	0af68063          	beq	a3,a5,63e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5a2:	07800793          	li	a5,120
 5a6:	0ef68263          	beq	a3,a5,68a <vprintf+0x1d2>
        putc(fd, '%');
 5aa:	02500593          	li	a1,37
 5ae:	855a                	mv	a0,s6
 5b0:	e53ff0ef          	jal	402 <putc>
        putc(fd, c0);
 5b4:	85a6                	mv	a1,s1
 5b6:	855a                	mv	a0,s6
 5b8:	e4bff0ef          	jal	402 <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b791                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000bb583          	ld	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e53ff0ef          	jal	420 <printint>
        i += 1;
 5d2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
        i += 1;
 5d8:	b72d                	j	502 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5da:	06400793          	li	a5,100
 5de:	02f60763          	beq	a2,a5,60c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e2:	07500793          	li	a5,117
 5e6:	06f60963          	beq	a2,a5,658 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ea:	07800793          	li	a5,120
 5ee:	faf61ee3          	bne	a2,a5,5aa <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e21ff0ef          	jal	420 <printint>
        i += 2;
 604:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	bde5                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8493          	addi	s1,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e07ff0ef          	jal	420 <printint>
        i += 2;
 61e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
        i += 2;
 624:	bdf9                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 626:	008b8493          	addi	s1,s7,8
 62a:	4681                	li	a3,0
 62c:	4629                	li	a2,10
 62e:	000ba583          	lw	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	dedff0ef          	jal	420 <printint>
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b5d9                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b8493          	addi	s1,s7,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	dd5ff0ef          	jal	420 <printint>
        i += 1;
 650:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
        i += 1;
 656:	b575                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	008b8493          	addi	s1,s7,8
 65c:	4681                	li	a3,0
 65e:	4629                	li	a2,10
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	dbbff0ef          	jal	420 <printint>
        i += 2;
 66a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	8ba6                	mv	s7,s1
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bd49                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 672:	008b8493          	addi	s1,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	da1ff0ef          	jal	420 <printint>
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
 688:	bdad                	j	502 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4681                	li	a3,0
 690:	4641                	li	a2,16
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	d89ff0ef          	jal	420 <printint>
        i += 1;
 69c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	b585                	j	502 <vprintf+0x4a>
 6a4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b8d13          	addi	s10,s7,8
 6aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ae:	03000593          	li	a1,48
 6b2:	855a                	mv	a0,s6
 6b4:	d4fff0ef          	jal	402 <putc>
  putc(fd, 'x');
 6b8:	07800593          	li	a1,120
 6bc:	855a                	mv	a0,s6
 6be:	d45ff0ef          	jal	402 <putc>
 6c2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	2ccb8b93          	addi	s7,s7,716 # 990 <digits>
 6cc:	03c9d793          	srli	a5,s3,0x3c
 6d0:	97de                	add	a5,a5,s7
 6d2:	0007c583          	lbu	a1,0(a5)
 6d6:	855a                	mv	a0,s6
 6d8:	d2bff0ef          	jal	402 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6dc:	0992                	slli	s3,s3,0x4
 6de:	34fd                	addiw	s1,s1,-1
 6e0:	f4f5                	bnez	s1,6cc <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6e2:	8bea                	mv	s7,s10
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	6d02                	ld	s10,0(sp)
 6e8:	bd29                	j	502 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6ea:	008b8993          	addi	s3,s7,8
 6ee:	000bb483          	ld	s1,0(s7)
 6f2:	cc91                	beqz	s1,70e <vprintf+0x256>
        for(; *s; s++)
 6f4:	0004c583          	lbu	a1,0(s1)
 6f8:	c195                	beqz	a1,71c <vprintf+0x264>
          putc(fd, *s);
 6fa:	855a                	mv	a0,s6
 6fc:	d07ff0ef          	jal	402 <putc>
        for(; *s; s++)
 700:	0485                	addi	s1,s1,1
 702:	0004c583          	lbu	a1,0(s1)
 706:	f9f5                	bnez	a1,6fa <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 708:	8bce                	mv	s7,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bbdd                	j	502 <vprintf+0x4a>
          s = "(null)";
 70e:	00000497          	auipc	s1,0x0
 712:	27a48493          	addi	s1,s1,634 # 988 <malloc+0x16a>
        for(; *s; s++)
 716:	02800593          	li	a1,40
 71a:	b7c5                	j	6fa <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 71c:	8bce                	mv	s7,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	b3cd                	j	502 <vprintf+0x4a>
 722:	6906                	ld	s2,64(sp)
 724:	79e2                	ld	s3,56(sp)
 726:	7a42                	ld	s4,48(sp)
 728:	7aa2                	ld	s5,40(sp)
 72a:	7b02                	ld	s6,32(sp)
 72c:	6be2                	ld	s7,24(sp)
 72e:	6c42                	ld	s8,16(sp)
 730:	6ca2                	ld	s9,8(sp)
    }
  }
}
 732:	60e6                	ld	ra,88(sp)
 734:	6446                	ld	s0,80(sp)
 736:	64a6                	ld	s1,72(sp)
 738:	6125                	addi	sp,sp,96
 73a:	8082                	ret

000000000000073c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73c:	715d                	addi	sp,sp,-80
 73e:	ec06                	sd	ra,24(sp)
 740:	e822                	sd	s0,16(sp)
 742:	1000                	addi	s0,sp,32
 744:	e010                	sd	a2,0(s0)
 746:	e414                	sd	a3,8(s0)
 748:	e818                	sd	a4,16(s0)
 74a:	ec1c                	sd	a5,24(s0)
 74c:	03043023          	sd	a6,32(s0)
 750:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	8622                	mv	a2,s0
 756:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75a:	d5fff0ef          	jal	4b8 <vprintf>
}
 75e:	60e2                	ld	ra,24(sp)
 760:	6442                	ld	s0,16(sp)
 762:	6161                	addi	sp,sp,80
 764:	8082                	ret

0000000000000766 <printf>:

void
printf(const char *fmt, ...)
{
 766:	711d                	addi	sp,sp,-96
 768:	ec06                	sd	ra,24(sp)
 76a:	e822                	sd	s0,16(sp)
 76c:	1000                	addi	s0,sp,32
 76e:	e40c                	sd	a1,8(s0)
 770:	e810                	sd	a2,16(s0)
 772:	ec14                	sd	a3,24(s0)
 774:	f018                	sd	a4,32(s0)
 776:	f41c                	sd	a5,40(s0)
 778:	03043823          	sd	a6,48(s0)
 77c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 780:	00840613          	addi	a2,s0,8
 784:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 788:	85aa                	mv	a1,a0
 78a:	4505                	li	a0,1
 78c:	d2dff0ef          	jal	4b8 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6125                	addi	sp,sp,96
 796:	8082                	ret

0000000000000798 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 798:	1141                	addi	sp,sp,-16
 79a:	e406                	sd	ra,8(sp)
 79c:	e022                	sd	s0,0(sp)
 79e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	00001797          	auipc	a5,0x1
 7a8:	86c7b783          	ld	a5,-1940(a5) # 1010 <freep>
 7ac:	a02d                	j	7d6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ae:	4618                	lw	a4,8(a2)
 7b0:	9f2d                	addw	a4,a4,a1
 7b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	6398                	ld	a4,0(a5)
 7b8:	6310                	ld	a2,0(a4)
 7ba:	a83d                	j	7f8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7bc:	ff852703          	lw	a4,-8(a0)
 7c0:	9f31                	addw	a4,a4,a2
 7c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c4:	ff053683          	ld	a3,-16(a0)
 7c8:	a091                	j	80c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e7e463          	bltu	a5,a4,7d4 <free+0x3c>
 7d0:	00e6ea63          	bltu	a3,a4,7e4 <free+0x4c>
{
 7d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	fed7fae3          	bgeu	a5,a3,7ca <free+0x32>
 7da:	6398                	ld	a4,0(a5)
 7dc:	00e6e463          	bltu	a3,a4,7e4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	fee7eae3          	bltu	a5,a4,7d4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7e4:	ff852583          	lw	a1,-8(a0)
 7e8:	6390                	ld	a2,0(a5)
 7ea:	02059813          	slli	a6,a1,0x20
 7ee:	01c85713          	srli	a4,a6,0x1c
 7f2:	9736                	add	a4,a4,a3
 7f4:	fae60de3          	beq	a2,a4,7ae <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fc:	4790                	lw	a2,8(a5)
 7fe:	02061593          	slli	a1,a2,0x20
 802:	01c5d713          	srli	a4,a1,0x1c
 806:	973e                	add	a4,a4,a5
 808:	fae68ae3          	beq	a3,a4,7bc <free+0x24>
    p->s.ptr = bp->s.ptr;
 80c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80e:	00001717          	auipc	a4,0x1
 812:	80f73123          	sd	a5,-2046(a4) # 1010 <freep>
}
 816:	60a2                	ld	ra,8(sp)
 818:	6402                	ld	s0,0(sp)
 81a:	0141                	addi	sp,sp,16
 81c:	8082                	ret

000000000000081e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	f04a                	sd	s2,32(sp)
 826:	ec4e                	sd	s3,24(sp)
 828:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82a:	02051993          	slli	s3,a0,0x20
 82e:	0209d993          	srli	s3,s3,0x20
 832:	09bd                	addi	s3,s3,15
 834:	0049d993          	srli	s3,s3,0x4
 838:	2985                	addiw	s3,s3,1
 83a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 83c:	00000517          	auipc	a0,0x0
 840:	7d453503          	ld	a0,2004(a0) # 1010 <freep>
 844:	c905                	beqz	a0,874 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 848:	4798                	lw	a4,8(a5)
 84a:	09377663          	bgeu	a4,s3,8d6 <malloc+0xb8>
 84e:	f426                	sd	s1,40(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 856:	8a4e                	mv	s4,s3
 858:	6705                	lui	a4,0x1
 85a:	00e9f363          	bgeu	s3,a4,860 <malloc+0x42>
 85e:	6a05                	lui	s4,0x1
 860:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 864:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 868:	00000497          	auipc	s1,0x0
 86c:	7a848493          	addi	s1,s1,1960 # 1010 <freep>
  if(p == (char*)-1)
 870:	5afd                	li	s5,-1
 872:	a83d                	j	8b0 <malloc+0x92>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 87c:	00000797          	auipc	a5,0x0
 880:	7a478793          	addi	a5,a5,1956 # 1020 <base>
 884:	00000717          	auipc	a4,0x0
 888:	78f73623          	sd	a5,1932(a4) # 1010 <freep>
 88c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 892:	b7d1                	j	856 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	e118                	sd	a4,0(a0)
 898:	a899                	j	8ee <malloc+0xd0>
  hp->s.size = nu;
 89a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89e:	0541                	addi	a0,a0,16
 8a0:	ef9ff0ef          	jal	798 <free>
  return freep;
 8a4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a6:	c125                	beqz	a0,906 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	03277163          	bgeu	a4,s2,8ce <malloc+0xb0>
    if(p == freep)
 8b0:	6098                	ld	a4,0(s1)
 8b2:	853e                	mv	a0,a5
 8b4:	fef71ae3          	bne	a4,a5,8a8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b8:	8552                	mv	a0,s4
 8ba:	b29ff0ef          	jal	3e2 <sbrk>
  if(p == (char*)-1)
 8be:	fd551ee3          	bne	a0,s5,89a <malloc+0x7c>
        return 0;
 8c2:	4501                	li	a0,0
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	a03d                	j	8fa <malloc+0xdc>
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d6:	fae90fe3          	beq	s2,a4,894 <malloc+0x76>
        p->s.size -= nunits;
 8da:	4137073b          	subw	a4,a4,s3
 8de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e0:	02071693          	slli	a3,a4,0x20
 8e4:	01c6d713          	srli	a4,a3,0x1c
 8e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	72a73123          	sd	a0,1826(a4) # 1010 <freep>
      return (void*)(p + 1);
 8f6:	01078513          	addi	a0,a5,16
  }
}
 8fa:	70e2                	ld	ra,56(sp)
 8fc:	7442                	ld	s0,48(sp)
 8fe:	7902                	ld	s2,32(sp)
 900:	69e2                	ld	s3,24(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
 906:	74a2                	ld	s1,40(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
 90e:	b7f5                	j	8fa <malloc+0xdc>
