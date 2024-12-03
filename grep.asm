
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
  }
}

int
main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	push   -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	57                   	push   %edi
    100e:	56                   	push   %esi
    100f:	53                   	push   %ebx
    1010:	51                   	push   %ecx
    1011:	83 ec 18             	sub    $0x18,%esp
    1014:	8b 01                	mov    (%ecx),%eax
    1016:	8b 59 04             	mov    0x4(%ecx),%ebx
    1019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
    101c:	83 f8 01             	cmp    $0x1,%eax
    101f:	7e 6f                	jle    1090 <main+0x90>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
    1021:	8b 43 04             	mov    0x4(%ebx),%eax
    1024:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
    1027:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    102b:	be 02 00 00 00       	mov    $0x2,%esi
  pattern = argv[1];
    1030:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(argc <= 2){
    1033:	75 2d                	jne    1062 <main+0x62>
    1035:	eb 6c                	jmp    10a3 <main+0xa3>
    1037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    103e:	66 90                	xchg   %ax,%ax
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
    1040:	83 ec 08             	sub    $0x8,%esp
  for(i = 2; i < argc; i++){
    1043:	83 c6 01             	add    $0x1,%esi
    1046:	83 c3 04             	add    $0x4,%ebx
    grep(pattern, fd);
    1049:	50                   	push   %eax
    104a:	ff 75 e0             	push   -0x20(%ebp)
    104d:	e8 7e 01 00 00       	call   11d0 <grep>
    close(fd);
    1052:	89 3c 24             	mov    %edi,(%esp)
    1055:	e8 91 05 00 00       	call   15eb <close>
  for(i = 2; i < argc; i++){
    105a:	83 c4 10             	add    $0x10,%esp
    105d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
    1060:	7e 29                	jle    108b <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
    1062:	83 ec 08             	sub    $0x8,%esp
    1065:	6a 00                	push   $0x0
    1067:	ff 33                	push   (%ebx)
    1069:	e8 95 05 00 00       	call   1603 <open>
    106e:	83 c4 10             	add    $0x10,%esp
    1071:	89 c7                	mov    %eax,%edi
    1073:	85 c0                	test   %eax,%eax
    1075:	79 c9                	jns    1040 <main+0x40>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1077:	50                   	push   %eax
    1078:	ff 33                	push   (%ebx)
    107a:	68 b4 1a 00 00       	push   $0x1ab4
    107f:	6a 01                	push   $0x1
    1081:	e8 aa 06 00 00       	call   1730 <printf>
      exit();
    1086:	e8 38 05 00 00       	call   15c3 <exit>
  }
  exit();
    108b:	e8 33 05 00 00       	call   15c3 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
    1090:	51                   	push   %ecx
    1091:	51                   	push   %ecx
    1092:	68 94 1a 00 00       	push   $0x1a94
    1097:	6a 02                	push   $0x2
    1099:	e8 92 06 00 00       	call   1730 <printf>
    exit();
    109e:	e8 20 05 00 00       	call   15c3 <exit>
    grep(pattern, 0);
    10a3:	52                   	push   %edx
    10a4:	52                   	push   %edx
    10a5:	6a 00                	push   $0x0
    10a7:	50                   	push   %eax
    10a8:	e8 23 01 00 00       	call   11d0 <grep>
    exit();
    10ad:	e8 11 05 00 00       	call   15c3 <exit>
    10b2:	66 90                	xchg   %ax,%ax
    10b4:	66 90                	xchg   %ax,%ax
    10b6:	66 90                	xchg   %ax,%ax
    10b8:	66 90                	xchg   %ax,%ax
    10ba:	66 90                	xchg   %ax,%ax
    10bc:	66 90                	xchg   %ax,%ax
    10be:	66 90                	xchg   %ax,%ax

000010c0 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	57                   	push   %edi
    10c4:	56                   	push   %esi
    10c5:	53                   	push   %ebx
    10c6:	83 ec 0c             	sub    $0xc,%esp
    10c9:	8b 75 08             	mov    0x8(%ebp),%esi
    10cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(re[0] == '\0')
    10cf:	0f b6 06             	movzbl (%esi),%eax
    10d2:	84 c0                	test   %al,%al
    10d4:	75 2d                	jne    1103 <matchhere+0x43>
    10d6:	e9 7d 00 00 00       	jmp    1158 <matchhere+0x98>
    10db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10df:	90                   	nop
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
    10e0:	0f b6 0f             	movzbl (%edi),%ecx
  if(re[0] == '$' && re[1] == '\0')
    10e3:	80 fb 24             	cmp    $0x24,%bl
    10e6:	75 04                	jne    10ec <matchhere+0x2c>
    10e8:	84 c0                	test   %al,%al
    10ea:	74 79                	je     1165 <matchhere+0xa5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    10ec:	84 c9                	test   %cl,%cl
    10ee:	74 58                	je     1148 <matchhere+0x88>
    10f0:	38 d9                	cmp    %bl,%cl
    10f2:	74 05                	je     10f9 <matchhere+0x39>
    10f4:	80 fb 2e             	cmp    $0x2e,%bl
    10f7:	75 4f                	jne    1148 <matchhere+0x88>
    return matchhere(re+1, text+1);
    10f9:	83 c7 01             	add    $0x1,%edi
    10fc:	83 c6 01             	add    $0x1,%esi
  if(re[0] == '\0')
    10ff:	84 c0                	test   %al,%al
    1101:	74 55                	je     1158 <matchhere+0x98>
  if(re[1] == '*')
    1103:	0f be d8             	movsbl %al,%ebx
    1106:	0f b6 46 01          	movzbl 0x1(%esi),%eax
    110a:	3c 2a                	cmp    $0x2a,%al
    110c:	75 d2                	jne    10e0 <matchhere+0x20>
    return matchstar(re[0], re+2, text);
    110e:	83 c6 02             	add    $0x2,%esi
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
    1111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    1118:	83 ec 08             	sub    $0x8,%esp
    111b:	57                   	push   %edi
    111c:	56                   	push   %esi
    111d:	e8 9e ff ff ff       	call   10c0 <matchhere>
    1122:	83 c4 10             	add    $0x10,%esp
    1125:	85 c0                	test   %eax,%eax
    1127:	75 2f                	jne    1158 <matchhere+0x98>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
    1129:	0f be 17             	movsbl (%edi),%edx
    112c:	84 d2                	test   %dl,%dl
    112e:	74 0c                	je     113c <matchhere+0x7c>
    1130:	83 c7 01             	add    $0x1,%edi
    1133:	83 fb 2e             	cmp    $0x2e,%ebx
    1136:	74 e0                	je     1118 <matchhere+0x58>
    1138:	39 da                	cmp    %ebx,%edx
    113a:	74 dc                	je     1118 <matchhere+0x58>
}
    113c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    113f:	5b                   	pop    %ebx
    1140:	5e                   	pop    %esi
    1141:	5f                   	pop    %edi
    1142:	5d                   	pop    %ebp
    1143:	c3                   	ret    
    1144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
    114b:	31 c0                	xor    %eax,%eax
}
    114d:	5b                   	pop    %ebx
    114e:	5e                   	pop    %esi
    114f:	5f                   	pop    %edi
    1150:	5d                   	pop    %ebp
    1151:	c3                   	ret    
    1152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1158:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 1;
    115b:	b8 01 00 00 00       	mov    $0x1,%eax
}
    1160:	5b                   	pop    %ebx
    1161:	5e                   	pop    %esi
    1162:	5f                   	pop    %edi
    1163:	5d                   	pop    %ebp
    1164:	c3                   	ret    
    return *text == '\0';
    1165:	31 c0                	xor    %eax,%eax
    1167:	84 c9                	test   %cl,%cl
    1169:	0f 94 c0             	sete   %al
    116c:	eb ce                	jmp    113c <matchhere+0x7c>
    116e:	66 90                	xchg   %ax,%ax

00001170 <match>:
{
    1170:	55                   	push   %ebp
    1171:	89 e5                	mov    %esp,%ebp
    1173:	56                   	push   %esi
    1174:	53                   	push   %ebx
    1175:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1178:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
    117b:	80 3b 5e             	cmpb   $0x5e,(%ebx)
    117e:	75 11                	jne    1191 <match+0x21>
    1180:	eb 2e                	jmp    11b0 <match+0x40>
    1182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
    1188:	83 c6 01             	add    $0x1,%esi
    118b:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
    118f:	74 16                	je     11a7 <match+0x37>
    if(matchhere(re, text))
    1191:	83 ec 08             	sub    $0x8,%esp
    1194:	56                   	push   %esi
    1195:	53                   	push   %ebx
    1196:	e8 25 ff ff ff       	call   10c0 <matchhere>
    119b:	83 c4 10             	add    $0x10,%esp
    119e:	85 c0                	test   %eax,%eax
    11a0:	74 e6                	je     1188 <match+0x18>
      return 1;
    11a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
    11a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11aa:	5b                   	pop    %ebx
    11ab:	5e                   	pop    %esi
    11ac:	5d                   	pop    %ebp
    11ad:	c3                   	ret    
    11ae:	66 90                	xchg   %ax,%ax
    return matchhere(re+1, text);
    11b0:	83 c3 01             	add    $0x1,%ebx
    11b3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    11b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11b9:	5b                   	pop    %ebx
    11ba:	5e                   	pop    %esi
    11bb:	5d                   	pop    %ebp
    return matchhere(re+1, text);
    11bc:	e9 ff fe ff ff       	jmp    10c0 <matchhere>
    11c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11cf:	90                   	nop

000011d0 <grep>:
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	57                   	push   %edi
    11d4:	56                   	push   %esi
    11d5:	53                   	push   %ebx
    11d6:	83 ec 1c             	sub    $0x1c,%esp
    11d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
    11dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    return matchhere(re+1, text);
    11e3:	8d 47 01             	lea    0x1(%edi),%eax
    11e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    11e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    11f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    11f3:	b8 ff 03 00 00       	mov    $0x3ff,%eax
    11f8:	83 ec 04             	sub    $0x4,%esp
    11fb:	29 c8                	sub    %ecx,%eax
    11fd:	50                   	push   %eax
    11fe:	8d 81 20 1f 00 00    	lea    0x1f20(%ecx),%eax
    1204:	50                   	push   %eax
    1205:	ff 75 0c             	push   0xc(%ebp)
    1208:	e8 ce 03 00 00       	call   15db <read>
    120d:	83 c4 10             	add    $0x10,%esp
    1210:	85 c0                	test   %eax,%eax
    1212:	0f 8e e5 00 00 00    	jle    12fd <grep+0x12d>
    m += n;
    1218:	01 45 dc             	add    %eax,-0x24(%ebp)
    121b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    p = buf;
    121e:	c7 45 e4 20 1f 00 00 	movl   $0x1f20,-0x1c(%ebp)
    buf[m] = '\0';
    1225:	c6 81 20 1f 00 00 00 	movb   $0x0,0x1f20(%ecx)
    while((q = strchr(p, '\n')) != 0){
    122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1230:	83 ec 08             	sub    $0x8,%esp
    1233:	6a 0a                	push   $0xa
    1235:	ff 75 e4             	push   -0x1c(%ebp)
    1238:	e8 13 02 00 00       	call   1450 <strchr>
    123d:	83 c4 10             	add    $0x10,%esp
    1240:	89 c3                	mov    %eax,%ebx
    1242:	85 c0                	test   %eax,%eax
    1244:	74 72                	je     12b8 <grep+0xe8>
      *q = 0;
    1246:	c6 03 00             	movb   $0x0,(%ebx)
        write(1, p, q+1 - p);
    1249:	8d 43 01             	lea    0x1(%ebx),%eax
  if(re[0] == '^')
    124c:	80 3f 5e             	cmpb   $0x5e,(%edi)
        write(1, p, q+1 - p);
    124f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1252:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  if(re[0] == '^')
    1255:	75 12                	jne    1269 <grep+0x99>
    1257:	eb 47                	jmp    12a0 <grep+0xd0>
    1259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }while(*text++ != '\0');
    1260:	83 c6 01             	add    $0x1,%esi
    1263:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
    1267:	74 2b                	je     1294 <grep+0xc4>
    if(matchhere(re, text))
    1269:	83 ec 08             	sub    $0x8,%esp
    126c:	56                   	push   %esi
    126d:	57                   	push   %edi
    126e:	e8 4d fe ff ff       	call   10c0 <matchhere>
    1273:	83 c4 10             	add    $0x10,%esp
    1276:	85 c0                	test   %eax,%eax
    1278:	74 e6                	je     1260 <grep+0x90>
        write(1, p, q+1 - p);
    127a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    127d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1280:	83 ec 04             	sub    $0x4,%esp
        *q = '\n';
    1283:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
    1286:	29 d0                	sub    %edx,%eax
    1288:	50                   	push   %eax
    1289:	52                   	push   %edx
    128a:	6a 01                	push   $0x1
    128c:	e8 52 03 00 00       	call   15e3 <write>
    1291:	83 c4 10             	add    $0x10,%esp
      p = q+1;
    1294:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    129a:	eb 94                	jmp    1230 <grep+0x60>
    129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return matchhere(re+1, text);
    12a0:	83 ec 08             	sub    $0x8,%esp
    12a3:	56                   	push   %esi
    12a4:	ff 75 d8             	push   -0x28(%ebp)
    12a7:	e8 14 fe ff ff       	call   10c0 <matchhere>
    12ac:	83 c4 10             	add    $0x10,%esp
      if(match(pattern, p)){
    12af:	85 c0                	test   %eax,%eax
    12b1:	74 e1                	je     1294 <grep+0xc4>
    12b3:	eb c5                	jmp    127a <grep+0xaa>
    12b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(p == buf)
    12b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    12bb:	81 fa 20 1f 00 00    	cmp    $0x1f20,%edx
    12c1:	74 2e                	je     12f1 <grep+0x121>
    if(m > 0){
    12c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    12c6:	85 c9                	test   %ecx,%ecx
    12c8:	0f 8e 22 ff ff ff    	jle    11f0 <grep+0x20>
      m -= p - buf;
    12ce:	89 d0                	mov    %edx,%eax
      memmove(buf, p, m);
    12d0:	83 ec 04             	sub    $0x4,%esp
      m -= p - buf;
    12d3:	2d 20 1f 00 00       	sub    $0x1f20,%eax
    12d8:	29 c1                	sub    %eax,%ecx
      memmove(buf, p, m);
    12da:	51                   	push   %ecx
    12db:	52                   	push   %edx
    12dc:	68 20 1f 00 00       	push   $0x1f20
      m -= p - buf;
    12e1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      memmove(buf, p, m);
    12e4:	e8 a7 02 00 00       	call   1590 <memmove>
    12e9:	83 c4 10             	add    $0x10,%esp
    12ec:	e9 ff fe ff ff       	jmp    11f0 <grep+0x20>
      m = 0;
    12f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    12f8:	e9 f3 fe ff ff       	jmp    11f0 <grep+0x20>
}
    12fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1300:	5b                   	pop    %ebx
    1301:	5e                   	pop    %esi
    1302:	5f                   	pop    %edi
    1303:	5d                   	pop    %ebp
    1304:	c3                   	ret    
    1305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001310 <matchstar>:
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	57                   	push   %edi
    1314:	56                   	push   %esi
    1315:	53                   	push   %ebx
    1316:	83 ec 0c             	sub    $0xc,%esp
    1319:	8b 5d 08             	mov    0x8(%ebp),%ebx
    131c:	8b 75 0c             	mov    0xc(%ebp),%esi
    131f:	8b 7d 10             	mov    0x10(%ebp),%edi
    1322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(matchhere(re, text))
    1328:	83 ec 08             	sub    $0x8,%esp
    132b:	57                   	push   %edi
    132c:	56                   	push   %esi
    132d:	e8 8e fd ff ff       	call   10c0 <matchhere>
    1332:	83 c4 10             	add    $0x10,%esp
    1335:	85 c0                	test   %eax,%eax
    1337:	75 1f                	jne    1358 <matchstar+0x48>
  }while(*text!='\0' && (*text++==c || c=='.'));
    1339:	0f be 17             	movsbl (%edi),%edx
    133c:	84 d2                	test   %dl,%dl
    133e:	74 0c                	je     134c <matchstar+0x3c>
    1340:	83 c7 01             	add    $0x1,%edi
    1343:	39 da                	cmp    %ebx,%edx
    1345:	74 e1                	je     1328 <matchstar+0x18>
    1347:	83 fb 2e             	cmp    $0x2e,%ebx
    134a:	74 dc                	je     1328 <matchstar+0x18>
}
    134c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    134f:	5b                   	pop    %ebx
    1350:	5e                   	pop    %esi
    1351:	5f                   	pop    %edi
    1352:	5d                   	pop    %ebp
    1353:	c3                   	ret    
    1354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1358:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 1;
    135b:	b8 01 00 00 00       	mov    $0x1,%eax
}
    1360:	5b                   	pop    %ebx
    1361:	5e                   	pop    %esi
    1362:	5f                   	pop    %edi
    1363:	5d                   	pop    %ebp
    1364:	c3                   	ret    
    1365:	66 90                	xchg   %ax,%ax
    1367:	66 90                	xchg   %ax,%ax
    1369:	66 90                	xchg   %ax,%ax
    136b:	66 90                	xchg   %ax,%ax
    136d:	66 90                	xchg   %ax,%ax
    136f:	90                   	nop

00001370 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1370:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1371:	31 c0                	xor    %eax,%eax
{
    1373:	89 e5                	mov    %esp,%ebp
    1375:	53                   	push   %ebx
    1376:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1379:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    1380:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1384:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1387:	83 c0 01             	add    $0x1,%eax
    138a:	84 d2                	test   %dl,%dl
    138c:	75 f2                	jne    1380 <strcpy+0x10>
    ;
  return os;
}
    138e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1391:	89 c8                	mov    %ecx,%eax
    1393:	c9                   	leave  
    1394:	c3                   	ret    
    1395:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000013a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13a0:	55                   	push   %ebp
    13a1:	89 e5                	mov    %esp,%ebp
    13a3:	53                   	push   %ebx
    13a4:	8b 55 08             	mov    0x8(%ebp),%edx
    13a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    13aa:	0f b6 02             	movzbl (%edx),%eax
    13ad:	84 c0                	test   %al,%al
    13af:	75 17                	jne    13c8 <strcmp+0x28>
    13b1:	eb 3a                	jmp    13ed <strcmp+0x4d>
    13b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    13b7:	90                   	nop
    13b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    13bc:	83 c2 01             	add    $0x1,%edx
    13bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    13c2:	84 c0                	test   %al,%al
    13c4:	74 1a                	je     13e0 <strcmp+0x40>
    p++, q++;
    13c6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
    13c8:	0f b6 19             	movzbl (%ecx),%ebx
    13cb:	38 c3                	cmp    %al,%bl
    13cd:	74 e9                	je     13b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    13cf:	29 d8                	sub    %ebx,%eax
}
    13d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13d4:	c9                   	leave  
    13d5:	c3                   	ret    
    13d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
    13e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    13e4:	31 c0                	xor    %eax,%eax
    13e6:	29 d8                	sub    %ebx,%eax
}
    13e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13eb:	c9                   	leave  
    13ec:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
    13ed:	0f b6 19             	movzbl (%ecx),%ebx
    13f0:	31 c0                	xor    %eax,%eax
    13f2:	eb db                	jmp    13cf <strcmp+0x2f>
    13f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    13ff:	90                   	nop

00001400 <strlen>:

uint
strlen(char *s)
{
    1400:	55                   	push   %ebp
    1401:	89 e5                	mov    %esp,%ebp
    1403:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1406:	80 3a 00             	cmpb   $0x0,(%edx)
    1409:	74 15                	je     1420 <strlen+0x20>
    140b:	31 c0                	xor    %eax,%eax
    140d:	8d 76 00             	lea    0x0(%esi),%esi
    1410:	83 c0 01             	add    $0x1,%eax
    1413:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    1417:	89 c1                	mov    %eax,%ecx
    1419:	75 f5                	jne    1410 <strlen+0x10>
    ;
  return n;
}
    141b:	89 c8                	mov    %ecx,%eax
    141d:	5d                   	pop    %ebp
    141e:	c3                   	ret    
    141f:	90                   	nop
  for(n = 0; s[n]; n++)
    1420:	31 c9                	xor    %ecx,%ecx
}
    1422:	5d                   	pop    %ebp
    1423:	89 c8                	mov    %ecx,%eax
    1425:	c3                   	ret    
    1426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    142d:	8d 76 00             	lea    0x0(%esi),%esi

00001430 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	57                   	push   %edi
    1434:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1437:	8b 4d 10             	mov    0x10(%ebp),%ecx
    143a:	8b 45 0c             	mov    0xc(%ebp),%eax
    143d:	89 d7                	mov    %edx,%edi
    143f:	fc                   	cld    
    1440:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1442:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1445:	89 d0                	mov    %edx,%eax
    1447:	c9                   	leave  
    1448:	c3                   	ret    
    1449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001450 <strchr>:

char*
strchr(const char *s, char c)
{
    1450:	55                   	push   %ebp
    1451:	89 e5                	mov    %esp,%ebp
    1453:	8b 45 08             	mov    0x8(%ebp),%eax
    1456:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    145a:	0f b6 10             	movzbl (%eax),%edx
    145d:	84 d2                	test   %dl,%dl
    145f:	75 12                	jne    1473 <strchr+0x23>
    1461:	eb 1d                	jmp    1480 <strchr+0x30>
    1463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1467:	90                   	nop
    1468:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    146c:	83 c0 01             	add    $0x1,%eax
    146f:	84 d2                	test   %dl,%dl
    1471:	74 0d                	je     1480 <strchr+0x30>
    if(*s == c)
    1473:	38 d1                	cmp    %dl,%cl
    1475:	75 f1                	jne    1468 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1477:	5d                   	pop    %ebp
    1478:	c3                   	ret    
    1479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1480:	31 c0                	xor    %eax,%eax
}
    1482:	5d                   	pop    %ebp
    1483:	c3                   	ret    
    1484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    148f:	90                   	nop

00001490 <gets>:

char*
gets(char *buf, int max)
{
    1490:	55                   	push   %ebp
    1491:	89 e5                	mov    %esp,%ebp
    1493:	57                   	push   %edi
    1494:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1495:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1498:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1499:	31 db                	xor    %ebx,%ebx
{
    149b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    149e:	eb 27                	jmp    14c7 <gets+0x37>
    cc = read(0, &c, 1);
    14a0:	83 ec 04             	sub    $0x4,%esp
    14a3:	6a 01                	push   $0x1
    14a5:	57                   	push   %edi
    14a6:	6a 00                	push   $0x0
    14a8:	e8 2e 01 00 00       	call   15db <read>
    if(cc < 1)
    14ad:	83 c4 10             	add    $0x10,%esp
    14b0:	85 c0                	test   %eax,%eax
    14b2:	7e 1d                	jle    14d1 <gets+0x41>
      break;
    buf[i++] = c;
    14b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    14b8:	8b 55 08             	mov    0x8(%ebp),%edx
    14bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    14bf:	3c 0a                	cmp    $0xa,%al
    14c1:	74 1d                	je     14e0 <gets+0x50>
    14c3:	3c 0d                	cmp    $0xd,%al
    14c5:	74 19                	je     14e0 <gets+0x50>
  for(i=0; i+1 < max; ){
    14c7:	89 de                	mov    %ebx,%esi
    14c9:	83 c3 01             	add    $0x1,%ebx
    14cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    14cf:	7c cf                	jl     14a0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    14d1:	8b 45 08             	mov    0x8(%ebp),%eax
    14d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    14d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14db:	5b                   	pop    %ebx
    14dc:	5e                   	pop    %esi
    14dd:	5f                   	pop    %edi
    14de:	5d                   	pop    %ebp
    14df:	c3                   	ret    
  buf[i] = '\0';
    14e0:	8b 45 08             	mov    0x8(%ebp),%eax
    14e3:	89 de                	mov    %ebx,%esi
    14e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    14e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14ec:	5b                   	pop    %ebx
    14ed:	5e                   	pop    %esi
    14ee:	5f                   	pop    %edi
    14ef:	5d                   	pop    %ebp
    14f0:	c3                   	ret    
    14f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14ff:	90                   	nop

00001500 <stat>:

int
stat(char *n, struct stat *st)
{
    1500:	55                   	push   %ebp
    1501:	89 e5                	mov    %esp,%ebp
    1503:	56                   	push   %esi
    1504:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1505:	83 ec 08             	sub    $0x8,%esp
    1508:	6a 00                	push   $0x0
    150a:	ff 75 08             	push   0x8(%ebp)
    150d:	e8 f1 00 00 00       	call   1603 <open>
  if(fd < 0)
    1512:	83 c4 10             	add    $0x10,%esp
    1515:	85 c0                	test   %eax,%eax
    1517:	78 27                	js     1540 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1519:	83 ec 08             	sub    $0x8,%esp
    151c:	ff 75 0c             	push   0xc(%ebp)
    151f:	89 c3                	mov    %eax,%ebx
    1521:	50                   	push   %eax
    1522:	e8 f4 00 00 00       	call   161b <fstat>
  close(fd);
    1527:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    152a:	89 c6                	mov    %eax,%esi
  close(fd);
    152c:	e8 ba 00 00 00       	call   15eb <close>
  return r;
    1531:	83 c4 10             	add    $0x10,%esp
}
    1534:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1537:	89 f0                	mov    %esi,%eax
    1539:	5b                   	pop    %ebx
    153a:	5e                   	pop    %esi
    153b:	5d                   	pop    %ebp
    153c:	c3                   	ret    
    153d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1540:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1545:	eb ed                	jmp    1534 <stat+0x34>
    1547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    154e:	66 90                	xchg   %ax,%ax

00001550 <atoi>:

int
atoi(const char *s)
{
    1550:	55                   	push   %ebp
    1551:	89 e5                	mov    %esp,%ebp
    1553:	53                   	push   %ebx
    1554:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1557:	0f be 02             	movsbl (%edx),%eax
    155a:	8d 48 d0             	lea    -0x30(%eax),%ecx
    155d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1560:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1565:	77 1e                	ja     1585 <atoi+0x35>
    1567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    156e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1570:	83 c2 01             	add    $0x1,%edx
    1573:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1576:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    157a:	0f be 02             	movsbl (%edx),%eax
    157d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1580:	80 fb 09             	cmp    $0x9,%bl
    1583:	76 eb                	jbe    1570 <atoi+0x20>
  return n;
}
    1585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1588:	89 c8                	mov    %ecx,%eax
    158a:	c9                   	leave  
    158b:	c3                   	ret    
    158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001590 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1590:	55                   	push   %ebp
    1591:	89 e5                	mov    %esp,%ebp
    1593:	57                   	push   %edi
    1594:	8b 45 10             	mov    0x10(%ebp),%eax
    1597:	8b 55 08             	mov    0x8(%ebp),%edx
    159a:	56                   	push   %esi
    159b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    159e:	85 c0                	test   %eax,%eax
    15a0:	7e 13                	jle    15b5 <memmove+0x25>
    15a2:	01 d0                	add    %edx,%eax
  dst = vdst;
    15a4:	89 d7                	mov    %edx,%edi
    15a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    15b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    15b1:	39 f8                	cmp    %edi,%eax
    15b3:	75 fb                	jne    15b0 <memmove+0x20>
  return vdst;
}
    15b5:	5e                   	pop    %esi
    15b6:	89 d0                	mov    %edx,%eax
    15b8:	5f                   	pop    %edi
    15b9:	5d                   	pop    %ebp
    15ba:	c3                   	ret    

000015bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15bb:	b8 01 00 00 00       	mov    $0x1,%eax
    15c0:	cd 40                	int    $0x40
    15c2:	c3                   	ret    

000015c3 <exit>:
SYSCALL(exit)
    15c3:	b8 02 00 00 00       	mov    $0x2,%eax
    15c8:	cd 40                	int    $0x40
    15ca:	c3                   	ret    

000015cb <wait>:
SYSCALL(wait)
    15cb:	b8 03 00 00 00       	mov    $0x3,%eax
    15d0:	cd 40                	int    $0x40
    15d2:	c3                   	ret    

000015d3 <pipe>:
SYSCALL(pipe)
    15d3:	b8 04 00 00 00       	mov    $0x4,%eax
    15d8:	cd 40                	int    $0x40
    15da:	c3                   	ret    

000015db <read>:
SYSCALL(read)
    15db:	b8 05 00 00 00       	mov    $0x5,%eax
    15e0:	cd 40                	int    $0x40
    15e2:	c3                   	ret    

000015e3 <write>:
SYSCALL(write)
    15e3:	b8 10 00 00 00       	mov    $0x10,%eax
    15e8:	cd 40                	int    $0x40
    15ea:	c3                   	ret    

000015eb <close>:
SYSCALL(close)
    15eb:	b8 15 00 00 00       	mov    $0x15,%eax
    15f0:	cd 40                	int    $0x40
    15f2:	c3                   	ret    

000015f3 <kill>:
SYSCALL(kill)
    15f3:	b8 06 00 00 00       	mov    $0x6,%eax
    15f8:	cd 40                	int    $0x40
    15fa:	c3                   	ret    

000015fb <exec>:
SYSCALL(exec)
    15fb:	b8 07 00 00 00       	mov    $0x7,%eax
    1600:	cd 40                	int    $0x40
    1602:	c3                   	ret    

00001603 <open>:
SYSCALL(open)
    1603:	b8 0f 00 00 00       	mov    $0xf,%eax
    1608:	cd 40                	int    $0x40
    160a:	c3                   	ret    

0000160b <mknod>:
SYSCALL(mknod)
    160b:	b8 11 00 00 00       	mov    $0x11,%eax
    1610:	cd 40                	int    $0x40
    1612:	c3                   	ret    

00001613 <unlink>:
SYSCALL(unlink)
    1613:	b8 12 00 00 00       	mov    $0x12,%eax
    1618:	cd 40                	int    $0x40
    161a:	c3                   	ret    

0000161b <fstat>:
SYSCALL(fstat)
    161b:	b8 08 00 00 00       	mov    $0x8,%eax
    1620:	cd 40                	int    $0x40
    1622:	c3                   	ret    

00001623 <link>:
SYSCALL(link)
    1623:	b8 13 00 00 00       	mov    $0x13,%eax
    1628:	cd 40                	int    $0x40
    162a:	c3                   	ret    

0000162b <mkdir>:
SYSCALL(mkdir)
    162b:	b8 14 00 00 00       	mov    $0x14,%eax
    1630:	cd 40                	int    $0x40
    1632:	c3                   	ret    

00001633 <chdir>:
SYSCALL(chdir)
    1633:	b8 09 00 00 00       	mov    $0x9,%eax
    1638:	cd 40                	int    $0x40
    163a:	c3                   	ret    

0000163b <dup>:
SYSCALL(dup)
    163b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1640:	cd 40                	int    $0x40
    1642:	c3                   	ret    

00001643 <getpid>:
SYSCALL(getpid)
    1643:	b8 0b 00 00 00       	mov    $0xb,%eax
    1648:	cd 40                	int    $0x40
    164a:	c3                   	ret    

0000164b <sbrk>:
SYSCALL(sbrk)
    164b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1650:	cd 40                	int    $0x40
    1652:	c3                   	ret    

00001653 <sleep>:
SYSCALL(sleep)
    1653:	b8 0d 00 00 00       	mov    $0xd,%eax
    1658:	cd 40                	int    $0x40
    165a:	c3                   	ret    

0000165b <uptime>:
SYSCALL(uptime)
    165b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1660:	cd 40                	int    $0x40
    1662:	c3                   	ret    

00001663 <shm_open>:
SYSCALL(shm_open)
    1663:	b8 16 00 00 00       	mov    $0x16,%eax
    1668:	cd 40                	int    $0x40
    166a:	c3                   	ret    

0000166b <shm_close>:
SYSCALL(shm_close)	
    166b:	b8 17 00 00 00       	mov    $0x17,%eax
    1670:	cd 40                	int    $0x40
    1672:	c3                   	ret    
    1673:	66 90                	xchg   %ax,%ax
    1675:	66 90                	xchg   %ax,%ax
    1677:	66 90                	xchg   %ax,%ax
    1679:	66 90                	xchg   %ax,%ax
    167b:	66 90                	xchg   %ax,%ax
    167d:	66 90                	xchg   %ax,%ax
    167f:	90                   	nop

00001680 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1680:	55                   	push   %ebp
    1681:	89 e5                	mov    %esp,%ebp
    1683:	57                   	push   %edi
    1684:	56                   	push   %esi
    1685:	53                   	push   %ebx
    1686:	83 ec 3c             	sub    $0x3c,%esp
    1689:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    168c:	89 d1                	mov    %edx,%ecx
{
    168e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1691:	85 d2                	test   %edx,%edx
    1693:	0f 89 7f 00 00 00    	jns    1718 <printint+0x98>
    1699:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    169d:	74 79                	je     1718 <printint+0x98>
    neg = 1;
    169f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    16a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    16a8:	31 db                	xor    %ebx,%ebx
    16aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
    16ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    16b0:	89 c8                	mov    %ecx,%eax
    16b2:	31 d2                	xor    %edx,%edx
    16b4:	89 cf                	mov    %ecx,%edi
    16b6:	f7 75 c4             	divl   -0x3c(%ebp)
    16b9:	0f b6 92 2c 1b 00 00 	movzbl 0x1b2c(%edx),%edx
    16c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    16c3:	89 d8                	mov    %ebx,%eax
    16c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    16c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    16cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    16ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    16d1:	76 dd                	jbe    16b0 <printint+0x30>
  if(neg)
    16d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    16d6:	85 c9                	test   %ecx,%ecx
    16d8:	74 0c                	je     16e6 <printint+0x66>
    buf[i++] = '-';
    16da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    16df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    16e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    16e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    16e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    16ed:	eb 07                	jmp    16f6 <printint+0x76>
    16ef:	90                   	nop
    putc(fd, buf[i]);
    16f0:	0f b6 13             	movzbl (%ebx),%edx
    16f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    16f6:	83 ec 04             	sub    $0x4,%esp
    16f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    16fc:	6a 01                	push   $0x1
    16fe:	56                   	push   %esi
    16ff:	57                   	push   %edi
    1700:	e8 de fe ff ff       	call   15e3 <write>
  while(--i >= 0)
    1705:	83 c4 10             	add    $0x10,%esp
    1708:	39 de                	cmp    %ebx,%esi
    170a:	75 e4                	jne    16f0 <printint+0x70>
}
    170c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    170f:	5b                   	pop    %ebx
    1710:	5e                   	pop    %esi
    1711:	5f                   	pop    %edi
    1712:	5d                   	pop    %ebp
    1713:	c3                   	ret    
    1714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1718:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    171f:	eb 87                	jmp    16a8 <printint+0x28>
    1721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    172f:	90                   	nop

00001730 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1730:	55                   	push   %ebp
    1731:	89 e5                	mov    %esp,%ebp
    1733:	57                   	push   %edi
    1734:	56                   	push   %esi
    1735:	53                   	push   %ebx
    1736:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1739:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    173c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    173f:	0f b6 13             	movzbl (%ebx),%edx
    1742:	84 d2                	test   %dl,%dl
    1744:	74 6a                	je     17b0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    1746:	8d 45 10             	lea    0x10(%ebp),%eax
    1749:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    174c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    174f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    1751:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1754:	eb 36                	jmp    178c <printf+0x5c>
    1756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    175d:	8d 76 00             	lea    0x0(%esi),%esi
    1760:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1763:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    1768:	83 f8 25             	cmp    $0x25,%eax
    176b:	74 15                	je     1782 <printf+0x52>
  write(fd, &c, 1);
    176d:	83 ec 04             	sub    $0x4,%esp
    1770:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1773:	6a 01                	push   $0x1
    1775:	57                   	push   %edi
    1776:	56                   	push   %esi
    1777:	e8 67 fe ff ff       	call   15e3 <write>
    177c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    177f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1782:	0f b6 13             	movzbl (%ebx),%edx
    1785:	83 c3 01             	add    $0x1,%ebx
    1788:	84 d2                	test   %dl,%dl
    178a:	74 24                	je     17b0 <printf+0x80>
    c = fmt[i] & 0xff;
    178c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    178f:	85 c9                	test   %ecx,%ecx
    1791:	74 cd                	je     1760 <printf+0x30>
      }
    } else if(state == '%'){
    1793:	83 f9 25             	cmp    $0x25,%ecx
    1796:	75 ea                	jne    1782 <printf+0x52>
      if(c == 'd'){
    1798:	83 f8 25             	cmp    $0x25,%eax
    179b:	0f 84 07 01 00 00    	je     18a8 <printf+0x178>
    17a1:	83 e8 63             	sub    $0x63,%eax
    17a4:	83 f8 15             	cmp    $0x15,%eax
    17a7:	77 17                	ja     17c0 <printf+0x90>
    17a9:	ff 24 85 d4 1a 00 00 	jmp    *0x1ad4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    17b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    17b3:	5b                   	pop    %ebx
    17b4:	5e                   	pop    %esi
    17b5:	5f                   	pop    %edi
    17b6:	5d                   	pop    %ebp
    17b7:	c3                   	ret    
    17b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    17bf:	90                   	nop
  write(fd, &c, 1);
    17c0:	83 ec 04             	sub    $0x4,%esp
    17c3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    17c6:	6a 01                	push   $0x1
    17c8:	57                   	push   %edi
    17c9:	56                   	push   %esi
    17ca:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    17ce:	e8 10 fe ff ff       	call   15e3 <write>
        putc(fd, c);
    17d3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    17d7:	83 c4 0c             	add    $0xc,%esp
    17da:	88 55 e7             	mov    %dl,-0x19(%ebp)
    17dd:	6a 01                	push   $0x1
    17df:	57                   	push   %edi
    17e0:	56                   	push   %esi
    17e1:	e8 fd fd ff ff       	call   15e3 <write>
        putc(fd, c);
    17e6:	83 c4 10             	add    $0x10,%esp
      state = 0;
    17e9:	31 c9                	xor    %ecx,%ecx
    17eb:	eb 95                	jmp    1782 <printf+0x52>
    17ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    17f0:	83 ec 0c             	sub    $0xc,%esp
    17f3:	b9 10 00 00 00       	mov    $0x10,%ecx
    17f8:	6a 00                	push   $0x0
    17fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
    17fd:	8b 10                	mov    (%eax),%edx
    17ff:	89 f0                	mov    %esi,%eax
    1801:	e8 7a fe ff ff       	call   1680 <printint>
        ap++;
    1806:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    180a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    180d:	31 c9                	xor    %ecx,%ecx
    180f:	e9 6e ff ff ff       	jmp    1782 <printf+0x52>
    1814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1818:	8b 45 d0             	mov    -0x30(%ebp),%eax
    181b:	8b 10                	mov    (%eax),%edx
        ap++;
    181d:	83 c0 04             	add    $0x4,%eax
    1820:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1823:	85 d2                	test   %edx,%edx
    1825:	0f 84 8d 00 00 00    	je     18b8 <printf+0x188>
        while(*s != 0){
    182b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    182e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    1830:	84 c0                	test   %al,%al
    1832:	0f 84 4a ff ff ff    	je     1782 <printf+0x52>
    1838:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    183b:	89 d3                	mov    %edx,%ebx
    183d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1840:	83 ec 04             	sub    $0x4,%esp
          s++;
    1843:	83 c3 01             	add    $0x1,%ebx
    1846:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1849:	6a 01                	push   $0x1
    184b:	57                   	push   %edi
    184c:	56                   	push   %esi
    184d:	e8 91 fd ff ff       	call   15e3 <write>
        while(*s != 0){
    1852:	0f b6 03             	movzbl (%ebx),%eax
    1855:	83 c4 10             	add    $0x10,%esp
    1858:	84 c0                	test   %al,%al
    185a:	75 e4                	jne    1840 <printf+0x110>
      state = 0;
    185c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    185f:	31 c9                	xor    %ecx,%ecx
    1861:	e9 1c ff ff ff       	jmp    1782 <printf+0x52>
    1866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    186d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    1870:	83 ec 0c             	sub    $0xc,%esp
    1873:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1878:	6a 01                	push   $0x1
    187a:	e9 7b ff ff ff       	jmp    17fa <printf+0xca>
    187f:	90                   	nop
        putc(fd, *ap);
    1880:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1883:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1886:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1888:	6a 01                	push   $0x1
    188a:	57                   	push   %edi
    188b:	56                   	push   %esi
        putc(fd, *ap);
    188c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    188f:	e8 4f fd ff ff       	call   15e3 <write>
        ap++;
    1894:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1898:	83 c4 10             	add    $0x10,%esp
      state = 0;
    189b:	31 c9                	xor    %ecx,%ecx
    189d:	e9 e0 fe ff ff       	jmp    1782 <printf+0x52>
    18a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    18a8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    18ab:	83 ec 04             	sub    $0x4,%esp
    18ae:	e9 2a ff ff ff       	jmp    17dd <printf+0xad>
    18b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    18b7:	90                   	nop
          s = "(null)";
    18b8:	ba ca 1a 00 00       	mov    $0x1aca,%edx
        while(*s != 0){
    18bd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    18c0:	b8 28 00 00 00       	mov    $0x28,%eax
    18c5:	89 d3                	mov    %edx,%ebx
    18c7:	e9 74 ff ff ff       	jmp    1840 <printf+0x110>
    18cc:	66 90                	xchg   %ax,%ax
    18ce:	66 90                	xchg   %ax,%ax

000018d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18d1:	a1 20 23 00 00       	mov    0x2320,%eax
{
    18d6:	89 e5                	mov    %esp,%ebp
    18d8:	57                   	push   %edi
    18d9:	56                   	push   %esi
    18da:	53                   	push   %ebx
    18db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    18de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    18e8:	89 c2                	mov    %eax,%edx
    18ea:	8b 00                	mov    (%eax),%eax
    18ec:	39 ca                	cmp    %ecx,%edx
    18ee:	73 30                	jae    1920 <free+0x50>
    18f0:	39 c1                	cmp    %eax,%ecx
    18f2:	72 04                	jb     18f8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18f4:	39 c2                	cmp    %eax,%edx
    18f6:	72 f0                	jb     18e8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    18f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    18fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    18fe:	39 f8                	cmp    %edi,%eax
    1900:	74 30                	je     1932 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1902:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1905:	8b 42 04             	mov    0x4(%edx),%eax
    1908:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    190b:	39 f1                	cmp    %esi,%ecx
    190d:	74 3a                	je     1949 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    190f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1911:	5b                   	pop    %ebx
  freep = p;
    1912:	89 15 20 23 00 00    	mov    %edx,0x2320
}
    1918:	5e                   	pop    %esi
    1919:	5f                   	pop    %edi
    191a:	5d                   	pop    %ebp
    191b:	c3                   	ret    
    191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1920:	39 c2                	cmp    %eax,%edx
    1922:	72 c4                	jb     18e8 <free+0x18>
    1924:	39 c1                	cmp    %eax,%ecx
    1926:	73 c0                	jae    18e8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1928:	8b 73 fc             	mov    -0x4(%ebx),%esi
    192b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    192e:	39 f8                	cmp    %edi,%eax
    1930:	75 d0                	jne    1902 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    1932:	03 70 04             	add    0x4(%eax),%esi
    1935:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1938:	8b 02                	mov    (%edx),%eax
    193a:	8b 00                	mov    (%eax),%eax
    193c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    193f:	8b 42 04             	mov    0x4(%edx),%eax
    1942:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1945:	39 f1                	cmp    %esi,%ecx
    1947:	75 c6                	jne    190f <free+0x3f>
    p->s.size += bp->s.size;
    1949:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    194c:	89 15 20 23 00 00    	mov    %edx,0x2320
    p->s.size += bp->s.size;
    1952:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1955:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1958:	89 0a                	mov    %ecx,(%edx)
}
    195a:	5b                   	pop    %ebx
    195b:	5e                   	pop    %esi
    195c:	5f                   	pop    %edi
    195d:	5d                   	pop    %ebp
    195e:	c3                   	ret    
    195f:	90                   	nop

00001960 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1960:	55                   	push   %ebp
    1961:	89 e5                	mov    %esp,%ebp
    1963:	57                   	push   %edi
    1964:	56                   	push   %esi
    1965:	53                   	push   %ebx
    1966:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1969:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    196c:	8b 3d 20 23 00 00    	mov    0x2320,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1972:	8d 70 07             	lea    0x7(%eax),%esi
    1975:	c1 ee 03             	shr    $0x3,%esi
    1978:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    197b:	85 ff                	test   %edi,%edi
    197d:	0f 84 9d 00 00 00    	je     1a20 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1983:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1985:	8b 4a 04             	mov    0x4(%edx),%ecx
    1988:	39 f1                	cmp    %esi,%ecx
    198a:	73 6a                	jae    19f6 <malloc+0x96>
    198c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1991:	39 de                	cmp    %ebx,%esi
    1993:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1996:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    19a0:	eb 17                	jmp    19b9 <malloc+0x59>
    19a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    19aa:	8b 48 04             	mov    0x4(%eax),%ecx
    19ad:	39 f1                	cmp    %esi,%ecx
    19af:	73 4f                	jae    1a00 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    19b1:	8b 3d 20 23 00 00    	mov    0x2320,%edi
    19b7:	89 c2                	mov    %eax,%edx
    19b9:	39 d7                	cmp    %edx,%edi
    19bb:	75 eb                	jne    19a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    19bd:	83 ec 0c             	sub    $0xc,%esp
    19c0:	ff 75 e4             	push   -0x1c(%ebp)
    19c3:	e8 83 fc ff ff       	call   164b <sbrk>
  if(p == (char*)-1)
    19c8:	83 c4 10             	add    $0x10,%esp
    19cb:	83 f8 ff             	cmp    $0xffffffff,%eax
    19ce:	74 1c                	je     19ec <malloc+0x8c>
  hp->s.size = nu;
    19d0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    19d3:	83 ec 0c             	sub    $0xc,%esp
    19d6:	83 c0 08             	add    $0x8,%eax
    19d9:	50                   	push   %eax
    19da:	e8 f1 fe ff ff       	call   18d0 <free>
  return freep;
    19df:	8b 15 20 23 00 00    	mov    0x2320,%edx
      if((p = morecore(nunits)) == 0)
    19e5:	83 c4 10             	add    $0x10,%esp
    19e8:	85 d2                	test   %edx,%edx
    19ea:	75 bc                	jne    19a8 <malloc+0x48>
        return 0;
  }
}
    19ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    19ef:	31 c0                	xor    %eax,%eax
}
    19f1:	5b                   	pop    %ebx
    19f2:	5e                   	pop    %esi
    19f3:	5f                   	pop    %edi
    19f4:	5d                   	pop    %ebp
    19f5:	c3                   	ret    
    if(p->s.size >= nunits){
    19f6:	89 d0                	mov    %edx,%eax
    19f8:	89 fa                	mov    %edi,%edx
    19fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1a00:	39 ce                	cmp    %ecx,%esi
    1a02:	74 4c                	je     1a50 <malloc+0xf0>
        p->s.size -= nunits;
    1a04:	29 f1                	sub    %esi,%ecx
    1a06:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1a09:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1a0c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    1a0f:	89 15 20 23 00 00    	mov    %edx,0x2320
}
    1a15:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1a18:	83 c0 08             	add    $0x8,%eax
}
    1a1b:	5b                   	pop    %ebx
    1a1c:	5e                   	pop    %esi
    1a1d:	5f                   	pop    %edi
    1a1e:	5d                   	pop    %ebp
    1a1f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    1a20:	c7 05 20 23 00 00 24 	movl   $0x2324,0x2320
    1a27:	23 00 00 
    base.s.size = 0;
    1a2a:	bf 24 23 00 00       	mov    $0x2324,%edi
    base.s.ptr = freep = prevp = &base;
    1a2f:	c7 05 24 23 00 00 24 	movl   $0x2324,0x2324
    1a36:	23 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a39:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    1a3b:	c7 05 28 23 00 00 00 	movl   $0x0,0x2328
    1a42:	00 00 00 
    if(p->s.size >= nunits){
    1a45:	e9 42 ff ff ff       	jmp    198c <malloc+0x2c>
    1a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1a50:	8b 08                	mov    (%eax),%ecx
    1a52:	89 0a                	mov    %ecx,(%edx)
    1a54:	eb b9                	jmp    1a0f <malloc+0xaf>
    1a56:	66 90                	xchg   %ax,%ax
    1a58:	66 90                	xchg   %ax,%ax
    1a5a:	66 90                	xchg   %ax,%ax
    1a5c:	66 90                	xchg   %ax,%ax
    1a5e:	66 90                	xchg   %ax,%ax

00001a60 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1a60:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1a61:	b9 01 00 00 00       	mov    $0x1,%ecx
    1a66:	89 e5                	mov    %esp,%ebp
    1a68:	8b 55 08             	mov    0x8(%ebp),%edx
    1a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1a6f:	90                   	nop
    1a70:	89 c8                	mov    %ecx,%eax
    1a72:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1a75:	85 c0                	test   %eax,%eax
    1a77:	75 f7                	jne    1a70 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1a79:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    1a7e:	5d                   	pop    %ebp
    1a7f:	c3                   	ret    

00001a80 <urelease>:

void urelease (struct uspinlock *lk) {
    1a80:	55                   	push   %ebp
    1a81:	89 e5                	mov    %esp,%ebp
    1a83:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1a86:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1a91:	5d                   	pop    %ebp
    1a92:	c3                   	ret    
