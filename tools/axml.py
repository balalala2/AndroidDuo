import struct,sys,zipfile
def strpool(b,off):
    hs,sz=struct.unpack_from('<HI',b,off+2);n,styles,flags,so,sto=struct.unpack_from('<IIIII',b,off+8)
    u8=flags&0x100;res=[];base=off+so
    for i in range(n):
        p=base+struct.unpack_from('<I',b,off+hs+i*4)[0]
        if u8:
            l=b[p];p+=2 if l&0x80 else 1
            l=b[p];
            if l&0x80: l=((l&0x7f)<<8)|b[p+1];p+=2
            else:p+=1
            res.append(b[p:p+l].decode('utf8','replace'))
        else:
            l=struct.unpack_from('<H',b,p)[0];p+=2
            if l&0x8000: l=((l&0x7fff)<<16)|struct.unpack_from('<H',b,p)[0];p+=2
            res.append(b[p:p+l*2].decode('utf16','replace'))
    return res,sz
def parse(b):
    off=8;S=[];resids=[];out=[]
    while off<len(b):
        t,hs,sz=struct.unpack_from('<HHI',b,off)
        if t==1:S,_=strpool(b,off)
        elif t==0x180:resids=list(struct.unpack_from('<%dI'%((sz-8)//4),b,off+8))
        elif t==0x102:
            ns,name,ast,asz,cnt=struct.unpack_from('<iiHHH',b,off+16)
            attrs={}
            for i in range(cnt):
                a=off+16+ast+i*asz;ans,an,araw,_,_,dt,dv=struct.unpack_from('<iiiHBBI',b,a)
                key=S[an] if an>=0 and an<len(S) and S[an] else (hex(resids[an]) if an<len(resids) else an)
                if an<len(resids): key=S[an] or hex(resids[an])
                val=S[araw] if araw>=0 else (hex(dv) if dt in(0x10,0x11,0x12,1) else dv)
                attrs[key]=val
            out.append((S[name],attrs))
        off+=sz
    return out
z=zipfile.ZipFile(sys.argv[1]);els=parse(z.read('AndroidManifest.xml'))
for n,a in els:
    if n in('activity','activity-alias') :
        nm=a.get('name','');
        if len(sys.argv)>2 and not any(k in nm for k in sys.argv[2].split(',')):continue
        print(n,nm,{k:v for k,v in a.items() if k in('configChanges','resizeableActivity','screenOrientation','launchMode','theme','targetActivity')})
    if n=='application': print('application',{k:v for k,v in a.items() if k in('resizeableActivity','name')})
