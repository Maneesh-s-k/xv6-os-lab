
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2de000ef          	jal	2ea <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2b6000ef          	jal	2ea <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	29a000ef          	jal	2ea <strlen>
  54:	862a                	mv	a2,a0
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	40e000ef          	jal	470 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  66:	8526                	mv	a0,s1
  68:	282000ef          	jal	2ea <strlen>
  6c:	892a                	mv	s2,a0
  6e:	8526                	mv	a0,s1
  70:	27a000ef          	jal	2ea <strlen>
  74:	1902                	slli	s2,s2,0x20
  76:	02095913          	srli	s2,s2,0x20
  7a:	4639                	li	a2,14
  7c:	9e09                	subw	a2,a2,a0
  7e:	02000593          	li	a1,32
  82:	01298533          	add	a0,s3,s2
  86:	292000ef          	jal	318 <memset>
  return buf;
  8a:	84ce                	mv	s1,s3
  8c:	6942                	ld	s2,16(sp)
  8e:	69a2                	ld	s3,8(sp)
  90:	b77d                	j	3e <fmtname+0x3e>

0000000000000092 <ls>:

void
ls(char *path)
{
  92:	d7010113          	addi	sp,sp,-656
  96:	28113423          	sd	ra,648(sp)
  9a:	28813023          	sd	s0,640(sp)
  9e:	27213823          	sd	s2,624(sp)
  a2:	0d00                	addi	s0,sp,656
  a4:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	4be000ef          	jal	566 <open>
  ac:	06054363          	bltz	a0,112 <ls+0x80>
  b0:	26913c23          	sd	s1,632(sp)
  b4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b6:	d7840593          	addi	a1,s0,-648
  ba:	4c4000ef          	jal	57e <fstat>
  be:	06054363          	bltz	a0,124 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c2:	d8041783          	lh	a5,-640(s0)
  c6:	4705                	li	a4,1
  c8:	06e78c63          	beq	a5,a4,140 <ls+0xae>
  cc:	37f9                	addiw	a5,a5,-2
  ce:	17c2                	slli	a5,a5,0x30
  d0:	93c1                	srli	a5,a5,0x30
  d2:	02f76263          	bltu	a4,a5,f6 <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  d6:	854a                	mv	a0,s2
  d8:	f29ff0ef          	jal	0 <fmtname>
  dc:	85aa                	mv	a1,a0
  de:	d8842703          	lw	a4,-632(s0)
  e2:	d7c42683          	lw	a3,-644(s0)
  e6:	d8041603          	lh	a2,-640(s0)
  ea:	00001517          	auipc	a0,0x1
  ee:	a2650513          	addi	a0,a0,-1498 # b10 <malloc+0x12e>
  f2:	039000ef          	jal	92a <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  f6:	8526                	mv	a0,s1
  f8:	456000ef          	jal	54e <close>
  fc:	27813483          	ld	s1,632(sp)
}
 100:	28813083          	ld	ra,648(sp)
 104:	28013403          	ld	s0,640(sp)
 108:	27013903          	ld	s2,624(sp)
 10c:	29010113          	addi	sp,sp,656
 110:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 112:	864a                	mv	a2,s2
 114:	00001597          	auipc	a1,0x1
 118:	9cc58593          	addi	a1,a1,-1588 # ae0 <malloc+0xfe>
 11c:	4509                	li	a0,2
 11e:	7e2000ef          	jal	900 <fprintf>
    return;
 122:	bff9                	j	100 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 124:	864a                	mv	a2,s2
 126:	00001597          	auipc	a1,0x1
 12a:	9d258593          	addi	a1,a1,-1582 # af8 <malloc+0x116>
 12e:	4509                	li	a0,2
 130:	7d0000ef          	jal	900 <fprintf>
    close(fd);
 134:	8526                	mv	a0,s1
 136:	418000ef          	jal	54e <close>
    return;
 13a:	27813483          	ld	s1,632(sp)
 13e:	b7c9                	j	100 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 140:	854a                	mv	a0,s2
 142:	1a8000ef          	jal	2ea <strlen>
 146:	2541                	addiw	a0,a0,16
 148:	20000793          	li	a5,512
 14c:	00a7f963          	bgeu	a5,a0,15e <ls+0xcc>
      printf("ls: path too long\n");
 150:	00001517          	auipc	a0,0x1
 154:	9d050513          	addi	a0,a0,-1584 # b20 <malloc+0x13e>
 158:	7d2000ef          	jal	92a <printf>
      break;
 15c:	bf69                	j	f6 <ls+0x64>
 15e:	27313423          	sd	s3,616(sp)
 162:	27413023          	sd	s4,608(sp)
 166:	25513c23          	sd	s5,600(sp)
 16a:	25613823          	sd	s6,592(sp)
 16e:	25713423          	sd	s7,584(sp)
 172:	25813023          	sd	s8,576(sp)
 176:	23913c23          	sd	s9,568(sp)
 17a:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 17e:	da040993          	addi	s3,s0,-608
 182:	85ca                	mv	a1,s2
 184:	854e                	mv	a0,s3
 186:	114000ef          	jal	29a <strcpy>
    p = buf+strlen(buf);
 18a:	854e                	mv	a0,s3
 18c:	15e000ef          	jal	2ea <strlen>
 190:	1502                	slli	a0,a0,0x20
 192:	9101                	srli	a0,a0,0x20
 194:	99aa                	add	s3,s3,a0
    *p++ = '/';
 196:	00198c93          	addi	s9,s3,1
 19a:	02f00793          	li	a5,47
 19e:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a2:	d9040a13          	addi	s4,s0,-624
 1a6:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1a8:	d9240c13          	addi	s8,s0,-622
 1ac:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1ae:	d7840b13          	addi	s6,s0,-648
 1b2:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1b6:	00001d17          	auipc	s10,0x1
 1ba:	95ad0d13          	addi	s10,s10,-1702 # b10 <malloc+0x12e>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1be:	a801                	j	1ce <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c0:	85d6                	mv	a1,s5
 1c2:	00001517          	auipc	a0,0x1
 1c6:	93650513          	addi	a0,a0,-1738 # af8 <malloc+0x116>
 1ca:	760000ef          	jal	92a <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ce:	864a                	mv	a2,s2
 1d0:	85d2                	mv	a1,s4
 1d2:	8526                	mv	a0,s1
 1d4:	36a000ef          	jal	53e <read>
 1d8:	05251063          	bne	a0,s2,218 <ls+0x186>
      if(de.inum == 0)
 1dc:	d9045783          	lhu	a5,-624(s0)
 1e0:	d7fd                	beqz	a5,1ce <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
 1e2:	865e                	mv	a2,s7
 1e4:	85e2                	mv	a1,s8
 1e6:	8566                	mv	a0,s9
 1e8:	288000ef          	jal	470 <memmove>
      p[DIRSIZ] = 0;
 1ec:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 1f0:	85da                	mv	a1,s6
 1f2:	8556                	mv	a0,s5
 1f4:	1f6000ef          	jal	3ea <stat>
 1f8:	fc0544e3          	bltz	a0,1c0 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fc:	8556                	mv	a0,s5
 1fe:	e03ff0ef          	jal	0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	d8842703          	lw	a4,-632(s0)
 208:	d7c42683          	lw	a3,-644(s0)
 20c:	d8041603          	lh	a2,-640(s0)
 210:	856a                	mv	a0,s10
 212:	718000ef          	jal	92a <printf>
 216:	bf65                	j	1ce <ls+0x13c>
 218:	26813983          	ld	s3,616(sp)
 21c:	26013a03          	ld	s4,608(sp)
 220:	25813a83          	ld	s5,600(sp)
 224:	25013b03          	ld	s6,592(sp)
 228:	24813b83          	ld	s7,584(sp)
 22c:	24013c03          	ld	s8,576(sp)
 230:	23813c83          	ld	s9,568(sp)
 234:	23013d03          	ld	s10,560(sp)
 238:	bd7d                	j	f6 <ls+0x64>

000000000000023a <main>:

int
main(int argc, char *argv[])
{
 23a:	1101                	addi	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 242:	4785                	li	a5,1
 244:	02a7d763          	bge	a5,a0,272 <main+0x38>
 248:	e426                	sd	s1,8(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	00858493          	addi	s1,a1,8
 250:	ffe5091b          	addiw	s2,a0,-2
 254:	02091793          	slli	a5,s2,0x20
 258:	01d7d913          	srli	s2,a5,0x1d
 25c:	05c1                	addi	a1,a1,16
 25e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 260:	6088                	ld	a0,0(s1)
 262:	e31ff0ef          	jal	92 <ls>
  for(i=1; i<argc; i++)
 266:	04a1                	addi	s1,s1,8
 268:	ff249ce3          	bne	s1,s2,260 <main+0x26>
  exit(0);
 26c:	4501                	li	a0,0
 26e:	2b8000ef          	jal	526 <exit>
 272:	e426                	sd	s1,8(sp)
 274:	e04a                	sd	s2,0(sp)
    ls(".");
 276:	00001517          	auipc	a0,0x1
 27a:	8c250513          	addi	a0,a0,-1854 # b38 <malloc+0x156>
 27e:	e15ff0ef          	jal	92 <ls>
    exit(0);
 282:	4501                	li	a0,0
 284:	2a2000ef          	jal	526 <exit>

0000000000000288 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 290:	fabff0ef          	jal	23a <main>
  exit(0);
 294:	4501                	li	a0,0
 296:	290000ef          	jal	526 <exit>

000000000000029a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a2:	87aa                	mv	a5,a0
 2a4:	0585                	addi	a1,a1,1
 2a6:	0785                	addi	a5,a5,1
 2a8:	fff5c703          	lbu	a4,-1(a1)
 2ac:	fee78fa3          	sb	a4,-1(a5)
 2b0:	fb75                	bnez	a4,2a4 <strcpy+0xa>
    ;
  return os;
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cb91                	beqz	a5,2da <strcmp+0x20>
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00f71763          	bne	a4,a5,2da <strcmp+0x20>
    p++, q++;
 2d0:	0505                	addi	a0,a0,1
 2d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	fbe5                	bnez	a5,2c8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2da:	0005c503          	lbu	a0,0(a1)
}
 2de:	40a7853b          	subw	a0,a5,a0
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cf99                	beqz	a5,314 <strlen+0x2a>
 2f8:	0505                	addi	a0,a0,1
 2fa:	87aa                	mv	a5,a0
 2fc:	86be                	mv	a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	ff65                	bnez	a4,2fc <strlen+0x12>
 306:	40a6853b          	subw	a0,a3,a0
 30a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfdd                	j	30c <strlen+0x22>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 320:	ca19                	beqz	a2,336 <memset+0x1e>
 322:	87aa                	mv	a5,a0
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 330:	0785                	addi	a5,a5,1
 332:	fee79de3          	bne	a5,a4,32c <memset+0x14>
  }
  return dst;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  for(; *s; s++)
 346:	00054783          	lbu	a5,0(a0)
 34a:	cf81                	beqz	a5,362 <strchr+0x24>
    if(*s == c)
 34c:	00f58763          	beq	a1,a5,35a <strchr+0x1c>
  for(; *s; s++)
 350:	0505                	addi	a0,a0,1
 352:	00054783          	lbu	a5,0(a0)
 356:	fbfd                	bnez	a5,34c <strchr+0xe>
      return (char*)s;
  return 0;
 358:	4501                	li	a0,0
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <strchr+0x1c>

0000000000000366 <gets>:

char*
gets(char *buf, int max)
{
 366:	7159                	addi	sp,sp,-112
 368:	f486                	sd	ra,104(sp)
 36a:	f0a2                	sd	s0,96(sp)
 36c:	eca6                	sd	s1,88(sp)
 36e:	e8ca                	sd	s2,80(sp)
 370:	e4ce                	sd	s3,72(sp)
 372:	e0d2                	sd	s4,64(sp)
 374:	fc56                	sd	s5,56(sp)
 376:	f85a                	sd	s6,48(sp)
 378:	f45e                	sd	s7,40(sp)
 37a:	f062                	sd	s8,32(sp)
 37c:	ec66                	sd	s9,24(sp)
 37e:	e86a                	sd	s10,16(sp)
 380:	1880                	addi	s0,sp,112
 382:	8caa                	mv	s9,a0
 384:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	892a                	mv	s2,a0
 388:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38a:	f9f40b13          	addi	s6,s0,-97
 38e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 390:	4ba9                	li	s7,10
 392:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 394:	8d26                	mv	s10,s1
 396:	0014899b          	addiw	s3,s1,1
 39a:	84ce                	mv	s1,s3
 39c:	0349d563          	bge	s3,s4,3c6 <gets+0x60>
    cc = read(0, &c, 1);
 3a0:	8656                	mv	a2,s5
 3a2:	85da                	mv	a1,s6
 3a4:	4501                	li	a0,0
 3a6:	198000ef          	jal	53e <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x60>
    buf[i++] = c;
 3ae:	f9f44783          	lbu	a5,-97(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01778763          	beq	a5,s7,3c4 <gets+0x5e>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd879ce3          	bne	a5,s8,394 <gets+0x2e>
    buf[i++] = c;
 3c0:	8d4e                	mv	s10,s3
 3c2:	a011                	j	3c6 <gets+0x60>
 3c4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c6:	9d66                	add	s10,s10,s9
 3c8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3cc:	8566                	mv	a0,s9
 3ce:	70a6                	ld	ra,104(sp)
 3d0:	7406                	ld	s0,96(sp)
 3d2:	64e6                	ld	s1,88(sp)
 3d4:	6946                	ld	s2,80(sp)
 3d6:	69a6                	ld	s3,72(sp)
 3d8:	6a06                	ld	s4,64(sp)
 3da:	7ae2                	ld	s5,56(sp)
 3dc:	7b42                	ld	s6,48(sp)
 3de:	7ba2                	ld	s7,40(sp)
 3e0:	7c02                	ld	s8,32(sp)
 3e2:	6ce2                	ld	s9,24(sp)
 3e4:	6d42                	ld	s10,16(sp)
 3e6:	6165                	addi	sp,sp,112
 3e8:	8082                	ret

00000000000003ea <stat>:

int
stat(const char *n, struct stat *st)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	e04a                	sd	s2,0(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f6:	4581                	li	a1,0
 3f8:	16e000ef          	jal	566 <open>
  if(fd < 0)
 3fc:	02054263          	bltz	a0,420 <stat+0x36>
 400:	e426                	sd	s1,8(sp)
 402:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 404:	85ca                	mv	a1,s2
 406:	178000ef          	jal	57e <fstat>
 40a:	892a                	mv	s2,a0
  close(fd);
 40c:	8526                	mv	a0,s1
 40e:	140000ef          	jal	54e <close>
  return r;
 412:	64a2                	ld	s1,8(sp)
}
 414:	854a                	mv	a0,s2
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfcd                	j	414 <stat+0x2a>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e406                	sd	ra,8(sp)
 428:	e022                	sd	s0,0(sp)
 42a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42c:	00054683          	lbu	a3,0(a0)
 430:	fd06879b          	addiw	a5,a3,-48
 434:	0ff7f793          	zext.b	a5,a5
 438:	4625                	li	a2,9
 43a:	02f66963          	bltu	a2,a5,46c <atoi+0x48>
 43e:	872a                	mv	a4,a0
  n = 0;
 440:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 442:	0705                	addi	a4,a4,1
 444:	0025179b          	slliw	a5,a0,0x2
 448:	9fa9                	addw	a5,a5,a0
 44a:	0017979b          	slliw	a5,a5,0x1
 44e:	9fb5                	addw	a5,a5,a3
 450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 454:	00074683          	lbu	a3,0(a4)
 458:	fd06879b          	addiw	a5,a3,-48
 45c:	0ff7f793          	zext.b	a5,a5
 460:	fef671e3          	bgeu	a2,a5,442 <atoi+0x1e>
  return n;
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  n = 0;
 46c:	4501                	li	a0,0
 46e:	bfdd                	j	464 <atoi+0x40>

0000000000000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 478:	02b57563          	bgeu	a0,a1,4a2 <memmove+0x32>
    while(n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x2a>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 488:	872a                	mv	a4,a0
      *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49a:	60a2                	ld	ra,8(sp)
 49c:	6402                	ld	s0,0(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
    dst += n;
 4a2:	00c50733          	add	a4,a0,a2
    src += n;
 4a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a8:	fec059e3          	blez	a2,49a <memmove+0x2a>
 4ac:	fff6079b          	addiw	a5,a2,-1
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	fff7c793          	not	a5,a5
 4b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ba:	15fd                	addi	a1,a1,-1
 4bc:	177d                	addi	a4,a4,-1
 4be:	0005c683          	lbu	a3,0(a1)
 4c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c6:	fef71ae3          	bne	a4,a5,4ba <memmove+0x4a>
 4ca:	bfc1                	j	49a <memmove+0x2a>

00000000000004cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d4:	ca0d                	beqz	a2,506 <memcmp+0x3a>
 4d6:	fff6069b          	addiw	a3,a2,-1
 4da:	1682                	slli	a3,a3,0x20
 4dc:	9281                	srli	a3,a3,0x20
 4de:	0685                	addi	a3,a3,1
 4e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	0005c703          	lbu	a4,0(a1)
 4ea:	00e79863          	bne	a5,a4,4fa <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4ee:	0505                	addi	a0,a0,1
    p2++;
 4f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f2:	fed518e3          	bne	a0,a3,4e2 <memcmp+0x16>
  }
  return 0;
 4f6:	4501                	li	a0,0
 4f8:	a019                	j	4fe <memcmp+0x32>
      return *p1 - *p2;
 4fa:	40e7853b          	subw	a0,a5,a4
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret
  return 0;
 506:	4501                	li	a0,0
 508:	bfdd                	j	4fe <memcmp+0x32>

000000000000050a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 512:	f5fff0ef          	jal	470 <memmove>
}
 516:	60a2                	ld	ra,8(sp)
 518:	6402                	ld	s0,0(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51e:	4885                	li	a7,1
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exit>:
.global exit
exit:
 li a7, SYS_exit
 526:	4889                	li	a7,2
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <wait>:
.global wait
wait:
 li a7, SYS_wait
 52e:	488d                	li	a7,3
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 536:	4891                	li	a7,4
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <read>:
.global read
read:
 li a7, SYS_read
 53e:	4895                	li	a7,5
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <write>:
.global write
write:
 li a7, SYS_write
 546:	48c1                	li	a7,16
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <close>:
.global close
close:
 li a7, SYS_close
 54e:	48d5                	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <kill>:
.global kill
kill:
 li a7, SYS_kill
 556:	4899                	li	a7,6
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <exec>:
.global exec
exec:
 li a7, SYS_exec
 55e:	489d                	li	a7,7
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <open>:
.global open
open:
 li a7, SYS_open
 566:	48bd                	li	a7,15
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56e:	48c5                	li	a7,17
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 576:	48c9                	li	a7,18
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57e:	48a1                	li	a7,8
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <link>:
.global link
link:
 li a7, SYS_link
 586:	48cd                	li	a7,19
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58e:	48d1                	li	a7,20
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 596:	48a5                	li	a7,9
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <dup>:
.global dup
dup:
 li a7, SYS_dup
 59e:	48a9                	li	a7,10
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a6:	48ad                	li	a7,11
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ae:	48b1                	li	a7,12
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b6:	48b5                	li	a7,13
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5be:	48b9                	li	a7,14
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c6:	1101                	addi	sp,sp,-32
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d2:	4605                	li	a2,1
 5d4:	fef40593          	addi	a1,s0,-17
 5d8:	f6fff0ef          	jal	546 <write>
}
 5dc:	60e2                	ld	ra,24(sp)
 5de:	6442                	ld	s0,16(sp)
 5e0:	6105                	addi	sp,sp,32
 5e2:	8082                	ret

00000000000005e4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	e486                	sd	ra,72(sp)
 5e8:	e0a2                	sd	s0,64(sp)
 5ea:	fc26                	sd	s1,56(sp)
 5ec:	f84a                	sd	s2,48(sp)
 5ee:	f44e                	sd	s3,40(sp)
 5f0:	0880                	addi	s0,sp,80
 5f2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f4:	c299                	beqz	a3,5fa <printint+0x16>
 5f6:	0605cf63          	bltz	a1,674 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5fa:	2581                	sext.w	a1,a1
  neg = 0;
 5fc:	4e01                	li	t3,0
  }

  i = 0;
 5fe:	fb840313          	addi	t1,s0,-72
  neg = 0;
 602:	869a                	mv	a3,t1
  i = 0;
 604:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 606:	00000817          	auipc	a6,0x0
 60a:	54280813          	addi	a6,a6,1346 # b48 <digits>
 60e:	88be                	mv	a7,a5
 610:	0017851b          	addiw	a0,a5,1
 614:	87aa                	mv	a5,a0
 616:	02c5f73b          	remuw	a4,a1,a2
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	9742                	add	a4,a4,a6
 620:	00074703          	lbu	a4,0(a4)
 624:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 628:	872e                	mv	a4,a1
 62a:	02c5d5bb          	divuw	a1,a1,a2
 62e:	0685                	addi	a3,a3,1
 630:	fcc77fe3          	bgeu	a4,a2,60e <printint+0x2a>
  if(neg)
 634:	000e0c63          	beqz	t3,64c <printint+0x68>
    buf[i++] = '-';
 638:	fd050793          	addi	a5,a0,-48
 63c:	00878533          	add	a0,a5,s0
 640:	02d00793          	li	a5,45
 644:	fef50423          	sb	a5,-24(a0)
 648:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 64c:	fff7899b          	addiw	s3,a5,-1
 650:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 654:	fff4c583          	lbu	a1,-1(s1)
 658:	854a                	mv	a0,s2
 65a:	f6dff0ef          	jal	5c6 <putc>
  while(--i >= 0)
 65e:	39fd                	addiw	s3,s3,-1
 660:	14fd                	addi	s1,s1,-1
 662:	fe09d9e3          	bgez	s3,654 <printint+0x70>
}
 666:	60a6                	ld	ra,72(sp)
 668:	6406                	ld	s0,64(sp)
 66a:	74e2                	ld	s1,56(sp)
 66c:	7942                	ld	s2,48(sp)
 66e:	79a2                	ld	s3,40(sp)
 670:	6161                	addi	sp,sp,80
 672:	8082                	ret
    x = -xx;
 674:	40b005bb          	negw	a1,a1
    neg = 1;
 678:	4e05                	li	t3,1
    x = -xx;
 67a:	b751                	j	5fe <printint+0x1a>

000000000000067c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67c:	711d                	addi	sp,sp,-96
 67e:	ec86                	sd	ra,88(sp)
 680:	e8a2                	sd	s0,80(sp)
 682:	e4a6                	sd	s1,72(sp)
 684:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 686:	0005c483          	lbu	s1,0(a1)
 68a:	26048663          	beqz	s1,8f6 <vprintf+0x27a>
 68e:	e0ca                	sd	s2,64(sp)
 690:	fc4e                	sd	s3,56(sp)
 692:	f852                	sd	s4,48(sp)
 694:	f456                	sd	s5,40(sp)
 696:	f05a                	sd	s6,32(sp)
 698:	ec5e                	sd	s7,24(sp)
 69a:	e862                	sd	s8,16(sp)
 69c:	e466                	sd	s9,8(sp)
 69e:	8b2a                	mv	s6,a0
 6a0:	8a2e                	mv	s4,a1
 6a2:	8bb2                	mv	s7,a2
  state = 0;
 6a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a6:	4901                	li	s2,0
 6a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b2:	06c00c93          	li	s9,108
 6b6:	a00d                	j	6d8 <vprintf+0x5c>
        putc(fd, c0);
 6b8:	85a6                	mv	a1,s1
 6ba:	855a                	mv	a0,s6
 6bc:	f0bff0ef          	jal	5c6 <putc>
 6c0:	a019                	j	6c6 <vprintf+0x4a>
    } else if(state == '%'){
 6c2:	03598363          	beq	s3,s5,6e8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6c6:	0019079b          	addiw	a5,s2,1
 6ca:	893e                	mv	s2,a5
 6cc:	873e                	mv	a4,a5
 6ce:	97d2                	add	a5,a5,s4
 6d0:	0007c483          	lbu	s1,0(a5)
 6d4:	20048963          	beqz	s1,8e6 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 6d8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6dc:	fe0993e3          	bnez	s3,6c2 <vprintf+0x46>
      if(c0 == '%'){
 6e0:	fd579ce3          	bne	a5,s5,6b8 <vprintf+0x3c>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7c5                	j	6c6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f2:	c681                	beqz	a3,6fa <vprintf+0x7e>
 6f4:	9752                	add	a4,a4,s4
 6f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fa:	03878e63          	beq	a5,s8,736 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	05978863          	beq	a5,s9,74e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 702:	07500713          	li	a4,117
 706:	0ee78263          	beq	a5,a4,7ea <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 70a:	07800713          	li	a4,120
 70e:	12e78463          	beq	a5,a4,836 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	14e78963          	beq	a5,a4,868 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 71a:	07300713          	li	a4,115
 71e:	18e78863          	beq	a5,a4,8ae <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 722:	02500713          	li	a4,37
 726:	04e79463          	bne	a5,a4,76e <vprintf+0xf2>
        putc(fd, '%');
 72a:	85ba                	mv	a1,a4
 72c:	855a                	mv	a0,s6
 72e:	e99ff0ef          	jal	5c6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 732:	4981                	li	s3,0
 734:	bf49                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 736:	008b8493          	addi	s1,s7,8
 73a:	4685                	li	a3,1
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	ea1ff0ef          	jal	5e4 <printint>
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bfad                	j	6c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 74e:	06400793          	li	a5,100
 752:	02f68963          	beq	a3,a5,784 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 756:	06c00793          	li	a5,108
 75a:	04f68263          	beq	a3,a5,79e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 75e:	07500793          	li	a5,117
 762:	0af68063          	beq	a3,a5,802 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 766:	07800793          	li	a5,120
 76a:	0ef68263          	beq	a3,a5,84e <vprintf+0x1d2>
        putc(fd, '%');
 76e:	02500593          	li	a1,37
 772:	855a                	mv	a0,s6
 774:	e53ff0ef          	jal	5c6 <putc>
        putc(fd, c0);
 778:	85a6                	mv	a1,s1
 77a:	855a                	mv	a0,s6
 77c:	e4bff0ef          	jal	5c6 <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b791                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 784:	008b8493          	addi	s1,s7,8
 788:	4685                	li	a3,1
 78a:	4629                	li	a2,10
 78c:	000bb583          	ld	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	e53ff0ef          	jal	5e4 <printint>
        i += 1;
 796:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 798:	8ba6                	mv	s7,s1
      state = 0;
 79a:	4981                	li	s3,0
        i += 1;
 79c:	b72d                	j	6c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 79e:	06400793          	li	a5,100
 7a2:	02f60763          	beq	a2,a5,7d0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a6:	07500793          	li	a5,117
 7aa:	06f60963          	beq	a2,a5,81c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ae:	07800793          	li	a5,120
 7b2:	faf61ee3          	bne	a2,a5,76e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b6:	008b8493          	addi	s1,s7,8
 7ba:	4681                	li	a3,0
 7bc:	4641                	li	a2,16
 7be:	000bb583          	ld	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	e21ff0ef          	jal	5e4 <printint>
        i += 2;
 7c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ca:	8ba6                	mv	s7,s1
      state = 0;
 7cc:	4981                	li	s3,0
        i += 2;
 7ce:	bde5                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d0:	008b8493          	addi	s1,s7,8
 7d4:	4685                	li	a3,1
 7d6:	4629                	li	a2,10
 7d8:	000bb583          	ld	a1,0(s7)
 7dc:	855a                	mv	a0,s6
 7de:	e07ff0ef          	jal	5e4 <printint>
        i += 2;
 7e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e4:	8ba6                	mv	s7,s1
      state = 0;
 7e6:	4981                	li	s3,0
        i += 2;
 7e8:	bdf9                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ea:	008b8493          	addi	s1,s7,8
 7ee:	4681                	li	a3,0
 7f0:	4629                	li	a2,10
 7f2:	000ba583          	lw	a1,0(s7)
 7f6:	855a                	mv	a0,s6
 7f8:	dedff0ef          	jal	5e4 <printint>
 7fc:	8ba6                	mv	s7,s1
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b5d9                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 802:	008b8493          	addi	s1,s7,8
 806:	4681                	li	a3,0
 808:	4629                	li	a2,10
 80a:	000bb583          	ld	a1,0(s7)
 80e:	855a                	mv	a0,s6
 810:	dd5ff0ef          	jal	5e4 <printint>
        i += 1;
 814:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 816:	8ba6                	mv	s7,s1
      state = 0;
 818:	4981                	li	s3,0
        i += 1;
 81a:	b575                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81c:	008b8493          	addi	s1,s7,8
 820:	4681                	li	a3,0
 822:	4629                	li	a2,10
 824:	000bb583          	ld	a1,0(s7)
 828:	855a                	mv	a0,s6
 82a:	dbbff0ef          	jal	5e4 <printint>
        i += 2;
 82e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 830:	8ba6                	mv	s7,s1
      state = 0;
 832:	4981                	li	s3,0
        i += 2;
 834:	bd49                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 836:	008b8493          	addi	s1,s7,8
 83a:	4681                	li	a3,0
 83c:	4641                	li	a2,16
 83e:	000ba583          	lw	a1,0(s7)
 842:	855a                	mv	a0,s6
 844:	da1ff0ef          	jal	5e4 <printint>
 848:	8ba6                	mv	s7,s1
      state = 0;
 84a:	4981                	li	s3,0
 84c:	bdad                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 84e:	008b8493          	addi	s1,s7,8
 852:	4681                	li	a3,0
 854:	4641                	li	a2,16
 856:	000bb583          	ld	a1,0(s7)
 85a:	855a                	mv	a0,s6
 85c:	d89ff0ef          	jal	5e4 <printint>
        i += 1;
 860:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 862:	8ba6                	mv	s7,s1
      state = 0;
 864:	4981                	li	s3,0
        i += 1;
 866:	b585                	j	6c6 <vprintf+0x4a>
 868:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 86a:	008b8d13          	addi	s10,s7,8
 86e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 872:	03000593          	li	a1,48
 876:	855a                	mv	a0,s6
 878:	d4fff0ef          	jal	5c6 <putc>
  putc(fd, 'x');
 87c:	07800593          	li	a1,120
 880:	855a                	mv	a0,s6
 882:	d45ff0ef          	jal	5c6 <putc>
 886:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 888:	00000b97          	auipc	s7,0x0
 88c:	2c0b8b93          	addi	s7,s7,704 # b48 <digits>
 890:	03c9d793          	srli	a5,s3,0x3c
 894:	97de                	add	a5,a5,s7
 896:	0007c583          	lbu	a1,0(a5)
 89a:	855a                	mv	a0,s6
 89c:	d2bff0ef          	jal	5c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a0:	0992                	slli	s3,s3,0x4
 8a2:	34fd                	addiw	s1,s1,-1
 8a4:	f4f5                	bnez	s1,890 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8a6:	8bea                	mv	s7,s10
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	6d02                	ld	s10,0(sp)
 8ac:	bd29                	j	6c6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ae:	008b8993          	addi	s3,s7,8
 8b2:	000bb483          	ld	s1,0(s7)
 8b6:	cc91                	beqz	s1,8d2 <vprintf+0x256>
        for(; *s; s++)
 8b8:	0004c583          	lbu	a1,0(s1)
 8bc:	c195                	beqz	a1,8e0 <vprintf+0x264>
          putc(fd, *s);
 8be:	855a                	mv	a0,s6
 8c0:	d07ff0ef          	jal	5c6 <putc>
        for(; *s; s++)
 8c4:	0485                	addi	s1,s1,1
 8c6:	0004c583          	lbu	a1,0(s1)
 8ca:	f9f5                	bnez	a1,8be <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8cc:	8bce                	mv	s7,s3
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	bbdd                	j	6c6 <vprintf+0x4a>
          s = "(null)";
 8d2:	00000497          	auipc	s1,0x0
 8d6:	26e48493          	addi	s1,s1,622 # b40 <malloc+0x15e>
        for(; *s; s++)
 8da:	02800593          	li	a1,40
 8de:	b7c5                	j	8be <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8e0:	8bce                	mv	s7,s3
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b3cd                	j	6c6 <vprintf+0x4a>
 8e6:	6906                	ld	s2,64(sp)
 8e8:	79e2                	ld	s3,56(sp)
 8ea:	7a42                	ld	s4,48(sp)
 8ec:	7aa2                	ld	s5,40(sp)
 8ee:	7b02                	ld	s6,32(sp)
 8f0:	6be2                	ld	s7,24(sp)
 8f2:	6c42                	ld	s8,16(sp)
 8f4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8f6:	60e6                	ld	ra,88(sp)
 8f8:	6446                	ld	s0,80(sp)
 8fa:	64a6                	ld	s1,72(sp)
 8fc:	6125                	addi	sp,sp,96
 8fe:	8082                	ret

0000000000000900 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 900:	715d                	addi	sp,sp,-80
 902:	ec06                	sd	ra,24(sp)
 904:	e822                	sd	s0,16(sp)
 906:	1000                	addi	s0,sp,32
 908:	e010                	sd	a2,0(s0)
 90a:	e414                	sd	a3,8(s0)
 90c:	e818                	sd	a4,16(s0)
 90e:	ec1c                	sd	a5,24(s0)
 910:	03043023          	sd	a6,32(s0)
 914:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	8622                	mv	a2,s0
 91a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 91e:	d5fff0ef          	jal	67c <vprintf>
}
 922:	60e2                	ld	ra,24(sp)
 924:	6442                	ld	s0,16(sp)
 926:	6161                	addi	sp,sp,80
 928:	8082                	ret

000000000000092a <printf>:

void
printf(const char *fmt, ...)
{
 92a:	711d                	addi	sp,sp,-96
 92c:	ec06                	sd	ra,24(sp)
 92e:	e822                	sd	s0,16(sp)
 930:	1000                	addi	s0,sp,32
 932:	e40c                	sd	a1,8(s0)
 934:	e810                	sd	a2,16(s0)
 936:	ec14                	sd	a3,24(s0)
 938:	f018                	sd	a4,32(s0)
 93a:	f41c                	sd	a5,40(s0)
 93c:	03043823          	sd	a6,48(s0)
 940:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 944:	00840613          	addi	a2,s0,8
 948:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 94c:	85aa                	mv	a1,a0
 94e:	4505                	li	a0,1
 950:	d2dff0ef          	jal	67c <vprintf>
}
 954:	60e2                	ld	ra,24(sp)
 956:	6442                	ld	s0,16(sp)
 958:	6125                	addi	sp,sp,96
 95a:	8082                	ret

000000000000095c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95c:	1141                	addi	sp,sp,-16
 95e:	e406                	sd	ra,8(sp)
 960:	e022                	sd	s0,0(sp)
 962:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 964:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	00000797          	auipc	a5,0x0
 96c:	6987b783          	ld	a5,1688(a5) # 1000 <freep>
 970:	a02d                	j	99a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 972:	4618                	lw	a4,8(a2)
 974:	9f2d                	addw	a4,a4,a1
 976:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	6398                	ld	a4,0(a5)
 97c:	6310                	ld	a2,0(a4)
 97e:	a83d                	j	9bc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 980:	ff852703          	lw	a4,-8(a0)
 984:	9f31                	addw	a4,a4,a2
 986:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 988:	ff053683          	ld	a3,-16(a0)
 98c:	a091                	j	9d0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98e:	6398                	ld	a4,0(a5)
 990:	00e7e463          	bltu	a5,a4,998 <free+0x3c>
 994:	00e6ea63          	bltu	a3,a4,9a8 <free+0x4c>
{
 998:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99a:	fed7fae3          	bgeu	a5,a3,98e <free+0x32>
 99e:	6398                	ld	a4,0(a5)
 9a0:	00e6e463          	bltu	a3,a4,9a8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	fee7eae3          	bltu	a5,a4,998 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9a8:	ff852583          	lw	a1,-8(a0)
 9ac:	6390                	ld	a2,0(a5)
 9ae:	02059813          	slli	a6,a1,0x20
 9b2:	01c85713          	srli	a4,a6,0x1c
 9b6:	9736                	add	a4,a4,a3
 9b8:	fae60de3          	beq	a2,a4,972 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c0:	4790                	lw	a2,8(a5)
 9c2:	02061593          	slli	a1,a2,0x20
 9c6:	01c5d713          	srli	a4,a1,0x1c
 9ca:	973e                	add	a4,a4,a5
 9cc:	fae68ae3          	beq	a3,a4,980 <free+0x24>
    p->s.ptr = bp->s.ptr;
 9d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d2:	00000717          	auipc	a4,0x0
 9d6:	62f73723          	sd	a5,1582(a4) # 1000 <freep>
}
 9da:	60a2                	ld	ra,8(sp)
 9dc:	6402                	ld	s0,0(sp)
 9de:	0141                	addi	sp,sp,16
 9e0:	8082                	ret

00000000000009e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e2:	7139                	addi	sp,sp,-64
 9e4:	fc06                	sd	ra,56(sp)
 9e6:	f822                	sd	s0,48(sp)
 9e8:	f04a                	sd	s2,32(sp)
 9ea:	ec4e                	sd	s3,24(sp)
 9ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ee:	02051993          	slli	s3,a0,0x20
 9f2:	0209d993          	srli	s3,s3,0x20
 9f6:	09bd                	addi	s3,s3,15
 9f8:	0049d993          	srli	s3,s3,0x4
 9fc:	2985                	addiw	s3,s3,1
 9fe:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a00:	00000517          	auipc	a0,0x0
 a04:	60053503          	ld	a0,1536(a0) # 1000 <freep>
 a08:	c905                	beqz	a0,a38 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	09377663          	bgeu	a4,s3,a9a <malloc+0xb8>
 a12:	f426                	sd	s1,40(sp)
 a14:	e852                	sd	s4,16(sp)
 a16:	e456                	sd	s5,8(sp)
 a18:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a1a:	8a4e                	mv	s4,s3
 a1c:	6705                	lui	a4,0x1
 a1e:	00e9f363          	bgeu	s3,a4,a24 <malloc+0x42>
 a22:	6a05                	lui	s4,0x1
 a24:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a28:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a2c:	00000497          	auipc	s1,0x0
 a30:	5d448493          	addi	s1,s1,1492 # 1000 <freep>
  if(p == (char*)-1)
 a34:	5afd                	li	s5,-1
 a36:	a83d                	j	a74 <malloc+0x92>
 a38:	f426                	sd	s1,40(sp)
 a3a:	e852                	sd	s4,16(sp)
 a3c:	e456                	sd	s5,8(sp)
 a3e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a40:	00000797          	auipc	a5,0x0
 a44:	5e078793          	addi	a5,a5,1504 # 1020 <base>
 a48:	00000717          	auipc	a4,0x0
 a4c:	5af73c23          	sd	a5,1464(a4) # 1000 <freep>
 a50:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a52:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a56:	b7d1                	j	a1a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a58:	6398                	ld	a4,0(a5)
 a5a:	e118                	sd	a4,0(a0)
 a5c:	a899                	j	ab2 <malloc+0xd0>
  hp->s.size = nu;
 a5e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a62:	0541                	addi	a0,a0,16
 a64:	ef9ff0ef          	jal	95c <free>
  return freep;
 a68:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a6a:	c125                	beqz	a0,aca <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6e:	4798                	lw	a4,8(a5)
 a70:	03277163          	bgeu	a4,s2,a92 <malloc+0xb0>
    if(p == freep)
 a74:	6098                	ld	a4,0(s1)
 a76:	853e                	mv	a0,a5
 a78:	fef71ae3          	bne	a4,a5,a6c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a7c:	8552                	mv	a0,s4
 a7e:	b31ff0ef          	jal	5ae <sbrk>
  if(p == (char*)-1)
 a82:	fd551ee3          	bne	a0,s5,a5e <malloc+0x7c>
        return 0;
 a86:	4501                	li	a0,0
 a88:	74a2                	ld	s1,40(sp)
 a8a:	6a42                	ld	s4,16(sp)
 a8c:	6aa2                	ld	s5,8(sp)
 a8e:	6b02                	ld	s6,0(sp)
 a90:	a03d                	j	abe <malloc+0xdc>
 a92:	74a2                	ld	s1,40(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a9a:	fae90fe3          	beq	s2,a4,a58 <malloc+0x76>
        p->s.size -= nunits;
 a9e:	4137073b          	subw	a4,a4,s3
 aa2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aa4:	02071693          	slli	a3,a4,0x20
 aa8:	01c6d713          	srli	a4,a3,0x1c
 aac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ab2:	00000717          	auipc	a4,0x0
 ab6:	54a73723          	sd	a0,1358(a4) # 1000 <freep>
      return (void*)(p + 1);
 aba:	01078513          	addi	a0,a5,16
  }
}
 abe:	70e2                	ld	ra,56(sp)
 ac0:	7442                	ld	s0,48(sp)
 ac2:	7902                	ld	s2,32(sp)
 ac4:	69e2                	ld	s3,24(sp)
 ac6:	6121                	addi	sp,sp,64
 ac8:	8082                	ret
 aca:	74a2                	ld	s1,40(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
 ad2:	b7f5                	j	abe <malloc+0xdc>
