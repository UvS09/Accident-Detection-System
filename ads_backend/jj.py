import sys 
def UvS():
    d=list(map(int,sys.stdin.read().strip().split()))
    pts=[(d[0],d[1]),(d[2],d[3]),(d[4],d[5])]
    xs=[p[0] for p in pts]
    ys=[p[1] for p in pts]
    my=sorted(ys)[1]
    min_x,max_x=min(xs),max(xs)
    lst=[]
    if min_x!=max_x:
        lst.append((min_x,my,max_x,my))
    for x,y in pts:
        if y!=my:
            lst.append((x,y,x,my))
    print(len(lst))
    for x1,y1,x2,y2 in lst:
        print(x1,y1,x2,y2)
UvS()