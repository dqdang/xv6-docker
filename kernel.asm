
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 d6 10 80       	mov    $0x8010d690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 ee 38 10 80       	mov    $0x801038ee,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 ac 94 10 	movl   $0x801094ac,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100049:	e8 a4 4e 00 00       	call   80104ef2 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 ec 1d 11 80 9c 	movl   $0x80111d9c,0x80111dec
80100055:	1d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 f0 1d 11 80 9c 	movl   $0x80111d9c,0x80111df0
8010005f:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 d4 d6 10 80 	movl   $0x8010d6d4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 f0 1d 11 80    	mov    0x80111df0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 9c 1d 11 80 	movl   $0x80111d9c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 b3 94 10 	movl   $0x801094b3,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 1d 4d 00 00       	call   80104db4 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 f0 1d 11 80       	mov    %eax,0x80111df0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 9c 1d 11 80 	cmpl   $0x80111d9c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801000c9:	e8 45 4e 00 00       	call   80104f13 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100104:	e8 74 4e 00 00       	call   80104f7d <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 d7 4c 00 00       	call   80104dee <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 9c 1d 11 80 	cmpl   $0x80111d9c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 ec 1d 11 80       	mov    0x80111dec,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010017d:	e8 fb 4d 00 00       	call   80104f7d <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 5e 4c 00 00       	call   80104dee <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 9c 1d 11 80 	cmpl   $0x80111d9c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 ba 94 10 80 	movl   $0x801094ba,(%esp)
801001ae:	e8 a1 03 00 00       	call   80100554 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 3e 28 00 00       	call   80102a25 <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 8b 4c 00 00       	call   80104e8b <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 cb 94 10 80 	movl   $0x801094cb,(%esp)
8010020b:	e8 44 03 00 00       	call   80100554 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 fb 27 00 00       	call   80102a25 <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 4b 4c 00 00       	call   80104e8b <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 d2 94 10 80 	movl   $0x801094d2,(%esp)
8010024b:	e8 04 03 00 00       	call   80100554 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 eb 4b 00 00       	call   80104e49 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100265:	e8 a9 4c 00 00       	call   80104f13 <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 f0 1d 11 80    	mov    0x80111df0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 9c 1d 11 80 	movl   $0x80111d9c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 f0 1d 11 80       	mov    %eax,0x80111df0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801002d1:	e8 a7 4c 00 00       	call   80104f7d <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801002e8:	89 c2                	mov    %eax,%edx
801002ea:	ec                   	in     (%dx),%al
801002eb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ee:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801002f1:	c9                   	leave  
801002f2:	c3                   	ret    

801002f3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f3:	55                   	push   %ebp
801002f4:	89 e5                	mov    %esp,%ebp
801002f6:	83 ec 08             	sub    $0x8,%esp
801002f9:	8b 45 08             	mov    0x8(%ebp),%eax
801002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801002ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100303:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100306:	8a 45 f8             	mov    -0x8(%ebp),%al
80100309:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	c9                   	leave  
8010030e:	c3                   	ret    

8010030f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030f:	55                   	push   %ebp
80100310:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100312:	fa                   	cli    
}
80100313:	5d                   	pop    %ebp
80100314:	c3                   	ret    

80100315 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100315:	55                   	push   %ebp
80100316:	89 e5                	mov    %esp,%ebp
80100318:	56                   	push   %esi
80100319:	53                   	push   %ebx
8010031a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100321:	74 1c                	je     8010033f <printint+0x2a>
80100323:	8b 45 08             	mov    0x8(%ebp),%eax
80100326:	c1 e8 1f             	shr    $0x1f,%eax
80100329:	0f b6 c0             	movzbl %al,%eax
8010032c:	89 45 10             	mov    %eax,0x10(%ebp)
8010032f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100333:	74 0a                	je     8010033f <printint+0x2a>
    x = -xx;
80100335:	8b 45 08             	mov    0x8(%ebp),%eax
80100338:	f7 d8                	neg    %eax
8010033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033d:	eb 06                	jmp    80100345 <printint+0x30>
  else
    x = xx;
8010033f:	8b 45 08             	mov    0x8(%ebp),%eax
80100342:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034f:	8d 41 01             	lea    0x1(%ecx),%eax
80100352:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035b:	ba 00 00 00 00       	mov    $0x0,%edx
80100360:	f7 f3                	div    %ebx
80100362:	89 d0                	mov    %edx,%eax
80100364:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
8010036a:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036e:	8b 75 0c             	mov    0xc(%ebp),%esi
80100371:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100374:	ba 00 00 00 00       	mov    $0x0,%edx
80100379:	f7 f6                	div    %esi
8010037b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100382:	75 c8                	jne    8010034c <printint+0x37>

  if(sign)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 10                	je     8010039a <printint+0x85>
    buf[i++] = '-';
8010038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038d:	8d 50 01             	lea    0x1(%eax),%edx
80100390:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100393:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100398:	eb 17                	jmp    801003b1 <printint+0x9c>
8010039a:	eb 15                	jmp    801003b1 <printint+0x9c>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	8a 00                	mov    (%eax),%al
801003a6:	0f be c0             	movsbl %al,%eax
801003a9:	89 04 24             	mov    %eax,(%esp)
801003ac:	e8 b7 03 00 00       	call   80100768 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b1:	ff 4d f4             	decl   -0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 e2                	jns    8010039c <printint+0x87>
    consputc(buf[i]);
}
801003ba:	83 c4 30             	add    $0x30,%esp
801003bd:	5b                   	pop    %ebx
801003be:	5e                   	pop    %esi
801003bf:	5d                   	pop    %ebp
801003c0:	c3                   	ret    

801003c1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c1:	55                   	push   %ebp
801003c2:	89 e5                	mov    %esp,%ebp
801003c4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c7:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801003cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d3:	74 0c                	je     801003e1 <cprintf+0x20>
    acquire(&cons.lock);
801003d5:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801003dc:	e8 32 4b 00 00       	call   80104f13 <acquire>

  if (fmt == 0)
801003e1:	8b 45 08             	mov    0x8(%ebp),%eax
801003e4:	85 c0                	test   %eax,%eax
801003e6:	75 0c                	jne    801003f4 <cprintf+0x33>
    panic("null fmt");
801003e8:	c7 04 24 d9 94 10 80 	movl   $0x801094d9,(%esp)
801003ef:	e8 60 01 00 00       	call   80100554 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100401:	e9 1b 01 00 00       	jmp    80100521 <cprintf+0x160>
    if(c != '%'){
80100406:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040a:	74 10                	je     8010041c <cprintf+0x5b>
      consputc(c);
8010040c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010040f:	89 04 24             	mov    %eax,(%esp)
80100412:	e8 51 03 00 00       	call   80100768 <consputc>
      continue;
80100417:	e9 02 01 00 00       	jmp    8010051e <cprintf+0x15d>
    }
    c = fmt[++i] & 0xff;
8010041c:	8b 55 08             	mov    0x8(%ebp),%edx
8010041f:	ff 45 f4             	incl   -0xc(%ebp)
80100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100425:	01 d0                	add    %edx,%eax
80100427:	8a 00                	mov    (%eax),%al
80100429:	0f be c0             	movsbl %al,%eax
8010042c:	25 ff 00 00 00       	and    $0xff,%eax
80100431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100434:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100438:	75 05                	jne    8010043f <cprintf+0x7e>
      break;
8010043a:	e9 01 01 00 00       	jmp    80100540 <cprintf+0x17f>
    switch(c){
8010043f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100442:	83 f8 70             	cmp    $0x70,%eax
80100445:	74 4f                	je     80100496 <cprintf+0xd5>
80100447:	83 f8 70             	cmp    $0x70,%eax
8010044a:	7f 13                	jg     8010045f <cprintf+0x9e>
8010044c:	83 f8 25             	cmp    $0x25,%eax
8010044f:	0f 84 a3 00 00 00    	je     801004f8 <cprintf+0x137>
80100455:	83 f8 64             	cmp    $0x64,%eax
80100458:	74 14                	je     8010046e <cprintf+0xad>
8010045a:	e9 a7 00 00 00       	jmp    80100506 <cprintf+0x145>
8010045f:	83 f8 73             	cmp    $0x73,%eax
80100462:	74 57                	je     801004bb <cprintf+0xfa>
80100464:	83 f8 78             	cmp    $0x78,%eax
80100467:	74 2d                	je     80100496 <cprintf+0xd5>
80100469:	e9 98 00 00 00       	jmp    80100506 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
8010046e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100471:	8d 50 04             	lea    0x4(%eax),%edx
80100474:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100477:	8b 00                	mov    (%eax),%eax
80100479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100480:	00 
80100481:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100488:	00 
80100489:	89 04 24             	mov    %eax,(%esp)
8010048c:	e8 84 fe ff ff       	call   80100315 <printint>
      break;
80100491:	e9 88 00 00 00       	jmp    8010051e <cprintf+0x15d>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004a8:	00 
801004a9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b0:	00 
801004b1:	89 04 24             	mov    %eax,(%esp)
801004b4:	e8 5c fe ff ff       	call   80100315 <printint>
      break;
801004b9:	eb 63                	jmp    8010051e <cprintf+0x15d>
    case 's':
      if((s = (char*)*argp++) == 0)
801004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004be:	8d 50 04             	lea    0x4(%eax),%edx
801004c1:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c4:	8b 00                	mov    (%eax),%eax
801004c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cd:	75 09                	jne    801004d8 <cprintf+0x117>
        s = "(null)";
801004cf:	c7 45 ec e2 94 10 80 	movl   $0x801094e2,-0x14(%ebp)
      for(; *s; s++)
801004d6:	eb 15                	jmp    801004ed <cprintf+0x12c>
801004d8:	eb 13                	jmp    801004ed <cprintf+0x12c>
        consputc(*s);
801004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dd:	8a 00                	mov    (%eax),%al
801004df:	0f be c0             	movsbl %al,%eax
801004e2:	89 04 24             	mov    %eax,(%esp)
801004e5:	e8 7e 02 00 00       	call   80100768 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004ea:	ff 45 ec             	incl   -0x14(%ebp)
801004ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f0:	8a 00                	mov    (%eax),%al
801004f2:	84 c0                	test   %al,%al
801004f4:	75 e4                	jne    801004da <cprintf+0x119>
        consputc(*s);
      break;
801004f6:	eb 26                	jmp    8010051e <cprintf+0x15d>
    case '%':
      consputc('%');
801004f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ff:	e8 64 02 00 00       	call   80100768 <consputc>
      break;
80100504:	eb 18                	jmp    8010051e <cprintf+0x15d>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100506:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050d:	e8 56 02 00 00       	call   80100768 <consputc>
      consputc(c);
80100512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100515:	89 04 24             	mov    %eax,(%esp)
80100518:	e8 4b 02 00 00       	call   80100768 <consputc>
      break;
8010051d:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010051e:	ff 45 f4             	incl   -0xc(%ebp)
80100521:	8b 55 08             	mov    0x8(%ebp),%edx
80100524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100527:	01 d0                	add    %edx,%eax
80100529:	8a 00                	mov    (%eax),%al
8010052b:	0f be c0             	movsbl %al,%eax
8010052e:	25 ff 00 00 00       	and    $0xff,%eax
80100533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053a:	0f 85 c6 fe ff ff    	jne    80100406 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100540:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100544:	74 0c                	je     80100552 <cprintf+0x191>
    release(&cons.lock);
80100546:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010054d:	e8 2b 4a 00 00       	call   80104f7d <release>
}
80100552:	c9                   	leave  
80100553:	c3                   	ret    

80100554 <panic>:

void
panic(char *s)
{
80100554:	55                   	push   %ebp
80100555:	89 e5                	mov    %esp,%ebp
80100557:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
8010055a:	e8 b0 fd ff ff       	call   8010030f <cli>
  cons.locking = 0;
8010055f:	c7 05 34 c6 10 80 00 	movl   $0x0,0x8010c634
80100566:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100569:	e8 53 2b 00 00       	call   801030c1 <lapicid>
8010056e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100572:	c7 04 24 e9 94 10 80 	movl   $0x801094e9,(%esp)
80100579:	e8 43 fe ff ff       	call   801003c1 <cprintf>
  cprintf(s);
8010057e:	8b 45 08             	mov    0x8(%ebp),%eax
80100581:	89 04 24             	mov    %eax,(%esp)
80100584:	e8 38 fe ff ff       	call   801003c1 <cprintf>
  cprintf("\n");
80100589:	c7 04 24 fd 94 10 80 	movl   $0x801094fd,(%esp)
80100590:	e8 2c fe ff ff       	call   801003c1 <cprintf>
  getcallerpcs(&s, pcs);
80100595:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010059c:	8d 45 08             	lea    0x8(%ebp),%eax
8010059f:	89 04 24             	mov    %eax,(%esp)
801005a2:	e8 23 4a 00 00       	call   80104fca <getcallerpcs>
  for(i=0; i<10; i++)
801005a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005ae:	eb 1a                	jmp    801005ca <panic+0x76>
    cprintf(" %p", pcs[i]);
801005b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005b3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005bb:	c7 04 24 ff 94 10 80 	movl   $0x801094ff,(%esp)
801005c2:	e8 fa fd ff ff       	call   801003c1 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c7:	ff 45 f4             	incl   -0xc(%ebp)
801005ca:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005ce:	7e e0                	jle    801005b0 <panic+0x5c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005d0:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
801005d7:	00 00 00 
  for(;;)
    ;
801005da:	eb fe                	jmp    801005da <panic+0x86>

801005dc <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005dc:	55                   	push   %ebp
801005dd:	89 e5                	mov    %esp,%ebp
801005df:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005e2:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e9:	00 
801005ea:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005f1:	e8 fd fc ff ff       	call   801002f3 <outb>
  pos = inb(CRTPORT+1) << 8;
801005f6:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005fd:	e8 d6 fc ff ff       	call   801002d8 <inb>
80100602:	0f b6 c0             	movzbl %al,%eax
80100605:	c1 e0 08             	shl    $0x8,%eax
80100608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010060b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100612:	00 
80100613:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010061a:	e8 d4 fc ff ff       	call   801002f3 <outb>
  pos |= inb(CRTPORT+1);
8010061f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100626:	e8 ad fc ff ff       	call   801002d8 <inb>
8010062b:	0f b6 c0             	movzbl %al,%eax
8010062e:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100631:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100635:	75 1b                	jne    80100652 <cgaputc+0x76>
    pos += 80 - pos%80;
80100637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010063a:	b9 50 00 00 00       	mov    $0x50,%ecx
8010063f:	99                   	cltd   
80100640:	f7 f9                	idiv   %ecx
80100642:	89 d0                	mov    %edx,%eax
80100644:	ba 50 00 00 00       	mov    $0x50,%edx
80100649:	29 c2                	sub    %eax,%edx
8010064b:	89 d0                	mov    %edx,%eax
8010064d:	01 45 f4             	add    %eax,-0xc(%ebp)
80100650:	eb 34                	jmp    80100686 <cgaputc+0xaa>
  else if(c == BACKSPACE){
80100652:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100659:	75 0b                	jne    80100666 <cgaputc+0x8a>
    if(pos > 0) --pos;
8010065b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010065f:	7e 25                	jle    80100686 <cgaputc+0xaa>
80100661:	ff 4d f4             	decl   -0xc(%ebp)
80100664:	eb 20                	jmp    80100686 <cgaputc+0xaa>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100666:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010066f:	8d 50 01             	lea    0x1(%eax),%edx
80100672:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100675:	01 c0                	add    %eax,%eax
80100677:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067a:	8b 45 08             	mov    0x8(%ebp),%eax
8010067d:	0f b6 c0             	movzbl %al,%eax
80100680:	80 cc 07             	or     $0x7,%ah
80100683:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
80100686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068a:	78 09                	js     80100695 <cgaputc+0xb9>
8010068c:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100693:	7e 0c                	jle    801006a1 <cgaputc+0xc5>
    panic("pos under/overflow");
80100695:	c7 04 24 03 95 10 80 	movl   $0x80109503,(%esp)
8010069c:	e8 b3 fe ff ff       	call   80100554 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006a1:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006a8:	7e 53                	jle    801006fd <cgaputc+0x121>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006aa:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006af:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006b5:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ba:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c1:	00 
801006c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801006c6:	89 04 24             	mov    %eax,(%esp)
801006c9:	e8 71 4b 00 00       	call   8010523f <memmove>
    pos -= 80;
801006ce:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d2:	b8 80 07 00 00       	mov    $0x780,%eax
801006d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006da:	01 c0                	add    %eax,%eax
801006dc:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801006e5:	01 d2                	add    %edx,%edx
801006e7:	01 ca                	add    %ecx,%edx
801006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801006ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f4:	00 
801006f5:	89 14 24             	mov    %edx,(%esp)
801006f8:	e8 79 4a 00 00       	call   80105176 <memset>
  }

  outb(CRTPORT, 14);
801006fd:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100704:	00 
80100705:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010070c:	e8 e2 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos>>8);
80100711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100714:	c1 f8 08             	sar    $0x8,%eax
80100717:	0f b6 c0             	movzbl %al,%eax
8010071a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010071e:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100725:	e8 c9 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT, 15);
8010072a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100731:	00 
80100732:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100739:	e8 b5 fb ff ff       	call   801002f3 <outb>
  outb(CRTPORT+1, pos);
8010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	89 44 24 04          	mov    %eax,0x4(%esp)
80100748:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010074f:	e8 9f fb ff ff       	call   801002f3 <outb>
  crt[pos] = ' ' | 0x0700;
80100754:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
8010075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010075d:	01 c0                	add    %eax,%eax
8010075f:	01 d0                	add    %edx,%eax
80100761:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100766:	c9                   	leave  
80100767:	c3                   	ret    

80100768 <consputc>:

void
consputc(int c)
{
80100768:	55                   	push   %ebp
80100769:	89 e5                	mov    %esp,%ebp
8010076b:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010076e:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
80100773:	85 c0                	test   %eax,%eax
80100775:	74 07                	je     8010077e <consputc+0x16>
    cli();
80100777:	e8 93 fb ff ff       	call   8010030f <cli>
    for(;;)
      ;
8010077c:	eb fe                	jmp    8010077c <consputc+0x14>
  }

  if(c == BACKSPACE){
8010077e:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100785:	75 26                	jne    801007ad <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 15 6d 00 00       	call   801074a8 <uartputc>
80100793:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079a:	e8 09 6d 00 00       	call   801074a8 <uartputc>
8010079f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a6:	e8 fd 6c 00 00       	call   801074a8 <uartputc>
801007ab:	eb 0b                	jmp    801007b8 <consputc+0x50>
  } else
    uartputc(c);
801007ad:	8b 45 08             	mov    0x8(%ebp),%eax
801007b0:	89 04 24             	mov    %eax,(%esp)
801007b3:	e8 f0 6c 00 00       	call   801074a8 <uartputc>
  cgaputc(c);
801007b8:	8b 45 08             	mov    0x8(%ebp),%eax
801007bb:	89 04 24             	mov    %eax,(%esp)
801007be:	e8 19 fe ff ff       	call   801005dc <cgaputc>
}
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <copy_buf>:

#define C(x)  ((x)-'@')  // Control-x


void copy_buf(char *dst, char *src, int len)
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 10             	sub    $0x10,%esp
  int i;

  for (i = 0; i < len; i++) {
801007cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801007d2:	eb 17                	jmp    801007eb <copy_buf+0x26>
    dst[i] = src[i];
801007d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801007d7:	8b 45 08             	mov    0x8(%ebp),%eax
801007da:	01 c2                	add    %eax,%edx
801007dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
801007df:	8b 45 0c             	mov    0xc(%ebp),%eax
801007e2:	01 c8                	add    %ecx,%eax
801007e4:	8a 00                	mov    (%eax),%al
801007e6:	88 02                	mov    %al,(%edx)

void copy_buf(char *dst, char *src, int len)
{
  int i;

  for (i = 0; i < len; i++) {
801007e8:	ff 45 fc             	incl   -0x4(%ebp)
801007eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801007ee:	3b 45 10             	cmp    0x10(%ebp),%eax
801007f1:	7c e1                	jl     801007d4 <copy_buf+0xf>
    dst[i] = src[i];
  }
}
801007f3:	c9                   	leave  
801007f4:	c3                   	ret    

801007f5 <consoleintr>:

void
consoleintr(int (*getc)(void))
{
801007f5:	55                   	push   %ebp
801007f6:	89 e5                	mov    %esp,%ebp
801007f8:	57                   	push   %edi
801007f9:	56                   	push   %esi
801007fa:	53                   	push   %ebx
801007fb:	81 ec ac 00 00 00    	sub    $0xac,%esp
  int c, doprocdump = 0, doconsoleswitch = 0;
80100801:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100808:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  acquire(&cons.lock);
8010080f:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100816:	e8 f8 46 00 00       	call   80104f13 <acquire>
  while((c = getc()) >= 0){
8010081b:	e9 a3 02 00 00       	jmp    80100ac3 <consoleintr+0x2ce>
    switch(c){
80100820:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100823:	83 f8 14             	cmp    $0x14,%eax
80100826:	74 3b                	je     80100863 <consoleintr+0x6e>
80100828:	83 f8 14             	cmp    $0x14,%eax
8010082b:	7f 13                	jg     80100840 <consoleintr+0x4b>
8010082d:	83 f8 08             	cmp    $0x8,%eax
80100830:	0f 84 d0 01 00 00    	je     80100a06 <consoleintr+0x211>
80100836:	83 f8 10             	cmp    $0x10,%eax
80100839:	74 1c                	je     80100857 <consoleintr+0x62>
8010083b:	e9 f6 01 00 00       	jmp    80100a36 <consoleintr+0x241>
80100840:	83 f8 15             	cmp    $0x15,%eax
80100843:	0f 84 95 01 00 00    	je     801009de <consoleintr+0x1e9>
80100849:	83 f8 7f             	cmp    $0x7f,%eax
8010084c:	0f 84 b4 01 00 00    	je     80100a06 <consoleintr+0x211>
80100852:	e9 df 01 00 00       	jmp    80100a36 <consoleintr+0x241>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100857:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
8010085e:	e9 60 02 00 00       	jmp    80100ac3 <consoleintr+0x2ce>
    case C('T'):  // Process listing.
      inputs[active] = input;
80100863:	8b 15 e4 c5 10 80    	mov    0x8010c5e4,%edx
80100869:	89 d0                	mov    %edx,%eax
8010086b:	c1 e0 02             	shl    $0x2,%eax
8010086e:	01 d0                	add    %edx,%eax
80100870:	c1 e0 02             	shl    $0x2,%eax
80100873:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010087a:	29 c2                	sub    %eax,%edx
8010087c:	8d 82 40 26 11 80    	lea    -0x7feed9c0(%edx),%eax
80100882:	89 c2                	mov    %eax,%edx
80100884:	bb 00 20 11 80       	mov    $0x80112000,%ebx
80100889:	b8 23 00 00 00       	mov    $0x23,%eax
8010088e:	89 d7                	mov    %edx,%edi
80100890:	89 de                	mov    %ebx,%esi
80100892:	89 c1                	mov    %eax,%ecx
80100894:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      active = (active + 1) % (NUM_VCS + 1);
80100896:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
8010089b:	40                   	inc    %eax
8010089c:	b9 05 00 00 00       	mov    $0x5,%ecx
801008a1:	99                   	cltd   
801008a2:	f7 f9                	idiv   %ecx
801008a4:	89 d0                	mov    %edx,%eax
801008a6:	a3 e4 c5 10 80       	mov    %eax,0x8010c5e4
      input = inputs[active];
801008ab:	8b 15 e4 c5 10 80    	mov    0x8010c5e4,%edx
801008b1:	89 d0                	mov    %edx,%eax
801008b3:	c1 e0 02             	shl    $0x2,%eax
801008b6:	01 d0                	add    %edx,%eax
801008b8:	c1 e0 02             	shl    $0x2,%eax
801008bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801008c2:	29 c2                	sub    %eax,%edx
801008c4:	8d 82 40 26 11 80    	lea    -0x7feed9c0(%edx),%eax
801008ca:	ba 00 20 11 80       	mov    $0x80112000,%edx
801008cf:	89 c3                	mov    %eax,%ebx
801008d1:	b8 23 00 00 00       	mov    $0x23,%eax
801008d6:	89 d7                	mov    %edx,%edi
801008d8:	89 de                	mov    %ebx,%esi
801008da:	89 c1                	mov    %eax,%ecx
801008dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      doconsoleswitch = 1;
801008de:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
      char fs[32];
      if(active > 0){
801008e5:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
801008ea:	85 c0                	test   %eax,%eax
801008ec:	0f 8e b2 00 00 00    	jle    801009a4 <consoleintr+0x1af>
        char active_string[32];
        itoa(active-1, active_string, 10);
801008f2:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
801008f7:	8d 50 ff             	lea    -0x1(%eax),%edx
801008fa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
80100901:	00 
80100902:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
80100908:	89 44 24 04          	mov    %eax,0x4(%esp)
8010090c:	89 14 24             	mov    %edx,(%esp)
8010090f:	e8 73 4c 00 00       	call   80105587 <itoa>
        strcat(active_string, "\0");
80100914:	c7 44 24 04 16 95 10 	movl   $0x80109516,0x4(%esp)
8010091b:	80 
8010091c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
80100922:	89 04 24             	mov    %eax,(%esp)
80100925:	e8 f2 4a 00 00       	call   8010541c <strcat>
        char vc[32];
        strcpy(vc, "vc");
8010092a:	c7 44 24 04 18 95 10 	movl   $0x80109518,0x4(%esp)
80100931:	80 
80100932:	8d 45 9c             	lea    -0x64(%ebp),%eax
80100935:	89 04 24             	mov    %eax,(%esp)
80100938:	e8 ef 49 00 00       	call   8010532c <strcpy>
        strcat(vc, active_string);
8010093d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
80100943:	89 44 24 04          	mov    %eax,0x4(%esp)
80100947:	8d 45 9c             	lea    -0x64(%ebp),%eax
8010094a:	89 04 24             	mov    %eax,(%esp)
8010094d:	e8 ca 4a 00 00       	call   8010541c <strcat>
        strcat(vc, "\0");
80100952:	c7 44 24 04 16 95 10 	movl   $0x80109516,0x4(%esp)
80100959:	80 
8010095a:	8d 45 9c             	lea    -0x64(%ebp),%eax
8010095d:	89 04 24             	mov    %eax,(%esp)
80100960:	e8 b7 4a 00 00       	call   8010541c <strcat>
        char vcfs[32];
        getvcfs(vc, vcfs);
80100965:	8d 45 bc             	lea    -0x44(%ebp),%eax
80100968:	89 44 24 04          	mov    %eax,0x4(%esp)
8010096c:	8d 45 9c             	lea    -0x64(%ebp),%eax
8010096f:	89 04 24             	mov    %eax,(%esp)
80100972:	e8 5a 86 00 00       	call   80108fd1 <getvcfs>
        strcpy(fs, "/");
80100977:	c7 44 24 04 1b 95 10 	movl   $0x8010951b,0x4(%esp)
8010097e:	80 
8010097f:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80100985:	89 04 24             	mov    %eax,(%esp)
80100988:	e8 9f 49 00 00       	call   8010532c <strcpy>
        strcat(fs, vcfs);
8010098d:	8d 45 bc             	lea    -0x44(%ebp),%eax
80100990:	89 44 24 04          	mov    %eax,0x4(%esp)
80100994:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
8010099a:	89 04 24             	mov    %eax,(%esp)
8010099d:	e8 7a 4a 00 00       	call   8010541c <strcat>
801009a2:	eb 0e                	jmp    801009b2 <consoleintr+0x1bd>
      }else{
        fs[0] = '/';
801009a4:	c6 85 5c ff ff ff 2f 	movb   $0x2f,-0xa4(%ebp)
        fs[1] = '\0';
801009ab:	c6 85 5d ff ff ff 00 	movb   $0x0,-0xa3(%ebp)
      }
      setactivefs(fs);
801009b2:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801009b8:	89 04 24             	mov    %eax,(%esp)
801009bb:	e8 9e 86 00 00       	call   8010905e <setactivefs>
      break;
801009c0:	e9 fe 00 00 00       	jmp    80100ac3 <consoleintr+0x2ce>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801009c5:	a1 88 20 11 80       	mov    0x80112088,%eax
801009ca:	48                   	dec    %eax
801009cb:	a3 88 20 11 80       	mov    %eax,0x80112088
        consputc(BACKSPACE);
801009d0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801009d7:	e8 8c fd ff ff       	call   80100768 <consputc>
801009dc:	eb 01                	jmp    801009df <consoleintr+0x1ea>
        fs[1] = '\0';
      }
      setactivefs(fs);
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801009de:	90                   	nop
801009df:	8b 15 88 20 11 80    	mov    0x80112088,%edx
801009e5:	a1 84 20 11 80       	mov    0x80112084,%eax
801009ea:	39 c2                	cmp    %eax,%edx
801009ec:	74 13                	je     80100a01 <consoleintr+0x20c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009ee:	a1 88 20 11 80       	mov    0x80112088,%eax
801009f3:	48                   	dec    %eax
801009f4:	83 e0 7f             	and    $0x7f,%eax
801009f7:	8a 80 00 20 11 80    	mov    -0x7feee000(%eax),%al
        fs[1] = '\0';
      }
      setactivefs(fs);
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801009fd:	3c 0a                	cmp    $0xa,%al
801009ff:	75 c4                	jne    801009c5 <consoleintr+0x1d0>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100a01:	e9 bd 00 00 00       	jmp    80100ac3 <consoleintr+0x2ce>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100a06:	8b 15 88 20 11 80    	mov    0x80112088,%edx
80100a0c:	a1 84 20 11 80       	mov    0x80112084,%eax
80100a11:	39 c2                	cmp    %eax,%edx
80100a13:	74 1c                	je     80100a31 <consoleintr+0x23c>
        input.e--;
80100a15:	a1 88 20 11 80       	mov    0x80112088,%eax
80100a1a:	48                   	dec    %eax
80100a1b:	a3 88 20 11 80       	mov    %eax,0x80112088
        consputc(BACKSPACE);
80100a20:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100a27:	e8 3c fd ff ff       	call   80100768 <consputc>
      }
      break;
80100a2c:	e9 92 00 00 00       	jmp    80100ac3 <consoleintr+0x2ce>
80100a31:	e9 8d 00 00 00       	jmp    80100ac3 <consoleintr+0x2ce>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100a3a:	0f 84 82 00 00 00    	je     80100ac2 <consoleintr+0x2cd>
80100a40:	8b 15 88 20 11 80    	mov    0x80112088,%edx
80100a46:	a1 80 20 11 80       	mov    0x80112080,%eax
80100a4b:	29 c2                	sub    %eax,%edx
80100a4d:	89 d0                	mov    %edx,%eax
80100a4f:	83 f8 7f             	cmp    $0x7f,%eax
80100a52:	77 6e                	ja     80100ac2 <consoleintr+0x2cd>
        c = (c == '\r') ? '\n' : c;
80100a54:	83 7d dc 0d          	cmpl   $0xd,-0x24(%ebp)
80100a58:	74 05                	je     80100a5f <consoleintr+0x26a>
80100a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a5d:	eb 05                	jmp    80100a64 <consoleintr+0x26f>
80100a5f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a64:	89 45 dc             	mov    %eax,-0x24(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100a67:	a1 88 20 11 80       	mov    0x80112088,%eax
80100a6c:	8d 50 01             	lea    0x1(%eax),%edx
80100a6f:	89 15 88 20 11 80    	mov    %edx,0x80112088
80100a75:	83 e0 7f             	and    $0x7f,%eax
80100a78:	89 c2                	mov    %eax,%edx
80100a7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a7d:	88 82 00 20 11 80    	mov    %al,-0x7feee000(%edx)
        consputc(c);
80100a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a86:	89 04 24             	mov    %eax,(%esp)
80100a89:	e8 da fc ff ff       	call   80100768 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a8e:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
80100a92:	74 18                	je     80100aac <consoleintr+0x2b7>
80100a94:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
80100a98:	74 12                	je     80100aac <consoleintr+0x2b7>
80100a9a:	a1 88 20 11 80       	mov    0x80112088,%eax
80100a9f:	8b 15 80 20 11 80    	mov    0x80112080,%edx
80100aa5:	83 ea 80             	sub    $0xffffff80,%edx
80100aa8:	39 d0                	cmp    %edx,%eax
80100aaa:	75 16                	jne    80100ac2 <consoleintr+0x2cd>
          input.w = input.e;
80100aac:	a1 88 20 11 80       	mov    0x80112088,%eax
80100ab1:	a3 84 20 11 80       	mov    %eax,0x80112084
          wakeup(&input.r);
80100ab6:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100abd:	e8 56 41 00 00       	call   80104c18 <wakeup>
        }
      }
      break;
80100ac2:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doconsoleswitch = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80100ac6:	ff d0                	call   *%eax
80100ac8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100acb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100acf:	0f 89 4b fd ff ff    	jns    80100820 <consoleintr+0x2b>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100ad5:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100adc:	e8 9c 44 00 00       	call   80104f7d <release>
  if(doprocdump){
80100ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100ae5:	74 05                	je     80100aec <consoleintr+0x2f7>
    procdump();  // now call procdump() wo. cons.lock held
80100ae7:	e8 cf 41 00 00       	call   80104cbb <procdump>
  }
  if(doconsoleswitch){
80100aec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100af0:	74 15                	je     80100b07 <consoleintr+0x312>
    cprintf("\nActive console now: %d\n", active);
80100af2:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100af7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100afb:	c7 04 24 1d 95 10 80 	movl   $0x8010951d,(%esp)
80100b02:	e8 ba f8 ff ff       	call   801003c1 <cprintf>
  }
}
80100b07:	81 c4 ac 00 00 00    	add    $0xac,%esp
80100b0d:	5b                   	pop    %ebx
80100b0e:	5e                   	pop    %esi
80100b0f:	5f                   	pop    %edi
80100b10:	5d                   	pop    %ebp
80100b11:	c3                   	ret    

80100b12 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100b12:	55                   	push   %ebp
80100b13:	89 e5                	mov    %esp,%ebp
80100b15:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100b18:	8b 45 08             	mov    0x8(%ebp),%eax
80100b1b:	89 04 24             	mov    %eax,(%esp)
80100b1e:	e8 f9 10 00 00       	call   80101c1c <iunlock>
  target = n;
80100b23:	8b 45 10             	mov    0x10(%ebp),%eax
80100b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100b29:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100b30:	e8 de 43 00 00       	call   80104f13 <acquire>
  while(n > 0){
80100b35:	e9 b8 00 00 00       	jmp    80100bf2 <consoleread+0xe0>
    while((input.r == input.w) || (active != ip->minor-1)){
80100b3a:	eb 41                	jmp    80100b7d <consoleread+0x6b>
      if(myproc()->killed){
80100b3c:	e8 c2 37 00 00       	call   80104303 <myproc>
80100b41:	8b 40 24             	mov    0x24(%eax),%eax
80100b44:	85 c0                	test   %eax,%eax
80100b46:	74 21                	je     80100b69 <consoleread+0x57>
        release(&cons.lock);
80100b48:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100b4f:	e8 29 44 00 00       	call   80104f7d <release>
        ilock(ip);
80100b54:	8b 45 08             	mov    0x8(%ebp),%eax
80100b57:	89 04 24             	mov    %eax,(%esp)
80100b5a:	e8 b3 0f 00 00       	call   80101b12 <ilock>
        return -1;
80100b5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b64:	e9 b4 00 00 00       	jmp    80100c1d <consoleread+0x10b>
      }
      sleep(&input.r, &cons.lock);
80100b69:	c7 44 24 04 00 c6 10 	movl   $0x8010c600,0x4(%esp)
80100b70:	80 
80100b71:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100b78:	e8 c7 3f 00 00       	call   80104b44 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while((input.r == input.w) || (active != ip->minor-1)){
80100b7d:	8b 15 80 20 11 80    	mov    0x80112080,%edx
80100b83:	a1 84 20 11 80       	mov    0x80112084,%eax
80100b88:	39 c2                	cmp    %eax,%edx
80100b8a:	74 b0                	je     80100b3c <consoleread+0x2a>
80100b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80100b8f:	8b 40 54             	mov    0x54(%eax),%eax
80100b92:	98                   	cwtl   
80100b93:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b96:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100b9b:	39 c2                	cmp    %eax,%edx
80100b9d:	75 9d                	jne    80100b3c <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100b9f:	a1 80 20 11 80       	mov    0x80112080,%eax
80100ba4:	8d 50 01             	lea    0x1(%eax),%edx
80100ba7:	89 15 80 20 11 80    	mov    %edx,0x80112080
80100bad:	83 e0 7f             	and    $0x7f,%eax
80100bb0:	8a 80 00 20 11 80    	mov    -0x7feee000(%eax),%al
80100bb6:	0f be c0             	movsbl %al,%eax
80100bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100bbc:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100bc0:	75 17                	jne    80100bd9 <consoleread+0xc7>
      if(n < target){
80100bc2:	8b 45 10             	mov    0x10(%ebp),%eax
80100bc5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100bc8:	73 0d                	jae    80100bd7 <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100bca:	a1 80 20 11 80       	mov    0x80112080,%eax
80100bcf:	48                   	dec    %eax
80100bd0:	a3 80 20 11 80       	mov    %eax,0x80112080
      }
      break;
80100bd5:	eb 25                	jmp    80100bfc <consoleread+0xea>
80100bd7:	eb 23                	jmp    80100bfc <consoleread+0xea>
    }
    *dst++ = c;
80100bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bdc:	8d 50 01             	lea    0x1(%eax),%edx
80100bdf:	89 55 0c             	mov    %edx,0xc(%ebp)
80100be2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100be5:	88 10                	mov    %dl,(%eax)
    --n;
80100be7:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100bea:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100bee:	75 02                	jne    80100bf2 <consoleread+0xe0>
      break;
80100bf0:	eb 0a                	jmp    80100bfc <consoleread+0xea>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100bf6:	0f 8f 3e ff ff ff    	jg     80100b3a <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100bfc:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100c03:	e8 75 43 00 00       	call   80104f7d <release>
  ilock(ip);
80100c08:	8b 45 08             	mov    0x8(%ebp),%eax
80100c0b:	89 04 24             	mov    %eax,(%esp)
80100c0e:	e8 ff 0e 00 00       	call   80101b12 <ilock>

  return target - n;
80100c13:	8b 45 10             	mov    0x10(%ebp),%eax
80100c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100c19:	29 c2                	sub    %eax,%edx
80100c1b:	89 d0                	mov    %edx,%eax
}
80100c1d:	c9                   	leave  
80100c1e:	c3                   	ret    

80100c1f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100c1f:	55                   	push   %ebp
80100c20:	89 e5                	mov    %esp,%ebp
80100c22:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (active == ip->minor-1){
80100c25:	8b 45 08             	mov    0x8(%ebp),%eax
80100c28:	8b 40 54             	mov    0x54(%eax),%eax
80100c2b:	98                   	cwtl   
80100c2c:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c2f:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80100c34:	39 c2                	cmp    %eax,%edx
80100c36:	75 5a                	jne    80100c92 <consolewrite+0x73>
    iunlock(ip);
80100c38:	8b 45 08             	mov    0x8(%ebp),%eax
80100c3b:	89 04 24             	mov    %eax,(%esp)
80100c3e:	e8 d9 0f 00 00       	call   80101c1c <iunlock>
    acquire(&cons.lock);
80100c43:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100c4a:	e8 c4 42 00 00       	call   80104f13 <acquire>
    for(i = 0; i < n; i++)
80100c4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100c56:	eb 1b                	jmp    80100c73 <consolewrite+0x54>
      consputc(buf[i] & 0xff);
80100c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5e:	01 d0                	add    %edx,%eax
80100c60:	8a 00                	mov    (%eax),%al
80100c62:	0f be c0             	movsbl %al,%eax
80100c65:	0f b6 c0             	movzbl %al,%eax
80100c68:	89 04 24             	mov    %eax,(%esp)
80100c6b:	e8 f8 fa ff ff       	call   80100768 <consputc>
  int i;

  if (active == ip->minor-1){
    iunlock(ip);
    acquire(&cons.lock);
    for(i = 0; i < n; i++)
80100c70:	ff 45 f4             	incl   -0xc(%ebp)
80100c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100c76:	3b 45 10             	cmp    0x10(%ebp),%eax
80100c79:	7c dd                	jl     80100c58 <consolewrite+0x39>
      consputc(buf[i] & 0xff);
    release(&cons.lock);
80100c7b:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100c82:	e8 f6 42 00 00       	call   80104f7d <release>
    ilock(ip);
80100c87:	8b 45 08             	mov    0x8(%ebp),%eax
80100c8a:	89 04 24             	mov    %eax,(%esp)
80100c8d:	e8 80 0e 00 00       	call   80101b12 <ilock>
  }
  return n;
80100c92:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100c95:	c9                   	leave  
80100c96:	c3                   	ret    

80100c97 <consoleinit>:

void
consoleinit(void)
{
80100c97:	55                   	push   %ebp
80100c98:	89 e5                	mov    %esp,%ebp
80100c9a:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100c9d:	c7 44 24 04 36 95 10 	movl   $0x80109536,0x4(%esp)
80100ca4:	80 
80100ca5:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100cac:	e8 41 42 00 00       	call   80104ef2 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100cb1:	c7 05 ac 32 11 80 1f 	movl   $0x80100c1f,0x801132ac
80100cb8:	0c 10 80 
  devsw[CONSOLE].read = consoleread;
80100cbb:	c7 05 a8 32 11 80 12 	movl   $0x80100b12,0x801132a8
80100cc2:	0b 10 80 
  cons.locking = 1;
80100cc5:	c7 05 34 c6 10 80 01 	movl   $0x1,0x8010c634
80100ccc:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100ccf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100cd6:	00 
80100cd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100cde:	e8 f4 1e 00 00       	call   80102bd7 <ioapicenable>
  setactivefs("//\0");
80100ce3:	c7 04 24 3e 95 10 80 	movl   $0x8010953e,(%esp)
80100cea:	e8 6f 83 00 00       	call   8010905e <setactivefs>
}
80100cef:	c9                   	leave  
80100cf0:	c3                   	ret    
80100cf1:	00 00                	add    %al,(%eax)
	...

80100cf4 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100cf4:	55                   	push   %ebp
80100cf5:	89 e5                	mov    %esp,%ebp
80100cf7:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100cfd:	e8 01 36 00 00       	call   80104303 <myproc>
80100d02:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100d05:	e8 01 29 00 00       	call   8010360b <begin_op>

  if((ip = namei(path)) == 0){
80100d0a:	8b 45 08             	mov    0x8(%ebp),%eax
80100d0d:	89 04 24             	mov    %eax,(%esp)
80100d10:	e8 22 19 00 00       	call   80102637 <namei>
80100d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100d18:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100d1c:	75 1b                	jne    80100d39 <exec+0x45>
    end_op();
80100d1e:	e8 6a 29 00 00       	call   8010368d <end_op>
    cprintf("exec: fail\n");
80100d23:	c7 04 24 42 95 10 80 	movl   $0x80109542,(%esp)
80100d2a:	e8 92 f6 ff ff       	call   801003c1 <cprintf>
    return -1;
80100d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d34:	e9 f6 03 00 00       	jmp    8010112f <exec+0x43b>
  }
  ilock(ip);
80100d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100d3c:	89 04 24             	mov    %eax,(%esp)
80100d3f:	e8 ce 0d 00 00       	call   80101b12 <ilock>
  pgdir = 0;
80100d44:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d4b:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100d52:	00 
80100d53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100d5a:	00 
80100d5b:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100d61:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d65:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100d68:	89 04 24             	mov    %eax,(%esp)
80100d6b:	e8 39 12 00 00       	call   80101fa9 <readi>
80100d70:	83 f8 34             	cmp    $0x34,%eax
80100d73:	74 05                	je     80100d7a <exec+0x86>
    goto bad;
80100d75:	e9 89 03 00 00       	jmp    80101103 <exec+0x40f>
  if(elf.magic != ELF_MAGIC)
80100d7a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100d80:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d85:	74 05                	je     80100d8c <exec+0x98>
    goto bad;
80100d87:	e9 77 03 00 00       	jmp    80101103 <exec+0x40f>

  if((pgdir = setupkvm()) == 0)
80100d8c:	e8 f9 76 00 00       	call   8010848a <setupkvm>
80100d91:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d94:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d98:	75 05                	jne    80100d9f <exec+0xab>
    goto bad;
80100d9a:	e9 64 03 00 00       	jmp    80101103 <exec+0x40f>

  // Load program into memory.
  sz = 0;
80100d9f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100da6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100dad:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100db3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100db6:	e9 fb 00 00 00       	jmp    80100eb6 <exec+0x1c2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dbe:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100dc5:	00 
80100dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dca:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100dd7:	89 04 24             	mov    %eax,(%esp)
80100dda:	e8 ca 11 00 00       	call   80101fa9 <readi>
80100ddf:	83 f8 20             	cmp    $0x20,%eax
80100de2:	74 05                	je     80100de9 <exec+0xf5>
      goto bad;
80100de4:	e9 1a 03 00 00       	jmp    80101103 <exec+0x40f>
    if(ph.type != ELF_PROG_LOAD)
80100de9:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100def:	83 f8 01             	cmp    $0x1,%eax
80100df2:	74 05                	je     80100df9 <exec+0x105>
      continue;
80100df4:	e9 b1 00 00 00       	jmp    80100eaa <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100df9:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100dff:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100e05:	39 c2                	cmp    %eax,%edx
80100e07:	73 05                	jae    80100e0e <exec+0x11a>
      goto bad;
80100e09:	e9 f5 02 00 00       	jmp    80101103 <exec+0x40f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100e0e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e14:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100e1a:	01 c2                	add    %eax,%edx
80100e1c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100e22:	39 c2                	cmp    %eax,%edx
80100e24:	73 05                	jae    80100e2b <exec+0x137>
      goto bad;
80100e26:	e9 d8 02 00 00       	jmp    80101103 <exec+0x40f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e2b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e31:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100e37:	01 d0                	add    %edx,%eax
80100e39:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e40:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e47:	89 04 24             	mov    %eax,(%esp)
80100e4a:	e8 07 7a 00 00       	call   80108856 <allocuvm>
80100e4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e56:	75 05                	jne    80100e5d <exec+0x169>
      goto bad;
80100e58:	e9 a6 02 00 00       	jmp    80101103 <exec+0x40f>
    if(ph.vaddr % PGSIZE != 0)
80100e5d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100e63:	25 ff 0f 00 00       	and    $0xfff,%eax
80100e68:	85 c0                	test   %eax,%eax
80100e6a:	74 05                	je     80100e71 <exec+0x17d>
      goto bad;
80100e6c:	e9 92 02 00 00       	jmp    80101103 <exec+0x40f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e71:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100e77:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100e7d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100e83:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100e87:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100e8b:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100e8e:	89 54 24 08          	mov    %edx,0x8(%esp)
80100e92:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e99:	89 04 24             	mov    %eax,(%esp)
80100e9c:	e8 d2 78 00 00       	call   80108773 <loaduvm>
80100ea1:	85 c0                	test   %eax,%eax
80100ea3:	79 05                	jns    80100eaa <exec+0x1b6>
      goto bad;
80100ea5:	e9 59 02 00 00       	jmp    80101103 <exec+0x40f>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100eaa:	ff 45 ec             	incl   -0x14(%ebp)
80100ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100eb0:	83 c0 20             	add    $0x20,%eax
80100eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100eb6:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100ebc:	0f b7 c0             	movzwl %ax,%eax
80100ebf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100ec2:	0f 8f f3 fe ff ff    	jg     80100dbb <exec+0xc7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ec8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ecb:	89 04 24             	mov    %eax,(%esp)
80100ece:	e8 3e 0e 00 00       	call   80101d11 <iunlockput>
  end_op();
80100ed3:	e8 b5 27 00 00       	call   8010368d <end_op>
  ip = 0;
80100ed8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ee2:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100eec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100eef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ef2:	05 00 20 00 00       	add    $0x2000,%eax
80100ef7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100efe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f05:	89 04 24             	mov    %eax,(%esp)
80100f08:	e8 49 79 00 00       	call   80108856 <allocuvm>
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100f10:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100f14:	75 05                	jne    80100f1b <exec+0x227>
    goto bad;
80100f16:	e9 e8 01 00 00       	jmp    80101103 <exec+0x40f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f1e:	2d 00 20 00 00       	sub    $0x2000,%eax
80100f23:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f2a:	89 04 24             	mov    %eax,(%esp)
80100f2d:	e8 94 7b 00 00       	call   80108ac6 <clearpteu>
  sp = sz;
80100f32:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f35:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100f3f:	e9 95 00 00 00       	jmp    80100fd9 <exec+0x2e5>
    if(argc >= MAXARG)
80100f44:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100f48:	76 05                	jbe    80100f4f <exec+0x25b>
      goto bad;
80100f4a:	e9 b4 01 00 00       	jmp    80101103 <exec+0x40f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f59:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f5c:	01 d0                	add    %edx,%eax
80100f5e:	8b 00                	mov    (%eax),%eax
80100f60:	89 04 24             	mov    %eax,(%esp)
80100f63:	e8 8f 44 00 00       	call   801053f7 <strlen>
80100f68:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f6b:	29 c2                	sub    %eax,%edx
80100f6d:	89 d0                	mov    %edx,%eax
80100f6f:	48                   	dec    %eax
80100f70:	83 e0 fc             	and    $0xfffffffc,%eax
80100f73:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f80:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f83:	01 d0                	add    %edx,%eax
80100f85:	8b 00                	mov    (%eax),%eax
80100f87:	89 04 24             	mov    %eax,(%esp)
80100f8a:	e8 68 44 00 00       	call   801053f7 <strlen>
80100f8f:	40                   	inc    %eax
80100f90:	89 c2                	mov    %eax,%edx
80100f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f95:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f9f:	01 c8                	add    %ecx,%eax
80100fa1:	8b 00                	mov    (%eax),%eax
80100fa3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100fa7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fae:	89 44 24 04          	mov    %eax,0x4(%esp)
80100fb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100fb5:	89 04 24             	mov    %eax,(%esp)
80100fb8:	e8 c1 7c 00 00       	call   80108c7e <copyout>
80100fbd:	85 c0                	test   %eax,%eax
80100fbf:	79 05                	jns    80100fc6 <exec+0x2d2>
      goto bad;
80100fc1:	e9 3d 01 00 00       	jmp    80101103 <exec+0x40f>
    ustack[3+argc] = sp;
80100fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fc9:	8d 50 03             	lea    0x3(%eax),%edx
80100fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fcf:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100fd6:	ff 45 e4             	incl   -0x1c(%ebp)
80100fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fe6:	01 d0                	add    %edx,%eax
80100fe8:	8b 00                	mov    (%eax),%eax
80100fea:	85 c0                	test   %eax,%eax
80100fec:	0f 85 52 ff ff ff    	jne    80100f44 <exec+0x250>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff5:	83 c0 03             	add    $0x3,%eax
80100ff8:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100fff:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80101003:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
8010100a:	ff ff ff 
  ustack[1] = argc;
8010100d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101010:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	40                   	inc    %eax
8010101a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101021:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101024:	29 d0                	sub    %edx,%eax
80101026:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
8010102c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010102f:	83 c0 04             	add    $0x4,%eax
80101032:	c1 e0 02             	shl    $0x2,%eax
80101035:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010103b:	83 c0 04             	add    $0x4,%eax
8010103e:	c1 e0 02             	shl    $0x2,%eax
80101041:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101045:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
8010104b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010104f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101052:	89 44 24 04          	mov    %eax,0x4(%esp)
80101056:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101059:	89 04 24             	mov    %eax,(%esp)
8010105c:	e8 1d 7c 00 00       	call   80108c7e <copyout>
80101061:	85 c0                	test   %eax,%eax
80101063:	79 05                	jns    8010106a <exec+0x376>
    goto bad;
80101065:	e9 99 00 00 00       	jmp    80101103 <exec+0x40f>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010106a:	8b 45 08             	mov    0x8(%ebp),%eax
8010106d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101070:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101073:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101076:	eb 13                	jmp    8010108b <exec+0x397>
    if(*s == '/')
80101078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010107b:	8a 00                	mov    (%eax),%al
8010107d:	3c 2f                	cmp    $0x2f,%al
8010107f:	75 07                	jne    80101088 <exec+0x394>
      last = s+1;
80101081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101084:	40                   	inc    %eax
80101085:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101088:	ff 45 f4             	incl   -0xc(%ebp)
8010108b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010108e:	8a 00                	mov    (%eax),%al
80101090:	84 c0                	test   %al,%al
80101092:	75 e4                	jne    80101078 <exec+0x384>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101094:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101097:	8d 50 6c             	lea    0x6c(%eax),%edx
8010109a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801010a1:	00 
801010a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801010a9:	89 14 24             	mov    %edx,(%esp)
801010ac:	e8 ff 42 00 00       	call   801053b0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
801010ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801010c0:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
801010c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
801010c9:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
801010cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010ce:	8b 40 18             	mov    0x18(%eax),%eax
801010d1:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
801010d7:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801010da:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010dd:	8b 40 18             	mov    0x18(%eax),%eax
801010e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801010e3:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
801010e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010e9:	89 04 24             	mov    %eax,(%esp)
801010ec:	e8 73 74 00 00       	call   80108564 <switchuvm>
  freevm(oldpgdir);
801010f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801010f4:	89 04 24             	mov    %eax,(%esp)
801010f7:	e8 34 79 00 00       	call   80108a30 <freevm>
  return 0;
801010fc:	b8 00 00 00 00       	mov    $0x0,%eax
80101101:	eb 2c                	jmp    8010112f <exec+0x43b>

 bad:
  if(pgdir)
80101103:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101107:	74 0b                	je     80101114 <exec+0x420>
    freevm(pgdir);
80101109:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010110c:	89 04 24             	mov    %eax,(%esp)
8010110f:	e8 1c 79 00 00       	call   80108a30 <freevm>
  if(ip){
80101114:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101118:	74 10                	je     8010112a <exec+0x436>
    iunlockput(ip);
8010111a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010111d:	89 04 24             	mov    %eax,(%esp)
80101120:	e8 ec 0b 00 00       	call   80101d11 <iunlockput>
    end_op();
80101125:	e8 63 25 00 00       	call   8010368d <end_op>
  }
  return -1;
8010112a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010112f:	c9                   	leave  
80101130:	c3                   	ret    
80101131:	00 00                	add    %al,(%eax)
	...

80101134 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101134:	55                   	push   %ebp
80101135:	89 e5                	mov    %esp,%ebp
80101137:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
8010113a:	c7 44 24 04 4e 95 10 	movl   $0x8010954e,0x4(%esp)
80101141:	80 
80101142:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80101149:	e8 a4 3d 00 00       	call   80104ef2 <initlock>
}
8010114e:	c9                   	leave  
8010114f:	c3                   	ret    

80101150 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80101156:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
8010115d:	e8 b1 3d 00 00       	call   80104f13 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101162:	c7 45 f4 34 29 11 80 	movl   $0x80112934,-0xc(%ebp)
80101169:	eb 29                	jmp    80101194 <filealloc+0x44>
    if(f->ref == 0){
8010116b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010116e:	8b 40 04             	mov    0x4(%eax),%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	75 1b                	jne    80101190 <filealloc+0x40>
      f->ref = 1;
80101175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101178:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010117f:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80101186:	e8 f2 3d 00 00       	call   80104f7d <release>
      return f;
8010118b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010118e:	eb 1e                	jmp    801011ae <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101190:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101194:	81 7d f4 94 32 11 80 	cmpl   $0x80113294,-0xc(%ebp)
8010119b:	72 ce                	jb     8010116b <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010119d:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
801011a4:	e8 d4 3d 00 00       	call   80104f7d <release>
  return 0;
801011a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801011ae:	c9                   	leave  
801011af:	c3                   	ret    

801011b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
801011b6:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
801011bd:	e8 51 3d 00 00       	call   80104f13 <acquire>
  if(f->ref < 1)
801011c2:	8b 45 08             	mov    0x8(%ebp),%eax
801011c5:	8b 40 04             	mov    0x4(%eax),%eax
801011c8:	85 c0                	test   %eax,%eax
801011ca:	7f 0c                	jg     801011d8 <filedup+0x28>
    panic("filedup");
801011cc:	c7 04 24 55 95 10 80 	movl   $0x80109555,(%esp)
801011d3:	e8 7c f3 ff ff       	call   80100554 <panic>
  f->ref++;
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	8b 40 04             	mov    0x4(%eax),%eax
801011de:	8d 50 01             	lea    0x1(%eax),%edx
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801011e7:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
801011ee:	e8 8a 3d 00 00       	call   80104f7d <release>
  return f;
801011f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801011f6:	c9                   	leave  
801011f7:	c3                   	ret    

801011f8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011f8:	55                   	push   %ebp
801011f9:	89 e5                	mov    %esp,%ebp
801011fb:	57                   	push   %edi
801011fc:	56                   	push   %esi
801011fd:	53                   	push   %ebx
801011fe:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80101201:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80101208:	e8 06 3d 00 00       	call   80104f13 <acquire>
  if(f->ref < 1)
8010120d:	8b 45 08             	mov    0x8(%ebp),%eax
80101210:	8b 40 04             	mov    0x4(%eax),%eax
80101213:	85 c0                	test   %eax,%eax
80101215:	7f 0c                	jg     80101223 <fileclose+0x2b>
    panic("fileclose");
80101217:	c7 04 24 5d 95 10 80 	movl   $0x8010955d,(%esp)
8010121e:	e8 31 f3 ff ff       	call   80100554 <panic>
  if(--f->ref > 0){
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 40 04             	mov    0x4(%eax),%eax
80101229:	8d 50 ff             	lea    -0x1(%eax),%edx
8010122c:	8b 45 08             	mov    0x8(%ebp),%eax
8010122f:	89 50 04             	mov    %edx,0x4(%eax)
80101232:	8b 45 08             	mov    0x8(%ebp),%eax
80101235:	8b 40 04             	mov    0x4(%eax),%eax
80101238:	85 c0                	test   %eax,%eax
8010123a:	7e 0e                	jle    8010124a <fileclose+0x52>
    release(&ftable.lock);
8010123c:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80101243:	e8 35 3d 00 00       	call   80104f7d <release>
80101248:	eb 70                	jmp    801012ba <fileclose+0xc2>
    return;
  }
  ff = *f;
8010124a:	8b 45 08             	mov    0x8(%ebp),%eax
8010124d:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101250:	89 c3                	mov    %eax,%ebx
80101252:	b8 06 00 00 00       	mov    $0x6,%eax
80101257:	89 d7                	mov    %edx,%edi
80101259:	89 de                	mov    %ebx,%esi
8010125b:	89 c1                	mov    %eax,%ecx
8010125d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010125f:	8b 45 08             	mov    0x8(%ebp),%eax
80101262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101269:	8b 45 08             	mov    0x8(%ebp),%eax
8010126c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101272:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80101279:	e8 ff 3c 00 00       	call   80104f7d <release>

  if(ff.type == FD_PIPE)
8010127e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101281:	83 f8 01             	cmp    $0x1,%eax
80101284:	75 17                	jne    8010129d <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
80101286:	8a 45 d9             	mov    -0x27(%ebp),%al
80101289:	0f be d0             	movsbl %al,%edx
8010128c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010128f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101293:	89 04 24             	mov    %eax,(%esp)
80101296:	e8 00 2d 00 00       	call   80103f9b <pipeclose>
8010129b:	eb 1d                	jmp    801012ba <fileclose+0xc2>
  else if(ff.type == FD_INODE){
8010129d:	8b 45 d0             	mov    -0x30(%ebp),%eax
801012a0:	83 f8 02             	cmp    $0x2,%eax
801012a3:	75 15                	jne    801012ba <fileclose+0xc2>
    begin_op();
801012a5:	e8 61 23 00 00       	call   8010360b <begin_op>
    iput(ff.ip);
801012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012ad:	89 04 24             	mov    %eax,(%esp)
801012b0:	e8 ab 09 00 00       	call   80101c60 <iput>
    end_op();
801012b5:	e8 d3 23 00 00       	call   8010368d <end_op>
  }
}
801012ba:	83 c4 3c             	add    $0x3c,%esp
801012bd:	5b                   	pop    %ebx
801012be:	5e                   	pop    %esi
801012bf:	5f                   	pop    %edi
801012c0:	5d                   	pop    %ebp
801012c1:	c3                   	ret    

801012c2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012c2:	55                   	push   %ebp
801012c3:	89 e5                	mov    %esp,%ebp
801012c5:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 00                	mov    (%eax),%eax
801012cd:	83 f8 02             	cmp    $0x2,%eax
801012d0:	75 38                	jne    8010130a <filestat+0x48>
    ilock(f->ip);
801012d2:	8b 45 08             	mov    0x8(%ebp),%eax
801012d5:	8b 40 10             	mov    0x10(%eax),%eax
801012d8:	89 04 24             	mov    %eax,(%esp)
801012db:	e8 32 08 00 00       	call   80101b12 <ilock>
    stati(f->ip, st);
801012e0:	8b 45 08             	mov    0x8(%ebp),%eax
801012e3:	8b 40 10             	mov    0x10(%eax),%eax
801012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
801012e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801012ed:	89 04 24             	mov    %eax,(%esp)
801012f0:	e8 70 0c 00 00       	call   80101f65 <stati>
    iunlock(f->ip);
801012f5:	8b 45 08             	mov    0x8(%ebp),%eax
801012f8:	8b 40 10             	mov    0x10(%eax),%eax
801012fb:	89 04 24             	mov    %eax,(%esp)
801012fe:	e8 19 09 00 00       	call   80101c1c <iunlock>
    return 0;
80101303:	b8 00 00 00 00       	mov    $0x0,%eax
80101308:	eb 05                	jmp    8010130f <filestat+0x4d>
  }
  return -1;
8010130a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010130f:	c9                   	leave  
80101310:	c3                   	ret    

80101311 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101311:	55                   	push   %ebp
80101312:	89 e5                	mov    %esp,%ebp
80101314:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101317:	8b 45 08             	mov    0x8(%ebp),%eax
8010131a:	8a 40 08             	mov    0x8(%eax),%al
8010131d:	84 c0                	test   %al,%al
8010131f:	75 0a                	jne    8010132b <fileread+0x1a>
    return -1;
80101321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101326:	e9 9f 00 00 00       	jmp    801013ca <fileread+0xb9>
  if(f->type == FD_PIPE)
8010132b:	8b 45 08             	mov    0x8(%ebp),%eax
8010132e:	8b 00                	mov    (%eax),%eax
80101330:	83 f8 01             	cmp    $0x1,%eax
80101333:	75 1e                	jne    80101353 <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 40 0c             	mov    0xc(%eax),%eax
8010133b:	8b 55 10             	mov    0x10(%ebp),%edx
8010133e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101342:	8b 55 0c             	mov    0xc(%ebp),%edx
80101345:	89 54 24 04          	mov    %edx,0x4(%esp)
80101349:	89 04 24             	mov    %eax,(%esp)
8010134c:	e8 c8 2d 00 00       	call   80104119 <piperead>
80101351:	eb 77                	jmp    801013ca <fileread+0xb9>
  if(f->type == FD_INODE){
80101353:	8b 45 08             	mov    0x8(%ebp),%eax
80101356:	8b 00                	mov    (%eax),%eax
80101358:	83 f8 02             	cmp    $0x2,%eax
8010135b:	75 61                	jne    801013be <fileread+0xad>
    ilock(f->ip);
8010135d:	8b 45 08             	mov    0x8(%ebp),%eax
80101360:	8b 40 10             	mov    0x10(%eax),%eax
80101363:	89 04 24             	mov    %eax,(%esp)
80101366:	e8 a7 07 00 00       	call   80101b12 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010136b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010136e:	8b 45 08             	mov    0x8(%ebp),%eax
80101371:	8b 50 14             	mov    0x14(%eax),%edx
80101374:	8b 45 08             	mov    0x8(%ebp),%eax
80101377:	8b 40 10             	mov    0x10(%eax),%eax
8010137a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010137e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101382:	8b 55 0c             	mov    0xc(%ebp),%edx
80101385:	89 54 24 04          	mov    %edx,0x4(%esp)
80101389:	89 04 24             	mov    %eax,(%esp)
8010138c:	e8 18 0c 00 00       	call   80101fa9 <readi>
80101391:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101398:	7e 11                	jle    801013ab <fileread+0x9a>
      f->off += r;
8010139a:	8b 45 08             	mov    0x8(%ebp),%eax
8010139d:	8b 50 14             	mov    0x14(%eax),%edx
801013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a3:	01 c2                	add    %eax,%edx
801013a5:	8b 45 08             	mov    0x8(%ebp),%eax
801013a8:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801013ab:	8b 45 08             	mov    0x8(%ebp),%eax
801013ae:	8b 40 10             	mov    0x10(%eax),%eax
801013b1:	89 04 24             	mov    %eax,(%esp)
801013b4:	e8 63 08 00 00       	call   80101c1c <iunlock>
    return r;
801013b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013bc:	eb 0c                	jmp    801013ca <fileread+0xb9>
  }
  panic("fileread");
801013be:	c7 04 24 67 95 10 80 	movl   $0x80109567,(%esp)
801013c5:	e8 8a f1 ff ff       	call   80100554 <panic>
}
801013ca:	c9                   	leave  
801013cb:	c3                   	ret    

801013cc <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013cc:	55                   	push   %ebp
801013cd:	89 e5                	mov    %esp,%ebp
801013cf:	53                   	push   %ebx
801013d0:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801013d3:	8b 45 08             	mov    0x8(%ebp),%eax
801013d6:	8a 40 09             	mov    0x9(%eax),%al
801013d9:	84 c0                	test   %al,%al
801013db:	75 0a                	jne    801013e7 <filewrite+0x1b>
    return -1;
801013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013e2:	e9 20 01 00 00       	jmp    80101507 <filewrite+0x13b>
  if(f->type == FD_PIPE)
801013e7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ea:	8b 00                	mov    (%eax),%eax
801013ec:	83 f8 01             	cmp    $0x1,%eax
801013ef:	75 21                	jne    80101412 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
801013f1:	8b 45 08             	mov    0x8(%ebp),%eax
801013f4:	8b 40 0c             	mov    0xc(%eax),%eax
801013f7:	8b 55 10             	mov    0x10(%ebp),%edx
801013fa:	89 54 24 08          	mov    %edx,0x8(%esp)
801013fe:	8b 55 0c             	mov    0xc(%ebp),%edx
80101401:	89 54 24 04          	mov    %edx,0x4(%esp)
80101405:	89 04 24             	mov    %eax,(%esp)
80101408:	e8 20 2c 00 00       	call   8010402d <pipewrite>
8010140d:	e9 f5 00 00 00       	jmp    80101507 <filewrite+0x13b>
  if(f->type == FD_INODE){
80101412:	8b 45 08             	mov    0x8(%ebp),%eax
80101415:	8b 00                	mov    (%eax),%eax
80101417:	83 f8 02             	cmp    $0x2,%eax
8010141a:	0f 85 db 00 00 00    	jne    801014fb <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101420:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010142e:	e9 a8 00 00 00       	jmp    801014db <filewrite+0x10f>
      int n1 = n - i;
80101433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101436:	8b 55 10             	mov    0x10(%ebp),%edx
80101439:	29 c2                	sub    %eax,%edx
8010143b:	89 d0                	mov    %edx,%eax
8010143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101440:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101443:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101446:	7e 06                	jle    8010144e <filewrite+0x82>
        n1 = max;
80101448:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010144b:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010144e:	e8 b8 21 00 00       	call   8010360b <begin_op>
      ilock(f->ip);
80101453:	8b 45 08             	mov    0x8(%ebp),%eax
80101456:	8b 40 10             	mov    0x10(%eax),%eax
80101459:	89 04 24             	mov    %eax,(%esp)
8010145c:	e8 b1 06 00 00       	call   80101b12 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101461:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101464:	8b 45 08             	mov    0x8(%ebp),%eax
80101467:	8b 50 14             	mov    0x14(%eax),%edx
8010146a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010146d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101470:	01 c3                	add    %eax,%ebx
80101472:	8b 45 08             	mov    0x8(%ebp),%eax
80101475:	8b 40 10             	mov    0x10(%eax),%eax
80101478:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010147c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101480:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101484:	89 04 24             	mov    %eax,(%esp)
80101487:	e8 81 0c 00 00       	call   8010210d <writei>
8010148c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010148f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101493:	7e 11                	jle    801014a6 <filewrite+0xda>
        f->off += r;
80101495:	8b 45 08             	mov    0x8(%ebp),%eax
80101498:	8b 50 14             	mov    0x14(%eax),%edx
8010149b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010149e:	01 c2                	add    %eax,%edx
801014a0:	8b 45 08             	mov    0x8(%ebp),%eax
801014a3:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801014a6:	8b 45 08             	mov    0x8(%ebp),%eax
801014a9:	8b 40 10             	mov    0x10(%eax),%eax
801014ac:	89 04 24             	mov    %eax,(%esp)
801014af:	e8 68 07 00 00       	call   80101c1c <iunlock>
      end_op();
801014b4:	e8 d4 21 00 00       	call   8010368d <end_op>

      if(r < 0)
801014b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801014bd:	79 02                	jns    801014c1 <filewrite+0xf5>
        break;
801014bf:	eb 26                	jmp    801014e7 <filewrite+0x11b>
      if(r != n1)
801014c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801014c7:	74 0c                	je     801014d5 <filewrite+0x109>
        panic("short filewrite");
801014c9:	c7 04 24 70 95 10 80 	movl   $0x80109570,(%esp)
801014d0:	e8 7f f0 ff ff       	call   80100554 <panic>
      i += r;
801014d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014d8:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801014db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014de:	3b 45 10             	cmp    0x10(%ebp),%eax
801014e1:	0f 8c 4c ff ff ff    	jl     80101433 <filewrite+0x67>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ea:	3b 45 10             	cmp    0x10(%ebp),%eax
801014ed:	75 05                	jne    801014f4 <filewrite+0x128>
801014ef:	8b 45 10             	mov    0x10(%ebp),%eax
801014f2:	eb 05                	jmp    801014f9 <filewrite+0x12d>
801014f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014f9:	eb 0c                	jmp    80101507 <filewrite+0x13b>
  }
  panic("filewrite");
801014fb:	c7 04 24 80 95 10 80 	movl   $0x80109580,(%esp)
80101502:	e8 4d f0 ff ff       	call   80100554 <panic>
}
80101507:	83 c4 24             	add    $0x24,%esp
8010150a:	5b                   	pop    %ebx
8010150b:	5d                   	pop    %ebp
8010150c:	c3                   	ret    
8010150d:	00 00                	add    %al,(%eax)
	...

80101510 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101516:	8b 45 08             	mov    0x8(%ebp),%eax
80101519:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101520:	00 
80101521:	89 04 24             	mov    %eax,(%esp)
80101524:	e8 8c ec ff ff       	call   801001b5 <bread>
80101529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010152c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010152f:	83 c0 5c             	add    $0x5c,%eax
80101532:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101539:	00 
8010153a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010153e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101541:	89 04 24             	mov    %eax,(%esp)
80101544:	e8 f6 3c 00 00       	call   8010523f <memmove>
  brelse(bp);
80101549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010154c:	89 04 24             	mov    %eax,(%esp)
8010154f:	e8 d8 ec ff ff       	call   8010022c <brelse>
}
80101554:	c9                   	leave  
80101555:	c3                   	ret    

80101556 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101556:	55                   	push   %ebp
80101557:	89 e5                	mov    %esp,%ebp
80101559:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010155c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010155f:	8b 45 08             	mov    0x8(%ebp),%eax
80101562:	89 54 24 04          	mov    %edx,0x4(%esp)
80101566:	89 04 24             	mov    %eax,(%esp)
80101569:	e8 47 ec ff ff       	call   801001b5 <bread>
8010156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101574:	83 c0 5c             	add    $0x5c,%eax
80101577:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010157e:	00 
8010157f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101586:	00 
80101587:	89 04 24             	mov    %eax,(%esp)
8010158a:	e8 e7 3b 00 00       	call   80105176 <memset>
  log_write(bp);
8010158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101592:	89 04 24             	mov    %eax,(%esp)
80101595:	e8 75 22 00 00       	call   8010380f <log_write>
  brelse(bp);
8010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159d:	89 04 24             	mov    %eax,(%esp)
801015a0:	e8 87 ec ff ff       	call   8010022c <brelse>
}
801015a5:	c9                   	leave  
801015a6:	c3                   	ret    

801015a7 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801015a7:	55                   	push   %ebp
801015a8:	89 e5                	mov    %esp,%ebp
801015aa:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801015ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801015bb:	e9 03 01 00 00       	jmp    801016c3 <balloc+0x11c>
    bp = bread(dev, BBLOCK(b, sb));
801015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015c3:	85 c0                	test   %eax,%eax
801015c5:	79 05                	jns    801015cc <balloc+0x25>
801015c7:	05 ff 0f 00 00       	add    $0xfff,%eax
801015cc:	c1 f8 0c             	sar    $0xc,%eax
801015cf:	89 c2                	mov    %eax,%edx
801015d1:	a1 18 33 11 80       	mov    0x80113318,%eax
801015d6:	01 d0                	add    %edx,%eax
801015d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801015dc:	8b 45 08             	mov    0x8(%ebp),%eax
801015df:	89 04 24             	mov    %eax,(%esp)
801015e2:	e8 ce eb ff ff       	call   801001b5 <bread>
801015e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015f1:	e9 9b 00 00 00       	jmp    80101691 <balloc+0xea>
      m = 1 << (bi % 8);
801015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f9:	25 07 00 00 80       	and    $0x80000007,%eax
801015fe:	85 c0                	test   %eax,%eax
80101600:	79 05                	jns    80101607 <balloc+0x60>
80101602:	48                   	dec    %eax
80101603:	83 c8 f8             	or     $0xfffffff8,%eax
80101606:	40                   	inc    %eax
80101607:	ba 01 00 00 00       	mov    $0x1,%edx
8010160c:	88 c1                	mov    %al,%cl
8010160e:	d3 e2                	shl    %cl,%edx
80101610:	89 d0                	mov    %edx,%eax
80101612:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101615:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101618:	85 c0                	test   %eax,%eax
8010161a:	79 03                	jns    8010161f <balloc+0x78>
8010161c:	83 c0 07             	add    $0x7,%eax
8010161f:	c1 f8 03             	sar    $0x3,%eax
80101622:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101625:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101629:	0f b6 c0             	movzbl %al,%eax
8010162c:	23 45 e8             	and    -0x18(%ebp),%eax
8010162f:	85 c0                	test   %eax,%eax
80101631:	75 5b                	jne    8010168e <balloc+0xe7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101636:	85 c0                	test   %eax,%eax
80101638:	79 03                	jns    8010163d <balloc+0x96>
8010163a:	83 c0 07             	add    $0x7,%eax
8010163d:	c1 f8 03             	sar    $0x3,%eax
80101640:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101643:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101647:	88 d1                	mov    %dl,%cl
80101649:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010164c:	09 ca                	or     %ecx,%edx
8010164e:	88 d1                	mov    %dl,%cl
80101650:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101653:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101657:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010165a:	89 04 24             	mov    %eax,(%esp)
8010165d:	e8 ad 21 00 00       	call   8010380f <log_write>
        brelse(bp);
80101662:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101665:	89 04 24             	mov    %eax,(%esp)
80101668:	e8 bf eb ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
8010166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101670:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101673:	01 c2                	add    %eax,%edx
80101675:	8b 45 08             	mov    0x8(%ebp),%eax
80101678:	89 54 24 04          	mov    %edx,0x4(%esp)
8010167c:	89 04 24             	mov    %eax,(%esp)
8010167f:	e8 d2 fe ff ff       	call   80101556 <bzero>
        return b + bi;
80101684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101687:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010168a:	01 d0                	add    %edx,%eax
8010168c:	eb 51                	jmp    801016df <balloc+0x138>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010168e:	ff 45 f0             	incl   -0x10(%ebp)
80101691:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101698:	7f 17                	jg     801016b1 <balloc+0x10a>
8010169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a0:	01 d0                	add    %edx,%eax
801016a2:	89 c2                	mov    %eax,%edx
801016a4:	a1 00 33 11 80       	mov    0x80113300,%eax
801016a9:	39 c2                	cmp    %eax,%edx
801016ab:	0f 82 45 ff ff ff    	jb     801015f6 <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016b4:	89 04 24             	mov    %eax,(%esp)
801016b7:	e8 70 eb ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801016bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801016c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c6:	a1 00 33 11 80       	mov    0x80113300,%eax
801016cb:	39 c2                	cmp    %eax,%edx
801016cd:	0f 82 ed fe ff ff    	jb     801015c0 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016d3:	c7 04 24 8c 95 10 80 	movl   $0x8010958c,(%esp)
801016da:	e8 75 ee ff ff       	call   80100554 <panic>
}
801016df:	c9                   	leave  
801016e0:	c3                   	ret    

801016e1 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016e1:	55                   	push   %ebp
801016e2:	89 e5                	mov    %esp,%ebp
801016e4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016e7:	c7 44 24 04 00 33 11 	movl   $0x80113300,0x4(%esp)
801016ee:	80 
801016ef:	8b 45 08             	mov    0x8(%ebp),%eax
801016f2:	89 04 24             	mov    %eax,(%esp)
801016f5:	e8 16 fe ff ff       	call   80101510 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801016fd:	c1 e8 0c             	shr    $0xc,%eax
80101700:	89 c2                	mov    %eax,%edx
80101702:	a1 18 33 11 80       	mov    0x80113318,%eax
80101707:	01 c2                	add    %eax,%edx
80101709:	8b 45 08             	mov    0x8(%ebp),%eax
8010170c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101710:	89 04 24             	mov    %eax,(%esp)
80101713:	e8 9d ea ff ff       	call   801001b5 <bread>
80101718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010171b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010171e:	25 ff 0f 00 00       	and    $0xfff,%eax
80101723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101729:	25 07 00 00 80       	and    $0x80000007,%eax
8010172e:	85 c0                	test   %eax,%eax
80101730:	79 05                	jns    80101737 <bfree+0x56>
80101732:	48                   	dec    %eax
80101733:	83 c8 f8             	or     $0xfffffff8,%eax
80101736:	40                   	inc    %eax
80101737:	ba 01 00 00 00       	mov    $0x1,%edx
8010173c:	88 c1                	mov    %al,%cl
8010173e:	d3 e2                	shl    %cl,%edx
80101740:	89 d0                	mov    %edx,%eax
80101742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101745:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101748:	85 c0                	test   %eax,%eax
8010174a:	79 03                	jns    8010174f <bfree+0x6e>
8010174c:	83 c0 07             	add    $0x7,%eax
8010174f:	c1 f8 03             	sar    $0x3,%eax
80101752:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101755:	8a 44 02 5c          	mov    0x5c(%edx,%eax,1),%al
80101759:	0f b6 c0             	movzbl %al,%eax
8010175c:	23 45 ec             	and    -0x14(%ebp),%eax
8010175f:	85 c0                	test   %eax,%eax
80101761:	75 0c                	jne    8010176f <bfree+0x8e>
    panic("freeing free block");
80101763:	c7 04 24 a2 95 10 80 	movl   $0x801095a2,(%esp)
8010176a:	e8 e5 ed ff ff       	call   80100554 <panic>
  bp->data[bi/8] &= ~m;
8010176f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	79 03                	jns    80101779 <bfree+0x98>
80101776:	83 c0 07             	add    $0x7,%eax
80101779:	c1 f8 03             	sar    $0x3,%eax
8010177c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010177f:	8a 54 02 5c          	mov    0x5c(%edx,%eax,1),%dl
80101783:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101786:	f7 d1                	not    %ecx
80101788:	21 ca                	and    %ecx,%edx
8010178a:	88 d1                	mov    %dl,%cl
8010178c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010178f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101796:	89 04 24             	mov    %eax,(%esp)
80101799:	e8 71 20 00 00       	call   8010380f <log_write>
  brelse(bp);
8010179e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a1:	89 04 24             	mov    %eax,(%esp)
801017a4:	e8 83 ea ff ff       	call   8010022c <brelse>
}
801017a9:	c9                   	leave  
801017aa:	c3                   	ret    

801017ab <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801017ab:	55                   	push   %ebp
801017ac:	89 e5                	mov    %esp,%ebp
801017ae:	57                   	push   %edi
801017af:	56                   	push   %esi
801017b0:	53                   	push   %ebx
801017b1:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801017b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801017bb:	c7 44 24 04 b5 95 10 	movl   $0x801095b5,0x4(%esp)
801017c2:	80 
801017c3:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
801017ca:	e8 23 37 00 00       	call   80104ef2 <initlock>
  for(i = 0; i < NINODE; i++) {
801017cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801017d6:	eb 2b                	jmp    80101803 <iinit+0x58>
    initsleeplock(&icache.inode[i].lock, "inode");
801017d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017db:	89 d0                	mov    %edx,%eax
801017dd:	c1 e0 03             	shl    $0x3,%eax
801017e0:	01 d0                	add    %edx,%eax
801017e2:	c1 e0 04             	shl    $0x4,%eax
801017e5:	83 c0 30             	add    $0x30,%eax
801017e8:	05 20 33 11 80       	add    $0x80113320,%eax
801017ed:	83 c0 10             	add    $0x10,%eax
801017f0:	c7 44 24 04 bc 95 10 	movl   $0x801095bc,0x4(%esp)
801017f7:	80 
801017f8:	89 04 24             	mov    %eax,(%esp)
801017fb:	e8 b4 35 00 00       	call   80104db4 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101800:	ff 45 e4             	incl   -0x1c(%ebp)
80101803:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101807:	7e cf                	jle    801017d8 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
80101809:	c7 44 24 04 00 33 11 	movl   $0x80113300,0x4(%esp)
80101810:	80 
80101811:	8b 45 08             	mov    0x8(%ebp),%eax
80101814:	89 04 24             	mov    %eax,(%esp)
80101817:	e8 f4 fc ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010181c:	a1 18 33 11 80       	mov    0x80113318,%eax
80101821:	8b 3d 14 33 11 80    	mov    0x80113314,%edi
80101827:	8b 35 10 33 11 80    	mov    0x80113310,%esi
8010182d:	8b 1d 0c 33 11 80    	mov    0x8011330c,%ebx
80101833:	8b 0d 08 33 11 80    	mov    0x80113308,%ecx
80101839:	8b 15 04 33 11 80    	mov    0x80113304,%edx
8010183f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80101842:	8b 15 00 33 11 80    	mov    0x80113300,%edx
80101848:	89 44 24 1c          	mov    %eax,0x1c(%esp)
8010184c:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101850:	89 74 24 14          	mov    %esi,0x14(%esp)
80101854:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101858:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010185c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010185f:	89 44 24 08          	mov    %eax,0x8(%esp)
80101863:	89 d0                	mov    %edx,%eax
80101865:	89 44 24 04          	mov    %eax,0x4(%esp)
80101869:	c7 04 24 c4 95 10 80 	movl   $0x801095c4,(%esp)
80101870:	e8 4c eb ff ff       	call   801003c1 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101875:	83 c4 4c             	add    $0x4c,%esp
80101878:	5b                   	pop    %ebx
80101879:	5e                   	pop    %esi
8010187a:	5f                   	pop    %edi
8010187b:	5d                   	pop    %ebp
8010187c:	c3                   	ret    

8010187d <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010187d:	55                   	push   %ebp
8010187e:	89 e5                	mov    %esp,%ebp
80101880:	83 ec 28             	sub    $0x28,%esp
80101883:	8b 45 0c             	mov    0xc(%ebp),%eax
80101886:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010188a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101891:	e9 9b 00 00 00       	jmp    80101931 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
80101896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101899:	c1 e8 03             	shr    $0x3,%eax
8010189c:	89 c2                	mov    %eax,%edx
8010189e:	a1 14 33 11 80       	mov    0x80113314,%eax
801018a3:	01 d0                	add    %edx,%eax
801018a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801018a9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ac:	89 04 24             	mov    %eax,(%esp)
801018af:	e8 01 e9 ff ff       	call   801001b5 <bread>
801018b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801018b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ba:	8d 50 5c             	lea    0x5c(%eax),%edx
801018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c0:	83 e0 07             	and    $0x7,%eax
801018c3:	c1 e0 06             	shl    $0x6,%eax
801018c6:	01 d0                	add    %edx,%eax
801018c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801018cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018ce:	8b 00                	mov    (%eax),%eax
801018d0:	66 85 c0             	test   %ax,%ax
801018d3:	75 4e                	jne    80101923 <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
801018d5:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801018dc:	00 
801018dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801018e4:	00 
801018e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018e8:	89 04 24             	mov    %eax,(%esp)
801018eb:	e8 86 38 00 00       	call   80105176 <memset>
      dip->type = type;
801018f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801018f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f6:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801018f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018fc:	89 04 24             	mov    %eax,(%esp)
801018ff:	e8 0b 1f 00 00       	call   8010380f <log_write>
      brelse(bp);
80101904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101907:	89 04 24             	mov    %eax,(%esp)
8010190a:	e8 1d e9 ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
8010190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101912:	89 44 24 04          	mov    %eax,0x4(%esp)
80101916:	8b 45 08             	mov    0x8(%ebp),%eax
80101919:	89 04 24             	mov    %eax,(%esp)
8010191c:	e8 ea 00 00 00       	call   80101a0b <iget>
80101921:	eb 2a                	jmp    8010194d <ialloc+0xd0>
    }
    brelse(bp);
80101923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101926:	89 04 24             	mov    %eax,(%esp)
80101929:	e8 fe e8 ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010192e:	ff 45 f4             	incl   -0xc(%ebp)
80101931:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101934:	a1 08 33 11 80       	mov    0x80113308,%eax
80101939:	39 c2                	cmp    %eax,%edx
8010193b:	0f 82 55 ff ff ff    	jb     80101896 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101941:	c7 04 24 17 96 10 80 	movl   $0x80109617,(%esp)
80101948:	e8 07 ec ff ff       	call   80100554 <panic>
}
8010194d:	c9                   	leave  
8010194e:	c3                   	ret    

8010194f <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
8010194f:	55                   	push   %ebp
80101950:	89 e5                	mov    %esp,%ebp
80101952:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101955:	8b 45 08             	mov    0x8(%ebp),%eax
80101958:	8b 40 04             	mov    0x4(%eax),%eax
8010195b:	c1 e8 03             	shr    $0x3,%eax
8010195e:	89 c2                	mov    %eax,%edx
80101960:	a1 14 33 11 80       	mov    0x80113314,%eax
80101965:	01 c2                	add    %eax,%edx
80101967:	8b 45 08             	mov    0x8(%ebp),%eax
8010196a:	8b 00                	mov    (%eax),%eax
8010196c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101970:	89 04 24             	mov    %eax,(%esp)
80101973:	e8 3d e8 ff ff       	call   801001b5 <bread>
80101978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197e:	8d 50 5c             	lea    0x5c(%eax),%edx
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 04             	mov    0x4(%eax),%eax
80101987:	83 e0 07             	and    $0x7,%eax
8010198a:	c1 e0 06             	shl    $0x6,%eax
8010198d:	01 d0                	add    %edx,%eax
8010198f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101992:	8b 45 08             	mov    0x8(%ebp),%eax
80101995:	8b 40 50             	mov    0x50(%eax),%eax
80101998:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010199b:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	66 8b 40 52          	mov    0x52(%eax),%ax
801019a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019a8:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801019ac:	8b 45 08             	mov    0x8(%ebp),%eax
801019af:	8b 40 54             	mov    0x54(%eax),%eax
801019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019b5:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	66 8b 40 56          	mov    0x56(%eax),%ax
801019c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801019c3:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	8b 50 58             	mov    0x58(%eax),%edx
801019cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d0:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019d3:	8b 45 08             	mov    0x8(%ebp),%eax
801019d6:	8d 50 5c             	lea    0x5c(%eax),%edx
801019d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019dc:	83 c0 0c             	add    $0xc,%eax
801019df:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019e6:	00 
801019e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801019eb:	89 04 24             	mov    %eax,(%esp)
801019ee:	e8 4c 38 00 00       	call   8010523f <memmove>
  log_write(bp);
801019f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f6:	89 04 24             	mov    %eax,(%esp)
801019f9:	e8 11 1e 00 00       	call   8010380f <log_write>
  brelse(bp);
801019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a01:	89 04 24             	mov    %eax,(%esp)
80101a04:	e8 23 e8 ff ff       	call   8010022c <brelse>
}
80101a09:	c9                   	leave  
80101a0a:	c3                   	ret    

80101a0b <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101a0b:	55                   	push   %ebp
80101a0c:	89 e5                	mov    %esp,%ebp
80101a0e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101a11:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101a18:	e8 f6 34 00 00       	call   80104f13 <acquire>

  // Is the inode already cached?
  empty = 0;
80101a1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a24:	c7 45 f4 54 33 11 80 	movl   $0x80113354,-0xc(%ebp)
80101a2b:	eb 5c                	jmp    80101a89 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a30:	8b 40 08             	mov    0x8(%eax),%eax
80101a33:	85 c0                	test   %eax,%eax
80101a35:	7e 35                	jle    80101a6c <iget+0x61>
80101a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3a:	8b 00                	mov    (%eax),%eax
80101a3c:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a3f:	75 2b                	jne    80101a6c <iget+0x61>
80101a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a44:	8b 40 04             	mov    0x4(%eax),%eax
80101a47:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a4a:	75 20                	jne    80101a6c <iget+0x61>
      ip->ref++;
80101a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4f:	8b 40 08             	mov    0x8(%eax),%eax
80101a52:	8d 50 01             	lea    0x1(%eax),%edx
80101a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a58:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a5b:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101a62:	e8 16 35 00 00       	call   80104f7d <release>
      return ip;
80101a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a6a:	eb 72                	jmp    80101ade <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a70:	75 10                	jne    80101a82 <iget+0x77>
80101a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a75:	8b 40 08             	mov    0x8(%eax),%eax
80101a78:	85 c0                	test   %eax,%eax
80101a7a:	75 06                	jne    80101a82 <iget+0x77>
      empty = ip;
80101a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a82:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101a89:	81 7d f4 74 4f 11 80 	cmpl   $0x80114f74,-0xc(%ebp)
80101a90:	72 9b                	jb     80101a2d <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a96:	75 0c                	jne    80101aa4 <iget+0x99>
    panic("iget: no inodes");
80101a98:	c7 04 24 29 96 10 80 	movl   $0x80109629,(%esp)
80101a9f:	e8 b0 ea ff ff       	call   80100554 <panic>

  ip = empty;
80101aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aad:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab0:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ab8:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101abe:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac8:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101acf:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101ad6:	e8 a2 34 00 00       	call   80104f7d <release>

  return ip;
80101adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101ade:	c9                   	leave  
80101adf:	c3                   	ret    

80101ae0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101ae6:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101aed:	e8 21 34 00 00       	call   80104f13 <acquire>
  ip->ref++;
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	8b 40 08             	mov    0x8(%eax),%eax
80101af8:	8d 50 01             	lea    0x1(%eax),%edx
80101afb:	8b 45 08             	mov    0x8(%ebp),%eax
80101afe:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b01:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101b08:	e8 70 34 00 00       	call   80104f7d <release>
  return ip;
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b10:	c9                   	leave  
80101b11:	c3                   	ret    

80101b12 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b12:	55                   	push   %ebp
80101b13:	89 e5                	mov    %esp,%ebp
80101b15:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b1c:	74 0a                	je     80101b28 <ilock+0x16>
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	8b 40 08             	mov    0x8(%eax),%eax
80101b24:	85 c0                	test   %eax,%eax
80101b26:	7f 0c                	jg     80101b34 <ilock+0x22>
    panic("ilock");
80101b28:	c7 04 24 39 96 10 80 	movl   $0x80109639,(%esp)
80101b2f:	e8 20 ea ff ff       	call   80100554 <panic>

  acquiresleep(&ip->lock);
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	83 c0 0c             	add    $0xc,%eax
80101b3a:	89 04 24             	mov    %eax,(%esp)
80101b3d:	e8 ac 32 00 00       	call   80104dee <acquiresleep>

  if(ip->valid == 0){
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b48:	85 c0                	test   %eax,%eax
80101b4a:	0f 85 ca 00 00 00    	jne    80101c1a <ilock+0x108>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 40 04             	mov    0x4(%eax),%eax
80101b56:	c1 e8 03             	shr    $0x3,%eax
80101b59:	89 c2                	mov    %eax,%edx
80101b5b:	a1 14 33 11 80       	mov    0x80113314,%eax
80101b60:	01 c2                	add    %eax,%edx
80101b62:	8b 45 08             	mov    0x8(%ebp),%eax
80101b65:	8b 00                	mov    (%eax),%eax
80101b67:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b6b:	89 04 24             	mov    %eax,(%esp)
80101b6e:	e8 42 e6 ff ff       	call   801001b5 <bread>
80101b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b79:	8d 50 5c             	lea    0x5c(%eax),%edx
80101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7f:	8b 40 04             	mov    0x4(%eax),%eax
80101b82:	83 e0 07             	and    $0x7,%eax
80101b85:	c1 e0 06             	shl    $0x6,%eax
80101b88:	01 d0                	add    %edx,%eax
80101b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b90:	8b 00                	mov    (%eax),%eax
80101b92:	8b 55 08             	mov    0x8(%ebp),%edx
80101b95:	66 89 42 50          	mov    %ax,0x50(%edx)
    ip->major = dip->major;
80101b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b9c:	66 8b 40 02          	mov    0x2(%eax),%ax
80101ba0:	8b 55 08             	mov    0x8(%ebp),%edx
80101ba3:	66 89 42 52          	mov    %ax,0x52(%edx)
    ip->minor = dip->minor;
80101ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101baa:	8b 40 04             	mov    0x4(%eax),%eax
80101bad:	8b 55 08             	mov    0x8(%ebp),%edx
80101bb0:	66 89 42 54          	mov    %ax,0x54(%edx)
    ip->nlink = dip->nlink;
80101bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bb7:	66 8b 40 06          	mov    0x6(%eax),%ax
80101bbb:	8b 55 08             	mov    0x8(%ebp),%edx
80101bbe:	66 89 42 56          	mov    %ax,0x56(%edx)
    ip->size = dip->size;
80101bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc5:	8b 50 08             	mov    0x8(%eax),%edx
80101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcb:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd1:	8d 50 0c             	lea    0xc(%eax),%edx
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	83 c0 5c             	add    $0x5c,%eax
80101bda:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101be1:	00 
80101be2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101be6:	89 04 24             	mov    %eax,(%esp)
80101be9:	e8 51 36 00 00       	call   8010523f <memmove>
    brelse(bp);
80101bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf1:	89 04 24             	mov    %eax,(%esp)
80101bf4:	e8 33 e6 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101c03:	8b 45 08             	mov    0x8(%ebp),%eax
80101c06:	8b 40 50             	mov    0x50(%eax),%eax
80101c09:	66 85 c0             	test   %ax,%ax
80101c0c:	75 0c                	jne    80101c1a <ilock+0x108>
      panic("ilock: no type");
80101c0e:	c7 04 24 3f 96 10 80 	movl   $0x8010963f,(%esp)
80101c15:	e8 3a e9 ff ff       	call   80100554 <panic>
  }
}
80101c1a:	c9                   	leave  
80101c1b:	c3                   	ret    

80101c1c <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c1c:	55                   	push   %ebp
80101c1d:	89 e5                	mov    %esp,%ebp
80101c1f:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c26:	74 1c                	je     80101c44 <iunlock+0x28>
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	83 c0 0c             	add    $0xc,%eax
80101c2e:	89 04 24             	mov    %eax,(%esp)
80101c31:	e8 55 32 00 00       	call   80104e8b <holdingsleep>
80101c36:	85 c0                	test   %eax,%eax
80101c38:	74 0a                	je     80101c44 <iunlock+0x28>
80101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3d:	8b 40 08             	mov    0x8(%eax),%eax
80101c40:	85 c0                	test   %eax,%eax
80101c42:	7f 0c                	jg     80101c50 <iunlock+0x34>
    panic("iunlock");
80101c44:	c7 04 24 4e 96 10 80 	movl   $0x8010964e,(%esp)
80101c4b:	e8 04 e9 ff ff       	call   80100554 <panic>

  releasesleep(&ip->lock);
80101c50:	8b 45 08             	mov    0x8(%ebp),%eax
80101c53:	83 c0 0c             	add    $0xc,%eax
80101c56:	89 04 24             	mov    %eax,(%esp)
80101c59:	e8 eb 31 00 00       	call   80104e49 <releasesleep>
}
80101c5e:	c9                   	leave  
80101c5f:	c3                   	ret    

80101c60 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	83 c0 0c             	add    $0xc,%eax
80101c6c:	89 04 24             	mov    %eax,(%esp)
80101c6f:	e8 7a 31 00 00       	call   80104dee <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c74:	8b 45 08             	mov    0x8(%ebp),%eax
80101c77:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c7a:	85 c0                	test   %eax,%eax
80101c7c:	74 5c                	je     80101cda <iput+0x7a>
80101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c81:	66 8b 40 56          	mov    0x56(%eax),%ax
80101c85:	66 85 c0             	test   %ax,%ax
80101c88:	75 50                	jne    80101cda <iput+0x7a>
    acquire(&icache.lock);
80101c8a:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101c91:	e8 7d 32 00 00       	call   80104f13 <acquire>
    int r = ip->ref;
80101c96:	8b 45 08             	mov    0x8(%ebp),%eax
80101c99:	8b 40 08             	mov    0x8(%eax),%eax
80101c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101c9f:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101ca6:	e8 d2 32 00 00       	call   80104f7d <release>
    if(r == 1){
80101cab:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101caf:	75 29                	jne    80101cda <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb4:	89 04 24             	mov    %eax,(%esp)
80101cb7:	e8 86 01 00 00       	call   80101e42 <itrunc>
      ip->type = 0;
80101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbf:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc8:	89 04 24             	mov    %eax,(%esp)
80101ccb:	e8 7f fc ff ff       	call   8010194f <iupdate>
      ip->valid = 0;
80101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd3:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101cda:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdd:	83 c0 0c             	add    $0xc,%eax
80101ce0:	89 04 24             	mov    %eax,(%esp)
80101ce3:	e8 61 31 00 00       	call   80104e49 <releasesleep>

  acquire(&icache.lock);
80101ce8:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101cef:	e8 1f 32 00 00       	call   80104f13 <acquire>
  ip->ref--;
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 40 08             	mov    0x8(%eax),%eax
80101cfa:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d03:	c7 04 24 20 33 11 80 	movl   $0x80113320,(%esp)
80101d0a:	e8 6e 32 00 00       	call   80104f7d <release>
}
80101d0f:	c9                   	leave  
80101d10:	c3                   	ret    

80101d11 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d11:	55                   	push   %ebp
80101d12:	89 e5                	mov    %esp,%ebp
80101d14:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101d17:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1a:	89 04 24             	mov    %eax,(%esp)
80101d1d:	e8 fa fe ff ff       	call   80101c1c <iunlock>
  iput(ip);
80101d22:	8b 45 08             	mov    0x8(%ebp),%eax
80101d25:	89 04 24             	mov    %eax,(%esp)
80101d28:	e8 33 ff ff ff       	call   80101c60 <iput>
}
80101d2d:	c9                   	leave  
80101d2e:	c3                   	ret    

80101d2f <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d2f:	55                   	push   %ebp
80101d30:	89 e5                	mov    %esp,%ebp
80101d32:	53                   	push   %ebx
80101d33:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d36:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d3a:	77 3e                	ja     80101d7a <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d42:	83 c2 14             	add    $0x14,%edx
80101d45:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d50:	75 20                	jne    80101d72 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	8b 00                	mov    (%eax),%eax
80101d57:	89 04 24             	mov    %eax,(%esp)
80101d5a:	e8 48 f8 ff ff       	call   801015a7 <balloc>
80101d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d62:	8b 45 08             	mov    0x8(%ebp),%eax
80101d65:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d68:	8d 4a 14             	lea    0x14(%edx),%ecx
80101d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6e:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d75:	e9 c2 00 00 00       	jmp    80101e3c <bmap+0x10d>
  }
  bn -= NDIRECT;
80101d7a:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d7e:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d82:	0f 87 a8 00 00 00    	ja     80101e30 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d88:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d98:	75 1c                	jne    80101db6 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	8b 00                	mov    (%eax),%eax
80101d9f:	89 04 24             	mov    %eax,(%esp)
80101da2:	e8 00 f8 ff ff       	call   801015a7 <balloc>
80101da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db0:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	8b 00                	mov    (%eax),%eax
80101dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dbe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dc2:	89 04 24             	mov    %eax,(%esp)
80101dc5:	e8 eb e3 ff ff       	call   801001b5 <bread>
80101dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd0:	83 c0 5c             	add    $0x5c,%eax
80101dd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101de3:	01 d0                	add    %edx,%eax
80101de5:	8b 00                	mov    (%eax),%eax
80101de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dee:	75 30                	jne    80101e20 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dfd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101e00:	8b 45 08             	mov    0x8(%ebp),%eax
80101e03:	8b 00                	mov    (%eax),%eax
80101e05:	89 04 24             	mov    %eax,(%esp)
80101e08:	e8 9a f7 ff ff       	call   801015a7 <balloc>
80101e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e13:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e18:	89 04 24             	mov    %eax,(%esp)
80101e1b:	e8 ef 19 00 00       	call   8010380f <log_write>
    }
    brelse(bp);
80101e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e23:	89 04 24             	mov    %eax,(%esp)
80101e26:	e8 01 e4 ff ff       	call   8010022c <brelse>
    return addr;
80101e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e2e:	eb 0c                	jmp    80101e3c <bmap+0x10d>
  }

  panic("bmap: out of range");
80101e30:	c7 04 24 56 96 10 80 	movl   $0x80109656,(%esp)
80101e37:	e8 18 e7 ff ff       	call   80100554 <panic>
}
80101e3c:	83 c4 24             	add    $0x24,%esp
80101e3f:	5b                   	pop    %ebx
80101e40:	5d                   	pop    %ebp
80101e41:	c3                   	ret    

80101e42 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e42:	55                   	push   %ebp
80101e43:	89 e5                	mov    %esp,%ebp
80101e45:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e4f:	eb 43                	jmp    80101e94 <itrunc+0x52>
    if(ip->addrs[i]){
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e57:	83 c2 14             	add    $0x14,%edx
80101e5a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e5e:	85 c0                	test   %eax,%eax
80101e60:	74 2f                	je     80101e91 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101e62:	8b 45 08             	mov    0x8(%ebp),%eax
80101e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e68:	83 c2 14             	add    $0x14,%edx
80101e6b:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e72:	8b 00                	mov    (%eax),%eax
80101e74:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e78:	89 04 24             	mov    %eax,(%esp)
80101e7b:	e8 61 f8 ff ff       	call   801016e1 <bfree>
      ip->addrs[i] = 0;
80101e80:	8b 45 08             	mov    0x8(%ebp),%eax
80101e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e86:	83 c2 14             	add    $0x14,%edx
80101e89:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e90:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e91:	ff 45 f4             	incl   -0xc(%ebp)
80101e94:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e98:	7e b7                	jle    80101e51 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	0f 84 a3 00 00 00    	je     80101f4e <itrunc+0x10c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101eab:	8b 45 08             	mov    0x8(%ebp),%eax
80101eae:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb7:	8b 00                	mov    (%eax),%eax
80101eb9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ebd:	89 04 24             	mov    %eax,(%esp)
80101ec0:	e8 f0 e2 ff ff       	call   801001b5 <bread>
80101ec5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ecb:	83 c0 5c             	add    $0x5c,%eax
80101ece:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ed1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ed8:	eb 3a                	jmp    80101f14 <itrunc+0xd2>
      if(a[j])
80101eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101edd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ee7:	01 d0                	add    %edx,%eax
80101ee9:	8b 00                	mov    (%eax),%eax
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	74 22                	je     80101f11 <itrunc+0xcf>
        bfree(ip->dev, a[j]);
80101eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101efc:	01 d0                	add    %edx,%eax
80101efe:	8b 10                	mov    (%eax),%edx
80101f00:	8b 45 08             	mov    0x8(%ebp),%eax
80101f03:	8b 00                	mov    (%eax),%eax
80101f05:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f09:	89 04 24             	mov    %eax,(%esp)
80101f0c:	e8 d0 f7 ff ff       	call   801016e1 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101f11:	ff 45 f0             	incl   -0x10(%ebp)
80101f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f17:	83 f8 7f             	cmp    $0x7f,%eax
80101f1a:	76 be                	jbe    80101eda <itrunc+0x98>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f1f:	89 04 24             	mov    %eax,(%esp)
80101f22:	e8 05 e3 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101f30:	8b 45 08             	mov    0x8(%ebp),%eax
80101f33:	8b 00                	mov    (%eax),%eax
80101f35:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f39:	89 04 24             	mov    %eax,(%esp)
80101f3c:	e8 a0 f7 ff ff       	call   801016e1 <bfree>
    ip->addrs[NDIRECT] = 0;
80101f41:	8b 45 08             	mov    0x8(%ebp),%eax
80101f44:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101f4b:	00 00 00 
  }

  ip->size = 0;
80101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f51:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	89 04 24             	mov    %eax,(%esp)
80101f5e:	e8 ec f9 ff ff       	call   8010194f <iupdate>
}
80101f63:	c9                   	leave  
80101f64:	c3                   	ret    

80101f65 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f65:	55                   	push   %ebp
80101f66:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f68:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6b:	8b 00                	mov    (%eax),%eax
80101f6d:	89 c2                	mov    %eax,%edx
80101f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f72:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f75:	8b 45 08             	mov    0x8(%ebp),%eax
80101f78:	8b 50 04             	mov    0x4(%eax),%edx
80101f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f7e:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	8b 40 50             	mov    0x50(%eax),%eax
80101f87:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f8a:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f90:	66 8b 40 56          	mov    0x56(%eax),%ax
80101f94:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f97:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9e:	8b 50 58             	mov    0x58(%eax),%edx
80101fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fa4:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fa7:	5d                   	pop    %ebp
80101fa8:	c3                   	ret    

80101fa9 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fa9:	55                   	push   %ebp
80101faa:	89 e5                	mov    %esp,%ebp
80101fac:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101faf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb2:	8b 40 50             	mov    0x50(%eax),%eax
80101fb5:	66 83 f8 03          	cmp    $0x3,%ax
80101fb9:	75 60                	jne    8010201b <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbe:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fc2:	66 85 c0             	test   %ax,%ax
80101fc5:	78 20                	js     80101fe7 <readi+0x3e>
80101fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fca:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fce:	66 83 f8 09          	cmp    $0x9,%ax
80101fd2:	7f 13                	jg     80101fe7 <readi+0x3e>
80101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd7:	66 8b 40 52          	mov    0x52(%eax),%ax
80101fdb:	98                   	cwtl   
80101fdc:	8b 04 c5 a0 32 11 80 	mov    -0x7feecd60(,%eax,8),%eax
80101fe3:	85 c0                	test   %eax,%eax
80101fe5:	75 0a                	jne    80101ff1 <readi+0x48>
      return -1;
80101fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fec:	e9 1a 01 00 00       	jmp    8010210b <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff4:	66 8b 40 52          	mov    0x52(%eax),%ax
80101ff8:	98                   	cwtl   
80101ff9:	8b 04 c5 a0 32 11 80 	mov    -0x7feecd60(,%eax,8),%eax
80102000:	8b 55 14             	mov    0x14(%ebp),%edx
80102003:	89 54 24 08          	mov    %edx,0x8(%esp)
80102007:	8b 55 0c             	mov    0xc(%ebp),%edx
8010200a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010200e:	8b 55 08             	mov    0x8(%ebp),%edx
80102011:	89 14 24             	mov    %edx,(%esp)
80102014:	ff d0                	call   *%eax
80102016:	e9 f0 00 00 00       	jmp    8010210b <readi+0x162>
  }

  if(off > ip->size || off + n < off)
8010201b:	8b 45 08             	mov    0x8(%ebp),%eax
8010201e:	8b 40 58             	mov    0x58(%eax),%eax
80102021:	3b 45 10             	cmp    0x10(%ebp),%eax
80102024:	72 0d                	jb     80102033 <readi+0x8a>
80102026:	8b 45 14             	mov    0x14(%ebp),%eax
80102029:	8b 55 10             	mov    0x10(%ebp),%edx
8010202c:	01 d0                	add    %edx,%eax
8010202e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102031:	73 0a                	jae    8010203d <readi+0x94>
    return -1;
80102033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102038:	e9 ce 00 00 00       	jmp    8010210b <readi+0x162>
  if(off + n > ip->size)
8010203d:	8b 45 14             	mov    0x14(%ebp),%eax
80102040:	8b 55 10             	mov    0x10(%ebp),%edx
80102043:	01 c2                	add    %eax,%edx
80102045:	8b 45 08             	mov    0x8(%ebp),%eax
80102048:	8b 40 58             	mov    0x58(%eax),%eax
8010204b:	39 c2                	cmp    %eax,%edx
8010204d:	76 0c                	jbe    8010205b <readi+0xb2>
    n = ip->size - off;
8010204f:	8b 45 08             	mov    0x8(%ebp),%eax
80102052:	8b 40 58             	mov    0x58(%eax),%eax
80102055:	2b 45 10             	sub    0x10(%ebp),%eax
80102058:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010205b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102062:	e9 95 00 00 00       	jmp    801020fc <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102067:	8b 45 10             	mov    0x10(%ebp),%eax
8010206a:	c1 e8 09             	shr    $0x9,%eax
8010206d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102071:	8b 45 08             	mov    0x8(%ebp),%eax
80102074:	89 04 24             	mov    %eax,(%esp)
80102077:	e8 b3 fc ff ff       	call   80101d2f <bmap>
8010207c:	8b 55 08             	mov    0x8(%ebp),%edx
8010207f:	8b 12                	mov    (%edx),%edx
80102081:	89 44 24 04          	mov    %eax,0x4(%esp)
80102085:	89 14 24             	mov    %edx,(%esp)
80102088:	e8 28 e1 ff ff       	call   801001b5 <bread>
8010208d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102090:	8b 45 10             	mov    0x10(%ebp),%eax
80102093:	25 ff 01 00 00       	and    $0x1ff,%eax
80102098:	89 c2                	mov    %eax,%edx
8010209a:	b8 00 02 00 00       	mov    $0x200,%eax
8010209f:	29 d0                	sub    %edx,%eax
801020a1:	89 c1                	mov    %eax,%ecx
801020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020a6:	8b 55 14             	mov    0x14(%ebp),%edx
801020a9:	29 c2                	sub    %eax,%edx
801020ab:	89 c8                	mov    %ecx,%eax
801020ad:	39 d0                	cmp    %edx,%eax
801020af:	76 02                	jbe    801020b3 <readi+0x10a>
801020b1:	89 d0                	mov    %edx,%eax
801020b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801020b6:	8b 45 10             	mov    0x10(%ebp),%eax
801020b9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020be:	8d 50 50             	lea    0x50(%eax),%edx
801020c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c4:	01 d0                	add    %edx,%eax
801020c6:	8d 50 0c             	lea    0xc(%eax),%edx
801020c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cc:	89 44 24 08          	mov    %eax,0x8(%esp)
801020d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d7:	89 04 24             	mov    %eax,(%esp)
801020da:	e8 60 31 00 00       	call   8010523f <memmove>
    brelse(bp);
801020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020e2:	89 04 24             	mov    %eax,(%esp)
801020e5:	e8 42 e1 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ed:	01 45 f4             	add    %eax,-0xc(%ebp)
801020f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020f3:	01 45 10             	add    %eax,0x10(%ebp)
801020f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020f9:	01 45 0c             	add    %eax,0xc(%ebp)
801020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ff:	3b 45 14             	cmp    0x14(%ebp),%eax
80102102:	0f 82 5f ff ff ff    	jb     80102067 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102108:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010210b:	c9                   	leave  
8010210c:	c3                   	ret    

8010210d <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010210d:	55                   	push   %ebp
8010210e:	89 e5                	mov    %esp,%ebp
80102110:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	8b 40 50             	mov    0x50(%eax),%eax
80102119:	66 83 f8 03          	cmp    $0x3,%ax
8010211d:	75 60                	jne    8010217f <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010211f:	8b 45 08             	mov    0x8(%ebp),%eax
80102122:	66 8b 40 52          	mov    0x52(%eax),%ax
80102126:	66 85 c0             	test   %ax,%ax
80102129:	78 20                	js     8010214b <writei+0x3e>
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	66 8b 40 52          	mov    0x52(%eax),%ax
80102132:	66 83 f8 09          	cmp    $0x9,%ax
80102136:	7f 13                	jg     8010214b <writei+0x3e>
80102138:	8b 45 08             	mov    0x8(%ebp),%eax
8010213b:	66 8b 40 52          	mov    0x52(%eax),%ax
8010213f:	98                   	cwtl   
80102140:	8b 04 c5 a4 32 11 80 	mov    -0x7feecd5c(,%eax,8),%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	75 0a                	jne    80102155 <writei+0x48>
      return -1;
8010214b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102150:	e9 45 01 00 00       	jmp    8010229a <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102155:	8b 45 08             	mov    0x8(%ebp),%eax
80102158:	66 8b 40 52          	mov    0x52(%eax),%ax
8010215c:	98                   	cwtl   
8010215d:	8b 04 c5 a4 32 11 80 	mov    -0x7feecd5c(,%eax,8),%eax
80102164:	8b 55 14             	mov    0x14(%ebp),%edx
80102167:	89 54 24 08          	mov    %edx,0x8(%esp)
8010216b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010216e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102172:	8b 55 08             	mov    0x8(%ebp),%edx
80102175:	89 14 24             	mov    %edx,(%esp)
80102178:	ff d0                	call   *%eax
8010217a:	e9 1b 01 00 00       	jmp    8010229a <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
8010217f:	8b 45 08             	mov    0x8(%ebp),%eax
80102182:	8b 40 58             	mov    0x58(%eax),%eax
80102185:	3b 45 10             	cmp    0x10(%ebp),%eax
80102188:	72 0d                	jb     80102197 <writei+0x8a>
8010218a:	8b 45 14             	mov    0x14(%ebp),%eax
8010218d:	8b 55 10             	mov    0x10(%ebp),%edx
80102190:	01 d0                	add    %edx,%eax
80102192:	3b 45 10             	cmp    0x10(%ebp),%eax
80102195:	73 0a                	jae    801021a1 <writei+0x94>
    return -1;
80102197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010219c:	e9 f9 00 00 00       	jmp    8010229a <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
801021a1:	8b 45 14             	mov    0x14(%ebp),%eax
801021a4:	8b 55 10             	mov    0x10(%ebp),%edx
801021a7:	01 d0                	add    %edx,%eax
801021a9:	3d 00 18 01 00       	cmp    $0x11800,%eax
801021ae:	76 0a                	jbe    801021ba <writei+0xad>
    return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	e9 e0 00 00 00       	jmp    8010229a <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021c1:	e9 a0 00 00 00       	jmp    80102266 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021c6:	8b 45 10             	mov    0x10(%ebp),%eax
801021c9:	c1 e8 09             	shr    $0x9,%eax
801021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801021d0:	8b 45 08             	mov    0x8(%ebp),%eax
801021d3:	89 04 24             	mov    %eax,(%esp)
801021d6:	e8 54 fb ff ff       	call   80101d2f <bmap>
801021db:	8b 55 08             	mov    0x8(%ebp),%edx
801021de:	8b 12                	mov    (%edx),%edx
801021e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e4:	89 14 24             	mov    %edx,(%esp)
801021e7:	e8 c9 df ff ff       	call   801001b5 <bread>
801021ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021ef:	8b 45 10             	mov    0x10(%ebp),%eax
801021f2:	25 ff 01 00 00       	and    $0x1ff,%eax
801021f7:	89 c2                	mov    %eax,%edx
801021f9:	b8 00 02 00 00       	mov    $0x200,%eax
801021fe:	29 d0                	sub    %edx,%eax
80102200:	89 c1                	mov    %eax,%ecx
80102202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102205:	8b 55 14             	mov    0x14(%ebp),%edx
80102208:	29 c2                	sub    %eax,%edx
8010220a:	89 c8                	mov    %ecx,%eax
8010220c:	39 d0                	cmp    %edx,%eax
8010220e:	76 02                	jbe    80102212 <writei+0x105>
80102210:	89 d0                	mov    %edx,%eax
80102212:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102215:	8b 45 10             	mov    0x10(%ebp),%eax
80102218:	25 ff 01 00 00       	and    $0x1ff,%eax
8010221d:	8d 50 50             	lea    0x50(%eax),%edx
80102220:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102223:	01 d0                	add    %edx,%eax
80102225:	8d 50 0c             	lea    0xc(%eax),%edx
80102228:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010222b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010222f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102232:	89 44 24 04          	mov    %eax,0x4(%esp)
80102236:	89 14 24             	mov    %edx,(%esp)
80102239:	e8 01 30 00 00       	call   8010523f <memmove>
    log_write(bp);
8010223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102241:	89 04 24             	mov    %eax,(%esp)
80102244:	e8 c6 15 00 00       	call   8010380f <log_write>
    brelse(bp);
80102249:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010224c:	89 04 24             	mov    %eax,(%esp)
8010224f:	e8 d8 df ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102254:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102257:	01 45 f4             	add    %eax,-0xc(%ebp)
8010225a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010225d:	01 45 10             	add    %eax,0x10(%ebp)
80102260:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102263:	01 45 0c             	add    %eax,0xc(%ebp)
80102266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102269:	3b 45 14             	cmp    0x14(%ebp),%eax
8010226c:	0f 82 54 ff ff ff    	jb     801021c6 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102272:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102276:	74 1f                	je     80102297 <writei+0x18a>
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	8b 40 58             	mov    0x58(%eax),%eax
8010227e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102281:	73 14                	jae    80102297 <writei+0x18a>
    ip->size = off;
80102283:	8b 45 08             	mov    0x8(%ebp),%eax
80102286:	8b 55 10             	mov    0x10(%ebp),%edx
80102289:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
8010228c:	8b 45 08             	mov    0x8(%ebp),%eax
8010228f:	89 04 24             	mov    %eax,(%esp)
80102292:	e8 b8 f6 ff ff       	call   8010194f <iupdate>
  }
  return n;
80102297:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010229a:	c9                   	leave  
8010229b:	c3                   	ret    

8010229c <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010229c:	55                   	push   %ebp
8010229d:	89 e5                	mov    %esp,%ebp
8010229f:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801022a2:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022a9:	00 
801022aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b1:	8b 45 08             	mov    0x8(%ebp),%eax
801022b4:	89 04 24             	mov    %eax,(%esp)
801022b7:	e8 22 30 00 00       	call   801052de <strncmp>
}
801022bc:	c9                   	leave  
801022bd:	c3                   	ret    

801022be <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801022be:	55                   	push   %ebp
801022bf:	89 e5                	mov    %esp,%ebp
801022c1:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801022c4:	8b 45 08             	mov    0x8(%ebp),%eax
801022c7:	8b 40 50             	mov    0x50(%eax),%eax
801022ca:	66 83 f8 01          	cmp    $0x1,%ax
801022ce:	74 0c                	je     801022dc <dirlookup+0x1e>
    panic("dirlookup not DIR");
801022d0:	c7 04 24 69 96 10 80 	movl   $0x80109669,(%esp)
801022d7:	e8 78 e2 ff ff       	call   80100554 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801022dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022e3:	e9 86 00 00 00       	jmp    8010236e <dirlookup+0xb0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022e8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022ef:	00 
801022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f3:	89 44 24 08          	mov    %eax,0x8(%esp)
801022f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801022fe:	8b 45 08             	mov    0x8(%ebp),%eax
80102301:	89 04 24             	mov    %eax,(%esp)
80102304:	e8 a0 fc ff ff       	call   80101fa9 <readi>
80102309:	83 f8 10             	cmp    $0x10,%eax
8010230c:	74 0c                	je     8010231a <dirlookup+0x5c>
      panic("dirlookup read");
8010230e:	c7 04 24 7b 96 10 80 	movl   $0x8010967b,(%esp)
80102315:	e8 3a e2 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
8010231a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010231d:	66 85 c0             	test   %ax,%ax
80102320:	75 02                	jne    80102324 <dirlookup+0x66>
      continue;
80102322:	eb 46                	jmp    8010236a <dirlookup+0xac>
    if(namecmp(name, de.name) == 0){
80102324:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102327:	83 c0 02             	add    $0x2,%eax
8010232a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010232e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102331:	89 04 24             	mov    %eax,(%esp)
80102334:	e8 63 ff ff ff       	call   8010229c <namecmp>
80102339:	85 c0                	test   %eax,%eax
8010233b:	75 2d                	jne    8010236a <dirlookup+0xac>
      // entry matches path element
      if(poff)
8010233d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102341:	74 08                	je     8010234b <dirlookup+0x8d>
        *poff = off;
80102343:	8b 45 10             	mov    0x10(%ebp),%eax
80102346:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102349:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010234b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010234e:	0f b7 c0             	movzwl %ax,%eax
80102351:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102354:	8b 45 08             	mov    0x8(%ebp),%eax
80102357:	8b 00                	mov    (%eax),%eax
80102359:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010235c:	89 54 24 04          	mov    %edx,0x4(%esp)
80102360:	89 04 24             	mov    %eax,(%esp)
80102363:	e8 a3 f6 ff ff       	call   80101a0b <iget>
80102368:	eb 18                	jmp    80102382 <dirlookup+0xc4>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010236a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010236e:	8b 45 08             	mov    0x8(%ebp),%eax
80102371:	8b 40 58             	mov    0x58(%eax),%eax
80102374:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102377:	0f 87 6b ff ff ff    	ja     801022e8 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010237d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102382:	c9                   	leave  
80102383:	c3                   	ret    

80102384 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102384:	55                   	push   %ebp
80102385:	89 e5                	mov    %esp,%ebp
80102387:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010238a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102391:	00 
80102392:	8b 45 0c             	mov    0xc(%ebp),%eax
80102395:	89 44 24 04          	mov    %eax,0x4(%esp)
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	89 04 24             	mov    %eax,(%esp)
8010239f:	e8 1a ff ff ff       	call   801022be <dirlookup>
801023a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023ab:	74 15                	je     801023c2 <dirlink+0x3e>
    iput(ip);
801023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b0:	89 04 24             	mov    %eax,(%esp)
801023b3:	e8 a8 f8 ff ff       	call   80101c60 <iput>
    return -1;
801023b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023bd:	e9 b6 00 00 00       	jmp    80102478 <dirlink+0xf4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023c9:	eb 45                	jmp    80102410 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801023d5:	00 
801023d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801023da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e1:	8b 45 08             	mov    0x8(%ebp),%eax
801023e4:	89 04 24             	mov    %eax,(%esp)
801023e7:	e8 bd fb ff ff       	call   80101fa9 <readi>
801023ec:	83 f8 10             	cmp    $0x10,%eax
801023ef:	74 0c                	je     801023fd <dirlink+0x79>
      panic("dirlink read");
801023f1:	c7 04 24 8a 96 10 80 	movl   $0x8010968a,(%esp)
801023f8:	e8 57 e1 ff ff       	call   80100554 <panic>
    if(de.inum == 0)
801023fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102400:	66 85 c0             	test   %ax,%ax
80102403:	75 02                	jne    80102407 <dirlink+0x83>
      break;
80102405:	eb 16                	jmp    8010241d <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240a:	83 c0 10             	add    $0x10,%eax
8010240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102410:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102413:	8b 45 08             	mov    0x8(%ebp),%eax
80102416:	8b 40 58             	mov    0x58(%eax),%eax
80102419:	39 c2                	cmp    %eax,%edx
8010241b:	72 ae                	jb     801023cb <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
8010241d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102424:	00 
80102425:	8b 45 0c             	mov    0xc(%ebp),%eax
80102428:	89 44 24 04          	mov    %eax,0x4(%esp)
8010242c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010242f:	83 c0 02             	add    $0x2,%eax
80102432:	89 04 24             	mov    %eax,(%esp)
80102435:	e8 20 2f 00 00       	call   8010535a <strncpy>
  de.inum = inum;
8010243a:	8b 45 10             	mov    0x10(%ebp),%eax
8010243d:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102444:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010244b:	00 
8010244c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102450:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102453:	89 44 24 04          	mov    %eax,0x4(%esp)
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
8010245a:	89 04 24             	mov    %eax,(%esp)
8010245d:	e8 ab fc ff ff       	call   8010210d <writei>
80102462:	83 f8 10             	cmp    $0x10,%eax
80102465:	74 0c                	je     80102473 <dirlink+0xef>
    panic("dirlink");
80102467:	c7 04 24 97 96 10 80 	movl   $0x80109697,(%esp)
8010246e:	e8 e1 e0 ff ff       	call   80100554 <panic>

  return 0;
80102473:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102478:	c9                   	leave  
80102479:	c3                   	ret    

8010247a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010247a:	55                   	push   %ebp
8010247b:	89 e5                	mov    %esp,%ebp
8010247d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102480:	eb 03                	jmp    80102485 <skipelem+0xb>
    path++;
80102482:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
80102488:	8a 00                	mov    (%eax),%al
8010248a:	3c 2f                	cmp    $0x2f,%al
8010248c:	74 f4                	je     80102482 <skipelem+0x8>
    path++;
  if(*path == 0)
8010248e:	8b 45 08             	mov    0x8(%ebp),%eax
80102491:	8a 00                	mov    (%eax),%al
80102493:	84 c0                	test   %al,%al
80102495:	75 0a                	jne    801024a1 <skipelem+0x27>
    return 0;
80102497:	b8 00 00 00 00       	mov    $0x0,%eax
8010249c:	e9 81 00 00 00       	jmp    80102522 <skipelem+0xa8>
  s = path;
801024a1:	8b 45 08             	mov    0x8(%ebp),%eax
801024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024a7:	eb 03                	jmp    801024ac <skipelem+0x32>
    path++;
801024a9:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	8a 00                	mov    (%eax),%al
801024b1:	3c 2f                	cmp    $0x2f,%al
801024b3:	74 09                	je     801024be <skipelem+0x44>
801024b5:	8b 45 08             	mov    0x8(%ebp),%eax
801024b8:	8a 00                	mov    (%eax),%al
801024ba:	84 c0                	test   %al,%al
801024bc:	75 eb                	jne    801024a9 <skipelem+0x2f>
    path++;
  len = path - s;
801024be:	8b 55 08             	mov    0x8(%ebp),%edx
801024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c4:	29 c2                	sub    %eax,%edx
801024c6:	89 d0                	mov    %edx,%eax
801024c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801024cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801024cf:	7e 1c                	jle    801024ed <skipelem+0x73>
    memmove(name, s, DIRSIZ);
801024d1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801024d8:	00 
801024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801024e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801024e3:	89 04 24             	mov    %eax,(%esp)
801024e6:	e8 54 2d 00 00       	call   8010523f <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801024eb:	eb 29                	jmp    80102516 <skipelem+0x9c>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801024ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024f0:	89 44 24 08          	mov    %eax,0x8(%esp)
801024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801024fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801024fe:	89 04 24             	mov    %eax,(%esp)
80102501:	e8 39 2d 00 00       	call   8010523f <memmove>
    name[len] = 0;
80102506:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102509:	8b 45 0c             	mov    0xc(%ebp),%eax
8010250c:	01 d0                	add    %edx,%eax
8010250e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102511:	eb 03                	jmp    80102516 <skipelem+0x9c>
    path++;
80102513:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102516:	8b 45 08             	mov    0x8(%ebp),%eax
80102519:	8a 00                	mov    (%eax),%al
8010251b:	3c 2f                	cmp    $0x2f,%al
8010251d:	74 f4                	je     80102513 <skipelem+0x99>
    path++;
  return path;
8010251f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102522:	c9                   	leave  
80102523:	c3                   	ret    

80102524 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010252a:	8b 45 08             	mov    0x8(%ebp),%eax
8010252d:	8a 00                	mov    (%eax),%al
8010252f:	3c 2f                	cmp    $0x2f,%al
80102531:	75 1c                	jne    8010254f <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102533:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010253a:	00 
8010253b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102542:	e8 c4 f4 ff ff       	call   80101a0b <iget>
80102547:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010254a:	e9 ac 00 00 00       	jmp    801025fb <namex+0xd7>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010254f:	e8 af 1d 00 00       	call   80104303 <myproc>
80102554:	8b 40 68             	mov    0x68(%eax),%eax
80102557:	89 04 24             	mov    %eax,(%esp)
8010255a:	e8 81 f5 ff ff       	call   80101ae0 <idup>
8010255f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102562:	e9 94 00 00 00       	jmp    801025fb <namex+0xd7>
    ilock(ip);
80102567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010256a:	89 04 24             	mov    %eax,(%esp)
8010256d:	e8 a0 f5 ff ff       	call   80101b12 <ilock>
    if(ip->type != T_DIR){
80102572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102575:	8b 40 50             	mov    0x50(%eax),%eax
80102578:	66 83 f8 01          	cmp    $0x1,%ax
8010257c:	74 15                	je     80102593 <namex+0x6f>
      iunlockput(ip);
8010257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102581:	89 04 24             	mov    %eax,(%esp)
80102584:	e8 88 f7 ff ff       	call   80101d11 <iunlockput>
      return 0;
80102589:	b8 00 00 00 00       	mov    $0x0,%eax
8010258e:	e9 a2 00 00 00       	jmp    80102635 <namex+0x111>
    }
    if(nameiparent && *path == '\0'){
80102593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102597:	74 1c                	je     801025b5 <namex+0x91>
80102599:	8b 45 08             	mov    0x8(%ebp),%eax
8010259c:	8a 00                	mov    (%eax),%al
8010259e:	84 c0                	test   %al,%al
801025a0:	75 13                	jne    801025b5 <namex+0x91>
      // Stop one level early.
      iunlock(ip);
801025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025a5:	89 04 24             	mov    %eax,(%esp)
801025a8:	e8 6f f6 ff ff       	call   80101c1c <iunlock>
      return ip;
801025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025b0:	e9 80 00 00 00       	jmp    80102635 <namex+0x111>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801025b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801025bc:	00 
801025bd:	8b 45 10             	mov    0x10(%ebp),%eax
801025c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025c7:	89 04 24             	mov    %eax,(%esp)
801025ca:	e8 ef fc ff ff       	call   801022be <dirlookup>
801025cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801025d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801025d6:	75 12                	jne    801025ea <namex+0xc6>
      iunlockput(ip);
801025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025db:	89 04 24             	mov    %eax,(%esp)
801025de:	e8 2e f7 ff ff       	call   80101d11 <iunlockput>
      return 0;
801025e3:	b8 00 00 00 00       	mov    $0x0,%eax
801025e8:	eb 4b                	jmp    80102635 <namex+0x111>
    }
    iunlockput(ip);
801025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ed:	89 04 24             	mov    %eax,(%esp)
801025f0:	e8 1c f7 ff ff       	call   80101d11 <iunlockput>
    ip = next;
801025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801025fb:	8b 45 10             	mov    0x10(%ebp),%eax
801025fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102602:	8b 45 08             	mov    0x8(%ebp),%eax
80102605:	89 04 24             	mov    %eax,(%esp)
80102608:	e8 6d fe ff ff       	call   8010247a <skipelem>
8010260d:	89 45 08             	mov    %eax,0x8(%ebp)
80102610:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102614:	0f 85 4d ff ff ff    	jne    80102567 <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010261a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010261e:	74 12                	je     80102632 <namex+0x10e>
    iput(ip);
80102620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102623:	89 04 24             	mov    %eax,(%esp)
80102626:	e8 35 f6 ff ff       	call   80101c60 <iput>
    return 0;
8010262b:	b8 00 00 00 00       	mov    $0x0,%eax
80102630:	eb 03                	jmp    80102635 <namex+0x111>
  }
  return ip;
80102632:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102635:	c9                   	leave  
80102636:	c3                   	ret    

80102637 <namei>:

struct inode*
namei(char *path)
{
80102637:	55                   	push   %ebp
80102638:	89 e5                	mov    %esp,%ebp
8010263a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010263d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102640:	89 44 24 08          	mov    %eax,0x8(%esp)
80102644:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010264b:	00 
8010264c:	8b 45 08             	mov    0x8(%ebp),%eax
8010264f:	89 04 24             	mov    %eax,(%esp)
80102652:	e8 cd fe ff ff       	call   80102524 <namex>
}
80102657:	c9                   	leave  
80102658:	c3                   	ret    

80102659 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102659:	55                   	push   %ebp
8010265a:	89 e5                	mov    %esp,%ebp
8010265c:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010265f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102662:	89 44 24 08          	mov    %eax,0x8(%esp)
80102666:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010266d:	00 
8010266e:	8b 45 08             	mov    0x8(%ebp),%eax
80102671:	89 04 24             	mov    %eax,(%esp)
80102674:	e8 ab fe ff ff       	call   80102524 <namex>
}
80102679:	c9                   	leave  
8010267a:	c3                   	ret    
	...

8010267c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010267c:	55                   	push   %ebp
8010267d:	89 e5                	mov    %esp,%ebp
8010267f:	83 ec 14             	sub    $0x14,%esp
80102682:	8b 45 08             	mov    0x8(%ebp),%eax
80102685:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102689:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010268c:	89 c2                	mov    %eax,%edx
8010268e:	ec                   	in     (%dx),%al
8010268f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102692:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102695:	c9                   	leave  
80102696:	c3                   	ret    

80102697 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102697:	55                   	push   %ebp
80102698:	89 e5                	mov    %esp,%ebp
8010269a:	57                   	push   %edi
8010269b:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010269c:	8b 55 08             	mov    0x8(%ebp),%edx
8010269f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026a2:	8b 45 10             	mov    0x10(%ebp),%eax
801026a5:	89 cb                	mov    %ecx,%ebx
801026a7:	89 df                	mov    %ebx,%edi
801026a9:	89 c1                	mov    %eax,%ecx
801026ab:	fc                   	cld    
801026ac:	f3 6d                	rep insl (%dx),%es:(%edi)
801026ae:	89 c8                	mov    %ecx,%eax
801026b0:	89 fb                	mov    %edi,%ebx
801026b2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026b5:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801026b8:	5b                   	pop    %ebx
801026b9:	5f                   	pop    %edi
801026ba:	5d                   	pop    %ebp
801026bb:	c3                   	ret    

801026bc <outb>:

static inline void
outb(ushort port, uchar data)
{
801026bc:	55                   	push   %ebp
801026bd:	89 e5                	mov    %esp,%ebp
801026bf:	83 ec 08             	sub    $0x8,%esp
801026c2:	8b 45 08             	mov    0x8(%ebp),%eax
801026c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801026c8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801026cc:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026cf:	8a 45 f8             	mov    -0x8(%ebp),%al
801026d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801026d5:	ee                   	out    %al,(%dx)
}
801026d6:	c9                   	leave  
801026d7:	c3                   	ret    

801026d8 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801026d8:	55                   	push   %ebp
801026d9:	89 e5                	mov    %esp,%ebp
801026db:	56                   	push   %esi
801026dc:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801026dd:	8b 55 08             	mov    0x8(%ebp),%edx
801026e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026e3:	8b 45 10             	mov    0x10(%ebp),%eax
801026e6:	89 cb                	mov    %ecx,%ebx
801026e8:	89 de                	mov    %ebx,%esi
801026ea:	89 c1                	mov    %eax,%ecx
801026ec:	fc                   	cld    
801026ed:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801026ef:	89 c8                	mov    %ecx,%eax
801026f1:	89 f3                	mov    %esi,%ebx
801026f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026f6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801026f9:	5b                   	pop    %ebx
801026fa:	5e                   	pop    %esi
801026fb:	5d                   	pop    %ebp
801026fc:	c3                   	ret    

801026fd <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801026fd:	55                   	push   %ebp
801026fe:	89 e5                	mov    %esp,%ebp
80102700:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102703:	90                   	nop
80102704:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010270b:	e8 6c ff ff ff       	call   8010267c <inb>
80102710:	0f b6 c0             	movzbl %al,%eax
80102713:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102716:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102719:	25 c0 00 00 00       	and    $0xc0,%eax
8010271e:	83 f8 40             	cmp    $0x40,%eax
80102721:	75 e1                	jne    80102704 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102723:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102727:	74 11                	je     8010273a <idewait+0x3d>
80102729:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010272c:	83 e0 21             	and    $0x21,%eax
8010272f:	85 c0                	test   %eax,%eax
80102731:	74 07                	je     8010273a <idewait+0x3d>
    return -1;
80102733:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102738:	eb 05                	jmp    8010273f <idewait+0x42>
  return 0;
8010273a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010273f:	c9                   	leave  
80102740:	c3                   	ret    

80102741 <ideinit>:

void
ideinit(void)
{
80102741:	55                   	push   %ebp
80102742:	89 e5                	mov    %esp,%ebp
80102744:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102747:	c7 44 24 04 9f 96 10 	movl   $0x8010969f,0x4(%esp)
8010274e:	80 
8010274f:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102756:	e8 97 27 00 00       	call   80104ef2 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010275b:	a1 40 56 11 80       	mov    0x80115640,%eax
80102760:	48                   	dec    %eax
80102761:	89 44 24 04          	mov    %eax,0x4(%esp)
80102765:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010276c:	e8 66 04 00 00       	call   80102bd7 <ioapicenable>
  idewait(0);
80102771:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102778:	e8 80 ff ff ff       	call   801026fd <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010277d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102784:	00 
80102785:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010278c:	e8 2b ff ff ff       	call   801026bc <outb>
  for(i=0; i<1000; i++){
80102791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102798:	eb 1f                	jmp    801027b9 <ideinit+0x78>
    if(inb(0x1f7) != 0){
8010279a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027a1:	e8 d6 fe ff ff       	call   8010267c <inb>
801027a6:	84 c0                	test   %al,%al
801027a8:	74 0c                	je     801027b6 <ideinit+0x75>
      havedisk1 = 1;
801027aa:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
801027b1:	00 00 00 
      break;
801027b4:	eb 0c                	jmp    801027c2 <ideinit+0x81>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801027b6:	ff 45 f4             	incl   -0xc(%ebp)
801027b9:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801027c0:	7e d8                	jle    8010279a <ideinit+0x59>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801027c2:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801027c9:	00 
801027ca:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801027d1:	e8 e6 fe ff ff       	call   801026bc <outb>
}
801027d6:	c9                   	leave  
801027d7:	c3                   	ret    

801027d8 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027d8:	55                   	push   %ebp
801027d9:	89 e5                	mov    %esp,%ebp
801027db:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
801027de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801027e2:	75 0c                	jne    801027f0 <idestart+0x18>
    panic("idestart");
801027e4:	c7 04 24 a3 96 10 80 	movl   $0x801096a3,(%esp)
801027eb:	e8 64 dd ff ff       	call   80100554 <panic>
  if(b->blockno >= FSSIZE)
801027f0:	8b 45 08             	mov    0x8(%ebp),%eax
801027f3:	8b 40 08             	mov    0x8(%eax),%eax
801027f6:	3d 1f 4e 00 00       	cmp    $0x4e1f,%eax
801027fb:	76 0c                	jbe    80102809 <idestart+0x31>
    panic("incorrect blockno");
801027fd:	c7 04 24 ac 96 10 80 	movl   $0x801096ac,(%esp)
80102804:	e8 4b dd ff ff       	call   80100554 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102809:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102810:	8b 45 08             	mov    0x8(%ebp),%eax
80102813:	8b 50 08             	mov    0x8(%eax),%edx
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102819:	0f af c2             	imul   %edx,%eax
8010281c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010281f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102823:	75 07                	jne    8010282c <idestart+0x54>
80102825:	b8 20 00 00 00       	mov    $0x20,%eax
8010282a:	eb 05                	jmp    80102831 <idestart+0x59>
8010282c:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102831:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102834:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102838:	75 07                	jne    80102841 <idestart+0x69>
8010283a:	b8 30 00 00 00       	mov    $0x30,%eax
8010283f:	eb 05                	jmp    80102846 <idestart+0x6e>
80102841:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102846:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102849:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010284d:	7e 0c                	jle    8010285b <idestart+0x83>
8010284f:	c7 04 24 a3 96 10 80 	movl   $0x801096a3,(%esp)
80102856:	e8 f9 dc ff ff       	call   80100554 <panic>

  idewait(0);
8010285b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102862:	e8 96 fe ff ff       	call   801026fd <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102867:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010286e:	00 
8010286f:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102876:	e8 41 fe ff ff       	call   801026bc <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
8010287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287e:	0f b6 c0             	movzbl %al,%eax
80102881:	89 44 24 04          	mov    %eax,0x4(%esp)
80102885:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010288c:	e8 2b fe ff ff       	call   801026bc <outb>
  outb(0x1f3, sector & 0xff);
80102891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102894:	0f b6 c0             	movzbl %al,%eax
80102897:	89 44 24 04          	mov    %eax,0x4(%esp)
8010289b:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801028a2:	e8 15 fe ff ff       	call   801026bc <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028aa:	c1 f8 08             	sar    $0x8,%eax
801028ad:	0f b6 c0             	movzbl %al,%eax
801028b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801028b4:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801028bb:	e8 fc fd ff ff       	call   801026bc <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028c3:	c1 f8 10             	sar    $0x10,%eax
801028c6:	0f b6 c0             	movzbl %al,%eax
801028c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801028cd:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801028d4:	e8 e3 fd ff ff       	call   801026bc <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801028d9:	8b 45 08             	mov    0x8(%ebp),%eax
801028dc:	8b 40 04             	mov    0x4(%eax),%eax
801028df:	83 e0 01             	and    $0x1,%eax
801028e2:	c1 e0 04             	shl    $0x4,%eax
801028e5:	88 c2                	mov    %al,%dl
801028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028ea:	c1 f8 18             	sar    $0x18,%eax
801028ed:	83 e0 0f             	and    $0xf,%eax
801028f0:	09 d0                	or     %edx,%eax
801028f2:	83 c8 e0             	or     $0xffffffe0,%eax
801028f5:	0f b6 c0             	movzbl %al,%eax
801028f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801028fc:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102903:	e8 b4 fd ff ff       	call   801026bc <outb>
  if(b->flags & B_DIRTY){
80102908:	8b 45 08             	mov    0x8(%ebp),%eax
8010290b:	8b 00                	mov    (%eax),%eax
8010290d:	83 e0 04             	and    $0x4,%eax
80102910:	85 c0                	test   %eax,%eax
80102912:	74 36                	je     8010294a <idestart+0x172>
    outb(0x1f7, write_cmd);
80102914:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102917:	0f b6 c0             	movzbl %al,%eax
8010291a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010291e:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102925:	e8 92 fd ff ff       	call   801026bc <outb>
    outsl(0x1f0, b->data, BSIZE/4);
8010292a:	8b 45 08             	mov    0x8(%ebp),%eax
8010292d:	83 c0 5c             	add    $0x5c,%eax
80102930:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102937:	00 
80102938:	89 44 24 04          	mov    %eax,0x4(%esp)
8010293c:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102943:	e8 90 fd ff ff       	call   801026d8 <outsl>
80102948:	eb 16                	jmp    80102960 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
8010294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010294d:	0f b6 c0             	movzbl %al,%eax
80102950:	89 44 24 04          	mov    %eax,0x4(%esp)
80102954:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010295b:	e8 5c fd ff ff       	call   801026bc <outb>
  }
}
80102960:	c9                   	leave  
80102961:	c3                   	ret    

80102962 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102962:	55                   	push   %ebp
80102963:	89 e5                	mov    %esp,%ebp
80102965:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102968:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010296f:	e8 9f 25 00 00       	call   80104f13 <acquire>

  if((b = idequeue) == 0){
80102974:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102979:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102980:	75 11                	jne    80102993 <ideintr+0x31>
    release(&idelock);
80102982:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102989:	e8 ef 25 00 00       	call   80104f7d <release>
    return;
8010298e:	e9 90 00 00 00       	jmp    80102a23 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102996:	8b 40 58             	mov    0x58(%eax),%eax
80102999:	a3 74 c6 10 80       	mov    %eax,0x8010c674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a1:	8b 00                	mov    (%eax),%eax
801029a3:	83 e0 04             	and    $0x4,%eax
801029a6:	85 c0                	test   %eax,%eax
801029a8:	75 2e                	jne    801029d8 <ideintr+0x76>
801029aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029b1:	e8 47 fd ff ff       	call   801026fd <idewait>
801029b6:	85 c0                	test   %eax,%eax
801029b8:	78 1e                	js     801029d8 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029bd:	83 c0 5c             	add    $0x5c,%eax
801029c0:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801029c7:	00 
801029c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029cc:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801029d3:	e8 bf fc ff ff       	call   80102697 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029db:	8b 00                	mov    (%eax),%eax
801029dd:	83 c8 02             	or     $0x2,%eax
801029e0:	89 c2                	mov    %eax,%edx
801029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e5:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ea:	8b 00                	mov    (%eax),%eax
801029ec:	83 e0 fb             	and    $0xfffffffb,%eax
801029ef:	89 c2                	mov    %eax,%edx
801029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f4:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f9:	89 04 24             	mov    %eax,(%esp)
801029fc:	e8 17 22 00 00       	call   80104c18 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a01:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102a06:	85 c0                	test   %eax,%eax
80102a08:	74 0d                	je     80102a17 <ideintr+0xb5>
    idestart(idequeue);
80102a0a:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102a0f:	89 04 24             	mov    %eax,(%esp)
80102a12:	e8 c1 fd ff ff       	call   801027d8 <idestart>

  release(&idelock);
80102a17:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102a1e:	e8 5a 25 00 00       	call   80104f7d <release>
}
80102a23:	c9                   	leave  
80102a24:	c3                   	ret    

80102a25 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a25:	55                   	push   %ebp
80102a26:	89 e5                	mov    %esp,%ebp
80102a28:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2e:	83 c0 0c             	add    $0xc,%eax
80102a31:	89 04 24             	mov    %eax,(%esp)
80102a34:	e8 52 24 00 00       	call   80104e8b <holdingsleep>
80102a39:	85 c0                	test   %eax,%eax
80102a3b:	75 0c                	jne    80102a49 <iderw+0x24>
    panic("iderw: buf not locked");
80102a3d:	c7 04 24 be 96 10 80 	movl   $0x801096be,(%esp)
80102a44:	e8 0b db ff ff       	call   80100554 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102a49:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4c:	8b 00                	mov    (%eax),%eax
80102a4e:	83 e0 06             	and    $0x6,%eax
80102a51:	83 f8 02             	cmp    $0x2,%eax
80102a54:	75 0c                	jne    80102a62 <iderw+0x3d>
    panic("iderw: nothing to do");
80102a56:	c7 04 24 d4 96 10 80 	movl   $0x801096d4,(%esp)
80102a5d:	e8 f2 da ff ff       	call   80100554 <panic>
  if(b->dev != 0 && !havedisk1)
80102a62:	8b 45 08             	mov    0x8(%ebp),%eax
80102a65:	8b 40 04             	mov    0x4(%eax),%eax
80102a68:	85 c0                	test   %eax,%eax
80102a6a:	74 15                	je     80102a81 <iderw+0x5c>
80102a6c:	a1 78 c6 10 80       	mov    0x8010c678,%eax
80102a71:	85 c0                	test   %eax,%eax
80102a73:	75 0c                	jne    80102a81 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102a75:	c7 04 24 e9 96 10 80 	movl   $0x801096e9,(%esp)
80102a7c:	e8 d3 da ff ff       	call   80100554 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a81:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102a88:	e8 86 24 00 00       	call   80104f13 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a90:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a97:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80102a9e:	eb 0b                	jmp    80102aab <iderw+0x86>
80102aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa3:	8b 00                	mov    (%eax),%eax
80102aa5:	83 c0 58             	add    $0x58,%eax
80102aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aae:	8b 00                	mov    (%eax),%eax
80102ab0:	85 c0                	test   %eax,%eax
80102ab2:	75 ec                	jne    80102aa0 <iderw+0x7b>
    ;
  *pp = b;
80102ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80102aba:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102abc:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102ac1:	3b 45 08             	cmp    0x8(%ebp),%eax
80102ac4:	75 0d                	jne    80102ad3 <iderw+0xae>
    idestart(b);
80102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac9:	89 04 24             	mov    %eax,(%esp)
80102acc:	e8 07 fd ff ff       	call   801027d8 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ad1:	eb 15                	jmp    80102ae8 <iderw+0xc3>
80102ad3:	eb 13                	jmp    80102ae8 <iderw+0xc3>
    sleep(b, &idelock);
80102ad5:	c7 44 24 04 40 c6 10 	movl   $0x8010c640,0x4(%esp)
80102adc:	80 
80102add:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae0:	89 04 24             	mov    %eax,(%esp)
80102ae3:	e8 5c 20 00 00       	call   80104b44 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80102aeb:	8b 00                	mov    (%eax),%eax
80102aed:	83 e0 06             	and    $0x6,%eax
80102af0:	83 f8 02             	cmp    $0x2,%eax
80102af3:	75 e0                	jne    80102ad5 <iderw+0xb0>
    sleep(b, &idelock);
  }


  release(&idelock);
80102af5:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102afc:	e8 7c 24 00 00       	call   80104f7d <release>
}
80102b01:	c9                   	leave  
80102b02:	c3                   	ret    
	...

80102b04 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b04:	55                   	push   %ebp
80102b05:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b07:	a1 74 4f 11 80       	mov    0x80114f74,%eax
80102b0c:	8b 55 08             	mov    0x8(%ebp),%edx
80102b0f:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102b11:	a1 74 4f 11 80       	mov    0x80114f74,%eax
80102b16:	8b 40 10             	mov    0x10(%eax),%eax
}
80102b19:	5d                   	pop    %ebp
80102b1a:	c3                   	ret    

80102b1b <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102b1b:	55                   	push   %ebp
80102b1c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b1e:	a1 74 4f 11 80       	mov    0x80114f74,%eax
80102b23:	8b 55 08             	mov    0x8(%ebp),%edx
80102b26:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102b28:	a1 74 4f 11 80       	mov    0x80114f74,%eax
80102b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102b30:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b33:	5d                   	pop    %ebp
80102b34:	c3                   	ret    

80102b35 <ioapicinit>:

void
ioapicinit(void)
{
80102b35:	55                   	push   %ebp
80102b36:	89 e5                	mov    %esp,%ebp
80102b38:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102b3b:	c7 05 74 4f 11 80 00 	movl   $0xfec00000,0x80114f74
80102b42:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102b45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102b4c:	e8 b3 ff ff ff       	call   80102b04 <ioapicread>
80102b51:	c1 e8 10             	shr    $0x10,%eax
80102b54:	25 ff 00 00 00       	and    $0xff,%eax
80102b59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102b5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102b63:	e8 9c ff ff ff       	call   80102b04 <ioapicread>
80102b68:	c1 e8 18             	shr    $0x18,%eax
80102b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b6e:	a0 a0 50 11 80       	mov    0x801150a0,%al
80102b73:	0f b6 c0             	movzbl %al,%eax
80102b76:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b79:	74 0c                	je     80102b87 <ioapicinit+0x52>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b7b:	c7 04 24 08 97 10 80 	movl   $0x80109708,(%esp)
80102b82:	e8 3a d8 ff ff       	call   801003c1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b8e:	eb 3d                	jmp    80102bcd <ioapicinit+0x98>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b93:	83 c0 20             	add    $0x20,%eax
80102b96:	0d 00 00 01 00       	or     $0x10000,%eax
80102b9b:	89 c2                	mov    %eax,%edx
80102b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba0:	83 c0 08             	add    $0x8,%eax
80102ba3:	01 c0                	add    %eax,%eax
80102ba5:	89 54 24 04          	mov    %edx,0x4(%esp)
80102ba9:	89 04 24             	mov    %eax,(%esp)
80102bac:	e8 6a ff ff ff       	call   80102b1b <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb4:	83 c0 08             	add    $0x8,%eax
80102bb7:	01 c0                	add    %eax,%eax
80102bb9:	40                   	inc    %eax
80102bba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102bc1:	00 
80102bc2:	89 04 24             	mov    %eax,(%esp)
80102bc5:	e8 51 ff ff ff       	call   80102b1b <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102bca:	ff 45 f4             	incl   -0xc(%ebp)
80102bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102bd3:	7e bb                	jle    80102b90 <ioapicinit+0x5b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102bd5:	c9                   	leave  
80102bd6:	c3                   	ret    

80102bd7 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102bd7:	55                   	push   %ebp
80102bd8:	89 e5                	mov    %esp,%ebp
80102bda:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80102be0:	83 c0 20             	add    $0x20,%eax
80102be3:	89 c2                	mov    %eax,%edx
80102be5:	8b 45 08             	mov    0x8(%ebp),%eax
80102be8:	83 c0 08             	add    $0x8,%eax
80102beb:	01 c0                	add    %eax,%eax
80102bed:	89 54 24 04          	mov    %edx,0x4(%esp)
80102bf1:	89 04 24             	mov    %eax,(%esp)
80102bf4:	e8 22 ff ff ff       	call   80102b1b <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bfc:	c1 e0 18             	shl    $0x18,%eax
80102bff:	8b 55 08             	mov    0x8(%ebp),%edx
80102c02:	83 c2 08             	add    $0x8,%edx
80102c05:	01 d2                	add    %edx,%edx
80102c07:	42                   	inc    %edx
80102c08:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0c:	89 14 24             	mov    %edx,(%esp)
80102c0f:	e8 07 ff ff ff       	call   80102b1b <ioapicwrite>
}
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
	...

80102c18 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c18:	55                   	push   %ebp
80102c19:	89 e5                	mov    %esp,%ebp
80102c1b:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102c1e:	c7 44 24 04 3a 97 10 	movl   $0x8010973a,0x4(%esp)
80102c25:	80 
80102c26:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80102c2d:	e8 c0 22 00 00       	call   80104ef2 <initlock>
  kmem.use_lock = 0;
80102c32:	c7 05 b4 4f 11 80 00 	movl   $0x0,0x80114fb4
80102c39:	00 00 00 
  freerange(vstart, vend);
80102c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c43:	8b 45 08             	mov    0x8(%ebp),%eax
80102c46:	89 04 24             	mov    %eax,(%esp)
80102c49:	e8 26 00 00 00       	call   80102c74 <freerange>
}
80102c4e:	c9                   	leave  
80102c4f:	c3                   	ret    

80102c50 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102c56:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c59:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c60:	89 04 24             	mov    %eax,(%esp)
80102c63:	e8 0c 00 00 00       	call   80102c74 <freerange>
  kmem.use_lock = 1;
80102c68:	c7 05 b4 4f 11 80 01 	movl   $0x1,0x80114fb4
80102c6f:	00 00 00 
}
80102c72:	c9                   	leave  
80102c73:	c3                   	ret    

80102c74 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c74:	55                   	push   %ebp
80102c75:	89 e5                	mov    %esp,%ebp
80102c77:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80102c7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8a:	eb 12                	jmp    80102c9e <freerange+0x2a>
    kfree(p);
80102c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8f:	89 04 24             	mov    %eax,(%esp)
80102c92:	e8 16 00 00 00       	call   80102cad <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c97:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ca1:	05 00 10 00 00       	add    $0x1000,%eax
80102ca6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ca9:	76 e1                	jbe    80102c8c <freerange+0x18>
    kfree(p);
}
80102cab:	c9                   	leave  
80102cac:	c3                   	ret    

80102cad <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102cad:	55                   	push   %ebp
80102cae:	89 e5                	mov    %esp,%ebp
80102cb0:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb6:	25 ff 0f 00 00       	and    $0xfff,%eax
80102cbb:	85 c0                	test   %eax,%eax
80102cbd:	75 18                	jne    80102cd7 <kfree+0x2a>
80102cbf:	81 7d 08 e8 7d 11 80 	cmpl   $0x80117de8,0x8(%ebp)
80102cc6:	72 0f                	jb     80102cd7 <kfree+0x2a>
80102cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80102ccb:	05 00 00 00 80       	add    $0x80000000,%eax
80102cd0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102cd5:	76 0c                	jbe    80102ce3 <kfree+0x36>
    panic("kfree");
80102cd7:	c7 04 24 3f 97 10 80 	movl   $0x8010973f,(%esp)
80102cde:	e8 71 d8 ff ff       	call   80100554 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ce3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102cea:	00 
80102ceb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102cf2:	00 
80102cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf6:	89 04 24             	mov    %eax,(%esp)
80102cf9:	e8 78 24 00 00       	call   80105176 <memset>

  if(kmem.use_lock)
80102cfe:	a1 b4 4f 11 80       	mov    0x80114fb4,%eax
80102d03:	85 c0                	test   %eax,%eax
80102d05:	74 0c                	je     80102d13 <kfree+0x66>
    acquire(&kmem.lock);
80102d07:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80102d0e:	e8 00 22 00 00       	call   80104f13 <acquire>
  r = (struct run*)v;
80102d13:	8b 45 08             	mov    0x8(%ebp),%eax
80102d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d19:	8b 15 b8 4f 11 80    	mov    0x80114fb8,%edx
80102d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d22:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d27:	a3 b8 4f 11 80       	mov    %eax,0x80114fb8
  if(kmem.use_lock)
80102d2c:	a1 b4 4f 11 80       	mov    0x80114fb4,%eax
80102d31:	85 c0                	test   %eax,%eax
80102d33:	74 0c                	je     80102d41 <kfree+0x94>
    release(&kmem.lock);
80102d35:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80102d3c:	e8 3c 22 00 00       	call   80104f7d <release>
}
80102d41:	c9                   	leave  
80102d42:	c3                   	ret    

80102d43 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d43:	55                   	push   %ebp
80102d44:	89 e5                	mov    %esp,%ebp
80102d46:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102d49:	a1 b4 4f 11 80       	mov    0x80114fb4,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	74 0c                	je     80102d5e <kalloc+0x1b>
    acquire(&kmem.lock);
80102d52:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80102d59:	e8 b5 21 00 00       	call   80104f13 <acquire>
  r = kmem.freelist;
80102d5e:	a1 b8 4f 11 80       	mov    0x80114fb8,%eax
80102d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d6a:	74 0a                	je     80102d76 <kalloc+0x33>
    kmem.freelist = r->next;
80102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d6f:	8b 00                	mov    (%eax),%eax
80102d71:	a3 b8 4f 11 80       	mov    %eax,0x80114fb8
  if(kmem.use_lock)
80102d76:	a1 b4 4f 11 80       	mov    0x80114fb4,%eax
80102d7b:	85 c0                	test   %eax,%eax
80102d7d:	74 0c                	je     80102d8b <kalloc+0x48>
    release(&kmem.lock);
80102d7f:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80102d86:	e8 f2 21 00 00       	call   80104f7d <release>
  return (char*)r;
80102d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d8e:	c9                   	leave  
80102d8f:	c3                   	ret    

80102d90 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	83 ec 14             	sub    $0x14,%esp
80102d96:	8b 45 08             	mov    0x8(%ebp),%eax
80102d99:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	ec                   	in     (%dx),%al
80102da3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102da6:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102da9:	c9                   	leave  
80102daa:	c3                   	ret    

80102dab <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102dab:	55                   	push   %ebp
80102dac:	89 e5                	mov    %esp,%ebp
80102dae:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102db1:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102db8:	e8 d3 ff ff ff       	call   80102d90 <inb>
80102dbd:	0f b6 c0             	movzbl %al,%eax
80102dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dc6:	83 e0 01             	and    $0x1,%eax
80102dc9:	85 c0                	test   %eax,%eax
80102dcb:	75 0a                	jne    80102dd7 <kbdgetc+0x2c>
    return -1;
80102dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102dd2:	e9 21 01 00 00       	jmp    80102ef8 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102dd7:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102dde:	e8 ad ff ff ff       	call   80102d90 <inb>
80102de3:	0f b6 c0             	movzbl %al,%eax
80102de6:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102de9:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102df0:	75 17                	jne    80102e09 <kbdgetc+0x5e>
    shift |= E0ESC;
80102df2:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102df7:	83 c8 40             	or     $0x40,%eax
80102dfa:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102dff:	b8 00 00 00 00       	mov    $0x0,%eax
80102e04:	e9 ef 00 00 00       	jmp    80102ef8 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e0c:	25 80 00 00 00       	and    $0x80,%eax
80102e11:	85 c0                	test   %eax,%eax
80102e13:	74 44                	je     80102e59 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102e15:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e1a:	83 e0 40             	and    $0x40,%eax
80102e1d:	85 c0                	test   %eax,%eax
80102e1f:	75 08                	jne    80102e29 <kbdgetc+0x7e>
80102e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e24:	83 e0 7f             	and    $0x7f,%eax
80102e27:	eb 03                	jmp    80102e2c <kbdgetc+0x81>
80102e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e32:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e37:	8a 00                	mov    (%eax),%al
80102e39:	83 c8 40             	or     $0x40,%eax
80102e3c:	0f b6 c0             	movzbl %al,%eax
80102e3f:	f7 d0                	not    %eax
80102e41:	89 c2                	mov    %eax,%edx
80102e43:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e48:	21 d0                	and    %edx,%eax
80102e4a:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102e4f:	b8 00 00 00 00       	mov    $0x0,%eax
80102e54:	e9 9f 00 00 00       	jmp    80102ef8 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e59:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e5e:	83 e0 40             	and    $0x40,%eax
80102e61:	85 c0                	test   %eax,%eax
80102e63:	74 14                	je     80102e79 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e65:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e6c:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e71:	83 e0 bf             	and    $0xffffffbf,%eax
80102e74:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  }

  shift |= shiftcode[data];
80102e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e7c:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e81:	8a 00                	mov    (%eax),%al
80102e83:	0f b6 d0             	movzbl %al,%edx
80102e86:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e8b:	09 d0                	or     %edx,%eax
80102e8d:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  shift ^= togglecode[data];
80102e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e95:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e9a:	8a 00                	mov    (%eax),%al
80102e9c:	0f b6 d0             	movzbl %al,%edx
80102e9f:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ea4:	31 d0                	xor    %edx,%eax
80102ea6:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  c = charcode[shift & (CTL | SHIFT)][data];
80102eab:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102eb0:	83 e0 03             	and    $0x3,%eax
80102eb3:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ebd:	01 d0                	add    %edx,%eax
80102ebf:	8a 00                	mov    (%eax),%al
80102ec1:	0f b6 c0             	movzbl %al,%eax
80102ec4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ec7:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ecc:	83 e0 08             	and    $0x8,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	74 22                	je     80102ef5 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102ed3:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ed7:	76 0c                	jbe    80102ee5 <kbdgetc+0x13a>
80102ed9:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102edd:	77 06                	ja     80102ee5 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102edf:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102ee3:	eb 10                	jmp    80102ef5 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102ee5:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ee9:	76 0a                	jbe    80102ef5 <kbdgetc+0x14a>
80102eeb:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102eef:	77 04                	ja     80102ef5 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ef1:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ef8:	c9                   	leave  
80102ef9:	c3                   	ret    

80102efa <kbdintr>:

void
kbdintr(void)
{
80102efa:	55                   	push   %ebp
80102efb:	89 e5                	mov    %esp,%ebp
80102efd:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102f00:	c7 04 24 ab 2d 10 80 	movl   $0x80102dab,(%esp)
80102f07:	e8 e9 d8 ff ff       	call   801007f5 <consoleintr>
}
80102f0c:	c9                   	leave  
80102f0d:	c3                   	ret    
	...

80102f10 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 14             	sub    $0x14,%esp
80102f16:	8b 45 08             	mov    0x8(%ebp),%eax
80102f19:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f20:	89 c2                	mov    %eax,%edx
80102f22:	ec                   	in     (%dx),%al
80102f23:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f26:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102f29:	c9                   	leave  
80102f2a:	c3                   	ret    

80102f2b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102f2b:	55                   	push   %ebp
80102f2c:	89 e5                	mov    %esp,%ebp
80102f2e:	83 ec 08             	sub    $0x8,%esp
80102f31:	8b 45 08             	mov    0x8(%ebp),%eax
80102f34:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f37:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102f3b:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f3e:	8a 45 f8             	mov    -0x8(%ebp),%al
80102f41:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102f44:	ee                   	out    %al,(%dx)
}
80102f45:	c9                   	leave  
80102f46:	c3                   	ret    

80102f47 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102f47:	55                   	push   %ebp
80102f48:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f4a:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
80102f4f:	8b 55 08             	mov    0x8(%ebp),%edx
80102f52:	c1 e2 02             	shl    $0x2,%edx
80102f55:	01 c2                	add    %eax,%edx
80102f57:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f5a:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f5c:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
80102f61:	83 c0 20             	add    $0x20,%eax
80102f64:	8b 00                	mov    (%eax),%eax
}
80102f66:	5d                   	pop    %ebp
80102f67:	c3                   	ret    

80102f68 <lapicinit>:

void
lapicinit(void)
{
80102f68:	55                   	push   %ebp
80102f69:	89 e5                	mov    %esp,%ebp
80102f6b:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102f6e:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
80102f73:	85 c0                	test   %eax,%eax
80102f75:	75 05                	jne    80102f7c <lapicinit+0x14>
    return;
80102f77:	e9 43 01 00 00       	jmp    801030bf <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f7c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102f83:	00 
80102f84:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102f8b:	e8 b7 ff ff ff       	call   80102f47 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f90:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102f97:	00 
80102f98:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102f9f:	e8 a3 ff ff ff       	call   80102f47 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102fa4:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102fab:	00 
80102fac:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fb3:	e8 8f ff ff ff       	call   80102f47 <lapicw>
  lapicw(TICR, 10000000);
80102fb8:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102fbf:	00 
80102fc0:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102fc7:	e8 7b ff ff ff       	call   80102f47 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102fcc:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102fd3:	00 
80102fd4:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102fdb:	e8 67 ff ff ff       	call   80102f47 <lapicw>
  lapicw(LINT1, MASKED);
80102fe0:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102fe7:	00 
80102fe8:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102fef:	e8 53 ff ff ff       	call   80102f47 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ff4:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
80102ff9:	83 c0 30             	add    $0x30,%eax
80102ffc:	8b 00                	mov    (%eax),%eax
80102ffe:	c1 e8 10             	shr    $0x10,%eax
80103001:	0f b6 c0             	movzbl %al,%eax
80103004:	83 f8 03             	cmp    $0x3,%eax
80103007:	76 14                	jbe    8010301d <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80103009:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103010:	00 
80103011:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80103018:	e8 2a ff ff ff       	call   80102f47 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010301d:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80103024:	00 
80103025:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
8010302c:	e8 16 ff ff ff       	call   80102f47 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103031:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103038:	00 
80103039:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103040:	e8 02 ff ff ff       	call   80102f47 <lapicw>
  lapicw(ESR, 0);
80103045:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010304c:	00 
8010304d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103054:	e8 ee fe ff ff       	call   80102f47 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103059:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103060:	00 
80103061:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103068:	e8 da fe ff ff       	call   80102f47 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010306d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103074:	00 
80103075:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010307c:	e8 c6 fe ff ff       	call   80102f47 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103081:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80103088:	00 
80103089:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103090:	e8 b2 fe ff ff       	call   80102f47 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80103095:	90                   	nop
80103096:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
8010309b:	05 00 03 00 00       	add    $0x300,%eax
801030a0:	8b 00                	mov    (%eax),%eax
801030a2:	25 00 10 00 00       	and    $0x1000,%eax
801030a7:	85 c0                	test   %eax,%eax
801030a9:	75 eb                	jne    80103096 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801030ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030b2:	00 
801030b3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801030ba:	e8 88 fe ff ff       	call   80102f47 <lapicw>
}
801030bf:	c9                   	leave  
801030c0:	c3                   	ret    

801030c1 <lapicid>:

int
lapicid(void)
{
801030c1:	55                   	push   %ebp
801030c2:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801030c4:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
801030c9:	85 c0                	test   %eax,%eax
801030cb:	75 07                	jne    801030d4 <lapicid+0x13>
    return 0;
801030cd:	b8 00 00 00 00       	mov    $0x0,%eax
801030d2:	eb 0d                	jmp    801030e1 <lapicid+0x20>
  return lapic[ID] >> 24;
801030d4:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
801030d9:	83 c0 20             	add    $0x20,%eax
801030dc:	8b 00                	mov    (%eax),%eax
801030de:	c1 e8 18             	shr    $0x18,%eax
}
801030e1:	5d                   	pop    %ebp
801030e2:	c3                   	ret    

801030e3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030e3:	55                   	push   %ebp
801030e4:	89 e5                	mov    %esp,%ebp
801030e6:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
801030e9:	a1 bc 4f 11 80       	mov    0x80114fbc,%eax
801030ee:	85 c0                	test   %eax,%eax
801030f0:	74 14                	je     80103106 <lapiceoi+0x23>
    lapicw(EOI, 0);
801030f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030f9:	00 
801030fa:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103101:	e8 41 fe ff ff       	call   80102f47 <lapicw>
}
80103106:	c9                   	leave  
80103107:	c3                   	ret    

80103108 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103108:	55                   	push   %ebp
80103109:	89 e5                	mov    %esp,%ebp
}
8010310b:	5d                   	pop    %ebp
8010310c:	c3                   	ret    

8010310d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010310d:	55                   	push   %ebp
8010310e:	89 e5                	mov    %esp,%ebp
80103110:	83 ec 1c             	sub    $0x1c,%esp
80103113:	8b 45 08             	mov    0x8(%ebp),%eax
80103116:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103119:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80103120:	00 
80103121:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103128:	e8 fe fd ff ff       	call   80102f2b <outb>
  outb(CMOS_PORT+1, 0x0A);
8010312d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103134:	00 
80103135:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010313c:	e8 ea fd ff ff       	call   80102f2b <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103141:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103148:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010314b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103150:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103153:	8d 50 02             	lea    0x2(%eax),%edx
80103156:	8b 45 0c             	mov    0xc(%ebp),%eax
80103159:	c1 e8 04             	shr    $0x4,%eax
8010315c:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010315f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103163:	c1 e0 18             	shl    $0x18,%eax
80103166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010316a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103171:	e8 d1 fd ff ff       	call   80102f47 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103176:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010317d:	00 
8010317e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103185:	e8 bd fd ff ff       	call   80102f47 <lapicw>
  microdelay(200);
8010318a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103191:	e8 72 ff ff ff       	call   80103108 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103196:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010319d:	00 
8010319e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801031a5:	e8 9d fd ff ff       	call   80102f47 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801031aa:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801031b1:	e8 52 ff ff ff       	call   80103108 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801031bd:	eb 3f                	jmp    801031fe <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
801031bf:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031c3:	c1 e0 18             	shl    $0x18,%eax
801031c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801031ca:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801031d1:	e8 71 fd ff ff       	call   80102f47 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801031d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801031d9:	c1 e8 0c             	shr    $0xc,%eax
801031dc:	80 cc 06             	or     $0x6,%ah
801031df:	89 44 24 04          	mov    %eax,0x4(%esp)
801031e3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801031ea:	e8 58 fd ff ff       	call   80102f47 <lapicw>
    microdelay(200);
801031ef:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801031f6:	e8 0d ff ff ff       	call   80103108 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031fb:	ff 45 fc             	incl   -0x4(%ebp)
801031fe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103202:	7e bb                	jle    801031bf <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103204:	c9                   	leave  
80103205:	c3                   	ret    

80103206 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103206:	55                   	push   %ebp
80103207:	89 e5                	mov    %esp,%ebp
80103209:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010320c:	8b 45 08             	mov    0x8(%ebp),%eax
8010320f:	0f b6 c0             	movzbl %al,%eax
80103212:	89 44 24 04          	mov    %eax,0x4(%esp)
80103216:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010321d:	e8 09 fd ff ff       	call   80102f2b <outb>
  microdelay(200);
80103222:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103229:	e8 da fe ff ff       	call   80103108 <microdelay>

  return inb(CMOS_RETURN);
8010322e:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103235:	e8 d6 fc ff ff       	call   80102f10 <inb>
8010323a:	0f b6 c0             	movzbl %al,%eax
}
8010323d:	c9                   	leave  
8010323e:	c3                   	ret    

8010323f <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010323f:	55                   	push   %ebp
80103240:	89 e5                	mov    %esp,%ebp
80103242:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103245:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010324c:	e8 b5 ff ff ff       	call   80103206 <cmos_read>
80103251:	8b 55 08             	mov    0x8(%ebp),%edx
80103254:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103256:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010325d:	e8 a4 ff ff ff       	call   80103206 <cmos_read>
80103262:	8b 55 08             	mov    0x8(%ebp),%edx
80103265:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103268:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010326f:	e8 92 ff ff ff       	call   80103206 <cmos_read>
80103274:	8b 55 08             	mov    0x8(%ebp),%edx
80103277:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010327a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103281:	e8 80 ff ff ff       	call   80103206 <cmos_read>
80103286:	8b 55 08             	mov    0x8(%ebp),%edx
80103289:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010328c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103293:	e8 6e ff ff ff       	call   80103206 <cmos_read>
80103298:	8b 55 08             	mov    0x8(%ebp),%edx
8010329b:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010329e:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801032a5:	e8 5c ff ff ff       	call   80103206 <cmos_read>
801032aa:	8b 55 08             	mov    0x8(%ebp),%edx
801032ad:	89 42 14             	mov    %eax,0x14(%edx)
}
801032b0:	c9                   	leave  
801032b1:	c3                   	ret    

801032b2 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801032b2:	55                   	push   %ebp
801032b3:	89 e5                	mov    %esp,%ebp
801032b5:	57                   	push   %edi
801032b6:	56                   	push   %esi
801032b7:	53                   	push   %ebx
801032b8:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801032bb:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801032c2:	e8 3f ff ff ff       	call   80103206 <cmos_read>
801032c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801032ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032cd:	83 e0 04             	and    $0x4,%eax
801032d0:	85 c0                	test   %eax,%eax
801032d2:	0f 94 c0             	sete   %al
801032d5:	0f b6 c0             	movzbl %al,%eax
801032d8:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801032db:	8d 45 c8             	lea    -0x38(%ebp),%eax
801032de:	89 04 24             	mov    %eax,(%esp)
801032e1:	e8 59 ff ff ff       	call   8010323f <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801032e6:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801032ed:	e8 14 ff ff ff       	call   80103206 <cmos_read>
801032f2:	25 80 00 00 00       	and    $0x80,%eax
801032f7:	85 c0                	test   %eax,%eax
801032f9:	74 02                	je     801032fd <cmostime+0x4b>
        continue;
801032fb:	eb 36                	jmp    80103333 <cmostime+0x81>
    fill_rtcdate(&t2);
801032fd:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103300:	89 04 24             	mov    %eax,(%esp)
80103303:	e8 37 ff ff ff       	call   8010323f <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103308:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010330f:	00 
80103310:	8d 45 b0             	lea    -0x50(%ebp),%eax
80103313:	89 44 24 04          	mov    %eax,0x4(%esp)
80103317:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010331a:	89 04 24             	mov    %eax,(%esp)
8010331d:	e8 cb 1e 00 00       	call   801051ed <memcmp>
80103322:	85 c0                	test   %eax,%eax
80103324:	75 0d                	jne    80103333 <cmostime+0x81>
      break;
80103326:	90                   	nop
  }

  // convert
  if(bcd) {
80103327:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010332b:	0f 84 ac 00 00 00    	je     801033dd <cmostime+0x12b>
80103331:	eb 02                	jmp    80103335 <cmostime+0x83>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103333:	eb a6                	jmp    801032db <cmostime+0x29>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103335:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103338:	c1 e8 04             	shr    $0x4,%eax
8010333b:	89 c2                	mov    %eax,%edx
8010333d:	89 d0                	mov    %edx,%eax
8010333f:	c1 e0 02             	shl    $0x2,%eax
80103342:	01 d0                	add    %edx,%eax
80103344:	01 c0                	add    %eax,%eax
80103346:	8b 55 c8             	mov    -0x38(%ebp),%edx
80103349:	83 e2 0f             	and    $0xf,%edx
8010334c:	01 d0                	add    %edx,%eax
8010334e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
80103351:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103354:	c1 e8 04             	shr    $0x4,%eax
80103357:	89 c2                	mov    %eax,%edx
80103359:	89 d0                	mov    %edx,%eax
8010335b:	c1 e0 02             	shl    $0x2,%eax
8010335e:	01 d0                	add    %edx,%eax
80103360:	01 c0                	add    %eax,%eax
80103362:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103365:	83 e2 0f             	and    $0xf,%edx
80103368:	01 d0                	add    %edx,%eax
8010336a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
8010336d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80103370:	c1 e8 04             	shr    $0x4,%eax
80103373:	89 c2                	mov    %eax,%edx
80103375:	89 d0                	mov    %edx,%eax
80103377:	c1 e0 02             	shl    $0x2,%eax
8010337a:	01 d0                	add    %edx,%eax
8010337c:	01 c0                	add    %eax,%eax
8010337e:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103381:	83 e2 0f             	and    $0xf,%edx
80103384:	01 d0                	add    %edx,%eax
80103386:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
80103389:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010338c:	c1 e8 04             	shr    $0x4,%eax
8010338f:	89 c2                	mov    %eax,%edx
80103391:	89 d0                	mov    %edx,%eax
80103393:	c1 e0 02             	shl    $0x2,%eax
80103396:	01 d0                	add    %edx,%eax
80103398:	01 c0                	add    %eax,%eax
8010339a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010339d:	83 e2 0f             	and    $0xf,%edx
801033a0:	01 d0                	add    %edx,%eax
801033a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
801033a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033a8:	c1 e8 04             	shr    $0x4,%eax
801033ab:	89 c2                	mov    %eax,%edx
801033ad:	89 d0                	mov    %edx,%eax
801033af:	c1 e0 02             	shl    $0x2,%eax
801033b2:	01 d0                	add    %edx,%eax
801033b4:	01 c0                	add    %eax,%eax
801033b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
801033b9:	83 e2 0f             	and    $0xf,%edx
801033bc:	01 d0                	add    %edx,%eax
801033be:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
801033c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033c4:	c1 e8 04             	shr    $0x4,%eax
801033c7:	89 c2                	mov    %eax,%edx
801033c9:	89 d0                	mov    %edx,%eax
801033cb:	c1 e0 02             	shl    $0x2,%eax
801033ce:	01 d0                	add    %edx,%eax
801033d0:	01 c0                	add    %eax,%eax
801033d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801033d5:	83 e2 0f             	and    $0xf,%edx
801033d8:	01 d0                	add    %edx,%eax
801033da:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
801033dd:	8b 45 08             	mov    0x8(%ebp),%eax
801033e0:	89 c2                	mov    %eax,%edx
801033e2:	8d 5d c8             	lea    -0x38(%ebp),%ebx
801033e5:	b8 06 00 00 00       	mov    $0x6,%eax
801033ea:	89 d7                	mov    %edx,%edi
801033ec:	89 de                	mov    %ebx,%esi
801033ee:	89 c1                	mov    %eax,%ecx
801033f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801033f2:	8b 45 08             	mov    0x8(%ebp),%eax
801033f5:	8b 40 14             	mov    0x14(%eax),%eax
801033f8:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033fe:	8b 45 08             	mov    0x8(%ebp),%eax
80103401:	89 50 14             	mov    %edx,0x14(%eax)
}
80103404:	83 c4 5c             	add    $0x5c,%esp
80103407:	5b                   	pop    %ebx
80103408:	5e                   	pop    %esi
80103409:	5f                   	pop    %edi
8010340a:	5d                   	pop    %ebp
8010340b:	c3                   	ret    

8010340c <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010340c:	55                   	push   %ebp
8010340d:	89 e5                	mov    %esp,%ebp
8010340f:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103412:	c7 44 24 04 45 97 10 	movl   $0x80109745,0x4(%esp)
80103419:	80 
8010341a:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103421:	e8 cc 1a 00 00       	call   80104ef2 <initlock>
  readsb(dev, &sb);
80103426:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103429:	89 44 24 04          	mov    %eax,0x4(%esp)
8010342d:	8b 45 08             	mov    0x8(%ebp),%eax
80103430:	89 04 24             	mov    %eax,(%esp)
80103433:	e8 d8 e0 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80103438:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010343b:	a3 f4 4f 11 80       	mov    %eax,0x80114ff4
  log.size = sb.nlog;
80103440:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103443:	a3 f8 4f 11 80       	mov    %eax,0x80114ff8
  log.dev = dev;
80103448:	8b 45 08             	mov    0x8(%ebp),%eax
8010344b:	a3 04 50 11 80       	mov    %eax,0x80115004
  recover_from_log();
80103450:	e8 95 01 00 00       	call   801035ea <recover_from_log>
}
80103455:	c9                   	leave  
80103456:	c3                   	ret    

80103457 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103457:	55                   	push   %ebp
80103458:	89 e5                	mov    %esp,%ebp
8010345a:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010345d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103464:	e9 89 00 00 00       	jmp    801034f2 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103469:	8b 15 f4 4f 11 80    	mov    0x80114ff4,%edx
8010346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103472:	01 d0                	add    %edx,%eax
80103474:	40                   	inc    %eax
80103475:	89 c2                	mov    %eax,%edx
80103477:	a1 04 50 11 80       	mov    0x80115004,%eax
8010347c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103480:	89 04 24             	mov    %eax,(%esp)
80103483:	e8 2d cd ff ff       	call   801001b5 <bread>
80103488:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010348b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010348e:	83 c0 10             	add    $0x10,%eax
80103491:	8b 04 85 cc 4f 11 80 	mov    -0x7feeb034(,%eax,4),%eax
80103498:	89 c2                	mov    %eax,%edx
8010349a:	a1 04 50 11 80       	mov    0x80115004,%eax
8010349f:	89 54 24 04          	mov    %edx,0x4(%esp)
801034a3:	89 04 24             	mov    %eax,(%esp)
801034a6:	e8 0a cd ff ff       	call   801001b5 <bread>
801034ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b1:	8d 50 5c             	lea    0x5c(%eax),%edx
801034b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b7:	83 c0 5c             	add    $0x5c,%eax
801034ba:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801034c1:	00 
801034c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801034c6:	89 04 24             	mov    %eax,(%esp)
801034c9:	e8 71 1d 00 00       	call   8010523f <memmove>
    bwrite(dbuf);  // write dst to disk
801034ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d1:	89 04 24             	mov    %eax,(%esp)
801034d4:	e8 13 cd ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
801034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034dc:	89 04 24             	mov    %eax,(%esp)
801034df:	e8 48 cd ff ff       	call   8010022c <brelse>
    brelse(dbuf);
801034e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034e7:	89 04 24             	mov    %eax,(%esp)
801034ea:	e8 3d cd ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034ef:	ff 45 f4             	incl   -0xc(%ebp)
801034f2:	a1 08 50 11 80       	mov    0x80115008,%eax
801034f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034fa:	0f 8f 69 ff ff ff    	jg     80103469 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103500:	c9                   	leave  
80103501:	c3                   	ret    

80103502 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103502:	55                   	push   %ebp
80103503:	89 e5                	mov    %esp,%ebp
80103505:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103508:	a1 f4 4f 11 80       	mov    0x80114ff4,%eax
8010350d:	89 c2                	mov    %eax,%edx
8010350f:	a1 04 50 11 80       	mov    0x80115004,%eax
80103514:	89 54 24 04          	mov    %edx,0x4(%esp)
80103518:	89 04 24             	mov    %eax,(%esp)
8010351b:	e8 95 cc ff ff       	call   801001b5 <bread>
80103520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103523:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103526:	83 c0 5c             	add    $0x5c,%eax
80103529:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010352c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010352f:	8b 00                	mov    (%eax),%eax
80103531:	a3 08 50 11 80       	mov    %eax,0x80115008
  for (i = 0; i < log.lh.n; i++) {
80103536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010353d:	eb 1a                	jmp    80103559 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
8010353f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103542:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103545:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103549:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010354c:	83 c2 10             	add    $0x10,%edx
8010354f:	89 04 95 cc 4f 11 80 	mov    %eax,-0x7feeb034(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103556:	ff 45 f4             	incl   -0xc(%ebp)
80103559:	a1 08 50 11 80       	mov    0x80115008,%eax
8010355e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103561:	7f dc                	jg     8010353f <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103566:	89 04 24             	mov    %eax,(%esp)
80103569:	e8 be cc ff ff       	call   8010022c <brelse>
}
8010356e:	c9                   	leave  
8010356f:	c3                   	ret    

80103570 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103576:	a1 f4 4f 11 80       	mov    0x80114ff4,%eax
8010357b:	89 c2                	mov    %eax,%edx
8010357d:	a1 04 50 11 80       	mov    0x80115004,%eax
80103582:	89 54 24 04          	mov    %edx,0x4(%esp)
80103586:	89 04 24             	mov    %eax,(%esp)
80103589:	e8 27 cc ff ff       	call   801001b5 <bread>
8010358e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103591:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103594:	83 c0 5c             	add    $0x5c,%eax
80103597:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010359a:	8b 15 08 50 11 80    	mov    0x80115008,%edx
801035a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a3:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801035a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035ac:	eb 1a                	jmp    801035c8 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
801035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035b1:	83 c0 10             	add    $0x10,%eax
801035b4:	8b 0c 85 cc 4f 11 80 	mov    -0x7feeb034(,%eax,4),%ecx
801035bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035c1:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035c5:	ff 45 f4             	incl   -0xc(%ebp)
801035c8:	a1 08 50 11 80       	mov    0x80115008,%eax
801035cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035d0:	7f dc                	jg     801035ae <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035d5:	89 04 24             	mov    %eax,(%esp)
801035d8:	e8 0f cc ff ff       	call   801001ec <bwrite>
  brelse(buf);
801035dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e0:	89 04 24             	mov    %eax,(%esp)
801035e3:	e8 44 cc ff ff       	call   8010022c <brelse>
}
801035e8:	c9                   	leave  
801035e9:	c3                   	ret    

801035ea <recover_from_log>:

static void
recover_from_log(void)
{
801035ea:	55                   	push   %ebp
801035eb:	89 e5                	mov    %esp,%ebp
801035ed:	83 ec 08             	sub    $0x8,%esp
  read_head();
801035f0:	e8 0d ff ff ff       	call   80103502 <read_head>
  install_trans(); // if committed, copy from log to disk
801035f5:	e8 5d fe ff ff       	call   80103457 <install_trans>
  log.lh.n = 0;
801035fa:	c7 05 08 50 11 80 00 	movl   $0x0,0x80115008
80103601:	00 00 00 
  write_head(); // clear the log
80103604:	e8 67 ff ff ff       	call   80103570 <write_head>
}
80103609:	c9                   	leave  
8010360a:	c3                   	ret    

8010360b <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010360b:	55                   	push   %ebp
8010360c:	89 e5                	mov    %esp,%ebp
8010360e:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103611:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103618:	e8 f6 18 00 00       	call   80104f13 <acquire>
  while(1){
    if(log.committing){
8010361d:	a1 00 50 11 80       	mov    0x80115000,%eax
80103622:	85 c0                	test   %eax,%eax
80103624:	74 16                	je     8010363c <begin_op+0x31>
      sleep(&log, &log.lock);
80103626:	c7 44 24 04 c0 4f 11 	movl   $0x80114fc0,0x4(%esp)
8010362d:	80 
8010362e:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103635:	e8 0a 15 00 00       	call   80104b44 <sleep>
8010363a:	eb 4d                	jmp    80103689 <begin_op+0x7e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010363c:	8b 15 08 50 11 80    	mov    0x80115008,%edx
80103642:	a1 fc 4f 11 80       	mov    0x80114ffc,%eax
80103647:	8d 48 01             	lea    0x1(%eax),%ecx
8010364a:	89 c8                	mov    %ecx,%eax
8010364c:	c1 e0 02             	shl    $0x2,%eax
8010364f:	01 c8                	add    %ecx,%eax
80103651:	01 c0                	add    %eax,%eax
80103653:	01 d0                	add    %edx,%eax
80103655:	83 f8 1e             	cmp    $0x1e,%eax
80103658:	7e 16                	jle    80103670 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010365a:	c7 44 24 04 c0 4f 11 	movl   $0x80114fc0,0x4(%esp)
80103661:	80 
80103662:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103669:	e8 d6 14 00 00       	call   80104b44 <sleep>
8010366e:	eb 19                	jmp    80103689 <begin_op+0x7e>
    } else {
      log.outstanding += 1;
80103670:	a1 fc 4f 11 80       	mov    0x80114ffc,%eax
80103675:	40                   	inc    %eax
80103676:	a3 fc 4f 11 80       	mov    %eax,0x80114ffc
      release(&log.lock);
8010367b:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103682:	e8 f6 18 00 00       	call   80104f7d <release>
      break;
80103687:	eb 02                	jmp    8010368b <begin_op+0x80>
    }
  }
80103689:	eb 92                	jmp    8010361d <begin_op+0x12>
}
8010368b:	c9                   	leave  
8010368c:	c3                   	ret    

8010368d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010368d:	55                   	push   %ebp
8010368e:	89 e5                	mov    %esp,%ebp
80103690:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010369a:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
801036a1:	e8 6d 18 00 00       	call   80104f13 <acquire>
  log.outstanding -= 1;
801036a6:	a1 fc 4f 11 80       	mov    0x80114ffc,%eax
801036ab:	48                   	dec    %eax
801036ac:	a3 fc 4f 11 80       	mov    %eax,0x80114ffc
  if(log.committing)
801036b1:	a1 00 50 11 80       	mov    0x80115000,%eax
801036b6:	85 c0                	test   %eax,%eax
801036b8:	74 0c                	je     801036c6 <end_op+0x39>
    panic("log.committing");
801036ba:	c7 04 24 49 97 10 80 	movl   $0x80109749,(%esp)
801036c1:	e8 8e ce ff ff       	call   80100554 <panic>
  if(log.outstanding == 0){
801036c6:	a1 fc 4f 11 80       	mov    0x80114ffc,%eax
801036cb:	85 c0                	test   %eax,%eax
801036cd:	75 13                	jne    801036e2 <end_op+0x55>
    do_commit = 1;
801036cf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036d6:	c7 05 00 50 11 80 01 	movl   $0x1,0x80115000
801036dd:	00 00 00 
801036e0:	eb 0c                	jmp    801036ee <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801036e2:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
801036e9:	e8 2a 15 00 00       	call   80104c18 <wakeup>
  }
  release(&log.lock);
801036ee:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
801036f5:	e8 83 18 00 00       	call   80104f7d <release>

  if(do_commit){
801036fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036fe:	74 33                	je     80103733 <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103700:	e8 db 00 00 00       	call   801037e0 <commit>
    acquire(&log.lock);
80103705:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
8010370c:	e8 02 18 00 00       	call   80104f13 <acquire>
    log.committing = 0;
80103711:	c7 05 00 50 11 80 00 	movl   $0x0,0x80115000
80103718:	00 00 00 
    wakeup(&log);
8010371b:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103722:	e8 f1 14 00 00       	call   80104c18 <wakeup>
    release(&log.lock);
80103727:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
8010372e:	e8 4a 18 00 00       	call   80104f7d <release>
  }
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    

80103735 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103735:	55                   	push   %ebp
80103736:	89 e5                	mov    %esp,%ebp
80103738:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010373b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103742:	e9 89 00 00 00       	jmp    801037d0 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103747:	8b 15 f4 4f 11 80    	mov    0x80114ff4,%edx
8010374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103750:	01 d0                	add    %edx,%eax
80103752:	40                   	inc    %eax
80103753:	89 c2                	mov    %eax,%edx
80103755:	a1 04 50 11 80       	mov    0x80115004,%eax
8010375a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010375e:	89 04 24             	mov    %eax,(%esp)
80103761:	e8 4f ca ff ff       	call   801001b5 <bread>
80103766:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010376c:	83 c0 10             	add    $0x10,%eax
8010376f:	8b 04 85 cc 4f 11 80 	mov    -0x7feeb034(,%eax,4),%eax
80103776:	89 c2                	mov    %eax,%edx
80103778:	a1 04 50 11 80       	mov    0x80115004,%eax
8010377d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103781:	89 04 24             	mov    %eax,(%esp)
80103784:	e8 2c ca ff ff       	call   801001b5 <bread>
80103789:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010378c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378f:	8d 50 5c             	lea    0x5c(%eax),%edx
80103792:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103795:	83 c0 5c             	add    $0x5c,%eax
80103798:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010379f:	00 
801037a0:	89 54 24 04          	mov    %edx,0x4(%esp)
801037a4:	89 04 24             	mov    %eax,(%esp)
801037a7:	e8 93 1a 00 00       	call   8010523f <memmove>
    bwrite(to);  // write the log
801037ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037af:	89 04 24             	mov    %eax,(%esp)
801037b2:	e8 35 ca ff ff       	call   801001ec <bwrite>
    brelse(from);
801037b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ba:	89 04 24             	mov    %eax,(%esp)
801037bd:	e8 6a ca ff ff       	call   8010022c <brelse>
    brelse(to);
801037c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037c5:	89 04 24             	mov    %eax,(%esp)
801037c8:	e8 5f ca ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037cd:	ff 45 f4             	incl   -0xc(%ebp)
801037d0:	a1 08 50 11 80       	mov    0x80115008,%eax
801037d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037d8:	0f 8f 69 ff ff ff    	jg     80103747 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
801037de:	c9                   	leave  
801037df:	c3                   	ret    

801037e0 <commit>:

static void
commit()
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037e6:	a1 08 50 11 80       	mov    0x80115008,%eax
801037eb:	85 c0                	test   %eax,%eax
801037ed:	7e 1e                	jle    8010380d <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801037ef:	e8 41 ff ff ff       	call   80103735 <write_log>
    write_head();    // Write header to disk -- the real commit
801037f4:	e8 77 fd ff ff       	call   80103570 <write_head>
    install_trans(); // Now install writes to home locations
801037f9:	e8 59 fc ff ff       	call   80103457 <install_trans>
    log.lh.n = 0;
801037fe:	c7 05 08 50 11 80 00 	movl   $0x0,0x80115008
80103805:	00 00 00 
    write_head();    // Erase the transaction from the log
80103808:	e8 63 fd ff ff       	call   80103570 <write_head>
  }
}
8010380d:	c9                   	leave  
8010380e:	c3                   	ret    

8010380f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010380f:	55                   	push   %ebp
80103810:	89 e5                	mov    %esp,%ebp
80103812:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103815:	a1 08 50 11 80       	mov    0x80115008,%eax
8010381a:	83 f8 1d             	cmp    $0x1d,%eax
8010381d:	7f 10                	jg     8010382f <log_write+0x20>
8010381f:	a1 08 50 11 80       	mov    0x80115008,%eax
80103824:	8b 15 f8 4f 11 80    	mov    0x80114ff8,%edx
8010382a:	4a                   	dec    %edx
8010382b:	39 d0                	cmp    %edx,%eax
8010382d:	7c 0c                	jl     8010383b <log_write+0x2c>
    panic("too big a transaction");
8010382f:	c7 04 24 58 97 10 80 	movl   $0x80109758,(%esp)
80103836:	e8 19 cd ff ff       	call   80100554 <panic>
  if (log.outstanding < 1)
8010383b:	a1 fc 4f 11 80       	mov    0x80114ffc,%eax
80103840:	85 c0                	test   %eax,%eax
80103842:	7f 0c                	jg     80103850 <log_write+0x41>
    panic("log_write outside of trans");
80103844:	c7 04 24 6e 97 10 80 	movl   $0x8010976e,(%esp)
8010384b:	e8 04 cd ff ff       	call   80100554 <panic>

  acquire(&log.lock);
80103850:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80103857:	e8 b7 16 00 00       	call   80104f13 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010385c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103863:	eb 1e                	jmp    80103883 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103868:	83 c0 10             	add    $0x10,%eax
8010386b:	8b 04 85 cc 4f 11 80 	mov    -0x7feeb034(,%eax,4),%eax
80103872:	89 c2                	mov    %eax,%edx
80103874:	8b 45 08             	mov    0x8(%ebp),%eax
80103877:	8b 40 08             	mov    0x8(%eax),%eax
8010387a:	39 c2                	cmp    %eax,%edx
8010387c:	75 02                	jne    80103880 <log_write+0x71>
      break;
8010387e:	eb 0d                	jmp    8010388d <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103880:	ff 45 f4             	incl   -0xc(%ebp)
80103883:	a1 08 50 11 80       	mov    0x80115008,%eax
80103888:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010388b:	7f d8                	jg     80103865 <log_write+0x56>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
8010388d:	8b 45 08             	mov    0x8(%ebp),%eax
80103890:	8b 40 08             	mov    0x8(%eax),%eax
80103893:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103896:	83 c2 10             	add    $0x10,%edx
80103899:	89 04 95 cc 4f 11 80 	mov    %eax,-0x7feeb034(,%edx,4)
  if (i == log.lh.n)
801038a0:	a1 08 50 11 80       	mov    0x80115008,%eax
801038a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038a8:	75 0b                	jne    801038b5 <log_write+0xa6>
    log.lh.n++;
801038aa:	a1 08 50 11 80       	mov    0x80115008,%eax
801038af:	40                   	inc    %eax
801038b0:	a3 08 50 11 80       	mov    %eax,0x80115008
  b->flags |= B_DIRTY; // prevent eviction
801038b5:	8b 45 08             	mov    0x8(%ebp),%eax
801038b8:	8b 00                	mov    (%eax),%eax
801038ba:	83 c8 04             	or     $0x4,%eax
801038bd:	89 c2                	mov    %eax,%edx
801038bf:	8b 45 08             	mov    0x8(%ebp),%eax
801038c2:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038c4:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
801038cb:	e8 ad 16 00 00       	call   80104f7d <release>
}
801038d0:	c9                   	leave  
801038d1:	c3                   	ret    
	...

801038d4 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038da:	8b 55 08             	mov    0x8(%ebp),%edx
801038dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801038e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038e3:	f0 87 02             	lock xchg %eax,(%edx)
801038e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    

801038ee <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038ee:	55                   	push   %ebp
801038ef:	89 e5                	mov    %esp,%ebp
801038f1:	83 e4 f0             	and    $0xfffffff0,%esp
801038f4:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038f7:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801038fe:	80 
801038ff:	c7 04 24 e8 7d 11 80 	movl   $0x80117de8,(%esp)
80103906:	e8 0d f3 ff ff       	call   80102c18 <kinit1>
  kvmalloc();      // kernel page table
8010390b:	e8 23 4c 00 00       	call   80108533 <kvmalloc>
  mpinit();        // detect other processors
80103910:	e8 c4 03 00 00       	call   80103cd9 <mpinit>
  lapicinit();     // interrupt controller
80103915:	e8 4e f6 ff ff       	call   80102f68 <lapicinit>
  seginit();       // segment descriptors
8010391a:	e8 fc 46 00 00       	call   8010801b <seginit>
  picinit();       // disable pic
8010391f:	e8 04 05 00 00       	call   80103e28 <picinit>
  ioapicinit();    // another interrupt controller
80103924:	e8 0c f2 ff ff       	call   80102b35 <ioapicinit>
  consoleinit();   // console hardware
80103929:	e8 69 d3 ff ff       	call   80100c97 <consoleinit>
  uartinit();      // serial port
8010392e:	e8 74 3a 00 00       	call   801073a7 <uartinit>
  pinit();         // process table
80103933:	e8 e6 08 00 00       	call   8010421e <pinit>
  tvinit();        // trap vectors
80103938:	e8 53 36 00 00       	call   80106f90 <tvinit>
  binit();         // buffer cache
8010393d:	e8 f2 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103942:	e8 ed d7 ff ff       	call   80101134 <fileinit>
  ideinit();       // disk 
80103947:	e8 f5 ed ff ff       	call   80102741 <ideinit>
  startothers();   // start other processors
8010394c:	e8 83 00 00 00       	call   801039d4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103951:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103958:	8e 
80103959:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103960:	e8 eb f2 ff ff       	call   80102c50 <kinit2>
  userinit();      // first user process
80103965:	e8 c1 0a 00 00       	call   8010442b <userinit>
  mpmain();        // finish this processor's setup
8010396a:	e8 1a 00 00 00       	call   80103989 <mpmain>

8010396f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010396f:	55                   	push   %ebp
80103970:	89 e5                	mov    %esp,%ebp
80103972:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103975:	e8 d0 4b 00 00       	call   8010854a <switchkvm>
  seginit();
8010397a:	e8 9c 46 00 00       	call   8010801b <seginit>
  lapicinit();
8010397f:	e8 e4 f5 ff ff       	call   80102f68 <lapicinit>
  mpmain();
80103984:	e8 00 00 00 00       	call   80103989 <mpmain>

80103989 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103989:	55                   	push   %ebp
8010398a:	89 e5                	mov    %esp,%ebp
8010398c:	53                   	push   %ebx
8010398d:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103990:	e8 a5 08 00 00       	call   8010423a <cpuid>
80103995:	89 c3                	mov    %eax,%ebx
80103997:	e8 9e 08 00 00       	call   8010423a <cpuid>
8010399c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801039a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801039a4:	c7 04 24 89 97 10 80 	movl   $0x80109789,(%esp)
801039ab:	e8 11 ca ff ff       	call   801003c1 <cprintf>
  idtinit();       // load idt register
801039b0:	e8 38 37 00 00       	call   801070ed <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801039b5:	e8 c5 08 00 00       	call   8010427f <mycpu>
801039ba:	05 a0 00 00 00       	add    $0xa0,%eax
801039bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801039c6:	00 
801039c7:	89 04 24             	mov    %eax,(%esp)
801039ca:	e8 05 ff ff ff       	call   801038d4 <xchg>
  scheduler();     // start running processes
801039cf:	e8 a6 0f 00 00       	call   8010497a <scheduler>

801039d4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039d4:	55                   	push   %ebp
801039d5:	89 e5                	mov    %esp,%ebp
801039d7:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
801039da:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039e1:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801039ea:	c7 44 24 04 4c c5 10 	movl   $0x8010c54c,0x4(%esp)
801039f1:	80 
801039f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039f5:	89 04 24             	mov    %eax,(%esp)
801039f8:	e8 42 18 00 00       	call   8010523f <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801039fd:	c7 45 f4 c0 50 11 80 	movl   $0x801150c0,-0xc(%ebp)
80103a04:	eb 75                	jmp    80103a7b <startothers+0xa7>
    if(c == mycpu())  // We've started already.
80103a06:	e8 74 08 00 00       	call   8010427f <mycpu>
80103a0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a0e:	75 02                	jne    80103a12 <startothers+0x3e>
      continue;
80103a10:	eb 62                	jmp    80103a74 <startothers+0xa0>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a12:	e8 2c f3 ff ff       	call   80102d43 <kalloc>
80103a17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a1d:	83 e8 04             	sub    $0x4,%eax
80103a20:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a23:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a29:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a2e:	83 e8 08             	sub    $0x8,%eax
80103a31:	c7 00 6f 39 10 80    	movl   $0x8010396f,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a3a:	8d 50 f4             	lea    -0xc(%eax),%edx
80103a3d:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103a42:	05 00 00 00 80       	add    $0x80000000,%eax
80103a47:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a4c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a55:	8a 00                	mov    (%eax),%al
80103a57:	0f b6 c0             	movzbl %al,%eax
80103a5a:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a5e:	89 04 24             	mov    %eax,(%esp)
80103a61:	e8 a7 f6 ff ff       	call   8010310d <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a66:	90                   	nop
80103a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6a:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103a70:	85 c0                	test   %eax,%eax
80103a72:	74 f3                	je     80103a67 <startothers+0x93>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103a74:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103a7b:	a1 40 56 11 80       	mov    0x80115640,%eax
80103a80:	89 c2                	mov    %eax,%edx
80103a82:	89 d0                	mov    %edx,%eax
80103a84:	c1 e0 02             	shl    $0x2,%eax
80103a87:	01 d0                	add    %edx,%eax
80103a89:	01 c0                	add    %eax,%eax
80103a8b:	01 d0                	add    %edx,%eax
80103a8d:	c1 e0 04             	shl    $0x4,%eax
80103a90:	05 c0 50 11 80       	add    $0x801150c0,%eax
80103a95:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a98:	0f 87 68 ff ff ff    	ja     80103a06 <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    

80103aa0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 14             	sub    $0x14,%esp
80103aa6:	8b 45 08             	mov    0x8(%ebp),%eax
80103aa9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ab0:	89 c2                	mov    %eax,%edx
80103ab2:	ec                   	in     (%dx),%al
80103ab3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103ab6:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103ab9:	c9                   	leave  
80103aba:	c3                   	ret    

80103abb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103abb:	55                   	push   %ebp
80103abc:	89 e5                	mov    %esp,%ebp
80103abe:	83 ec 08             	sub    $0x8,%esp
80103ac1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ac7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103acb:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ace:	8a 45 f8             	mov    -0x8(%ebp),%al
80103ad1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ad4:	ee                   	out    %al,(%dx)
}
80103ad5:	c9                   	leave  
80103ad6:	c3                   	ret    

80103ad7 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103ad7:	55                   	push   %ebp
80103ad8:	89 e5                	mov    %esp,%ebp
80103ada:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103add:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ae4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103aeb:	eb 13                	jmp    80103b00 <sum+0x29>
    sum += addr[i];
80103aed:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103af0:	8b 45 08             	mov    0x8(%ebp),%eax
80103af3:	01 d0                	add    %edx,%eax
80103af5:	8a 00                	mov    (%eax),%al
80103af7:	0f b6 c0             	movzbl %al,%eax
80103afa:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103afd:	ff 45 fc             	incl   -0x4(%ebp)
80103b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b03:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b06:	7c e5                	jl     80103aed <sum+0x16>
    sum += addr[i];
  return sum;
80103b08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b0b:	c9                   	leave  
80103b0c:	c3                   	ret    

80103b0d <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b0d:	55                   	push   %ebp
80103b0e:	89 e5                	mov    %esp,%ebp
80103b10:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103b13:	8b 45 08             	mov    0x8(%ebp),%eax
80103b16:	05 00 00 00 80       	add    $0x80000000,%eax
80103b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b24:	01 d0                	add    %edx,%eax
80103b26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b2f:	eb 3f                	jmp    80103b70 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b31:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b38:	00 
80103b39:	c7 44 24 04 a0 97 10 	movl   $0x801097a0,0x4(%esp)
80103b40:	80 
80103b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b44:	89 04 24             	mov    %eax,(%esp)
80103b47:	e8 a1 16 00 00       	call   801051ed <memcmp>
80103b4c:	85 c0                	test   %eax,%eax
80103b4e:	75 1c                	jne    80103b6c <mpsearch1+0x5f>
80103b50:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103b57:	00 
80103b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b5b:	89 04 24             	mov    %eax,(%esp)
80103b5e:	e8 74 ff ff ff       	call   80103ad7 <sum>
80103b63:	84 c0                	test   %al,%al
80103b65:	75 05                	jne    80103b6c <mpsearch1+0x5f>
      return (struct mp*)p;
80103b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6a:	eb 11                	jmp    80103b7d <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b6c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b73:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b76:	72 b9                	jb     80103b31 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b7d:	c9                   	leave  
80103b7e:	c3                   	ret    

80103b7f <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b7f:	55                   	push   %ebp
80103b80:	89 e5                	mov    %esp,%ebp
80103b82:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b85:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b8f:	83 c0 0f             	add    $0xf,%eax
80103b92:	8a 00                	mov    (%eax),%al
80103b94:	0f b6 c0             	movzbl %al,%eax
80103b97:	c1 e0 08             	shl    $0x8,%eax
80103b9a:	89 c2                	mov    %eax,%edx
80103b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9f:	83 c0 0e             	add    $0xe,%eax
80103ba2:	8a 00                	mov    (%eax),%al
80103ba4:	0f b6 c0             	movzbl %al,%eax
80103ba7:	09 d0                	or     %edx,%eax
80103ba9:	c1 e0 04             	shl    $0x4,%eax
80103bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103baf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bb3:	74 21                	je     80103bd6 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103bb5:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103bbc:	00 
80103bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc0:	89 04 24             	mov    %eax,(%esp)
80103bc3:	e8 45 ff ff ff       	call   80103b0d <mpsearch1>
80103bc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bcf:	74 4e                	je     80103c1f <mpsearch+0xa0>
      return mp;
80103bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bd4:	eb 5d                	jmp    80103c33 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd9:	83 c0 14             	add    $0x14,%eax
80103bdc:	8a 00                	mov    (%eax),%al
80103bde:	0f b6 c0             	movzbl %al,%eax
80103be1:	c1 e0 08             	shl    $0x8,%eax
80103be4:	89 c2                	mov    %eax,%edx
80103be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be9:	83 c0 13             	add    $0x13,%eax
80103bec:	8a 00                	mov    (%eax),%al
80103bee:	0f b6 c0             	movzbl %al,%eax
80103bf1:	09 d0                	or     %edx,%eax
80103bf3:	c1 e0 0a             	shl    $0xa,%eax
80103bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bfc:	2d 00 04 00 00       	sub    $0x400,%eax
80103c01:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103c08:	00 
80103c09:	89 04 24             	mov    %eax,(%esp)
80103c0c:	e8 fc fe ff ff       	call   80103b0d <mpsearch1>
80103c11:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c18:	74 05                	je     80103c1f <mpsearch+0xa0>
      return mp;
80103c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c1d:	eb 14                	jmp    80103c33 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c1f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103c26:	00 
80103c27:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103c2e:	e8 da fe ff ff       	call   80103b0d <mpsearch1>
}
80103c33:	c9                   	leave  
80103c34:	c3                   	ret    

80103c35 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c35:	55                   	push   %ebp
80103c36:	89 e5                	mov    %esp,%ebp
80103c38:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c3b:	e8 3f ff ff ff       	call   80103b7f <mpsearch>
80103c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c47:	74 0a                	je     80103c53 <mpconfig+0x1e>
80103c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c4c:	8b 40 04             	mov    0x4(%eax),%eax
80103c4f:	85 c0                	test   %eax,%eax
80103c51:	75 07                	jne    80103c5a <mpconfig+0x25>
    return 0;
80103c53:	b8 00 00 00 00       	mov    $0x0,%eax
80103c58:	eb 7d                	jmp    80103cd7 <mpconfig+0xa2>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5d:	8b 40 04             	mov    0x4(%eax),%eax
80103c60:	05 00 00 00 80       	add    $0x80000000,%eax
80103c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c68:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103c6f:	00 
80103c70:	c7 44 24 04 a5 97 10 	movl   $0x801097a5,0x4(%esp)
80103c77:	80 
80103c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c7b:	89 04 24             	mov    %eax,(%esp)
80103c7e:	e8 6a 15 00 00       	call   801051ed <memcmp>
80103c83:	85 c0                	test   %eax,%eax
80103c85:	74 07                	je     80103c8e <mpconfig+0x59>
    return 0;
80103c87:	b8 00 00 00 00       	mov    $0x0,%eax
80103c8c:	eb 49                	jmp    80103cd7 <mpconfig+0xa2>
  if(conf->version != 1 && conf->version != 4)
80103c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c91:	8a 40 06             	mov    0x6(%eax),%al
80103c94:	3c 01                	cmp    $0x1,%al
80103c96:	74 11                	je     80103ca9 <mpconfig+0x74>
80103c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c9b:	8a 40 06             	mov    0x6(%eax),%al
80103c9e:	3c 04                	cmp    $0x4,%al
80103ca0:	74 07                	je     80103ca9 <mpconfig+0x74>
    return 0;
80103ca2:	b8 00 00 00 00       	mov    $0x0,%eax
80103ca7:	eb 2e                	jmp    80103cd7 <mpconfig+0xa2>
  if(sum((uchar*)conf, conf->length) != 0)
80103ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cac:	8b 40 04             	mov    0x4(%eax),%eax
80103caf:	0f b7 c0             	movzwl %ax,%eax
80103cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cb9:	89 04 24             	mov    %eax,(%esp)
80103cbc:	e8 16 fe ff ff       	call   80103ad7 <sum>
80103cc1:	84 c0                	test   %al,%al
80103cc3:	74 07                	je     80103ccc <mpconfig+0x97>
    return 0;
80103cc5:	b8 00 00 00 00       	mov    $0x0,%eax
80103cca:	eb 0b                	jmp    80103cd7 <mpconfig+0xa2>
  *pmp = mp;
80103ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cd2:	89 10                	mov    %edx,(%eax)
  return conf;
80103cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103cd7:	c9                   	leave  
80103cd8:	c3                   	ret    

80103cd9 <mpinit>:

void
mpinit(void)
{
80103cd9:	55                   	push   %ebp
80103cda:	89 e5                	mov    %esp,%ebp
80103cdc:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103cdf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103ce2:	89 04 24             	mov    %eax,(%esp)
80103ce5:	e8 4b ff ff ff       	call   80103c35 <mpconfig>
80103cea:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ced:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cf1:	75 0c                	jne    80103cff <mpinit+0x26>
    panic("Expect to run on an SMP");
80103cf3:	c7 04 24 aa 97 10 80 	movl   $0x801097aa,(%esp)
80103cfa:	e8 55 c8 ff ff       	call   80100554 <panic>
  ismp = 1;
80103cff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d09:	8b 40 24             	mov    0x24(%eax),%eax
80103d0c:	a3 bc 4f 11 80       	mov    %eax,0x80114fbc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d14:	83 c0 2c             	add    $0x2c,%eax
80103d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d1d:	8b 40 04             	mov    0x4(%eax),%eax
80103d20:	0f b7 d0             	movzwl %ax,%edx
80103d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d26:	01 d0                	add    %edx,%eax
80103d28:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103d2b:	eb 7d                	jmp    80103daa <mpinit+0xd1>
    switch(*p){
80103d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d30:	8a 00                	mov    (%eax),%al
80103d32:	0f b6 c0             	movzbl %al,%eax
80103d35:	83 f8 04             	cmp    $0x4,%eax
80103d38:	77 68                	ja     80103da2 <mpinit+0xc9>
80103d3a:	8b 04 85 e4 97 10 80 	mov    -0x7fef681c(,%eax,4),%eax
80103d41:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103d49:	a1 40 56 11 80       	mov    0x80115640,%eax
80103d4e:	83 f8 07             	cmp    $0x7,%eax
80103d51:	7f 2c                	jg     80103d7f <mpinit+0xa6>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d53:	8b 15 40 56 11 80    	mov    0x80115640,%edx
80103d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d5c:	8a 48 01             	mov    0x1(%eax),%cl
80103d5f:	89 d0                	mov    %edx,%eax
80103d61:	c1 e0 02             	shl    $0x2,%eax
80103d64:	01 d0                	add    %edx,%eax
80103d66:	01 c0                	add    %eax,%eax
80103d68:	01 d0                	add    %edx,%eax
80103d6a:	c1 e0 04             	shl    $0x4,%eax
80103d6d:	05 c0 50 11 80       	add    $0x801150c0,%eax
80103d72:	88 08                	mov    %cl,(%eax)
        ncpu++;
80103d74:	a1 40 56 11 80       	mov    0x80115640,%eax
80103d79:	40                   	inc    %eax
80103d7a:	a3 40 56 11 80       	mov    %eax,0x80115640
      }
      p += sizeof(struct mpproc);
80103d7f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d83:	eb 25                	jmp    80103daa <mpinit+0xd1>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d88:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d8e:	8a 40 01             	mov    0x1(%eax),%al
80103d91:	a2 a0 50 11 80       	mov    %al,0x801150a0
      p += sizeof(struct mpioapic);
80103d96:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d9a:	eb 0e                	jmp    80103daa <mpinit+0xd1>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d9c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103da0:	eb 08                	jmp    80103daa <mpinit+0xd1>
    default:
      ismp = 0;
80103da2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103da9:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dad:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103db0:	0f 82 77 ff ff ff    	jb     80103d2d <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103db6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dba:	75 0c                	jne    80103dc8 <mpinit+0xef>
    panic("Didn't find a suitable machine");
80103dbc:	c7 04 24 c4 97 10 80 	movl   $0x801097c4,(%esp)
80103dc3:	e8 8c c7 ff ff       	call   80100554 <panic>

  if(mp->imcrp){
80103dc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dcb:	8a 40 0c             	mov    0xc(%eax),%al
80103dce:	84 c0                	test   %al,%al
80103dd0:	74 36                	je     80103e08 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103dd2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103dd9:	00 
80103dda:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103de1:	e8 d5 fc ff ff       	call   80103abb <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103de6:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103ded:	e8 ae fc ff ff       	call   80103aa0 <inb>
80103df2:	83 c8 01             	or     $0x1,%eax
80103df5:	0f b6 c0             	movzbl %al,%eax
80103df8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dfc:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e03:	e8 b3 fc ff ff       	call   80103abb <outb>
  }
}
80103e08:	c9                   	leave  
80103e09:	c3                   	ret    
	...

80103e0c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e0c:	55                   	push   %ebp
80103e0d:	89 e5                	mov    %esp,%ebp
80103e0f:	83 ec 08             	sub    $0x8,%esp
80103e12:	8b 45 08             	mov    0x8(%ebp),%eax
80103e15:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e1c:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e1f:	8a 45 f8             	mov    -0x8(%ebp),%al
80103e22:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e25:	ee                   	out    %al,(%dx)
}
80103e26:	c9                   	leave  
80103e27:	c3                   	ret    

80103e28 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e2e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e35:	00 
80103e36:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e3d:	e8 ca ff ff ff       	call   80103e0c <outb>
  outb(IO_PIC2+1, 0xFF);
80103e42:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e49:	00 
80103e4a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e51:	e8 b6 ff ff ff       	call   80103e0c <outb>
}
80103e56:	c9                   	leave  
80103e57:	c3                   	ret    

80103e58 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103e58:	55                   	push   %ebp
80103e59:	89 e5                	mov    %esp,%ebp
80103e5b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103e5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103e65:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e71:	8b 10                	mov    (%eax),%edx
80103e73:	8b 45 08             	mov    0x8(%ebp),%eax
80103e76:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103e78:	e8 d3 d2 ff ff       	call   80101150 <filealloc>
80103e7d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e80:	89 02                	mov    %eax,(%edx)
80103e82:	8b 45 08             	mov    0x8(%ebp),%eax
80103e85:	8b 00                	mov    (%eax),%eax
80103e87:	85 c0                	test   %eax,%eax
80103e89:	0f 84 c8 00 00 00    	je     80103f57 <pipealloc+0xff>
80103e8f:	e8 bc d2 ff ff       	call   80101150 <filealloc>
80103e94:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e97:	89 02                	mov    %eax,(%edx)
80103e99:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e9c:	8b 00                	mov    (%eax),%eax
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	0f 84 b1 00 00 00    	je     80103f57 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ea6:	e8 98 ee ff ff       	call   80102d43 <kalloc>
80103eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103eb2:	75 05                	jne    80103eb9 <pipealloc+0x61>
    goto bad;
80103eb4:	e9 9e 00 00 00       	jmp    80103f57 <pipealloc+0xff>
  p->readopen = 1;
80103eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ebc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ec3:	00 00 00 
  p->writeopen = 1;
80103ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ed0:	00 00 00 
  p->nwrite = 0;
80103ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed6:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103edd:	00 00 00 
  p->nread = 0;
80103ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee3:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103eea:	00 00 00 
  initlock(&p->lock, "pipe");
80103eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ef0:	c7 44 24 04 f8 97 10 	movl   $0x801097f8,0x4(%esp)
80103ef7:	80 
80103ef8:	89 04 24             	mov    %eax,(%esp)
80103efb:	e8 f2 0f 00 00       	call   80104ef2 <initlock>
  (*f0)->type = FD_PIPE;
80103f00:	8b 45 08             	mov    0x8(%ebp),%eax
80103f03:	8b 00                	mov    (%eax),%eax
80103f05:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0e:	8b 00                	mov    (%eax),%eax
80103f10:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103f14:	8b 45 08             	mov    0x8(%ebp),%eax
80103f17:	8b 00                	mov    (%eax),%eax
80103f19:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f20:	8b 00                	mov    (%eax),%eax
80103f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f25:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103f28:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f2b:	8b 00                	mov    (%eax),%eax
80103f2d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103f33:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f36:	8b 00                	mov    (%eax),%eax
80103f38:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f3f:	8b 00                	mov    (%eax),%eax
80103f41:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103f45:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f48:	8b 00                	mov    (%eax),%eax
80103f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f4d:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103f50:	b8 00 00 00 00       	mov    $0x0,%eax
80103f55:	eb 42                	jmp    80103f99 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103f57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f5b:	74 0b                	je     80103f68 <pipealloc+0x110>
    kfree((char*)p);
80103f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f60:	89 04 24             	mov    %eax,(%esp)
80103f63:	e8 45 ed ff ff       	call   80102cad <kfree>
  if(*f0)
80103f68:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6b:	8b 00                	mov    (%eax),%eax
80103f6d:	85 c0                	test   %eax,%eax
80103f6f:	74 0d                	je     80103f7e <pipealloc+0x126>
    fileclose(*f0);
80103f71:	8b 45 08             	mov    0x8(%ebp),%eax
80103f74:	8b 00                	mov    (%eax),%eax
80103f76:	89 04 24             	mov    %eax,(%esp)
80103f79:	e8 7a d2 ff ff       	call   801011f8 <fileclose>
  if(*f1)
80103f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f81:	8b 00                	mov    (%eax),%eax
80103f83:	85 c0                	test   %eax,%eax
80103f85:	74 0d                	je     80103f94 <pipealloc+0x13c>
    fileclose(*f1);
80103f87:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f8a:	8b 00                	mov    (%eax),%eax
80103f8c:	89 04 24             	mov    %eax,(%esp)
80103f8f:	e8 64 d2 ff ff       	call   801011f8 <fileclose>
  return -1;
80103f94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f99:	c9                   	leave  
80103f9a:	c3                   	ret    

80103f9b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103f9b:	55                   	push   %ebp
80103f9c:	89 e5                	mov    %esp,%ebp
80103f9e:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa4:	89 04 24             	mov    %eax,(%esp)
80103fa7:	e8 67 0f 00 00       	call   80104f13 <acquire>
  if(writable){
80103fac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103fb0:	74 1f                	je     80103fd1 <pipeclose+0x36>
    p->writeopen = 0;
80103fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb5:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103fbc:	00 00 00 
    wakeup(&p->nread);
80103fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc2:	05 34 02 00 00       	add    $0x234,%eax
80103fc7:	89 04 24             	mov    %eax,(%esp)
80103fca:	e8 49 0c 00 00       	call   80104c18 <wakeup>
80103fcf:	eb 1d                	jmp    80103fee <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103fdb:	00 00 00 
    wakeup(&p->nwrite);
80103fde:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe1:	05 38 02 00 00       	add    $0x238,%eax
80103fe6:	89 04 24             	mov    %eax,(%esp)
80103fe9:	e8 2a 0c 00 00       	call   80104c18 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103fee:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ff7:	85 c0                	test   %eax,%eax
80103ff9:	75 25                	jne    80104020 <pipeclose+0x85>
80103ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffe:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104004:	85 c0                	test   %eax,%eax
80104006:	75 18                	jne    80104020 <pipeclose+0x85>
    release(&p->lock);
80104008:	8b 45 08             	mov    0x8(%ebp),%eax
8010400b:	89 04 24             	mov    %eax,(%esp)
8010400e:	e8 6a 0f 00 00       	call   80104f7d <release>
    kfree((char*)p);
80104013:	8b 45 08             	mov    0x8(%ebp),%eax
80104016:	89 04 24             	mov    %eax,(%esp)
80104019:	e8 8f ec ff ff       	call   80102cad <kfree>
8010401e:	eb 0b                	jmp    8010402b <pipeclose+0x90>
  } else
    release(&p->lock);
80104020:	8b 45 08             	mov    0x8(%ebp),%eax
80104023:	89 04 24             	mov    %eax,(%esp)
80104026:	e8 52 0f 00 00       	call   80104f7d <release>
}
8010402b:	c9                   	leave  
8010402c:	c3                   	ret    

8010402d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010402d:	55                   	push   %ebp
8010402e:	89 e5                	mov    %esp,%ebp
80104030:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104033:	8b 45 08             	mov    0x8(%ebp),%eax
80104036:	89 04 24             	mov    %eax,(%esp)
80104039:	e8 d5 0e 00 00       	call   80104f13 <acquire>
  for(i = 0; i < n; i++){
8010403e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104045:	e9 a3 00 00 00       	jmp    801040ed <pipewrite+0xc0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010404a:	eb 56                	jmp    801040a2 <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
8010404c:	8b 45 08             	mov    0x8(%ebp),%eax
8010404f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104055:	85 c0                	test   %eax,%eax
80104057:	74 0c                	je     80104065 <pipewrite+0x38>
80104059:	e8 a5 02 00 00       	call   80104303 <myproc>
8010405e:	8b 40 24             	mov    0x24(%eax),%eax
80104061:	85 c0                	test   %eax,%eax
80104063:	74 15                	je     8010407a <pipewrite+0x4d>
        release(&p->lock);
80104065:	8b 45 08             	mov    0x8(%ebp),%eax
80104068:	89 04 24             	mov    %eax,(%esp)
8010406b:	e8 0d 0f 00 00       	call   80104f7d <release>
        return -1;
80104070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104075:	e9 9d 00 00 00       	jmp    80104117 <pipewrite+0xea>
      }
      wakeup(&p->nread);
8010407a:	8b 45 08             	mov    0x8(%ebp),%eax
8010407d:	05 34 02 00 00       	add    $0x234,%eax
80104082:	89 04 24             	mov    %eax,(%esp)
80104085:	e8 8e 0b 00 00       	call   80104c18 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010408a:	8b 45 08             	mov    0x8(%ebp),%eax
8010408d:	8b 55 08             	mov    0x8(%ebp),%edx
80104090:	81 c2 38 02 00 00    	add    $0x238,%edx
80104096:	89 44 24 04          	mov    %eax,0x4(%esp)
8010409a:	89 14 24             	mov    %edx,(%esp)
8010409d:	e8 a2 0a 00 00       	call   80104b44 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801040a2:	8b 45 08             	mov    0x8(%ebp),%eax
801040a5:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801040ab:	8b 45 08             	mov    0x8(%ebp),%eax
801040ae:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801040b4:	05 00 02 00 00       	add    $0x200,%eax
801040b9:	39 c2                	cmp    %eax,%edx
801040bb:	74 8f                	je     8010404c <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801040bd:	8b 45 08             	mov    0x8(%ebp),%eax
801040c0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801040c6:	8d 48 01             	lea    0x1(%eax),%ecx
801040c9:	8b 55 08             	mov    0x8(%ebp),%edx
801040cc:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801040d2:	25 ff 01 00 00       	and    $0x1ff,%eax
801040d7:	89 c1                	mov    %eax,%ecx
801040d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040df:	01 d0                	add    %edx,%eax
801040e1:	8a 10                	mov    (%eax),%dl
801040e3:	8b 45 08             	mov    0x8(%ebp),%eax
801040e6:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801040ea:	ff 45 f4             	incl   -0xc(%ebp)
801040ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f0:	3b 45 10             	cmp    0x10(%ebp),%eax
801040f3:	0f 8c 51 ff ff ff    	jl     8010404a <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801040f9:	8b 45 08             	mov    0x8(%ebp),%eax
801040fc:	05 34 02 00 00       	add    $0x234,%eax
80104101:	89 04 24             	mov    %eax,(%esp)
80104104:	e8 0f 0b 00 00       	call   80104c18 <wakeup>
  release(&p->lock);
80104109:	8b 45 08             	mov    0x8(%ebp),%eax
8010410c:	89 04 24             	mov    %eax,(%esp)
8010410f:	e8 69 0e 00 00       	call   80104f7d <release>
  return n;
80104114:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104117:	c9                   	leave  
80104118:	c3                   	ret    

80104119 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104119:	55                   	push   %ebp
8010411a:	89 e5                	mov    %esp,%ebp
8010411c:	53                   	push   %ebx
8010411d:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104120:	8b 45 08             	mov    0x8(%ebp),%eax
80104123:	89 04 24             	mov    %eax,(%esp)
80104126:	e8 e8 0d 00 00       	call   80104f13 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010412b:	eb 39                	jmp    80104166 <piperead+0x4d>
    if(myproc()->killed){
8010412d:	e8 d1 01 00 00       	call   80104303 <myproc>
80104132:	8b 40 24             	mov    0x24(%eax),%eax
80104135:	85 c0                	test   %eax,%eax
80104137:	74 15                	je     8010414e <piperead+0x35>
      release(&p->lock);
80104139:	8b 45 08             	mov    0x8(%ebp),%eax
8010413c:	89 04 24             	mov    %eax,(%esp)
8010413f:	e8 39 0e 00 00       	call   80104f7d <release>
      return -1;
80104144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104149:	e9 b3 00 00 00       	jmp    80104201 <piperead+0xe8>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010414e:	8b 45 08             	mov    0x8(%ebp),%eax
80104151:	8b 55 08             	mov    0x8(%ebp),%edx
80104154:	81 c2 34 02 00 00    	add    $0x234,%edx
8010415a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010415e:	89 14 24             	mov    %edx,(%esp)
80104161:	e8 de 09 00 00       	call   80104b44 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104166:	8b 45 08             	mov    0x8(%ebp),%eax
80104169:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010416f:	8b 45 08             	mov    0x8(%ebp),%eax
80104172:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104178:	39 c2                	cmp    %eax,%edx
8010417a:	75 0d                	jne    80104189 <piperead+0x70>
8010417c:	8b 45 08             	mov    0x8(%ebp),%eax
8010417f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104185:	85 c0                	test   %eax,%eax
80104187:	75 a4                	jne    8010412d <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104190:	eb 49                	jmp    801041db <piperead+0xc2>
    if(p->nread == p->nwrite)
80104192:	8b 45 08             	mov    0x8(%ebp),%eax
80104195:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010419b:	8b 45 08             	mov    0x8(%ebp),%eax
8010419e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041a4:	39 c2                	cmp    %eax,%edx
801041a6:	75 02                	jne    801041aa <piperead+0x91>
      break;
801041a8:	eb 39                	jmp    801041e3 <piperead+0xca>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801041aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801041b3:	8b 45 08             	mov    0x8(%ebp),%eax
801041b6:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041bc:	8d 48 01             	lea    0x1(%eax),%ecx
801041bf:	8b 55 08             	mov    0x8(%ebp),%edx
801041c2:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801041c8:	25 ff 01 00 00       	and    $0x1ff,%eax
801041cd:	89 c2                	mov    %eax,%edx
801041cf:	8b 45 08             	mov    0x8(%ebp),%eax
801041d2:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
801041d6:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041d8:	ff 45 f4             	incl   -0xc(%ebp)
801041db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041de:	3b 45 10             	cmp    0x10(%ebp),%eax
801041e1:	7c af                	jl     80104192 <piperead+0x79>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	05 38 02 00 00       	add    $0x238,%eax
801041eb:	89 04 24             	mov    %eax,(%esp)
801041ee:	e8 25 0a 00 00       	call   80104c18 <wakeup>
  release(&p->lock);
801041f3:	8b 45 08             	mov    0x8(%ebp),%eax
801041f6:	89 04 24             	mov    %eax,(%esp)
801041f9:	e8 7f 0d 00 00       	call   80104f7d <release>
  return i;
801041fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104201:	83 c4 24             	add    $0x24,%esp
80104204:	5b                   	pop    %ebx
80104205:	5d                   	pop    %ebp
80104206:	c3                   	ret    
	...

80104208 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104208:	55                   	push   %ebp
80104209:	89 e5                	mov    %esp,%ebp
8010420b:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010420e:	9c                   	pushf  
8010420f:	58                   	pop    %eax
80104210:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104213:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104216:	c9                   	leave  
80104217:	c3                   	ret    

80104218 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104218:	55                   	push   %ebp
80104219:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010421b:	fb                   	sti    
}
8010421c:	5d                   	pop    %ebp
8010421d:	c3                   	ret    

8010421e <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010421e:	55                   	push   %ebp
8010421f:	89 e5                	mov    %esp,%ebp
80104221:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104224:	c7 44 24 04 00 98 10 	movl   $0x80109800,0x4(%esp)
8010422b:	80 
8010422c:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104233:	e8 ba 0c 00 00       	call   80104ef2 <initlock>
}
80104238:	c9                   	leave  
80104239:	c3                   	ret    

8010423a <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010423a:	55                   	push   %ebp
8010423b:	89 e5                	mov    %esp,%ebp
8010423d:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104240:	e8 3a 00 00 00       	call   8010427f <mycpu>
80104245:	89 c2                	mov    %eax,%edx
80104247:	b8 c0 50 11 80       	mov    $0x801150c0,%eax
8010424c:	29 c2                	sub    %eax,%edx
8010424e:	89 d0                	mov    %edx,%eax
80104250:	c1 f8 04             	sar    $0x4,%eax
80104253:	89 c1                	mov    %eax,%ecx
80104255:	89 ca                	mov    %ecx,%edx
80104257:	c1 e2 03             	shl    $0x3,%edx
8010425a:	01 ca                	add    %ecx,%edx
8010425c:	89 d0                	mov    %edx,%eax
8010425e:	c1 e0 05             	shl    $0x5,%eax
80104261:	29 d0                	sub    %edx,%eax
80104263:	c1 e0 02             	shl    $0x2,%eax
80104266:	01 c8                	add    %ecx,%eax
80104268:	c1 e0 03             	shl    $0x3,%eax
8010426b:	01 c8                	add    %ecx,%eax
8010426d:	89 c2                	mov    %eax,%edx
8010426f:	c1 e2 0f             	shl    $0xf,%edx
80104272:	29 c2                	sub    %eax,%edx
80104274:	c1 e2 02             	shl    $0x2,%edx
80104277:	01 ca                	add    %ecx,%edx
80104279:	89 d0                	mov    %edx,%eax
8010427b:	f7 d8                	neg    %eax
}
8010427d:	c9                   	leave  
8010427e:	c3                   	ret    

8010427f <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
8010427f:	55                   	push   %ebp
80104280:	89 e5                	mov    %esp,%ebp
80104282:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
80104285:	e8 7e ff ff ff       	call   80104208 <readeflags>
8010428a:	25 00 02 00 00       	and    $0x200,%eax
8010428f:	85 c0                	test   %eax,%eax
80104291:	74 0c                	je     8010429f <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
80104293:	c7 04 24 08 98 10 80 	movl   $0x80109808,(%esp)
8010429a:	e8 b5 c2 ff ff       	call   80100554 <panic>
  
  apicid = lapicid();
8010429f:	e8 1d ee ff ff       	call   801030c1 <lapicid>
801042a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801042a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042ae:	eb 3b                	jmp    801042eb <mycpu+0x6c>
    if (cpus[i].apicid == apicid)
801042b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b3:	89 d0                	mov    %edx,%eax
801042b5:	c1 e0 02             	shl    $0x2,%eax
801042b8:	01 d0                	add    %edx,%eax
801042ba:	01 c0                	add    %eax,%eax
801042bc:	01 d0                	add    %edx,%eax
801042be:	c1 e0 04             	shl    $0x4,%eax
801042c1:	05 c0 50 11 80       	add    $0x801150c0,%eax
801042c6:	8a 00                	mov    (%eax),%al
801042c8:	0f b6 c0             	movzbl %al,%eax
801042cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801042ce:	75 18                	jne    801042e8 <mycpu+0x69>
      return &cpus[i];
801042d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042d3:	89 d0                	mov    %edx,%eax
801042d5:	c1 e0 02             	shl    $0x2,%eax
801042d8:	01 d0                	add    %edx,%eax
801042da:	01 c0                	add    %eax,%eax
801042dc:	01 d0                	add    %edx,%eax
801042de:	c1 e0 04             	shl    $0x4,%eax
801042e1:	05 c0 50 11 80       	add    $0x801150c0,%eax
801042e6:	eb 19                	jmp    80104301 <mycpu+0x82>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801042e8:	ff 45 f4             	incl   -0xc(%ebp)
801042eb:	a1 40 56 11 80       	mov    0x80115640,%eax
801042f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801042f3:	7c bb                	jl     801042b0 <mycpu+0x31>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801042f5:	c7 04 24 2e 98 10 80 	movl   $0x8010982e,(%esp)
801042fc:	e8 53 c2 ff ff       	call   80100554 <panic>
}
80104301:	c9                   	leave  
80104302:	c3                   	ret    

80104303 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104303:	55                   	push   %ebp
80104304:	89 e5                	mov    %esp,%ebp
80104306:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104309:	e8 64 0d 00 00       	call   80105072 <pushcli>
  c = mycpu();
8010430e:	e8 6c ff ff ff       	call   8010427f <mycpu>
80104313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80104316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104319:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010431f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104322:	e8 95 0d 00 00       	call   801050bc <popcli>
  return p;
80104327:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010432a:	c9                   	leave  
8010432b:	c3                   	ret    

8010432c <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010432c:	55                   	push   %ebp
8010432d:	89 e5                	mov    %esp,%ebp
8010432f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104332:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104339:	e8 d5 0b 00 00       	call   80104f13 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010433e:	c7 45 f4 94 56 11 80 	movl   $0x80115694,-0xc(%ebp)
80104345:	eb 50                	jmp    80104397 <allocproc+0x6b>
    if(p->state == UNUSED)
80104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434a:	8b 40 0c             	mov    0xc(%eax),%eax
8010434d:	85 c0                	test   %eax,%eax
8010434f:	75 42                	jne    80104393 <allocproc+0x67>
      goto found;
80104351:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104355:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010435c:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104361:	8d 50 01             	lea    0x1(%eax),%edx
80104364:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
8010436a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010436d:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104370:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104377:	e8 01 0c 00 00       	call   80104f7d <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010437c:	e8 c2 e9 ff ff       	call   80102d43 <kalloc>
80104381:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104384:	89 42 08             	mov    %eax,0x8(%edx)
80104387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438a:	8b 40 08             	mov    0x8(%eax),%eax
8010438d:	85 c0                	test   %eax,%eax
8010438f:	75 33                	jne    801043c4 <allocproc+0x98>
80104391:	eb 20                	jmp    801043b3 <allocproc+0x87>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104393:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104397:	81 7d f4 94 75 11 80 	cmpl   $0x80117594,-0xc(%ebp)
8010439e:	72 a7                	jb     80104347 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801043a0:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
801043a7:	e8 d1 0b 00 00       	call   80104f7d <release>
  return 0;
801043ac:	b8 00 00 00 00       	mov    $0x0,%eax
801043b1:	eb 76                	jmp    80104429 <allocproc+0xfd>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801043bd:	b8 00 00 00 00       	mov    $0x0,%eax
801043c2:	eb 65                	jmp    80104429 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801043c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c7:	8b 40 08             	mov    0x8(%eax),%eax
801043ca:	05 00 10 00 00       	add    $0x1000,%eax
801043cf:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801043d2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801043d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043dc:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801043df:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801043e3:	ba 4c 6f 10 80       	mov    $0x80106f4c,%edx
801043e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043eb:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801043ed:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801043f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043f7:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104400:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104407:	00 
80104408:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010440f:	00 
80104410:	89 04 24             	mov    %eax,(%esp)
80104413:	e8 5e 0d 00 00       	call   80105176 <memset>
  p->context->eip = (uint)forkret;
80104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010441e:	ba 05 4b 10 80       	mov    $0x80104b05,%edx
80104423:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104426:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104429:	c9                   	leave  
8010442a:	c3                   	ret    

8010442b <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010442b:	55                   	push   %ebp
8010442c:	89 e5                	mov    %esp,%ebp
8010442e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104431:	e8 f6 fe ff ff       	call   8010432c <allocproc>
80104436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443c:	a3 80 c6 10 80       	mov    %eax,0x8010c680
  if((p->pgdir = setupkvm()) == 0)
80104441:	e8 44 40 00 00       	call   8010848a <setupkvm>
80104446:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104449:	89 42 04             	mov    %eax,0x4(%edx)
8010444c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444f:	8b 40 04             	mov    0x4(%eax),%eax
80104452:	85 c0                	test   %eax,%eax
80104454:	75 0c                	jne    80104462 <userinit+0x37>
    panic("userinit: out of memory?");
80104456:	c7 04 24 3e 98 10 80 	movl   $0x8010983e,(%esp)
8010445d:	e8 f2 c0 ff ff       	call   80100554 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104462:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446a:	8b 40 04             	mov    0x4(%eax),%eax
8010446d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104471:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
80104478:	80 
80104479:	89 04 24             	mov    %eax,(%esp)
8010447c:	e8 6a 42 00 00       	call   801086eb <inituvm>
  p->sz = PGSIZE;
80104481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104484:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448d:	8b 40 18             	mov    0x18(%eax),%eax
80104490:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104497:	00 
80104498:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010449f:	00 
801044a0:	89 04 24             	mov    %eax,(%esp)
801044a3:	e8 ce 0c 00 00       	call   80105176 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ab:	8b 40 18             	mov    0x18(%eax),%eax
801044ae:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b7:	8b 40 18             	mov    0x18(%eax),%eax
801044ba:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801044c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c3:	8b 50 18             	mov    0x18(%eax),%edx
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c9:	8b 40 18             	mov    0x18(%eax),%eax
801044cc:	8b 40 2c             	mov    0x2c(%eax),%eax
801044cf:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d6:	8b 50 18             	mov    0x18(%eax),%edx
801044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dc:	8b 40 18             	mov    0x18(%eax),%eax
801044df:	8b 40 2c             	mov    0x2c(%eax),%eax
801044e2:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801044e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e9:	8b 40 18             	mov    0x18(%eax),%eax
801044ec:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801044f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f6:	8b 40 18             	mov    0x18(%eax),%eax
801044f9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104503:	8b 40 18             	mov    0x18(%eax),%eax
80104506:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010450d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104510:	83 c0 6c             	add    $0x6c,%eax
80104513:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010451a:	00 
8010451b:	c7 44 24 04 57 98 10 	movl   $0x80109857,0x4(%esp)
80104522:	80 
80104523:	89 04 24             	mov    %eax,(%esp)
80104526:	e8 85 0e 00 00       	call   801053b0 <safestrcpy>
  p->cwd = namei("/");
8010452b:	c7 04 24 60 98 10 80 	movl   $0x80109860,(%esp)
80104532:	e8 00 e1 ff ff       	call   80102637 <namei>
80104537:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010453a:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010453d:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104544:	e8 ca 09 00 00       	call   80104f13 <acquire>

  p->state = RUNNABLE;
80104549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104553:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
8010455a:	e8 1e 0a 00 00       	call   80104f7d <release>
}
8010455f:	c9                   	leave  
80104560:	c3                   	ret    

80104561 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104561:	55                   	push   %ebp
80104562:	89 e5                	mov    %esp,%ebp
80104564:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
80104567:	e8 97 fd ff ff       	call   80104303 <myproc>
8010456c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
8010456f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104572:	8b 00                	mov    (%eax),%eax
80104574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104577:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010457b:	7e 31                	jle    801045ae <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010457d:	8b 55 08             	mov    0x8(%ebp),%edx
80104580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104583:	01 c2                	add    %eax,%edx
80104585:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104588:	8b 40 04             	mov    0x4(%eax),%eax
8010458b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010458f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104592:	89 54 24 04          	mov    %edx,0x4(%esp)
80104596:	89 04 24             	mov    %eax,(%esp)
80104599:	e8 b8 42 00 00       	call   80108856 <allocuvm>
8010459e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045a5:	75 3e                	jne    801045e5 <growproc+0x84>
      return -1;
801045a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ac:	eb 4f                	jmp    801045fd <growproc+0x9c>
  } else if(n < 0){
801045ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045b2:	79 31                	jns    801045e5 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045b4:	8b 55 08             	mov    0x8(%ebp),%edx
801045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ba:	01 c2                	add    %eax,%edx
801045bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045bf:	8b 40 04             	mov    0x4(%eax),%eax
801045c2:	89 54 24 08          	mov    %edx,0x8(%esp)
801045c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801045cd:	89 04 24             	mov    %eax,(%esp)
801045d0:	e8 97 43 00 00       	call   8010896c <deallocuvm>
801045d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045dc:	75 07                	jne    801045e5 <growproc+0x84>
      return -1;
801045de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045e3:	eb 18                	jmp    801045fd <growproc+0x9c>
  }
  curproc->sz = sz;
801045e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045eb:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801045ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045f0:	89 04 24             	mov    %eax,(%esp)
801045f3:	e8 6c 3f 00 00       	call   80108564 <switchuvm>
  return 0;
801045f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045fd:	c9                   	leave  
801045fe:	c3                   	ret    

801045ff <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801045ff:	55                   	push   %ebp
80104600:	89 e5                	mov    %esp,%ebp
80104602:	57                   	push   %edi
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104608:	e8 f6 fc ff ff       	call   80104303 <myproc>
8010460d:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104610:	e8 17 fd ff ff       	call   8010432c <allocproc>
80104615:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104618:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
8010461c:	75 0a                	jne    80104628 <fork+0x29>
    return -1;
8010461e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104623:	e9 35 01 00 00       	jmp    8010475d <fork+0x15e>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104628:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010462b:	8b 10                	mov    (%eax),%edx
8010462d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104630:	8b 40 04             	mov    0x4(%eax),%eax
80104633:	89 54 24 04          	mov    %edx,0x4(%esp)
80104637:	89 04 24             	mov    %eax,(%esp)
8010463a:	e8 cd 44 00 00       	call   80108b0c <copyuvm>
8010463f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104642:	89 42 04             	mov    %eax,0x4(%edx)
80104645:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104648:	8b 40 04             	mov    0x4(%eax),%eax
8010464b:	85 c0                	test   %eax,%eax
8010464d:	75 2c                	jne    8010467b <fork+0x7c>
    kfree(np->kstack);
8010464f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104652:	8b 40 08             	mov    0x8(%eax),%eax
80104655:	89 04 24             	mov    %eax,(%esp)
80104658:	e8 50 e6 ff ff       	call   80102cad <kfree>
    np->kstack = 0;
8010465d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104660:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104667:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010466a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104676:	e9 e2 00 00 00       	jmp    8010475d <fork+0x15e>
  }
  np->sz = curproc->sz;
8010467b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010467e:	8b 10                	mov    (%eax),%edx
80104680:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104683:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104685:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104688:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010468b:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
8010468e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104691:	8b 50 18             	mov    0x18(%eax),%edx
80104694:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104697:	8b 40 18             	mov    0x18(%eax),%eax
8010469a:	89 c3                	mov    %eax,%ebx
8010469c:	b8 13 00 00 00       	mov    $0x13,%eax
801046a1:	89 d7                	mov    %edx,%edi
801046a3:	89 de                	mov    %ebx,%esi
801046a5:	89 c1                	mov    %eax,%ecx
801046a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801046a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046ac:	8b 40 18             	mov    0x18(%eax),%eax
801046af:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801046b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801046bd:	eb 36                	jmp    801046f5 <fork+0xf6>
    if(curproc->ofile[i])
801046bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046c5:	83 c2 08             	add    $0x8,%edx
801046c8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046cc:	85 c0                	test   %eax,%eax
801046ce:	74 22                	je     801046f2 <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046d6:	83 c2 08             	add    $0x8,%edx
801046d9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046dd:	89 04 24             	mov    %eax,(%esp)
801046e0:	e8 cb ca ff ff       	call   801011b0 <filedup>
801046e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801046eb:	83 c1 08             	add    $0x8,%ecx
801046ee:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801046f2:	ff 45 e4             	incl   -0x1c(%ebp)
801046f5:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801046f9:	7e c4                	jle    801046bf <fork+0xc0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801046fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fe:	8b 40 68             	mov    0x68(%eax),%eax
80104701:	89 04 24             	mov    %eax,(%esp)
80104704:	e8 d7 d3 ff ff       	call   80101ae0 <idup>
80104709:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010470c:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010470f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104712:	8d 50 6c             	lea    0x6c(%eax),%edx
80104715:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104718:	83 c0 6c             	add    $0x6c,%eax
8010471b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104722:	00 
80104723:	89 54 24 04          	mov    %edx,0x4(%esp)
80104727:	89 04 24             	mov    %eax,(%esp)
8010472a:	e8 81 0c 00 00       	call   801053b0 <safestrcpy>

  pid = np->pid;
8010472f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104732:	8b 40 10             	mov    0x10(%eax),%eax
80104735:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104738:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
8010473f:	e8 cf 07 00 00       	call   80104f13 <acquire>

  np->state = RUNNABLE;
80104744:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104747:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010474e:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104755:	e8 23 08 00 00       	call   80104f7d <release>

  return pid;
8010475a:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
8010475d:	83 c4 2c             	add    $0x2c,%esp
80104760:	5b                   	pop    %ebx
80104761:	5e                   	pop    %esi
80104762:	5f                   	pop    %edi
80104763:	5d                   	pop    %ebp
80104764:	c3                   	ret    

80104765 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104765:	55                   	push   %ebp
80104766:	89 e5                	mov    %esp,%ebp
80104768:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
8010476b:	e8 93 fb ff ff       	call   80104303 <myproc>
80104770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104773:	a1 80 c6 10 80       	mov    0x8010c680,%eax
80104778:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010477b:	75 0c                	jne    80104789 <exit+0x24>
    panic("init exiting");
8010477d:	c7 04 24 62 98 10 80 	movl   $0x80109862,(%esp)
80104784:	e8 cb bd ff ff       	call   80100554 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104790:	eb 3a                	jmp    801047cc <exit+0x67>
    if(curproc->ofile[fd]){
80104792:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104795:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104798:	83 c2 08             	add    $0x8,%edx
8010479b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010479f:	85 c0                	test   %eax,%eax
801047a1:	74 26                	je     801047c9 <exit+0x64>
      fileclose(curproc->ofile[fd]);
801047a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047a9:	83 c2 08             	add    $0x8,%edx
801047ac:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047b0:	89 04 24             	mov    %eax,(%esp)
801047b3:	e8 40 ca ff ff       	call   801011f8 <fileclose>
      curproc->ofile[fd] = 0;
801047b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047be:	83 c2 08             	add    $0x8,%edx
801047c1:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801047c8:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801047c9:	ff 45 f0             	incl   -0x10(%ebp)
801047cc:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801047d0:	7e c0                	jle    80104792 <exit+0x2d>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801047d2:	e8 34 ee ff ff       	call   8010360b <begin_op>
  iput(curproc->cwd);
801047d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047da:	8b 40 68             	mov    0x68(%eax),%eax
801047dd:	89 04 24             	mov    %eax,(%esp)
801047e0:	e8 7b d4 ff ff       	call   80101c60 <iput>
  end_op();
801047e5:	e8 a3 ee ff ff       	call   8010368d <end_op>
  curproc->cwd = 0;
801047ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ed:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801047f4:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
801047fb:	e8 13 07 00 00       	call   80104f13 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104800:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104803:	8b 40 14             	mov    0x14(%eax),%eax
80104806:	89 04 24             	mov    %eax,(%esp)
80104809:	e8 cc 03 00 00       	call   80104bda <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010480e:	c7 45 f4 94 56 11 80 	movl   $0x80115694,-0xc(%ebp)
80104815:	eb 33                	jmp    8010484a <exit+0xe5>
    if(p->parent == curproc){
80104817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481a:	8b 40 14             	mov    0x14(%eax),%eax
8010481d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104820:	75 24                	jne    80104846 <exit+0xe1>
      p->parent = initproc;
80104822:	8b 15 80 c6 10 80    	mov    0x8010c680,%edx
80104828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482b:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104831:	8b 40 0c             	mov    0xc(%eax),%eax
80104834:	83 f8 05             	cmp    $0x5,%eax
80104837:	75 0d                	jne    80104846 <exit+0xe1>
        wakeup1(initproc);
80104839:	a1 80 c6 10 80       	mov    0x8010c680,%eax
8010483e:	89 04 24             	mov    %eax,(%esp)
80104841:	e8 94 03 00 00       	call   80104bda <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104846:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010484a:	81 7d f4 94 75 11 80 	cmpl   $0x80117594,-0xc(%ebp)
80104851:	72 c4                	jb     80104817 <exit+0xb2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104853:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104856:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010485d:	e8 c3 01 00 00       	call   80104a25 <sched>
  panic("zombie exit");
80104862:	c7 04 24 6f 98 10 80 	movl   $0x8010986f,(%esp)
80104869:	e8 e6 bc ff ff       	call   80100554 <panic>

8010486e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010486e:	55                   	push   %ebp
8010486f:	89 e5                	mov    %esp,%ebp
80104871:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104874:	e8 8a fa ff ff       	call   80104303 <myproc>
80104879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010487c:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104883:	e8 8b 06 00 00       	call   80104f13 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104888:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488f:	c7 45 f4 94 56 11 80 	movl   $0x80115694,-0xc(%ebp)
80104896:	e9 95 00 00 00       	jmp    80104930 <wait+0xc2>
      if(p->parent != curproc)
8010489b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489e:	8b 40 14             	mov    0x14(%eax),%eax
801048a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801048a4:	74 05                	je     801048ab <wait+0x3d>
        continue;
801048a6:	e9 81 00 00 00       	jmp    8010492c <wait+0xbe>
      havekids = 1;
801048ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b5:	8b 40 0c             	mov    0xc(%eax),%eax
801048b8:	83 f8 05             	cmp    $0x5,%eax
801048bb:	75 6f                	jne    8010492c <wait+0xbe>
        // Found one.
        pid = p->pid;
801048bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c0:	8b 40 10             	mov    0x10(%eax),%eax
801048c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c9:	8b 40 08             	mov    0x8(%eax),%eax
801048cc:	89 04 24             	mov    %eax,(%esp)
801048cf:	e8 d9 e3 ff ff       	call   80102cad <kfree>
        p->kstack = 0;
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801048de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e1:	8b 40 04             	mov    0x4(%eax),%eax
801048e4:	89 04 24             	mov    %eax,(%esp)
801048e7:	e8 44 41 00 00       	call   80108a30 <freevm>
        p->pid = 0;
801048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ef:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104903:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104914:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010491b:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104922:	e8 56 06 00 00       	call   80104f7d <release>
        return pid;
80104927:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010492a:	eb 4c                	jmp    80104978 <wait+0x10a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010492c:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104930:	81 7d f4 94 75 11 80 	cmpl   $0x80117594,-0xc(%ebp)
80104937:	0f 82 5e ff ff ff    	jb     8010489b <wait+0x2d>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010493d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104941:	74 0a                	je     8010494d <wait+0xdf>
80104943:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104946:	8b 40 24             	mov    0x24(%eax),%eax
80104949:	85 c0                	test   %eax,%eax
8010494b:	74 13                	je     80104960 <wait+0xf2>
      release(&ptable.lock);
8010494d:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104954:	e8 24 06 00 00       	call   80104f7d <release>
      return -1;
80104959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010495e:	eb 18                	jmp    80104978 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104960:	c7 44 24 04 60 56 11 	movl   $0x80115660,0x4(%esp)
80104967:	80 
80104968:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010496b:	89 04 24             	mov    %eax,(%esp)
8010496e:	e8 d1 01 00 00       	call   80104b44 <sleep>
  }
80104973:	e9 10 ff ff ff       	jmp    80104888 <wait+0x1a>
}
80104978:	c9                   	leave  
80104979:	c3                   	ret    

8010497a <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010497a:	55                   	push   %ebp
8010497b:	89 e5                	mov    %esp,%ebp
8010497d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104980:	e8 fa f8 ff ff       	call   8010427f <mycpu>
80104985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104988:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104992:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104995:	e8 7e f8 ff ff       	call   80104218 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010499a:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
801049a1:	e8 6d 05 00 00       	call   80104f13 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a6:	c7 45 f4 94 56 11 80 	movl   $0x80115694,-0xc(%ebp)
801049ad:	eb 5c                	jmp    80104a0b <scheduler+0x91>
      if(p->state != RUNNABLE)
801049af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b2:	8b 40 0c             	mov    0xc(%eax),%eax
801049b5:	83 f8 03             	cmp    $0x3,%eax
801049b8:	74 02                	je     801049bc <scheduler+0x42>
        continue;
801049ba:	eb 4b                	jmp    80104a07 <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801049bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049c2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cb:	89 04 24             	mov    %eax,(%esp)
801049ce:	e8 91 3b 00 00       	call   80108564 <switchuvm>
      p->state = RUNNING;
801049d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801049dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801049e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049e6:	83 c2 04             	add    $0x4,%edx
801049e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801049ed:	89 14 24             	mov    %edx,(%esp)
801049f0:	e8 7f 0c 00 00       	call   80105674 <swtch>
      switchkvm();
801049f5:	e8 50 3b 00 00       	call   8010854a <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801049fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049fd:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a04:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a07:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a0b:	81 7d f4 94 75 11 80 	cmpl   $0x80117594,-0xc(%ebp)
80104a12:	72 9b                	jb     801049af <scheduler+0x35>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104a14:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104a1b:	e8 5d 05 00 00       	call   80104f7d <release>

  }
80104a20:	e9 70 ff ff ff       	jmp    80104995 <scheduler+0x1b>

80104a25 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104a25:	55                   	push   %ebp
80104a26:	89 e5                	mov    %esp,%ebp
80104a28:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104a2b:	e8 d3 f8 ff ff       	call   80104303 <myproc>
80104a30:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104a33:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104a3a:	e8 02 06 00 00       	call   80105041 <holding>
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	75 0c                	jne    80104a4f <sched+0x2a>
    panic("sched ptable.lock");
80104a43:	c7 04 24 7b 98 10 80 	movl   $0x8010987b,(%esp)
80104a4a:	e8 05 bb ff ff       	call   80100554 <panic>
  if(mycpu()->ncli != 1)
80104a4f:	e8 2b f8 ff ff       	call   8010427f <mycpu>
80104a54:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a5a:	83 f8 01             	cmp    $0x1,%eax
80104a5d:	74 0c                	je     80104a6b <sched+0x46>
    panic("sched locks");
80104a5f:	c7 04 24 8d 98 10 80 	movl   $0x8010988d,(%esp)
80104a66:	e8 e9 ba ff ff       	call   80100554 <panic>
  if(p->state == RUNNING)
80104a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6e:	8b 40 0c             	mov    0xc(%eax),%eax
80104a71:	83 f8 04             	cmp    $0x4,%eax
80104a74:	75 0c                	jne    80104a82 <sched+0x5d>
    panic("sched running");
80104a76:	c7 04 24 99 98 10 80 	movl   $0x80109899,(%esp)
80104a7d:	e8 d2 ba ff ff       	call   80100554 <panic>
  if(readeflags()&FL_IF)
80104a82:	e8 81 f7 ff ff       	call   80104208 <readeflags>
80104a87:	25 00 02 00 00       	and    $0x200,%eax
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	74 0c                	je     80104a9c <sched+0x77>
    panic("sched interruptible");
80104a90:	c7 04 24 a7 98 10 80 	movl   $0x801098a7,(%esp)
80104a97:	e8 b8 ba ff ff       	call   80100554 <panic>
  intena = mycpu()->intena;
80104a9c:	e8 de f7 ff ff       	call   8010427f <mycpu>
80104aa1:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104aaa:	e8 d0 f7 ff ff       	call   8010427f <mycpu>
80104aaf:	8b 40 04             	mov    0x4(%eax),%eax
80104ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ab5:	83 c2 1c             	add    $0x1c,%edx
80104ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104abc:	89 14 24             	mov    %edx,(%esp)
80104abf:	e8 b0 0b 00 00       	call   80105674 <swtch>
  mycpu()->intena = intena;
80104ac4:	e8 b6 f7 ff ff       	call   8010427f <mycpu>
80104ac9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104acc:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104ad2:	c9                   	leave  
80104ad3:	c3                   	ret    

80104ad4 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ada:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104ae1:	e8 2d 04 00 00       	call   80104f13 <acquire>
  myproc()->state = RUNNABLE;
80104ae6:	e8 18 f8 ff ff       	call   80104303 <myproc>
80104aeb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104af2:	e8 2e ff ff ff       	call   80104a25 <sched>
  release(&ptable.lock);
80104af7:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104afe:	e8 7a 04 00 00       	call   80104f7d <release>
}
80104b03:	c9                   	leave  
80104b04:	c3                   	ret    

80104b05 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b05:	55                   	push   %ebp
80104b06:	89 e5                	mov    %esp,%ebp
80104b08:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b0b:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104b12:	e8 66 04 00 00       	call   80104f7d <release>

  if (first) {
80104b17:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104b1c:	85 c0                	test   %eax,%eax
80104b1e:	74 22                	je     80104b42 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104b20:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104b27:	00 00 00 
    iinit(ROOTDEV);
80104b2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b31:	e8 75 cc ff ff       	call   801017ab <iinit>
    initlog(ROOTDEV);
80104b36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b3d:	e8 ca e8 ff ff       	call   8010340c <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104b42:	c9                   	leave  
80104b43:	c3                   	ret    

80104b44 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104b4a:	e8 b4 f7 ff ff       	call   80104303 <myproc>
80104b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104b56:	75 0c                	jne    80104b64 <sleep+0x20>
    panic("sleep");
80104b58:	c7 04 24 bb 98 10 80 	movl   $0x801098bb,(%esp)
80104b5f:	e8 f0 b9 ff ff       	call   80100554 <panic>

  if(lk == 0)
80104b64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b68:	75 0c                	jne    80104b76 <sleep+0x32>
    panic("sleep without lk");
80104b6a:	c7 04 24 c1 98 10 80 	movl   $0x801098c1,(%esp)
80104b71:	e8 de b9 ff ff       	call   80100554 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b76:	81 7d 0c 60 56 11 80 	cmpl   $0x80115660,0xc(%ebp)
80104b7d:	74 17                	je     80104b96 <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b7f:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104b86:	e8 88 03 00 00       	call   80104f13 <acquire>
    release(lk);
80104b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8e:	89 04 24             	mov    %eax,(%esp)
80104b91:	e8 e7 03 00 00       	call   80104f7d <release>
  }
  // Go to sleep.
  p->chan = chan;
80104b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b99:	8b 55 08             	mov    0x8(%ebp),%edx
80104b9c:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104ba9:	e8 77 fe ff ff       	call   80104a25 <sched>

  // Tidy up.
  p->chan = 0;
80104bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb1:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104bb8:	81 7d 0c 60 56 11 80 	cmpl   $0x80115660,0xc(%ebp)
80104bbf:	74 17                	je     80104bd8 <sleep+0x94>
    release(&ptable.lock);
80104bc1:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104bc8:	e8 b0 03 00 00       	call   80104f7d <release>
    acquire(lk);
80104bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bd0:	89 04 24             	mov    %eax,(%esp)
80104bd3:	e8 3b 03 00 00       	call   80104f13 <acquire>
  }
}
80104bd8:	c9                   	leave  
80104bd9:	c3                   	ret    

80104bda <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104bda:	55                   	push   %ebp
80104bdb:	89 e5                	mov    %esp,%ebp
80104bdd:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be0:	c7 45 fc 94 56 11 80 	movl   $0x80115694,-0x4(%ebp)
80104be7:	eb 24                	jmp    80104c0d <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bec:	8b 40 0c             	mov    0xc(%eax),%eax
80104bef:	83 f8 02             	cmp    $0x2,%eax
80104bf2:	75 15                	jne    80104c09 <wakeup1+0x2f>
80104bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bf7:	8b 40 20             	mov    0x20(%eax),%eax
80104bfa:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bfd:	75 0a                	jne    80104c09 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c02:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c09:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104c0d:	81 7d fc 94 75 11 80 	cmpl   $0x80117594,-0x4(%ebp)
80104c14:	72 d3                	jb     80104be9 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104c16:	c9                   	leave  
80104c17:	c3                   	ret    

80104c18 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c18:	55                   	push   %ebp
80104c19:	89 e5                	mov    %esp,%ebp
80104c1b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104c1e:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104c25:	e8 e9 02 00 00       	call   80104f13 <acquire>
  wakeup1(chan);
80104c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2d:	89 04 24             	mov    %eax,(%esp)
80104c30:	e8 a5 ff ff ff       	call   80104bda <wakeup1>
  release(&ptable.lock);
80104c35:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104c3c:	e8 3c 03 00 00       	call   80104f7d <release>
}
80104c41:	c9                   	leave  
80104c42:	c3                   	ret    

80104c43 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c43:	55                   	push   %ebp
80104c44:	89 e5                	mov    %esp,%ebp
80104c46:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c49:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104c50:	e8 be 02 00 00       	call   80104f13 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c55:	c7 45 f4 94 56 11 80 	movl   $0x80115694,-0xc(%ebp)
80104c5c:	eb 41                	jmp    80104c9f <kill+0x5c>
    if(p->pid == pid){
80104c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c61:	8b 40 10             	mov    0x10(%eax),%eax
80104c64:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c67:	75 32                	jne    80104c9b <kill+0x58>
      p->killed = 1;
80104c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c6c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c76:	8b 40 0c             	mov    0xc(%eax),%eax
80104c79:	83 f8 02             	cmp    $0x2,%eax
80104c7c:	75 0a                	jne    80104c88 <kill+0x45>
        p->state = RUNNABLE;
80104c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c81:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104c88:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104c8f:	e8 e9 02 00 00       	call   80104f7d <release>
      return 0;
80104c94:	b8 00 00 00 00       	mov    $0x0,%eax
80104c99:	eb 1e                	jmp    80104cb9 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c9b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104c9f:	81 7d f4 94 75 11 80 	cmpl   $0x80117594,-0xc(%ebp)
80104ca6:	72 b6                	jb     80104c5e <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104ca8:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
80104caf:	e8 c9 02 00 00       	call   80104f7d <release>
  return -1;
80104cb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb9:	c9                   	leave  
80104cba:	c3                   	ret    

80104cbb <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104cbb:	55                   	push   %ebp
80104cbc:	89 e5                	mov    %esp,%ebp
80104cbe:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc1:	c7 45 f0 94 56 11 80 	movl   $0x80115694,-0x10(%ebp)
80104cc8:	e9 d5 00 00 00       	jmp    80104da2 <procdump+0xe7>
    if(p->state == UNUSED)
80104ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd0:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	75 05                	jne    80104cdc <procdump+0x21>
      continue;
80104cd7:	e9 c2 00 00 00       	jmp    80104d9e <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cdf:	8b 40 0c             	mov    0xc(%eax),%eax
80104ce2:	83 f8 05             	cmp    $0x5,%eax
80104ce5:	77 23                	ja     80104d0a <procdump+0x4f>
80104ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cea:	8b 40 0c             	mov    0xc(%eax),%eax
80104ced:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	74 12                	je     80104d0a <procdump+0x4f>
      state = states[p->state];
80104cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cfb:	8b 40 0c             	mov    0xc(%eax),%eax
80104cfe:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104d05:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104d08:	eb 07                	jmp    80104d11 <procdump+0x56>
    else
      state = "???";
80104d0a:	c7 45 ec d2 98 10 80 	movl   $0x801098d2,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d14:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d1a:	8b 40 10             	mov    0x10(%eax),%eax
80104d1d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104d21:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d24:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d28:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d2c:	c7 04 24 d6 98 10 80 	movl   $0x801098d6,(%esp)
80104d33:	e8 89 b6 ff ff       	call   801003c1 <cprintf>
    if(p->state == SLEEPING){
80104d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d3b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d3e:	83 f8 02             	cmp    $0x2,%eax
80104d41:	75 4f                	jne    80104d92 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d46:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d49:	8b 40 0c             	mov    0xc(%eax),%eax
80104d4c:	83 c0 08             	add    $0x8,%eax
80104d4f:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d52:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d56:	89 04 24             	mov    %eax,(%esp)
80104d59:	e8 6c 02 00 00       	call   80104fca <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d65:	eb 1a                	jmp    80104d81 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d72:	c7 04 24 df 98 10 80 	movl   $0x801098df,(%esp)
80104d79:	e8 43 b6 ff ff       	call   801003c1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104d7e:	ff 45 f4             	incl   -0xc(%ebp)
80104d81:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104d85:	7f 0b                	jg     80104d92 <procdump+0xd7>
80104d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d8e:	85 c0                	test   %eax,%eax
80104d90:	75 d5                	jne    80104d67 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104d92:	c7 04 24 e3 98 10 80 	movl   $0x801098e3,(%esp)
80104d99:	e8 23 b6 ff ff       	call   801003c1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d9e:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104da2:	81 7d f0 94 75 11 80 	cmpl   $0x80117594,-0x10(%ebp)
80104da9:	0f 82 1e ff ff ff    	jb     80104ccd <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104daf:	c9                   	leave  
80104db0:	c3                   	ret    
80104db1:	00 00                	add    %al,(%eax)
	...

80104db4 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104dba:	8b 45 08             	mov    0x8(%ebp),%eax
80104dbd:	83 c0 04             	add    $0x4,%eax
80104dc0:	c7 44 24 04 0f 99 10 	movl   $0x8010990f,0x4(%esp)
80104dc7:	80 
80104dc8:	89 04 24             	mov    %eax,(%esp)
80104dcb:	e8 22 01 00 00       	call   80104ef2 <initlock>
  lk->name = name;
80104dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dd6:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80104ddc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104de2:	8b 45 08             	mov    0x8(%ebp),%eax
80104de5:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104dec:	c9                   	leave  
80104ded:	c3                   	ret    

80104dee <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104dee:	55                   	push   %ebp
80104def:	89 e5                	mov    %esp,%ebp
80104df1:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104df4:	8b 45 08             	mov    0x8(%ebp),%eax
80104df7:	83 c0 04             	add    $0x4,%eax
80104dfa:	89 04 24             	mov    %eax,(%esp)
80104dfd:	e8 11 01 00 00       	call   80104f13 <acquire>
  while (lk->locked) {
80104e02:	eb 15                	jmp    80104e19 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104e04:	8b 45 08             	mov    0x8(%ebp),%eax
80104e07:	83 c0 04             	add    $0x4,%eax
80104e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e11:	89 04 24             	mov    %eax,(%esp)
80104e14:	e8 2b fd ff ff       	call   80104b44 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104e19:	8b 45 08             	mov    0x8(%ebp),%eax
80104e1c:	8b 00                	mov    (%eax),%eax
80104e1e:	85 c0                	test   %eax,%eax
80104e20:	75 e2                	jne    80104e04 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104e22:	8b 45 08             	mov    0x8(%ebp),%eax
80104e25:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104e2b:	e8 d3 f4 ff ff       	call   80104303 <myproc>
80104e30:	8b 50 10             	mov    0x10(%eax),%edx
80104e33:	8b 45 08             	mov    0x8(%ebp),%eax
80104e36:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104e39:	8b 45 08             	mov    0x8(%ebp),%eax
80104e3c:	83 c0 04             	add    $0x4,%eax
80104e3f:	89 04 24             	mov    %eax,(%esp)
80104e42:	e8 36 01 00 00       	call   80104f7d <release>
}
80104e47:	c9                   	leave  
80104e48:	c3                   	ret    

80104e49 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104e49:	55                   	push   %ebp
80104e4a:	89 e5                	mov    %esp,%ebp
80104e4c:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e52:	83 c0 04             	add    $0x4,%eax
80104e55:	89 04 24             	mov    %eax,(%esp)
80104e58:	e8 b6 00 00 00       	call   80104f13 <acquire>
  lk->locked = 0;
80104e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104e66:	8b 45 08             	mov    0x8(%ebp),%eax
80104e69:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104e70:	8b 45 08             	mov    0x8(%ebp),%eax
80104e73:	89 04 24             	mov    %eax,(%esp)
80104e76:	e8 9d fd ff ff       	call   80104c18 <wakeup>
  release(&lk->lk);
80104e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7e:	83 c0 04             	add    $0x4,%eax
80104e81:	89 04 24             	mov    %eax,(%esp)
80104e84:	e8 f4 00 00 00       	call   80104f7d <release>
}
80104e89:	c9                   	leave  
80104e8a:	c3                   	ret    

80104e8b <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e8b:	55                   	push   %ebp
80104e8c:	89 e5                	mov    %esp,%ebp
80104e8e:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104e91:	8b 45 08             	mov    0x8(%ebp),%eax
80104e94:	83 c0 04             	add    $0x4,%eax
80104e97:	89 04 24             	mov    %eax,(%esp)
80104e9a:	e8 74 00 00 00       	call   80104f13 <acquire>
  r = lk->locked;
80104e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea2:	8b 00                	mov    (%eax),%eax
80104ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80104eaa:	83 c0 04             	add    $0x4,%eax
80104ead:	89 04 24             	mov    %eax,(%esp)
80104eb0:	e8 c8 00 00 00       	call   80104f7d <release>
  return r;
80104eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104eb8:	c9                   	leave  
80104eb9:	c3                   	ret    
	...

80104ebc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104ebc:	55                   	push   %ebp
80104ebd:	89 e5                	mov    %esp,%ebp
80104ebf:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ec2:	9c                   	pushf  
80104ec3:	58                   	pop    %eax
80104ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104eca:	c9                   	leave  
80104ecb:	c3                   	ret    

80104ecc <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104ecc:	55                   	push   %ebp
80104ecd:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104ecf:	fa                   	cli    
}
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    

80104ed2 <sti>:

static inline void
sti(void)
{
80104ed2:	55                   	push   %ebp
80104ed3:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104ed5:	fb                   	sti    
}
80104ed6:	5d                   	pop    %ebp
80104ed7:	c3                   	ret    

80104ed8 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104ed8:	55                   	push   %ebp
80104ed9:	89 e5                	mov    %esp,%ebp
80104edb:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104ede:	8b 55 08             	mov    0x8(%ebp),%edx
80104ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ee4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ee7:	f0 87 02             	lock xchg %eax,(%edx)
80104eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104ef0:	c9                   	leave  
80104ef1:	c3                   	ret    

80104ef2 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ef2:	55                   	push   %ebp
80104ef3:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104efb:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104efe:	8b 45 08             	mov    0x8(%ebp),%eax
80104f01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f07:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret    

80104f13 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f13:	55                   	push   %ebp
80104f14:	89 e5                	mov    %esp,%ebp
80104f16:	53                   	push   %ebx
80104f17:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f1a:	e8 53 01 00 00       	call   80105072 <pushcli>
  if(holding(lk))
80104f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f22:	89 04 24             	mov    %eax,(%esp)
80104f25:	e8 17 01 00 00       	call   80105041 <holding>
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	74 0c                	je     80104f3a <acquire+0x27>
    panic("acquire");
80104f2e:	c7 04 24 1a 99 10 80 	movl   $0x8010991a,(%esp)
80104f35:	e8 1a b6 ff ff       	call   80100554 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104f3a:	90                   	nop
80104f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f45:	00 
80104f46:	89 04 24             	mov    %eax,(%esp)
80104f49:	e8 8a ff ff ff       	call   80104ed8 <xchg>
80104f4e:	85 c0                	test   %eax,%eax
80104f50:	75 e9                	jne    80104f3b <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104f52:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f5a:	e8 20 f3 ff ff       	call   8010427f <mycpu>
80104f5f:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104f62:	8b 45 08             	mov    0x8(%ebp),%eax
80104f65:	83 c0 0c             	add    $0xc,%eax
80104f68:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f6c:	8d 45 08             	lea    0x8(%ebp),%eax
80104f6f:	89 04 24             	mov    %eax,(%esp)
80104f72:	e8 53 00 00 00       	call   80104fca <getcallerpcs>
}
80104f77:	83 c4 14             	add    $0x14,%esp
80104f7a:	5b                   	pop    %ebx
80104f7b:	5d                   	pop    %ebp
80104f7c:	c3                   	ret    

80104f7d <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104f7d:	55                   	push   %ebp
80104f7e:	89 e5                	mov    %esp,%ebp
80104f80:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104f83:	8b 45 08             	mov    0x8(%ebp),%eax
80104f86:	89 04 24             	mov    %eax,(%esp)
80104f89:	e8 b3 00 00 00       	call   80105041 <holding>
80104f8e:	85 c0                	test   %eax,%eax
80104f90:	75 0c                	jne    80104f9e <release+0x21>
    panic("release");
80104f92:	c7 04 24 22 99 10 80 	movl   $0x80109922,(%esp)
80104f99:	e8 b6 b5 ff ff       	call   80100554 <panic>

  lk->pcs[0] = 0;
80104f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80104fab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104fb2:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fba:	8b 55 08             	mov    0x8(%ebp),%edx
80104fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104fc3:	e8 f4 00 00 00       	call   801050bc <popcli>
}
80104fc8:	c9                   	leave  
80104fc9:	c3                   	ret    

80104fca <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104fca:	55                   	push   %ebp
80104fcb:	89 e5                	mov    %esp,%ebp
80104fcd:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd3:	83 e8 08             	sub    $0x8,%eax
80104fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104fd9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104fe0:	eb 37                	jmp    80105019 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104fe6:	74 37                	je     8010501f <getcallerpcs+0x55>
80104fe8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104fef:	76 2e                	jbe    8010501f <getcallerpcs+0x55>
80104ff1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104ff5:	74 28                	je     8010501f <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ffa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105001:	8b 45 0c             	mov    0xc(%ebp),%eax
80105004:	01 c2                	add    %eax,%edx
80105006:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105009:	8b 40 04             	mov    0x4(%eax),%eax
8010500c:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010500e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105011:	8b 00                	mov    (%eax),%eax
80105013:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105016:	ff 45 f8             	incl   -0x8(%ebp)
80105019:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010501d:	7e c3                	jle    80104fe2 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010501f:	eb 18                	jmp    80105039 <getcallerpcs+0x6f>
    pcs[i] = 0;
80105021:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105024:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010502b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502e:	01 d0                	add    %edx,%eax
80105030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105036:	ff 45 f8             	incl   -0x8(%ebp)
80105039:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010503d:	7e e2                	jle    80105021 <getcallerpcs+0x57>
    pcs[i] = 0;
}
8010503f:	c9                   	leave  
80105040:	c3                   	ret    

80105041 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105041:	55                   	push   %ebp
80105042:	89 e5                	mov    %esp,%ebp
80105044:	53                   	push   %ebx
80105045:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80105048:	8b 45 08             	mov    0x8(%ebp),%eax
8010504b:	8b 00                	mov    (%eax),%eax
8010504d:	85 c0                	test   %eax,%eax
8010504f:	74 16                	je     80105067 <holding+0x26>
80105051:	8b 45 08             	mov    0x8(%ebp),%eax
80105054:	8b 58 08             	mov    0x8(%eax),%ebx
80105057:	e8 23 f2 ff ff       	call   8010427f <mycpu>
8010505c:	39 c3                	cmp    %eax,%ebx
8010505e:	75 07                	jne    80105067 <holding+0x26>
80105060:	b8 01 00 00 00       	mov    $0x1,%eax
80105065:	eb 05                	jmp    8010506c <holding+0x2b>
80105067:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010506c:	83 c4 04             	add    $0x4,%esp
8010506f:	5b                   	pop    %ebx
80105070:	5d                   	pop    %ebp
80105071:	c3                   	ret    

80105072 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105072:	55                   	push   %ebp
80105073:	89 e5                	mov    %esp,%ebp
80105075:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105078:	e8 3f fe ff ff       	call   80104ebc <readeflags>
8010507d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105080:	e8 47 fe ff ff       	call   80104ecc <cli>
  if(mycpu()->ncli == 0)
80105085:	e8 f5 f1 ff ff       	call   8010427f <mycpu>
8010508a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105090:	85 c0                	test   %eax,%eax
80105092:	75 14                	jne    801050a8 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80105094:	e8 e6 f1 ff ff       	call   8010427f <mycpu>
80105099:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010509c:	81 e2 00 02 00 00    	and    $0x200,%edx
801050a2:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
801050a8:	e8 d2 f1 ff ff       	call   8010427f <mycpu>
801050ad:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050b3:	42                   	inc    %edx
801050b4:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
801050ba:	c9                   	leave  
801050bb:	c3                   	ret    

801050bc <popcli>:

void
popcli(void)
{
801050bc:	55                   	push   %ebp
801050bd:	89 e5                	mov    %esp,%ebp
801050bf:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801050c2:	e8 f5 fd ff ff       	call   80104ebc <readeflags>
801050c7:	25 00 02 00 00       	and    $0x200,%eax
801050cc:	85 c0                	test   %eax,%eax
801050ce:	74 0c                	je     801050dc <popcli+0x20>
    panic("popcli - interruptible");
801050d0:	c7 04 24 2a 99 10 80 	movl   $0x8010992a,(%esp)
801050d7:	e8 78 b4 ff ff       	call   80100554 <panic>
  if(--mycpu()->ncli < 0)
801050dc:	e8 9e f1 ff ff       	call   8010427f <mycpu>
801050e1:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050e7:	4a                   	dec    %edx
801050e8:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801050ee:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050f4:	85 c0                	test   %eax,%eax
801050f6:	79 0c                	jns    80105104 <popcli+0x48>
    panic("popcli");
801050f8:	c7 04 24 41 99 10 80 	movl   $0x80109941,(%esp)
801050ff:	e8 50 b4 ff ff       	call   80100554 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105104:	e8 76 f1 ff ff       	call   8010427f <mycpu>
80105109:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010510f:	85 c0                	test   %eax,%eax
80105111:	75 14                	jne    80105127 <popcli+0x6b>
80105113:	e8 67 f1 ff ff       	call   8010427f <mycpu>
80105118:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010511e:	85 c0                	test   %eax,%eax
80105120:	74 05                	je     80105127 <popcli+0x6b>
    sti();
80105122:	e8 ab fd ff ff       	call   80104ed2 <sti>
}
80105127:	c9                   	leave  
80105128:	c3                   	ret    
80105129:	00 00                	add    %al,(%eax)
	...

8010512c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010512c:	55                   	push   %ebp
8010512d:	89 e5                	mov    %esp,%ebp
8010512f:	57                   	push   %edi
80105130:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105131:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105134:	8b 55 10             	mov    0x10(%ebp),%edx
80105137:	8b 45 0c             	mov    0xc(%ebp),%eax
8010513a:	89 cb                	mov    %ecx,%ebx
8010513c:	89 df                	mov    %ebx,%edi
8010513e:	89 d1                	mov    %edx,%ecx
80105140:	fc                   	cld    
80105141:	f3 aa                	rep stos %al,%es:(%edi)
80105143:	89 ca                	mov    %ecx,%edx
80105145:	89 fb                	mov    %edi,%ebx
80105147:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010514a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010514d:	5b                   	pop    %ebx
8010514e:	5f                   	pop    %edi
8010514f:	5d                   	pop    %ebp
80105150:	c3                   	ret    

80105151 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105151:	55                   	push   %ebp
80105152:	89 e5                	mov    %esp,%ebp
80105154:	57                   	push   %edi
80105155:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105156:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105159:	8b 55 10             	mov    0x10(%ebp),%edx
8010515c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010515f:	89 cb                	mov    %ecx,%ebx
80105161:	89 df                	mov    %ebx,%edi
80105163:	89 d1                	mov    %edx,%ecx
80105165:	fc                   	cld    
80105166:	f3 ab                	rep stos %eax,%es:(%edi)
80105168:	89 ca                	mov    %ecx,%edx
8010516a:	89 fb                	mov    %edi,%ebx
8010516c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010516f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105172:	5b                   	pop    %ebx
80105173:	5f                   	pop    %edi
80105174:	5d                   	pop    %ebp
80105175:	c3                   	ret    

80105176 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105176:	55                   	push   %ebp
80105177:	89 e5                	mov    %esp,%ebp
80105179:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
8010517c:	8b 45 08             	mov    0x8(%ebp),%eax
8010517f:	83 e0 03             	and    $0x3,%eax
80105182:	85 c0                	test   %eax,%eax
80105184:	75 49                	jne    801051cf <memset+0x59>
80105186:	8b 45 10             	mov    0x10(%ebp),%eax
80105189:	83 e0 03             	and    $0x3,%eax
8010518c:	85 c0                	test   %eax,%eax
8010518e:	75 3f                	jne    801051cf <memset+0x59>
    c &= 0xFF;
80105190:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105197:	8b 45 10             	mov    0x10(%ebp),%eax
8010519a:	c1 e8 02             	shr    $0x2,%eax
8010519d:	89 c2                	mov    %eax,%edx
8010519f:	8b 45 0c             	mov    0xc(%ebp),%eax
801051a2:	c1 e0 18             	shl    $0x18,%eax
801051a5:	89 c1                	mov    %eax,%ecx
801051a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051aa:	c1 e0 10             	shl    $0x10,%eax
801051ad:	09 c1                	or     %eax,%ecx
801051af:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b2:	c1 e0 08             	shl    $0x8,%eax
801051b5:	09 c8                	or     %ecx,%eax
801051b7:	0b 45 0c             	or     0xc(%ebp),%eax
801051ba:	89 54 24 08          	mov    %edx,0x8(%esp)
801051be:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c2:	8b 45 08             	mov    0x8(%ebp),%eax
801051c5:	89 04 24             	mov    %eax,(%esp)
801051c8:	e8 84 ff ff ff       	call   80105151 <stosl>
801051cd:	eb 19                	jmp    801051e8 <memset+0x72>
  } else
    stosb(dst, c, n);
801051cf:	8b 45 10             	mov    0x10(%ebp),%eax
801051d2:	89 44 24 08          	mov    %eax,0x8(%esp)
801051d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801051d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051dd:	8b 45 08             	mov    0x8(%ebp),%eax
801051e0:	89 04 24             	mov    %eax,(%esp)
801051e3:	e8 44 ff ff ff       	call   8010512c <stosb>
  return dst;
801051e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051eb:	c9                   	leave  
801051ec:	c3                   	ret    

801051ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051ed:	55                   	push   %ebp
801051ee:	89 e5                	mov    %esp,%ebp
801051f0:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801051f3:	8b 45 08             	mov    0x8(%ebp),%eax
801051f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801051f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801051ff:	eb 2a                	jmp    8010522b <memcmp+0x3e>
    if(*s1 != *s2)
80105201:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105204:	8a 10                	mov    (%eax),%dl
80105206:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105209:	8a 00                	mov    (%eax),%al
8010520b:	38 c2                	cmp    %al,%dl
8010520d:	74 16                	je     80105225 <memcmp+0x38>
      return *s1 - *s2;
8010520f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105212:	8a 00                	mov    (%eax),%al
80105214:	0f b6 d0             	movzbl %al,%edx
80105217:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010521a:	8a 00                	mov    (%eax),%al
8010521c:	0f b6 c0             	movzbl %al,%eax
8010521f:	29 c2                	sub    %eax,%edx
80105221:	89 d0                	mov    %edx,%eax
80105223:	eb 18                	jmp    8010523d <memcmp+0x50>
    s1++, s2++;
80105225:	ff 45 fc             	incl   -0x4(%ebp)
80105228:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010522b:	8b 45 10             	mov    0x10(%ebp),%eax
8010522e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105231:	89 55 10             	mov    %edx,0x10(%ebp)
80105234:	85 c0                	test   %eax,%eax
80105236:	75 c9                	jne    80105201 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105238:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010523d:	c9                   	leave  
8010523e:	c3                   	ret    

8010523f <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010523f:	55                   	push   %ebp
80105240:	89 e5                	mov    %esp,%ebp
80105242:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105245:	8b 45 0c             	mov    0xc(%ebp),%eax
80105248:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010524b:	8b 45 08             	mov    0x8(%ebp),%eax
8010524e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105251:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105254:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105257:	73 3a                	jae    80105293 <memmove+0x54>
80105259:	8b 45 10             	mov    0x10(%ebp),%eax
8010525c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010525f:	01 d0                	add    %edx,%eax
80105261:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105264:	76 2d                	jbe    80105293 <memmove+0x54>
    s += n;
80105266:	8b 45 10             	mov    0x10(%ebp),%eax
80105269:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010526c:	8b 45 10             	mov    0x10(%ebp),%eax
8010526f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105272:	eb 10                	jmp    80105284 <memmove+0x45>
      *--d = *--s;
80105274:	ff 4d f8             	decl   -0x8(%ebp)
80105277:	ff 4d fc             	decl   -0x4(%ebp)
8010527a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010527d:	8a 10                	mov    (%eax),%dl
8010527f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105282:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105284:	8b 45 10             	mov    0x10(%ebp),%eax
80105287:	8d 50 ff             	lea    -0x1(%eax),%edx
8010528a:	89 55 10             	mov    %edx,0x10(%ebp)
8010528d:	85 c0                	test   %eax,%eax
8010528f:	75 e3                	jne    80105274 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105291:	eb 25                	jmp    801052b8 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105293:	eb 16                	jmp    801052ab <memmove+0x6c>
      *d++ = *s++;
80105295:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105298:	8d 50 01             	lea    0x1(%eax),%edx
8010529b:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010529e:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052a1:	8d 4a 01             	lea    0x1(%edx),%ecx
801052a4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801052a7:	8a 12                	mov    (%edx),%dl
801052a9:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052ab:	8b 45 10             	mov    0x10(%ebp),%eax
801052ae:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b1:	89 55 10             	mov    %edx,0x10(%ebp)
801052b4:	85 c0                	test   %eax,%eax
801052b6:	75 dd                	jne    80105295 <memmove+0x56>
      *d++ = *s++;

  return dst;
801052b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052bb:	c9                   	leave  
801052bc:	c3                   	ret    

801052bd <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052bd:	55                   	push   %ebp
801052be:	89 e5                	mov    %esp,%ebp
801052c0:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801052c3:	8b 45 10             	mov    0x10(%ebp),%eax
801052c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801052ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801052cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801052d1:	8b 45 08             	mov    0x8(%ebp),%eax
801052d4:	89 04 24             	mov    %eax,(%esp)
801052d7:	e8 63 ff ff ff       	call   8010523f <memmove>
}
801052dc:	c9                   	leave  
801052dd:	c3                   	ret    

801052de <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801052de:	55                   	push   %ebp
801052df:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801052e1:	eb 09                	jmp    801052ec <strncmp+0xe>
    n--, p++, q++;
801052e3:	ff 4d 10             	decl   0x10(%ebp)
801052e6:	ff 45 08             	incl   0x8(%ebp)
801052e9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801052ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052f0:	74 17                	je     80105309 <strncmp+0x2b>
801052f2:	8b 45 08             	mov    0x8(%ebp),%eax
801052f5:	8a 00                	mov    (%eax),%al
801052f7:	84 c0                	test   %al,%al
801052f9:	74 0e                	je     80105309 <strncmp+0x2b>
801052fb:	8b 45 08             	mov    0x8(%ebp),%eax
801052fe:	8a 10                	mov    (%eax),%dl
80105300:	8b 45 0c             	mov    0xc(%ebp),%eax
80105303:	8a 00                	mov    (%eax),%al
80105305:	38 c2                	cmp    %al,%dl
80105307:	74 da                	je     801052e3 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105309:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010530d:	75 07                	jne    80105316 <strncmp+0x38>
    return 0;
8010530f:	b8 00 00 00 00       	mov    $0x0,%eax
80105314:	eb 14                	jmp    8010532a <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
80105316:	8b 45 08             	mov    0x8(%ebp),%eax
80105319:	8a 00                	mov    (%eax),%al
8010531b:	0f b6 d0             	movzbl %al,%edx
8010531e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105321:	8a 00                	mov    (%eax),%al
80105323:	0f b6 c0             	movzbl %al,%eax
80105326:	29 c2                	sub    %eax,%edx
80105328:	89 d0                	mov    %edx,%eax
}
8010532a:	5d                   	pop    %ebp
8010532b:	c3                   	ret    

8010532c <strcpy>:

char*
strcpy(char *s, char *t)
{
8010532c:	55                   	push   %ebp
8010532d:	89 e5                	mov    %esp,%ebp
8010532f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105332:	8b 45 08             	mov    0x8(%ebp),%eax
80105335:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
80105338:	90                   	nop
80105339:	8b 45 08             	mov    0x8(%ebp),%eax
8010533c:	8d 50 01             	lea    0x1(%eax),%edx
8010533f:	89 55 08             	mov    %edx,0x8(%ebp)
80105342:	8b 55 0c             	mov    0xc(%ebp),%edx
80105345:	8d 4a 01             	lea    0x1(%edx),%ecx
80105348:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010534b:	8a 12                	mov    (%edx),%dl
8010534d:	88 10                	mov    %dl,(%eax)
8010534f:	8a 00                	mov    (%eax),%al
80105351:	84 c0                	test   %al,%al
80105353:	75 e4                	jne    80105339 <strcpy+0xd>
    ;
  return os;
80105355:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105358:	c9                   	leave  
80105359:	c3                   	ret    

8010535a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010535a:	55                   	push   %ebp
8010535b:	89 e5                	mov    %esp,%ebp
8010535d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105360:	8b 45 08             	mov    0x8(%ebp),%eax
80105363:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105366:	90                   	nop
80105367:	8b 45 10             	mov    0x10(%ebp),%eax
8010536a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010536d:	89 55 10             	mov    %edx,0x10(%ebp)
80105370:	85 c0                	test   %eax,%eax
80105372:	7e 1c                	jle    80105390 <strncpy+0x36>
80105374:	8b 45 08             	mov    0x8(%ebp),%eax
80105377:	8d 50 01             	lea    0x1(%eax),%edx
8010537a:	89 55 08             	mov    %edx,0x8(%ebp)
8010537d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105380:	8d 4a 01             	lea    0x1(%edx),%ecx
80105383:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105386:	8a 12                	mov    (%edx),%dl
80105388:	88 10                	mov    %dl,(%eax)
8010538a:	8a 00                	mov    (%eax),%al
8010538c:	84 c0                	test   %al,%al
8010538e:	75 d7                	jne    80105367 <strncpy+0xd>
    ;
  while(n-- > 0)
80105390:	eb 0c                	jmp    8010539e <strncpy+0x44>
    *s++ = 0;
80105392:	8b 45 08             	mov    0x8(%ebp),%eax
80105395:	8d 50 01             	lea    0x1(%eax),%edx
80105398:	89 55 08             	mov    %edx,0x8(%ebp)
8010539b:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010539e:	8b 45 10             	mov    0x10(%ebp),%eax
801053a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a4:	89 55 10             	mov    %edx,0x10(%ebp)
801053a7:	85 c0                	test   %eax,%eax
801053a9:	7f e7                	jg     80105392 <strncpy+0x38>
    *s++ = 0;
  return os;
801053ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053ae:	c9                   	leave  
801053af:	c3                   	ret    

801053b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801053b6:	8b 45 08             	mov    0x8(%ebp),%eax
801053b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053c0:	7f 05                	jg     801053c7 <safestrcpy+0x17>
    return os;
801053c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053c5:	eb 2e                	jmp    801053f5 <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
801053c7:	ff 4d 10             	decl   0x10(%ebp)
801053ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053ce:	7e 1c                	jle    801053ec <safestrcpy+0x3c>
801053d0:	8b 45 08             	mov    0x8(%ebp),%eax
801053d3:	8d 50 01             	lea    0x1(%eax),%edx
801053d6:	89 55 08             	mov    %edx,0x8(%ebp)
801053d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801053dc:	8d 4a 01             	lea    0x1(%edx),%ecx
801053df:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053e2:	8a 12                	mov    (%edx),%dl
801053e4:	88 10                	mov    %dl,(%eax)
801053e6:	8a 00                	mov    (%eax),%al
801053e8:	84 c0                	test   %al,%al
801053ea:	75 db                	jne    801053c7 <safestrcpy+0x17>
    ;
  *s = 0;
801053ec:	8b 45 08             	mov    0x8(%ebp),%eax
801053ef:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801053f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    

801053f7 <strlen>:

int
strlen(const char *s)
{
801053f7:	55                   	push   %ebp
801053f8:	89 e5                	mov    %esp,%ebp
801053fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801053fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105404:	eb 03                	jmp    80105409 <strlen+0x12>
80105406:	ff 45 fc             	incl   -0x4(%ebp)
80105409:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010540c:	8b 45 08             	mov    0x8(%ebp),%eax
8010540f:	01 d0                	add    %edx,%eax
80105411:	8a 00                	mov    (%eax),%al
80105413:	84 c0                	test   %al,%al
80105415:	75 ef                	jne    80105406 <strlen+0xf>
    ;
  return n;
80105417:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010541a:	c9                   	leave  
8010541b:	c3                   	ret    

8010541c <strcat>:

char*
strcat(char *dest, const char *src)
{
8010541c:	55                   	push   %ebp
8010541d:	89 e5                	mov    %esp,%ebp
8010541f:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
80105422:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105429:	eb 03                	jmp    8010542e <strcat+0x12>
8010542b:	ff 45 fc             	incl   -0x4(%ebp)
8010542e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105431:	8b 45 08             	mov    0x8(%ebp),%eax
80105434:	01 d0                	add    %edx,%eax
80105436:	8a 00                	mov    (%eax),%al
80105438:	84 c0                	test   %al,%al
8010543a:	75 ef                	jne    8010542b <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
8010543c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105443:	eb 1e                	jmp    80105463 <strcat+0x47>
        dest[i+j] = src[j];
80105445:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105448:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010544b:	01 d0                	add    %edx,%eax
8010544d:	89 c2                	mov    %eax,%edx
8010544f:	8b 45 08             	mov    0x8(%ebp),%eax
80105452:	01 c2                	add    %eax,%edx
80105454:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80105457:	8b 45 0c             	mov    0xc(%ebp),%eax
8010545a:	01 c8                	add    %ecx,%eax
8010545c:	8a 00                	mov    (%eax),%al
8010545e:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
80105460:	ff 45 f8             	incl   -0x8(%ebp)
80105463:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105466:	8b 45 0c             	mov    0xc(%ebp),%eax
80105469:	01 d0                	add    %edx,%eax
8010546b:	8a 00                	mov    (%eax),%al
8010546d:	84 c0                	test   %al,%al
8010546f:	75 d4                	jne    80105445 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
80105471:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105474:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105477:	01 d0                	add    %edx,%eax
80105479:	89 c2                	mov    %eax,%edx
8010547b:	8b 45 08             	mov    0x8(%ebp),%eax
8010547e:	01 d0                	add    %edx,%eax
80105480:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
80105483:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105486:	c9                   	leave  
80105487:	c3                   	ret    

80105488 <strchr>:

char*
strchr(const char *s, char c)
{
80105488:	55                   	push   %ebp
80105489:	89 e5                	mov    %esp,%ebp
8010548b:	83 ec 04             	sub    $0x4,%esp
8010548e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105491:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
80105494:	eb 12                	jmp    801054a8 <strchr+0x20>
    if(*s == c)
80105496:	8b 45 08             	mov    0x8(%ebp),%eax
80105499:	8a 00                	mov    (%eax),%al
8010549b:	3a 45 fc             	cmp    -0x4(%ebp),%al
8010549e:	75 05                	jne    801054a5 <strchr+0x1d>
      return (char*)s;
801054a0:	8b 45 08             	mov    0x8(%ebp),%eax
801054a3:	eb 11                	jmp    801054b6 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
801054a5:	ff 45 08             	incl   0x8(%ebp)
801054a8:	8b 45 08             	mov    0x8(%ebp),%eax
801054ab:	8a 00                	mov    (%eax),%al
801054ad:	84 c0                	test   %al,%al
801054af:	75 e5                	jne    80105496 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
801054b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054b6:	c9                   	leave  
801054b7:	c3                   	ret    

801054b8 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
801054b8:	55                   	push   %ebp
801054b9:	89 e5                	mov    %esp,%ebp
801054bb:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
801054be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
801054c5:	eb 26                	jmp    801054ed <strcspn+0x35>
        if(strchr(s2,*s1))
801054c7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ca:	8a 00                	mov    (%eax),%al
801054cc:	0f be c0             	movsbl %al,%eax
801054cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801054d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d6:	89 04 24             	mov    %eax,(%esp)
801054d9:	e8 aa ff ff ff       	call   80105488 <strchr>
801054de:	85 c0                	test   %eax,%eax
801054e0:	74 05                	je     801054e7 <strcspn+0x2f>
            return ret;
801054e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054e5:	eb 12                	jmp    801054f9 <strcspn+0x41>
        else
            s1++,ret++;
801054e7:	ff 45 08             	incl   0x8(%ebp)
801054ea:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
801054ed:	8b 45 08             	mov    0x8(%ebp),%eax
801054f0:	8a 00                	mov    (%eax),%al
801054f2:	84 c0                	test   %al,%al
801054f4:	75 d1                	jne    801054c7 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
801054f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054f9:	c9                   	leave  
801054fa:	c3                   	ret    

801054fb <strtok>:

char*
strtok(char *s, const char *delim)
{
801054fb:	55                   	push   %ebp
801054fc:	89 e5                	mov    %esp,%ebp
801054fe:	53                   	push   %ebx
801054ff:	83 ec 08             	sub    $0x8,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
80105502:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105506:	75 08                	jne    80105510 <strtok+0x15>
  s = lasts;
80105508:	a1 84 c6 10 80       	mov    0x8010c684,%eax
8010550d:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
80105510:	8b 45 08             	mov    0x8(%ebp),%eax
80105513:	8d 50 01             	lea    0x1(%eax),%edx
80105516:	89 55 08             	mov    %edx,0x8(%ebp)
80105519:	8a 00                	mov    (%eax),%al
8010551b:	0f be d8             	movsbl %al,%ebx
8010551e:	85 db                	test   %ebx,%ebx
80105520:	75 07                	jne    80105529 <strtok+0x2e>
      return 0;
80105522:	b8 00 00 00 00       	mov    $0x0,%eax
80105527:	eb 58                	jmp    80105581 <strtok+0x86>
    } while (strchr(delim, ch));
80105529:	88 d8                	mov    %bl,%al
8010552b:	0f be c0             	movsbl %al,%eax
8010552e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105532:	8b 45 0c             	mov    0xc(%ebp),%eax
80105535:	89 04 24             	mov    %eax,(%esp)
80105538:	e8 4b ff ff ff       	call   80105488 <strchr>
8010553d:	85 c0                	test   %eax,%eax
8010553f:	75 cf                	jne    80105510 <strtok+0x15>
    --s;
80105541:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
80105544:	8b 45 0c             	mov    0xc(%ebp),%eax
80105547:	89 44 24 04          	mov    %eax,0x4(%esp)
8010554b:	8b 45 08             	mov    0x8(%ebp),%eax
8010554e:	89 04 24             	mov    %eax,(%esp)
80105551:	e8 62 ff ff ff       	call   801054b8 <strcspn>
80105556:	89 c2                	mov    %eax,%edx
80105558:	8b 45 08             	mov    0x8(%ebp),%eax
8010555b:	01 d0                	add    %edx,%eax
8010555d:	a3 84 c6 10 80       	mov    %eax,0x8010c684
    if (*lasts != 0)
80105562:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80105567:	8a 00                	mov    (%eax),%al
80105569:	84 c0                	test   %al,%al
8010556b:	74 11                	je     8010557e <strtok+0x83>
  *lasts++ = 0;
8010556d:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80105572:	8d 50 01             	lea    0x1(%eax),%edx
80105575:	89 15 84 c6 10 80    	mov    %edx,0x8010c684
8010557b:	c6 00 00             	movb   $0x0,(%eax)
    return s;
8010557e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105581:	83 c4 08             	add    $0x8,%esp
80105584:	5b                   	pop    %ebx
80105585:	5d                   	pop    %ebp
80105586:	c3                   	ret    

80105587 <itoa>:

char* itoa(int num, char* str, int base)
{
80105587:	55                   	push   %ebp
80105588:	89 e5                	mov    %esp,%ebp
8010558a:	83 ec 10             	sub    $0x10,%esp
    char temp;
    int rem, i = 0, j = 0;
8010558d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 
    if (num == 0)
8010559b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010559f:	75 26                	jne    801055c7 <itoa+0x40>
    {
        str[i++] = '0';
801055a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055a4:	8d 50 01             	lea    0x1(%eax),%edx
801055a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
801055aa:	89 c2                	mov    %eax,%edx
801055ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801055af:	01 d0                	add    %edx,%eax
801055b1:	c6 00 30             	movb   $0x30,(%eax)
        str[i] = '\0';
801055b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
801055b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ba:	01 d0                	add    %edx,%eax
801055bc:	c6 00 00             	movb   $0x0,(%eax)
        return str;
801055bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c2:	e9 ab 00 00 00       	jmp    80105672 <itoa+0xeb>
    }
 
    while (num != 0)
801055c7:	eb 36                	jmp    801055ff <itoa+0x78>
    {
        rem = num % base;
801055c9:	8b 45 08             	mov    0x8(%ebp),%eax
801055cc:	99                   	cltd   
801055cd:	f7 7d 10             	idivl  0x10(%ebp)
801055d0:	89 55 fc             	mov    %edx,-0x4(%ebp)
        if(rem > 9)
801055d3:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
801055d7:	7e 04                	jle    801055dd <itoa+0x56>
        {
            rem = rem - 10;
801055d9:	83 6d fc 0a          	subl   $0xa,-0x4(%ebp)
        }
        /* Add the digit as a string */
        str[i++] = rem + '0';
801055dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055e0:	8d 50 01             	lea    0x1(%eax),%edx
801055e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
801055e6:	89 c2                	mov    %eax,%edx
801055e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801055eb:	01 c2                	add    %eax,%edx
801055ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055f0:	83 c0 30             	add    $0x30,%eax
801055f3:	88 02                	mov    %al,(%edx)
        num = num/base;
801055f5:	8b 45 08             	mov    0x8(%ebp),%eax
801055f8:	99                   	cltd   
801055f9:	f7 7d 10             	idivl  0x10(%ebp)
801055fc:	89 45 08             	mov    %eax,0x8(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
 
    while (num != 0)
801055ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105603:	75 c4                	jne    801055c9 <itoa+0x42>
        /* Add the digit as a string */
        str[i++] = rem + '0';
        num = num/base;
    }

    str[i] = '\0';
80105605:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105608:	8b 45 0c             	mov    0xc(%ebp),%eax
8010560b:	01 d0                	add    %edx,%eax
8010560d:	c6 00 00             	movb   $0x0,(%eax)

    for(j = 0; j < i / 2; j++)
80105610:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105617:	eb 45                	jmp    8010565e <itoa+0xd7>
    {
        temp = str[j];
80105619:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010561c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010561f:	01 d0                	add    %edx,%eax
80105621:	8a 00                	mov    (%eax),%al
80105623:	88 45 f3             	mov    %al,-0xd(%ebp)
        str[j] = str[i - j - 1];
80105626:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105629:	8b 45 0c             	mov    0xc(%ebp),%eax
8010562c:	01 c2                	add    %eax,%edx
8010562e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105631:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80105634:	29 c1                	sub    %eax,%ecx
80105636:	89 c8                	mov    %ecx,%eax
80105638:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010563b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010563e:	01 c8                	add    %ecx,%eax
80105640:	8a 00                	mov    (%eax),%al
80105642:	88 02                	mov    %al,(%edx)
        str[i - j - 1] = temp;
80105644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105647:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010564a:	29 c2                	sub    %eax,%edx
8010564c:	89 d0                	mov    %edx,%eax
8010564e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105651:	8b 45 0c             	mov    0xc(%ebp),%eax
80105654:	01 c2                	add    %eax,%edx
80105656:	8a 45 f3             	mov    -0xd(%ebp),%al
80105659:	88 02                	mov    %al,(%edx)
        num = num/base;
    }

    str[i] = '\0';

    for(j = 0; j < i / 2; j++)
8010565b:	ff 45 f4             	incl   -0xc(%ebp)
8010565e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105661:	89 c2                	mov    %eax,%edx
80105663:	c1 ea 1f             	shr    $0x1f,%edx
80105666:	01 d0                	add    %edx,%eax
80105668:	d1 f8                	sar    %eax
8010566a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010566d:	7f aa                	jg     80105619 <itoa+0x92>
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
 
    return str;
8010566f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
80105672:	c9                   	leave  
80105673:	c3                   	ret    

80105674 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105674:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105678:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010567c:	55                   	push   %ebp
  pushl %ebx
8010567d:	53                   	push   %ebx
  pushl %esi
8010567e:	56                   	push   %esi
  pushl %edi
8010567f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105680:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105682:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105684:	5f                   	pop    %edi
  popl %esi
80105685:	5e                   	pop    %esi
  popl %ebx
80105686:	5b                   	pop    %ebx
  popl %ebp
80105687:	5d                   	pop    %ebp
  ret
80105688:	c3                   	ret    
80105689:	00 00                	add    %al,(%eax)
	...

8010568c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010568c:	55                   	push   %ebp
8010568d:	89 e5                	mov    %esp,%ebp
8010568f:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105692:	e8 6c ec ff ff       	call   80104303 <myproc>
80105697:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010569a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569d:	8b 00                	mov    (%eax),%eax
8010569f:	3b 45 08             	cmp    0x8(%ebp),%eax
801056a2:	76 0f                	jbe    801056b3 <fetchint+0x27>
801056a4:	8b 45 08             	mov    0x8(%ebp),%eax
801056a7:	8d 50 04             	lea    0x4(%eax),%edx
801056aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ad:	8b 00                	mov    (%eax),%eax
801056af:	39 c2                	cmp    %eax,%edx
801056b1:	76 07                	jbe    801056ba <fetchint+0x2e>
    return -1;
801056b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b8:	eb 0f                	jmp    801056c9 <fetchint+0x3d>
  *ip = *(int*)(addr);
801056ba:	8b 45 08             	mov    0x8(%ebp),%eax
801056bd:	8b 10                	mov    (%eax),%edx
801056bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c2:	89 10                	mov    %edx,(%eax)
  return 0;
801056c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056c9:	c9                   	leave  
801056ca:	c3                   	ret    

801056cb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801056cb:	55                   	push   %ebp
801056cc:	89 e5                	mov    %esp,%ebp
801056ce:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801056d1:	e8 2d ec ff ff       	call   80104303 <myproc>
801056d6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801056d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056dc:	8b 00                	mov    (%eax),%eax
801056de:	3b 45 08             	cmp    0x8(%ebp),%eax
801056e1:	77 07                	ja     801056ea <fetchstr+0x1f>
    return -1;
801056e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e8:	eb 41                	jmp    8010572b <fetchstr+0x60>
  *pp = (char*)addr;
801056ea:	8b 55 08             	mov    0x8(%ebp),%edx
801056ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f0:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801056f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f5:	8b 00                	mov    (%eax),%eax
801056f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801056fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fd:	8b 00                	mov    (%eax),%eax
801056ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105702:	eb 1a                	jmp    8010571e <fetchstr+0x53>
    if(*s == 0)
80105704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105707:	8a 00                	mov    (%eax),%al
80105709:	84 c0                	test   %al,%al
8010570b:	75 0e                	jne    8010571b <fetchstr+0x50>
      return s - *pp;
8010570d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105710:	8b 45 0c             	mov    0xc(%ebp),%eax
80105713:	8b 00                	mov    (%eax),%eax
80105715:	29 c2                	sub    %eax,%edx
80105717:	89 d0                	mov    %edx,%eax
80105719:	eb 10                	jmp    8010572b <fetchstr+0x60>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010571b:	ff 45 f4             	incl   -0xc(%ebp)
8010571e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105721:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105724:	72 de                	jb     80105704 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80105726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572b:	c9                   	leave  
8010572c:	c3                   	ret    

8010572d <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010572d:	55                   	push   %ebp
8010572e:	89 e5                	mov    %esp,%ebp
80105730:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105733:	e8 cb eb ff ff       	call   80104303 <myproc>
80105738:	8b 40 18             	mov    0x18(%eax),%eax
8010573b:	8b 50 44             	mov    0x44(%eax),%edx
8010573e:	8b 45 08             	mov    0x8(%ebp),%eax
80105741:	c1 e0 02             	shl    $0x2,%eax
80105744:	01 d0                	add    %edx,%eax
80105746:	8d 50 04             	lea    0x4(%eax),%edx
80105749:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105750:	89 14 24             	mov    %edx,(%esp)
80105753:	e8 34 ff ff ff       	call   8010568c <fetchint>
}
80105758:	c9                   	leave  
80105759:	c3                   	ret    

8010575a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010575a:	55                   	push   %ebp
8010575b:	89 e5                	mov    %esp,%ebp
8010575d:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
80105760:	e8 9e eb ff ff       	call   80104303 <myproc>
80105765:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105768:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010576b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576f:	8b 45 08             	mov    0x8(%ebp),%eax
80105772:	89 04 24             	mov    %eax,(%esp)
80105775:	e8 b3 ff ff ff       	call   8010572d <argint>
8010577a:	85 c0                	test   %eax,%eax
8010577c:	79 07                	jns    80105785 <argptr+0x2b>
    return -1;
8010577e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105783:	eb 3d                	jmp    801057c2 <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105789:	78 21                	js     801057ac <argptr+0x52>
8010578b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010578e:	89 c2                	mov    %eax,%edx
80105790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105793:	8b 00                	mov    (%eax),%eax
80105795:	39 c2                	cmp    %eax,%edx
80105797:	73 13                	jae    801057ac <argptr+0x52>
80105799:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010579c:	89 c2                	mov    %eax,%edx
8010579e:	8b 45 10             	mov    0x10(%ebp),%eax
801057a1:	01 c2                	add    %eax,%edx
801057a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a6:	8b 00                	mov    (%eax),%eax
801057a8:	39 c2                	cmp    %eax,%edx
801057aa:	76 07                	jbe    801057b3 <argptr+0x59>
    return -1;
801057ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b1:	eb 0f                	jmp    801057c2 <argptr+0x68>
  *pp = (char*)i;
801057b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b6:	89 c2                	mov    %eax,%edx
801057b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801057bb:	89 10                	mov    %edx,(%eax)
  return 0;
801057bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057c2:	c9                   	leave  
801057c3:	c3                   	ret    

801057c4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801057ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801057d1:	8b 45 08             	mov    0x8(%ebp),%eax
801057d4:	89 04 24             	mov    %eax,(%esp)
801057d7:	e8 51 ff ff ff       	call   8010572d <argint>
801057dc:	85 c0                	test   %eax,%eax
801057de:	79 07                	jns    801057e7 <argstr+0x23>
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e5:	eb 12                	jmp    801057f9 <argstr+0x35>
  return fetchstr(addr, pp);
801057e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ea:	8b 55 0c             	mov    0xc(%ebp),%edx
801057ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801057f1:	89 04 24             	mov    %eax,(%esp)
801057f4:	e8 d2 fe ff ff       	call   801056cb <fetchstr>
}
801057f9:	c9                   	leave  
801057fa:	c3                   	ret    

801057fb <syscall>:
[SYS_setpath]    sys_setpath,
};

void
syscall(void)
{
801057fb:	55                   	push   %ebp
801057fc:	89 e5                	mov    %esp,%ebp
801057fe:	53                   	push   %ebx
801057ff:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
80105802:	e8 fc ea ff ff       	call   80104303 <myproc>
80105807:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010580a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580d:	8b 40 18             	mov    0x18(%eax),%eax
80105810:	8b 40 1c             	mov    0x1c(%eax),%eax
80105813:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010581a:	7e 2d                	jle    80105849 <syscall+0x4e>
8010581c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581f:	83 f8 2c             	cmp    $0x2c,%eax
80105822:	77 25                	ja     80105849 <syscall+0x4e>
80105824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105827:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
8010582e:	85 c0                	test   %eax,%eax
80105830:	74 17                	je     80105849 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
80105832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105835:	8b 58 18             	mov    0x18(%eax),%ebx
80105838:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010583b:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105842:	ff d0                	call   *%eax
80105844:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105847:	eb 34                	jmp    8010587d <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584c:	8d 48 6c             	lea    0x6c(%eax),%ecx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010584f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105852:	8b 40 10             	mov    0x10(%eax),%eax
80105855:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105858:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010585c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105860:	89 44 24 04          	mov    %eax,0x4(%esp)
80105864:	c7 04 24 48 99 10 80 	movl   $0x80109948,(%esp)
8010586b:	e8 51 ab ff ff       	call   801003c1 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105873:	8b 40 18             	mov    0x18(%eax),%eax
80105876:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010587d:	83 c4 24             	add    $0x24,%esp
80105880:	5b                   	pop    %ebx
80105881:	5d                   	pop    %ebp
80105882:	c3                   	ret    
	...

80105884 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010588a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010588d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105891:	8b 45 08             	mov    0x8(%ebp),%eax
80105894:	89 04 24             	mov    %eax,(%esp)
80105897:	e8 91 fe ff ff       	call   8010572d <argint>
8010589c:	85 c0                	test   %eax,%eax
8010589e:	79 07                	jns    801058a7 <argfd+0x23>
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a5:	eb 4f                	jmp    801058f6 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058aa:	85 c0                	test   %eax,%eax
801058ac:	78 20                	js     801058ce <argfd+0x4a>
801058ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b1:	83 f8 0f             	cmp    $0xf,%eax
801058b4:	7f 18                	jg     801058ce <argfd+0x4a>
801058b6:	e8 48 ea ff ff       	call   80104303 <myproc>
801058bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058be:	83 c2 08             	add    $0x8,%edx
801058c1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801058c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058cc:	75 07                	jne    801058d5 <argfd+0x51>
    return -1;
801058ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d3:	eb 21                	jmp    801058f6 <argfd+0x72>
  if(pfd)
801058d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801058d9:	74 08                	je     801058e3 <argfd+0x5f>
    *pfd = fd;
801058db:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058de:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e1:	89 10                	mov    %edx,(%eax)
  if(pf)
801058e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058e7:	74 08                	je     801058f1 <argfd+0x6d>
    *pf = f;
801058e9:	8b 45 10             	mov    0x10(%ebp),%eax
801058ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ef:	89 10                	mov    %edx,(%eax)
  return 0;
801058f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058f6:	c9                   	leave  
801058f7:	c3                   	ret    

801058f8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801058f8:	55                   	push   %ebp
801058f9:	89 e5                	mov    %esp,%ebp
801058fb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801058fe:	e8 00 ea ff ff       	call   80104303 <myproc>
80105903:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105906:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010590d:	eb 29                	jmp    80105938 <fdalloc+0x40>
    if(curproc->ofile[fd] == 0){
8010590f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105912:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105915:	83 c2 08             	add    $0x8,%edx
80105918:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010591c:	85 c0                	test   %eax,%eax
8010591e:	75 15                	jne    80105935 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105920:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105923:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105926:	8d 4a 08             	lea    0x8(%edx),%ecx
80105929:	8b 55 08             	mov    0x8(%ebp),%edx
8010592c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105933:	eb 0e                	jmp    80105943 <fdalloc+0x4b>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105935:	ff 45 f4             	incl   -0xc(%ebp)
80105938:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010593c:	7e d1                	jle    8010590f <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010593e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105943:	c9                   	leave  
80105944:	c3                   	ret    

80105945 <sys_dup>:

int
sys_dup(void)
{
80105945:	55                   	push   %ebp
80105946:	89 e5                	mov    %esp,%ebp
80105948:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010594b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010594e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105952:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105959:	00 
8010595a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105961:	e8 1e ff ff ff       	call   80105884 <argfd>
80105966:	85 c0                	test   %eax,%eax
80105968:	79 07                	jns    80105971 <sys_dup+0x2c>
    return -1;
8010596a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596f:	eb 29                	jmp    8010599a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105971:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105974:	89 04 24             	mov    %eax,(%esp)
80105977:	e8 7c ff ff ff       	call   801058f8 <fdalloc>
8010597c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010597f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105983:	79 07                	jns    8010598c <sys_dup+0x47>
    return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598a:	eb 0e                	jmp    8010599a <sys_dup+0x55>
  filedup(f);
8010598c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598f:	89 04 24             	mov    %eax,(%esp)
80105992:	e8 19 b8 ff ff       	call   801011b0 <filedup>
  return fd;
80105997:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010599a:	c9                   	leave  
8010599b:	c3                   	ret    

8010599c <sys_read>:

int
sys_read(void)
{
8010599c:	55                   	push   %ebp
8010599d:	89 e5                	mov    %esp,%ebp
8010599f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801059a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059b0:	00 
801059b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059b8:	e8 c7 fe ff ff       	call   80105884 <argfd>
801059bd:	85 c0                	test   %eax,%eax
801059bf:	78 35                	js     801059f6 <sys_read+0x5a>
801059c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801059cf:	e8 59 fd ff ff       	call   8010572d <argint>
801059d4:	85 c0                	test   %eax,%eax
801059d6:	78 1e                	js     801059f6 <sys_read+0x5a>
801059d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059db:	89 44 24 08          	mov    %eax,0x8(%esp)
801059df:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801059e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059ed:	e8 68 fd ff ff       	call   8010575a <argptr>
801059f2:	85 c0                	test   %eax,%eax
801059f4:	79 07                	jns    801059fd <sys_read+0x61>
    return -1;
801059f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fb:	eb 19                	jmp    80105a16 <sys_read+0x7a>
  return fileread(f, p, n);
801059fd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a00:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a06:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a0a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a0e:	89 04 24             	mov    %eax,(%esp)
80105a11:	e8 fb b8 ff ff       	call   80101311 <fileread>
}
80105a16:	c9                   	leave  
80105a17:	c3                   	ret    

80105a18 <sys_write>:

int
sys_write(void)
{
80105a18:	55                   	push   %ebp
80105a19:	89 e5                	mov    %esp,%ebp
80105a1b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a21:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a2c:	00 
80105a2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a34:	e8 4b fe ff ff       	call   80105884 <argfd>
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	78 35                	js     80105a72 <sys_write+0x5a>
80105a3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a40:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a44:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105a4b:	e8 dd fc ff ff       	call   8010572d <argint>
80105a50:	85 c0                	test   %eax,%eax
80105a52:	78 1e                	js     80105a72 <sys_write+0x5a>
80105a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a57:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a69:	e8 ec fc ff ff       	call   8010575a <argptr>
80105a6e:	85 c0                	test   %eax,%eax
80105a70:	79 07                	jns    80105a79 <sys_write+0x61>
    return -1;
80105a72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a77:	eb 19                	jmp    80105a92 <sys_write+0x7a>
  return filewrite(f, p, n);
80105a79:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a86:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a8a:	89 04 24             	mov    %eax,(%esp)
80105a8d:	e8 3a b9 ff ff       	call   801013cc <filewrite>
}
80105a92:	c9                   	leave  
80105a93:	c3                   	ret    

80105a94 <sys_close>:

int
sys_close(void)
{
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105a9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a9d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aa8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105aaf:	e8 d0 fd ff ff       	call   80105884 <argfd>
80105ab4:	85 c0                	test   %eax,%eax
80105ab6:	79 07                	jns    80105abf <sys_close+0x2b>
    return -1;
80105ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abd:	eb 23                	jmp    80105ae2 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
80105abf:	e8 3f e8 ff ff       	call   80104303 <myproc>
80105ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ac7:	83 c2 08             	add    $0x8,%edx
80105aca:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105ad1:	00 
  fileclose(f);
80105ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad5:	89 04 24             	mov    %eax,(%esp)
80105ad8:	e8 1b b7 ff ff       	call   801011f8 <fileclose>
  return 0;
80105add:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ae2:	c9                   	leave  
80105ae3:	c3                   	ret    

80105ae4 <sys_fstat>:

int
sys_fstat(void)
{
80105ae4:	55                   	push   %ebp
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105aea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aed:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105af8:	00 
80105af9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b00:	e8 7f fd ff ff       	call   80105884 <argfd>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 1f                	js     80105b28 <sys_fstat+0x44>
80105b09:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105b10:	00 
80105b11:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b14:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b1f:	e8 36 fc ff ff       	call   8010575a <argptr>
80105b24:	85 c0                	test   %eax,%eax
80105b26:	79 07                	jns    80105b2f <sys_fstat+0x4b>
    return -1;
80105b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2d:	eb 12                	jmp    80105b41 <sys_fstat+0x5d>
  return filestat(f, st);
80105b2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b35:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b39:	89 04 24             	mov    %eax,(%esp)
80105b3c:	e8 81 b7 ff ff       	call   801012c2 <filestat>
}
80105b41:	c9                   	leave  
80105b42:	c3                   	ret    

80105b43 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b43:	55                   	push   %ebp
80105b44:	89 e5                	mov    %esp,%ebp
80105b46:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b49:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b57:	e8 68 fc ff ff       	call   801057c4 <argstr>
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	78 17                	js     80105b77 <sys_link+0x34>
80105b60:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b6e:	e8 51 fc ff ff       	call   801057c4 <argstr>
80105b73:	85 c0                	test   %eax,%eax
80105b75:	79 0a                	jns    80105b81 <sys_link+0x3e>
    return -1;
80105b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7c:	e9 3d 01 00 00       	jmp    80105cbe <sys_link+0x17b>

  begin_op();
80105b81:	e8 85 da ff ff       	call   8010360b <begin_op>
  if((ip = namei(old)) == 0){
80105b86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105b89:	89 04 24             	mov    %eax,(%esp)
80105b8c:	e8 a6 ca ff ff       	call   80102637 <namei>
80105b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b98:	75 0f                	jne    80105ba9 <sys_link+0x66>
    end_op();
80105b9a:	e8 ee da ff ff       	call   8010368d <end_op>
    return -1;
80105b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba4:	e9 15 01 00 00       	jmp    80105cbe <sys_link+0x17b>
  }

  ilock(ip);
80105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bac:	89 04 24             	mov    %eax,(%esp)
80105baf:	e8 5e bf ff ff       	call   80101b12 <ilock>
  if(ip->type == T_DIR){
80105bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb7:	8b 40 50             	mov    0x50(%eax),%eax
80105bba:	66 83 f8 01          	cmp    $0x1,%ax
80105bbe:	75 1a                	jne    80105bda <sys_link+0x97>
    iunlockput(ip);
80105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc3:	89 04 24             	mov    %eax,(%esp)
80105bc6:	e8 46 c1 ff ff       	call   80101d11 <iunlockput>
    end_op();
80105bcb:	e8 bd da ff ff       	call   8010368d <end_op>
    return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd5:	e9 e4 00 00 00       	jmp    80105cbe <sys_link+0x17b>
  }

  ip->nlink++;
80105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdd:	66 8b 40 56          	mov    0x56(%eax),%ax
80105be1:	40                   	inc    %eax
80105be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105be5:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bec:	89 04 24             	mov    %eax,(%esp)
80105bef:	e8 5b bd ff ff       	call   8010194f <iupdate>
  iunlock(ip);
80105bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf7:	89 04 24             	mov    %eax,(%esp)
80105bfa:	e8 1d c0 ff ff       	call   80101c1c <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c02:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105c05:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c09:	89 04 24             	mov    %eax,(%esp)
80105c0c:	e8 48 ca ff ff       	call   80102659 <nameiparent>
80105c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c18:	75 02                	jne    80105c1c <sys_link+0xd9>
    goto bad;
80105c1a:	eb 68                	jmp    80105c84 <sys_link+0x141>
  ilock(dp);
80105c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1f:	89 04 24             	mov    %eax,(%esp)
80105c22:	e8 eb be ff ff       	call   80101b12 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2a:	8b 10                	mov    (%eax),%edx
80105c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2f:	8b 00                	mov    (%eax),%eax
80105c31:	39 c2                	cmp    %eax,%edx
80105c33:	75 20                	jne    80105c55 <sys_link+0x112>
80105c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c38:	8b 40 04             	mov    0x4(%eax),%eax
80105c3b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c3f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105c42:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c49:	89 04 24             	mov    %eax,(%esp)
80105c4c:	e8 33 c7 ff ff       	call   80102384 <dirlink>
80105c51:	85 c0                	test   %eax,%eax
80105c53:	79 0d                	jns    80105c62 <sys_link+0x11f>
    iunlockput(dp);
80105c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c58:	89 04 24             	mov    %eax,(%esp)
80105c5b:	e8 b1 c0 ff ff       	call   80101d11 <iunlockput>
    goto bad;
80105c60:	eb 22                	jmp    80105c84 <sys_link+0x141>
  }
  iunlockput(dp);
80105c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c65:	89 04 24             	mov    %eax,(%esp)
80105c68:	e8 a4 c0 ff ff       	call   80101d11 <iunlockput>
  iput(ip);
80105c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c70:	89 04 24             	mov    %eax,(%esp)
80105c73:	e8 e8 bf ff ff       	call   80101c60 <iput>

  end_op();
80105c78:	e8 10 da ff ff       	call   8010368d <end_op>

  return 0;
80105c7d:	b8 00 00 00 00       	mov    $0x0,%eax
80105c82:	eb 3a                	jmp    80105cbe <sys_link+0x17b>

bad:
  ilock(ip);
80105c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c87:	89 04 24             	mov    %eax,(%esp)
80105c8a:	e8 83 be ff ff       	call   80101b12 <ilock>
  ip->nlink--;
80105c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c92:	66 8b 40 56          	mov    0x56(%eax),%ax
80105c96:	48                   	dec    %eax
80105c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c9a:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca1:	89 04 24             	mov    %eax,(%esp)
80105ca4:	e8 a6 bc ff ff       	call   8010194f <iupdate>
  iunlockput(ip);
80105ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cac:	89 04 24             	mov    %eax,(%esp)
80105caf:	e8 5d c0 ff ff       	call   80101d11 <iunlockput>
  end_op();
80105cb4:	e8 d4 d9 ff ff       	call   8010368d <end_op>
  return -1;
80105cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cbe:	c9                   	leave  
80105cbf:	c3                   	ret    

80105cc0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cc6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ccd:	eb 4a                	jmp    80105d19 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105cd9:	00 
80105cda:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cde:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce8:	89 04 24             	mov    %eax,(%esp)
80105ceb:	e8 b9 c2 ff ff       	call   80101fa9 <readi>
80105cf0:	83 f8 10             	cmp    $0x10,%eax
80105cf3:	74 0c                	je     80105d01 <isdirempty+0x41>
      panic("isdirempty: readi");
80105cf5:	c7 04 24 64 99 10 80 	movl   $0x80109964,(%esp)
80105cfc:	e8 53 a8 ff ff       	call   80100554 <panic>
    if(de.inum != 0)
80105d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d04:	66 85 c0             	test   %ax,%ax
80105d07:	74 07                	je     80105d10 <isdirempty+0x50>
      return 0;
80105d09:	b8 00 00 00 00       	mov    $0x0,%eax
80105d0e:	eb 1b                	jmp    80105d2b <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d13:	83 c0 10             	add    $0x10,%eax
80105d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80105d1f:	8b 40 58             	mov    0x58(%eax),%eax
80105d22:	39 c2                	cmp    %eax,%edx
80105d24:	72 a9                	jb     80105ccf <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105d26:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d2b:	c9                   	leave  
80105d2c:	c3                   	ret    

80105d2d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d2d:	55                   	push   %ebp
80105d2e:	89 e5                	mov    %esp,%ebp
80105d30:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d33:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105d36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d41:	e8 7e fa ff ff       	call   801057c4 <argstr>
80105d46:	85 c0                	test   %eax,%eax
80105d48:	79 0a                	jns    80105d54 <sys_unlink+0x27>
    return -1;
80105d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4f:	e9 a9 01 00 00       	jmp    80105efd <sys_unlink+0x1d0>

  begin_op();
80105d54:	e8 b2 d8 ff ff       	call   8010360b <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105d59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105d5c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105d5f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d63:	89 04 24             	mov    %eax,(%esp)
80105d66:	e8 ee c8 ff ff       	call   80102659 <nameiparent>
80105d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d72:	75 0f                	jne    80105d83 <sys_unlink+0x56>
    end_op();
80105d74:	e8 14 d9 ff ff       	call   8010368d <end_op>
    return -1;
80105d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7e:	e9 7a 01 00 00       	jmp    80105efd <sys_unlink+0x1d0>
  }

  ilock(dp);
80105d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d86:	89 04 24             	mov    %eax,(%esp)
80105d89:	e8 84 bd ff ff       	call   80101b12 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d8e:	c7 44 24 04 76 99 10 	movl   $0x80109976,0x4(%esp)
80105d95:	80 
80105d96:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d99:	89 04 24             	mov    %eax,(%esp)
80105d9c:	e8 fb c4 ff ff       	call   8010229c <namecmp>
80105da1:	85 c0                	test   %eax,%eax
80105da3:	0f 84 3f 01 00 00    	je     80105ee8 <sys_unlink+0x1bb>
80105da9:	c7 44 24 04 78 99 10 	movl   $0x80109978,0x4(%esp)
80105db0:	80 
80105db1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105db4:	89 04 24             	mov    %eax,(%esp)
80105db7:	e8 e0 c4 ff ff       	call   8010229c <namecmp>
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	0f 84 24 01 00 00    	je     80105ee8 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105dc4:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105dc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dcb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105dce:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd5:	89 04 24             	mov    %eax,(%esp)
80105dd8:	e8 e1 c4 ff ff       	call   801022be <dirlookup>
80105ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105de0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105de4:	75 05                	jne    80105deb <sys_unlink+0xbe>
    goto bad;
80105de6:	e9 fd 00 00 00       	jmp    80105ee8 <sys_unlink+0x1bb>
  ilock(ip);
80105deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dee:	89 04 24             	mov    %eax,(%esp)
80105df1:	e8 1c bd ff ff       	call   80101b12 <ilock>

  if(ip->nlink < 1)
80105df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df9:	66 8b 40 56          	mov    0x56(%eax),%ax
80105dfd:	66 85 c0             	test   %ax,%ax
80105e00:	7f 0c                	jg     80105e0e <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105e02:	c7 04 24 7b 99 10 80 	movl   $0x8010997b,(%esp)
80105e09:	e8 46 a7 ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e11:	8b 40 50             	mov    0x50(%eax),%eax
80105e14:	66 83 f8 01          	cmp    $0x1,%ax
80105e18:	75 1f                	jne    80105e39 <sys_unlink+0x10c>
80105e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1d:	89 04 24             	mov    %eax,(%esp)
80105e20:	e8 9b fe ff ff       	call   80105cc0 <isdirempty>
80105e25:	85 c0                	test   %eax,%eax
80105e27:	75 10                	jne    80105e39 <sys_unlink+0x10c>
    iunlockput(ip);
80105e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2c:	89 04 24             	mov    %eax,(%esp)
80105e2f:	e8 dd be ff ff       	call   80101d11 <iunlockput>
    goto bad;
80105e34:	e9 af 00 00 00       	jmp    80105ee8 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105e39:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105e40:	00 
80105e41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e48:	00 
80105e49:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e4c:	89 04 24             	mov    %eax,(%esp)
80105e4f:	e8 22 f3 ff ff       	call   80105176 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e54:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105e57:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e5e:	00 
80105e5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e63:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6d:	89 04 24             	mov    %eax,(%esp)
80105e70:	e8 98 c2 ff ff       	call   8010210d <writei>
80105e75:	83 f8 10             	cmp    $0x10,%eax
80105e78:	74 0c                	je     80105e86 <sys_unlink+0x159>
    panic("unlink: writei");
80105e7a:	c7 04 24 8d 99 10 80 	movl   $0x8010998d,(%esp)
80105e81:	e8 ce a6 ff ff       	call   80100554 <panic>
  if(ip->type == T_DIR){
80105e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e89:	8b 40 50             	mov    0x50(%eax),%eax
80105e8c:	66 83 f8 01          	cmp    $0x1,%ax
80105e90:	75 1a                	jne    80105eac <sys_unlink+0x17f>
    dp->nlink--;
80105e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e95:	66 8b 40 56          	mov    0x56(%eax),%ax
80105e99:	48                   	dec    %eax
80105e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e9d:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80105ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea4:	89 04 24             	mov    %eax,(%esp)
80105ea7:	e8 a3 ba ff ff       	call   8010194f <iupdate>
  }
  iunlockput(dp);
80105eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eaf:	89 04 24             	mov    %eax,(%esp)
80105eb2:	e8 5a be ff ff       	call   80101d11 <iunlockput>

  ip->nlink--;
80105eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eba:	66 8b 40 56          	mov    0x56(%eax),%ax
80105ebe:	48                   	dec    %eax
80105ebf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ec2:	66 89 42 56          	mov    %ax,0x56(%edx)
  iupdate(ip);
80105ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec9:	89 04 24             	mov    %eax,(%esp)
80105ecc:	e8 7e ba ff ff       	call   8010194f <iupdate>
  iunlockput(ip);
80105ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed4:	89 04 24             	mov    %eax,(%esp)
80105ed7:	e8 35 be ff ff       	call   80101d11 <iunlockput>

  end_op();
80105edc:	e8 ac d7 ff ff       	call   8010368d <end_op>

  return 0;
80105ee1:	b8 00 00 00 00       	mov    $0x0,%eax
80105ee6:	eb 15                	jmp    80105efd <sys_unlink+0x1d0>

bad:
  iunlockput(dp);
80105ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eeb:	89 04 24             	mov    %eax,(%esp)
80105eee:	e8 1e be ff ff       	call   80101d11 <iunlockput>
  end_op();
80105ef3:	e8 95 d7 ff ff       	call   8010368d <end_op>
  return -1;
80105ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105efd:	c9                   	leave  
80105efe:	c3                   	ret    

80105eff <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105eff:	55                   	push   %ebp
80105f00:	89 e5                	mov    %esp,%ebp
80105f02:	83 ec 48             	sub    $0x48,%esp
80105f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105f08:	8b 55 10             	mov    0x10(%ebp),%edx
80105f0b:	8b 45 14             	mov    0x14(%ebp),%eax
80105f0e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105f12:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105f16:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105f1a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f21:	8b 45 08             	mov    0x8(%ebp),%eax
80105f24:	89 04 24             	mov    %eax,(%esp)
80105f27:	e8 2d c7 ff ff       	call   80102659 <nameiparent>
80105f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f33:	75 0a                	jne    80105f3f <create+0x40>
    return 0;
80105f35:	b8 00 00 00 00       	mov    $0x0,%eax
80105f3a:	e9 79 01 00 00       	jmp    801060b8 <create+0x1b9>
  ilock(dp);
80105f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f42:	89 04 24             	mov    %eax,(%esp)
80105f45:	e8 c8 bb ff ff       	call   80101b12 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105f4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f51:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5b:	89 04 24             	mov    %eax,(%esp)
80105f5e:	e8 5b c3 ff ff       	call   801022be <dirlookup>
80105f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f6a:	74 46                	je     80105fb2 <create+0xb3>
    iunlockput(dp);
80105f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6f:	89 04 24             	mov    %eax,(%esp)
80105f72:	e8 9a bd ff ff       	call   80101d11 <iunlockput>
    ilock(ip);
80105f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7a:	89 04 24             	mov    %eax,(%esp)
80105f7d:	e8 90 bb ff ff       	call   80101b12 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105f82:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f87:	75 14                	jne    80105f9d <create+0x9e>
80105f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8c:	8b 40 50             	mov    0x50(%eax),%eax
80105f8f:	66 83 f8 02          	cmp    $0x2,%ax
80105f93:	75 08                	jne    80105f9d <create+0x9e>
      return ip;
80105f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f98:	e9 1b 01 00 00       	jmp    801060b8 <create+0x1b9>
    iunlockput(ip);
80105f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa0:	89 04 24             	mov    %eax,(%esp)
80105fa3:	e8 69 bd ff ff       	call   80101d11 <iunlockput>
    return 0;
80105fa8:	b8 00 00 00 00       	mov    $0x0,%eax
80105fad:	e9 06 01 00 00       	jmp    801060b8 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105fb2:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb9:	8b 00                	mov    (%eax),%eax
80105fbb:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fbf:	89 04 24             	mov    %eax,(%esp)
80105fc2:	e8 b6 b8 ff ff       	call   8010187d <ialloc>
80105fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fce:	75 0c                	jne    80105fdc <create+0xdd>
    panic("create: ialloc");
80105fd0:	c7 04 24 9c 99 10 80 	movl   $0x8010999c,(%esp)
80105fd7:	e8 78 a5 ff ff       	call   80100554 <panic>

  ilock(ip);
80105fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fdf:	89 04 24             	mov    %eax,(%esp)
80105fe2:	e8 2b bb ff ff       	call   80101b12 <ilock>
  ip->major = major;
80105fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fea:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105fed:	66 89 42 52          	mov    %ax,0x52(%edx)
  ip->minor = minor;
80105ff1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ff4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ff7:	66 89 42 54          	mov    %ax,0x54(%edx)
  ip->nlink = 1;
80105ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffe:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80106004:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106007:	89 04 24             	mov    %eax,(%esp)
8010600a:	e8 40 b9 ff ff       	call   8010194f <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010600f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106014:	75 68                	jne    8010607e <create+0x17f>
    dp->nlink++;  // for ".."
80106016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106019:	66 8b 40 56          	mov    0x56(%eax),%ax
8010601d:	40                   	inc    %eax
8010601e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106021:	66 89 42 56          	mov    %ax,0x56(%edx)
    iupdate(dp);
80106025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106028:	89 04 24             	mov    %eax,(%esp)
8010602b:	e8 1f b9 ff ff       	call   8010194f <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106030:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106033:	8b 40 04             	mov    0x4(%eax),%eax
80106036:	89 44 24 08          	mov    %eax,0x8(%esp)
8010603a:	c7 44 24 04 76 99 10 	movl   $0x80109976,0x4(%esp)
80106041:	80 
80106042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106045:	89 04 24             	mov    %eax,(%esp)
80106048:	e8 37 c3 ff ff       	call   80102384 <dirlink>
8010604d:	85 c0                	test   %eax,%eax
8010604f:	78 21                	js     80106072 <create+0x173>
80106051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106054:	8b 40 04             	mov    0x4(%eax),%eax
80106057:	89 44 24 08          	mov    %eax,0x8(%esp)
8010605b:	c7 44 24 04 78 99 10 	movl   $0x80109978,0x4(%esp)
80106062:	80 
80106063:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106066:	89 04 24             	mov    %eax,(%esp)
80106069:	e8 16 c3 ff ff       	call   80102384 <dirlink>
8010606e:	85 c0                	test   %eax,%eax
80106070:	79 0c                	jns    8010607e <create+0x17f>
      panic("create dots");
80106072:	c7 04 24 ab 99 10 80 	movl   $0x801099ab,(%esp)
80106079:	e8 d6 a4 ff ff       	call   80100554 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010607e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106081:	8b 40 04             	mov    0x4(%eax),%eax
80106084:	89 44 24 08          	mov    %eax,0x8(%esp)
80106088:	8d 45 de             	lea    -0x22(%ebp),%eax
8010608b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010608f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106092:	89 04 24             	mov    %eax,(%esp)
80106095:	e8 ea c2 ff ff       	call   80102384 <dirlink>
8010609a:	85 c0                	test   %eax,%eax
8010609c:	79 0c                	jns    801060aa <create+0x1ab>
    panic("create: dirlink");
8010609e:	c7 04 24 b7 99 10 80 	movl   $0x801099b7,(%esp)
801060a5:	e8 aa a4 ff ff       	call   80100554 <panic>

  iunlockput(dp);
801060aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ad:	89 04 24             	mov    %eax,(%esp)
801060b0:	e8 5c bc ff ff       	call   80101d11 <iunlockput>

  return ip;
801060b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801060b8:	c9                   	leave  
801060b9:	c3                   	ret    

801060ba <sys_open>:

int
sys_open(void)
{
801060ba:	55                   	push   %ebp
801060bb:	89 e5                	mov    %esp,%ebp
801060bd:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060c0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ce:	e8 f1 f6 ff ff       	call   801057c4 <argstr>
801060d3:	85 c0                	test   %eax,%eax
801060d5:	78 17                	js     801060ee <sys_open+0x34>
801060d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060da:	89 44 24 04          	mov    %eax,0x4(%esp)
801060de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060e5:	e8 43 f6 ff ff       	call   8010572d <argint>
801060ea:	85 c0                	test   %eax,%eax
801060ec:	79 0a                	jns    801060f8 <sys_open+0x3e>
    return -1;
801060ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f3:	e9 5b 01 00 00       	jmp    80106253 <sys_open+0x199>

  begin_op();
801060f8:	e8 0e d5 ff ff       	call   8010360b <begin_op>

  if(omode & O_CREATE){
801060fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106100:	25 00 02 00 00       	and    $0x200,%eax
80106105:	85 c0                	test   %eax,%eax
80106107:	74 3b                	je     80106144 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106109:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010610c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106113:	00 
80106114:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010611b:	00 
8010611c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106123:	00 
80106124:	89 04 24             	mov    %eax,(%esp)
80106127:	e8 d3 fd ff ff       	call   80105eff <create>
8010612c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010612f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106133:	75 6a                	jne    8010619f <sys_open+0xe5>
      end_op();
80106135:	e8 53 d5 ff ff       	call   8010368d <end_op>
      return -1;
8010613a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010613f:	e9 0f 01 00 00       	jmp    80106253 <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80106144:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106147:	89 04 24             	mov    %eax,(%esp)
8010614a:	e8 e8 c4 ff ff       	call   80102637 <namei>
8010614f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106156:	75 0f                	jne    80106167 <sys_open+0xad>
      end_op();
80106158:	e8 30 d5 ff ff       	call   8010368d <end_op>
      return -1;
8010615d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106162:	e9 ec 00 00 00       	jmp    80106253 <sys_open+0x199>
    }
    ilock(ip);
80106167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616a:	89 04 24             	mov    %eax,(%esp)
8010616d:	e8 a0 b9 ff ff       	call   80101b12 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106175:	8b 40 50             	mov    0x50(%eax),%eax
80106178:	66 83 f8 01          	cmp    $0x1,%ax
8010617c:	75 21                	jne    8010619f <sys_open+0xe5>
8010617e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106181:	85 c0                	test   %eax,%eax
80106183:	74 1a                	je     8010619f <sys_open+0xe5>
      iunlockput(ip);
80106185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106188:	89 04 24             	mov    %eax,(%esp)
8010618b:	e8 81 bb ff ff       	call   80101d11 <iunlockput>
      end_op();
80106190:	e8 f8 d4 ff ff       	call   8010368d <end_op>
      return -1;
80106195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619a:	e9 b4 00 00 00       	jmp    80106253 <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010619f:	e8 ac af ff ff       	call   80101150 <filealloc>
801061a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061ab:	74 14                	je     801061c1 <sys_open+0x107>
801061ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b0:	89 04 24             	mov    %eax,(%esp)
801061b3:	e8 40 f7 ff ff       	call   801058f8 <fdalloc>
801061b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801061bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801061bf:	79 28                	jns    801061e9 <sys_open+0x12f>
    if(f)
801061c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c5:	74 0b                	je     801061d2 <sys_open+0x118>
      fileclose(f);
801061c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ca:	89 04 24             	mov    %eax,(%esp)
801061cd:	e8 26 b0 ff ff       	call   801011f8 <fileclose>
    iunlockput(ip);
801061d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d5:	89 04 24             	mov    %eax,(%esp)
801061d8:	e8 34 bb ff ff       	call   80101d11 <iunlockput>
    end_op();
801061dd:	e8 ab d4 ff ff       	call   8010368d <end_op>
    return -1;
801061e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e7:	eb 6a                	jmp    80106253 <sys_open+0x199>
  }
  iunlock(ip);
801061e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ec:	89 04 24             	mov    %eax,(%esp)
801061ef:	e8 28 ba ff ff       	call   80101c1c <iunlock>
  end_op();
801061f4:	e8 94 d4 ff ff       	call   8010368d <end_op>

  f->type = FD_INODE;
801061f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061fc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106202:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106208:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010620b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106218:	83 e0 01             	and    $0x1,%eax
8010621b:	85 c0                	test   %eax,%eax
8010621d:	0f 94 c0             	sete   %al
80106220:	88 c2                	mov    %al,%dl
80106222:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106225:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010622b:	83 e0 01             	and    $0x1,%eax
8010622e:	85 c0                	test   %eax,%eax
80106230:	75 0a                	jne    8010623c <sys_open+0x182>
80106232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106235:	83 e0 02             	and    $0x2,%eax
80106238:	85 c0                	test   %eax,%eax
8010623a:	74 07                	je     80106243 <sys_open+0x189>
8010623c:	b8 01 00 00 00       	mov    $0x1,%eax
80106241:	eb 05                	jmp    80106248 <sys_open+0x18e>
80106243:	b8 00 00 00 00       	mov    $0x0,%eax
80106248:	88 c2                	mov    %al,%dl
8010624a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624d:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106250:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106253:	c9                   	leave  
80106254:	c3                   	ret    

80106255 <sys_mkdir>:

int
sys_mkdir(void)
{
80106255:	55                   	push   %ebp
80106256:	89 e5                	mov    %esp,%ebp
80106258:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010625b:	e8 ab d3 ff ff       	call   8010360b <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106260:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106263:	89 44 24 04          	mov    %eax,0x4(%esp)
80106267:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010626e:	e8 51 f5 ff ff       	call   801057c4 <argstr>
80106273:	85 c0                	test   %eax,%eax
80106275:	78 2c                	js     801062a3 <sys_mkdir+0x4e>
80106277:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010627a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106281:	00 
80106282:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106289:	00 
8010628a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106291:	00 
80106292:	89 04 24             	mov    %eax,(%esp)
80106295:	e8 65 fc ff ff       	call   80105eff <create>
8010629a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010629d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062a1:	75 0c                	jne    801062af <sys_mkdir+0x5a>
    end_op();
801062a3:	e8 e5 d3 ff ff       	call   8010368d <end_op>
    return -1;
801062a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ad:	eb 15                	jmp    801062c4 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801062af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b2:	89 04 24             	mov    %eax,(%esp)
801062b5:	e8 57 ba ff ff       	call   80101d11 <iunlockput>
  end_op();
801062ba:	e8 ce d3 ff ff       	call   8010368d <end_op>
  return 0;
801062bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062c4:	c9                   	leave  
801062c5:	c3                   	ret    

801062c6 <sys_mknod>:

int
sys_mknod(void)
{
801062c6:	55                   	push   %ebp
801062c7:	89 e5                	mov    %esp,%ebp
801062c9:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801062cc:	e8 3a d3 ff ff       	call   8010360b <begin_op>
  if((argstr(0, &path)) < 0 ||
801062d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801062d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062df:	e8 e0 f4 ff ff       	call   801057c4 <argstr>
801062e4:	85 c0                	test   %eax,%eax
801062e6:	78 5e                	js     80106346 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801062e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062f6:	e8 32 f4 ff ff       	call   8010572d <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801062fb:	85 c0                	test   %eax,%eax
801062fd:	78 47                	js     80106346 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106302:	89 44 24 04          	mov    %eax,0x4(%esp)
80106306:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010630d:	e8 1b f4 ff ff       	call   8010572d <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106312:	85 c0                	test   %eax,%eax
80106314:	78 30                	js     80106346 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106316:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106319:	0f bf c8             	movswl %ax,%ecx
8010631c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010631f:	0f bf d0             	movswl %ax,%edx
80106322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106325:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106329:	89 54 24 08          	mov    %edx,0x8(%esp)
8010632d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106334:	00 
80106335:	89 04 24             	mov    %eax,(%esp)
80106338:	e8 c2 fb ff ff       	call   80105eff <create>
8010633d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106344:	75 0c                	jne    80106352 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106346:	e8 42 d3 ff ff       	call   8010368d <end_op>
    return -1;
8010634b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106350:	eb 15                	jmp    80106367 <sys_mknod+0xa1>
  }
  iunlockput(ip);
80106352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106355:	89 04 24             	mov    %eax,(%esp)
80106358:	e8 b4 b9 ff ff       	call   80101d11 <iunlockput>
  end_op();
8010635d:	e8 2b d3 ff ff       	call   8010368d <end_op>
  return 0;
80106362:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106367:	c9                   	leave  
80106368:	c3                   	ret    

80106369 <sys_chdir>:

int
sys_chdir(void)
{
80106369:	55                   	push   %ebp
8010636a:	89 e5                	mov    %esp,%ebp
8010636c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010636f:	e8 8f df ff ff       	call   80104303 <myproc>
80106374:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106377:	e8 8f d2 ff ff       	call   8010360b <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010637c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010637f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106383:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010638a:	e8 35 f4 ff ff       	call   801057c4 <argstr>
8010638f:	85 c0                	test   %eax,%eax
80106391:	78 14                	js     801063a7 <sys_chdir+0x3e>
80106393:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106396:	89 04 24             	mov    %eax,(%esp)
80106399:	e8 99 c2 ff ff       	call   80102637 <namei>
8010639e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063a5:	75 0c                	jne    801063b3 <sys_chdir+0x4a>
    end_op();
801063a7:	e8 e1 d2 ff ff       	call   8010368d <end_op>
    return -1;
801063ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b1:	eb 5a                	jmp    8010640d <sys_chdir+0xa4>
  }
  ilock(ip);
801063b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b6:	89 04 24             	mov    %eax,(%esp)
801063b9:	e8 54 b7 ff ff       	call   80101b12 <ilock>
  if(ip->type != T_DIR){
801063be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c1:	8b 40 50             	mov    0x50(%eax),%eax
801063c4:	66 83 f8 01          	cmp    $0x1,%ax
801063c8:	74 17                	je     801063e1 <sys_chdir+0x78>
    iunlockput(ip);
801063ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063cd:	89 04 24             	mov    %eax,(%esp)
801063d0:	e8 3c b9 ff ff       	call   80101d11 <iunlockput>
    end_op();
801063d5:	e8 b3 d2 ff ff       	call   8010368d <end_op>
    return -1;
801063da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063df:	eb 2c                	jmp    8010640d <sys_chdir+0xa4>
  }
  iunlock(ip);
801063e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e4:	89 04 24             	mov    %eax,(%esp)
801063e7:	e8 30 b8 ff ff       	call   80101c1c <iunlock>
  iput(curproc->cwd);
801063ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ef:	8b 40 68             	mov    0x68(%eax),%eax
801063f2:	89 04 24             	mov    %eax,(%esp)
801063f5:	e8 66 b8 ff ff       	call   80101c60 <iput>
  end_op();
801063fa:	e8 8e d2 ff ff       	call   8010368d <end_op>
  curproc->cwd = ip;
801063ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106402:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106405:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106408:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010640d:	c9                   	leave  
8010640e:	c3                   	ret    

8010640f <sys_exec>:

int
sys_exec(void)
{
8010640f:	55                   	push   %ebp
80106410:	89 e5                	mov    %esp,%ebp
80106412:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106418:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010641b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010641f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106426:	e8 99 f3 ff ff       	call   801057c4 <argstr>
8010642b:	85 c0                	test   %eax,%eax
8010642d:	78 1a                	js     80106449 <sys_exec+0x3a>
8010642f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106435:	89 44 24 04          	mov    %eax,0x4(%esp)
80106439:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106440:	e8 e8 f2 ff ff       	call   8010572d <argint>
80106445:	85 c0                	test   %eax,%eax
80106447:	79 0a                	jns    80106453 <sys_exec+0x44>
    return -1;
80106449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644e:	e9 c7 00 00 00       	jmp    8010651a <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80106453:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010645a:	00 
8010645b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106462:	00 
80106463:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106469:	89 04 24             	mov    %eax,(%esp)
8010646c:	e8 05 ed ff ff       	call   80105176 <memset>
  for(i=0;; i++){
80106471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010647b:	83 f8 1f             	cmp    $0x1f,%eax
8010647e:	76 0a                	jbe    8010648a <sys_exec+0x7b>
      return -1;
80106480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106485:	e9 90 00 00 00       	jmp    8010651a <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010648a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648d:	c1 e0 02             	shl    $0x2,%eax
80106490:	89 c2                	mov    %eax,%edx
80106492:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106498:	01 c2                	add    %eax,%edx
8010649a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801064a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801064a4:	89 14 24             	mov    %edx,(%esp)
801064a7:	e8 e0 f1 ff ff       	call   8010568c <fetchint>
801064ac:	85 c0                	test   %eax,%eax
801064ae:	79 07                	jns    801064b7 <sys_exec+0xa8>
      return -1;
801064b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b5:	eb 63                	jmp    8010651a <sys_exec+0x10b>
    if(uarg == 0){
801064b7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064bd:	85 c0                	test   %eax,%eax
801064bf:	75 26                	jne    801064e7 <sys_exec+0xd8>
      argv[i] = 0;
801064c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064c4:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801064cb:	00 00 00 00 
      break;
801064cf:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801064d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d3:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801064d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801064dd:	89 04 24             	mov    %eax,(%esp)
801064e0:	e8 0f a8 ff ff       	call   80100cf4 <exec>
801064e5:	eb 33                	jmp    8010651a <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801064e7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801064ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064f0:	c1 e2 02             	shl    $0x2,%edx
801064f3:	01 c2                	add    %eax,%edx
801064f5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801064ff:	89 04 24             	mov    %eax,(%esp)
80106502:	e8 c4 f1 ff ff       	call   801056cb <fetchstr>
80106507:	85 c0                	test   %eax,%eax
80106509:	79 07                	jns    80106512 <sys_exec+0x103>
      return -1;
8010650b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106510:	eb 08                	jmp    8010651a <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106512:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106515:	e9 5e ff ff ff       	jmp    80106478 <sys_exec+0x69>
  return exec(path, argv);
}
8010651a:	c9                   	leave  
8010651b:	c3                   	ret    

8010651c <sys_pipe>:

int
sys_pipe(void)
{
8010651c:	55                   	push   %ebp
8010651d:	89 e5                	mov    %esp,%ebp
8010651f:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106522:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106529:	00 
8010652a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010652d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106531:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106538:	e8 1d f2 ff ff       	call   8010575a <argptr>
8010653d:	85 c0                	test   %eax,%eax
8010653f:	79 0a                	jns    8010654b <sys_pipe+0x2f>
    return -1;
80106541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106546:	e9 9a 00 00 00       	jmp    801065e5 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
8010654b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010654e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106552:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106555:	89 04 24             	mov    %eax,(%esp)
80106558:	e8 fb d8 ff ff       	call   80103e58 <pipealloc>
8010655d:	85 c0                	test   %eax,%eax
8010655f:	79 07                	jns    80106568 <sys_pipe+0x4c>
    return -1;
80106561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106566:	eb 7d                	jmp    801065e5 <sys_pipe+0xc9>
  fd0 = -1;
80106568:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010656f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106572:	89 04 24             	mov    %eax,(%esp)
80106575:	e8 7e f3 ff ff       	call   801058f8 <fdalloc>
8010657a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010657d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106581:	78 14                	js     80106597 <sys_pipe+0x7b>
80106583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106586:	89 04 24             	mov    %eax,(%esp)
80106589:	e8 6a f3 ff ff       	call   801058f8 <fdalloc>
8010658e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106595:	79 36                	jns    801065cd <sys_pipe+0xb1>
    if(fd0 >= 0)
80106597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010659b:	78 13                	js     801065b0 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
8010659d:	e8 61 dd ff ff       	call   80104303 <myproc>
801065a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065a5:	83 c2 08             	add    $0x8,%edx
801065a8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801065af:	00 
    fileclose(rf);
801065b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065b3:	89 04 24             	mov    %eax,(%esp)
801065b6:	e8 3d ac ff ff       	call   801011f8 <fileclose>
    fileclose(wf);
801065bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065be:	89 04 24             	mov    %eax,(%esp)
801065c1:	e8 32 ac ff ff       	call   801011f8 <fileclose>
    return -1;
801065c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cb:	eb 18                	jmp    801065e5 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
801065cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065d3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801065d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065d8:	8d 50 04             	lea    0x4(%eax),%edx
801065db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065de:	89 02                	mov    %eax,(%edx)
  return 0;
801065e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065e5:	c9                   	leave  
801065e6:	c3                   	ret    

801065e7 <name_of_inode>:

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
801065e7:	55                   	push   %ebp
801065e8:	89 e5                	mov    %esp,%ebp
801065ea:	83 ec 38             	sub    $0x38,%esp
    uint off;
    struct dirent de;
    for (off = 0; off < parent->size; off += sizeof(de)) {
801065ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065f4:	eb 6a                	jmp    80106660 <name_of_inode+0x79>
        if (readi(parent, (char*)&de, off, sizeof(de)) != sizeof(de))
801065f6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801065fd:	00 
801065fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106601:	89 44 24 08          	mov    %eax,0x8(%esp)
80106605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106608:	89 44 24 04          	mov    %eax,0x4(%esp)
8010660c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010660f:	89 04 24             	mov    %eax,(%esp)
80106612:	e8 92 b9 ff ff       	call   80101fa9 <readi>
80106617:	83 f8 10             	cmp    $0x10,%eax
8010661a:	74 0c                	je     80106628 <name_of_inode+0x41>
            panic("couldn't read dir entry");
8010661c:	c7 04 24 c7 99 10 80 	movl   $0x801099c7,(%esp)
80106623:	e8 2c 9f ff ff       	call   80100554 <panic>
        if (de.inum == ip->inum) {
80106628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010662b:	0f b7 d0             	movzwl %ax,%edx
8010662e:	8b 45 08             	mov    0x8(%ebp),%eax
80106631:	8b 40 04             	mov    0x4(%eax),%eax
80106634:	39 c2                	cmp    %eax,%edx
80106636:	75 24                	jne    8010665c <name_of_inode+0x75>
            safestrcpy(buf, de.name, DIRSIZ);
80106638:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010663f:	00 
80106640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106643:	83 c0 02             	add    $0x2,%eax
80106646:	89 44 24 04          	mov    %eax,0x4(%esp)
8010664a:	8b 45 10             	mov    0x10(%ebp),%eax
8010664d:	89 04 24             	mov    %eax,(%esp)
80106650:	e8 5b ed ff ff       	call   801053b0 <safestrcpy>
            return 0;
80106655:	b8 00 00 00 00       	mov    $0x0,%eax
8010665a:	eb 14                	jmp    80106670 <name_of_inode+0x89>

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
    uint off;
    struct dirent de;
    for (off = 0; off < parent->size; off += sizeof(de)) {
8010665c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80106660:	8b 45 0c             	mov    0xc(%ebp),%eax
80106663:	8b 40 58             	mov    0x58(%eax),%eax
80106666:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106669:	77 8b                	ja     801065f6 <name_of_inode+0xf>
        if (de.inum == ip->inum) {
            safestrcpy(buf, de.name, DIRSIZ);
            return 0;
        }
    }
    return -1;
8010666b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106670:	c9                   	leave  
80106671:	c3                   	ret    

80106672 <name_for_inode>:

int
name_for_inode(char* buf, int n, struct inode *ip) {
80106672:	55                   	push   %ebp
80106673:	89 e5                	mov    %esp,%ebp
80106675:	53                   	push   %ebx
80106676:	83 ec 34             	sub    $0x34,%esp
    int path_offset;
    struct inode *parent;
    char node_name[DIRSIZ];
    if (ip->inum == namei("/")->inum) { //namei is inefficient but iget isn't exported for some reason
80106679:	8b 45 10             	mov    0x10(%ebp),%eax
8010667c:	8b 58 04             	mov    0x4(%eax),%ebx
8010667f:	c7 04 24 df 99 10 80 	movl   $0x801099df,(%esp)
80106686:	e8 ac bf ff ff       	call   80102637 <namei>
8010668b:	8b 40 04             	mov    0x4(%eax),%eax
8010668e:	39 c3                	cmp    %eax,%ebx
80106690:	75 10                	jne    801066a2 <name_for_inode+0x30>
        buf[0] = '/';
80106692:	8b 45 08             	mov    0x8(%ebp),%eax
80106695:	c6 00 2f             	movb   $0x2f,(%eax)
        return 1;
80106698:	b8 01 00 00 00       	mov    $0x1,%eax
8010669d:	e9 1d 01 00 00       	jmp    801067bf <name_for_inode+0x14d>
    } else if (ip->type == T_DIR) {
801066a2:	8b 45 10             	mov    0x10(%ebp),%eax
801066a5:	8b 40 50             	mov    0x50(%eax),%eax
801066a8:	66 83 f8 01          	cmp    $0x1,%ax
801066ac:	0f 85 dd 00 00 00    	jne    8010678f <name_for_inode+0x11d>
        parent = dirlookup(ip, "..", 0);
801066b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801066b9:	00 
801066ba:	c7 44 24 04 78 99 10 	movl   $0x80109978,0x4(%esp)
801066c1:	80 
801066c2:	8b 45 10             	mov    0x10(%ebp),%eax
801066c5:	89 04 24             	mov    %eax,(%esp)
801066c8:	e8 f1 bb ff ff       	call   801022be <dirlookup>
801066cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ilock(parent);
801066d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d3:	89 04 24             	mov    %eax,(%esp)
801066d6:	e8 37 b4 ff ff       	call   80101b12 <ilock>
        if (name_of_inode(ip, parent, node_name)) {
801066db:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801066de:	89 44 24 08          	mov    %eax,0x8(%esp)
801066e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801066e9:	8b 45 10             	mov    0x10(%ebp),%eax
801066ec:	89 04 24             	mov    %eax,(%esp)
801066ef:	e8 f3 fe ff ff       	call   801065e7 <name_of_inode>
801066f4:	85 c0                	test   %eax,%eax
801066f6:	74 0c                	je     80106704 <name_for_inode+0x92>
            panic("could not find name of inode in parent!");
801066f8:	c7 04 24 e4 99 10 80 	movl   $0x801099e4,(%esp)
801066ff:	e8 50 9e ff ff       	call   80100554 <panic>
        }
        path_offset = name_for_inode(buf, n, parent);
80106704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106707:	89 44 24 08          	mov    %eax,0x8(%esp)
8010670b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010670e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106712:	8b 45 08             	mov    0x8(%ebp),%eax
80106715:	89 04 24             	mov    %eax,(%esp)
80106718:	e8 55 ff ff ff       	call   80106672 <name_for_inode>
8010671d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        safestrcpy(buf + path_offset, node_name, n - path_offset);
80106720:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106723:	8b 55 0c             	mov    0xc(%ebp),%edx
80106726:	29 c2                	sub    %eax,%edx
80106728:	89 d0                	mov    %edx,%eax
8010672a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010672d:	8b 55 08             	mov    0x8(%ebp),%edx
80106730:	01 ca                	add    %ecx,%edx
80106732:	89 44 24 08          	mov    %eax,0x8(%esp)
80106736:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106739:	89 44 24 04          	mov    %eax,0x4(%esp)
8010673d:	89 14 24             	mov    %edx,(%esp)
80106740:	e8 6b ec ff ff       	call   801053b0 <safestrcpy>
        path_offset += strlen(node_name);
80106745:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106748:	89 04 24             	mov    %eax,(%esp)
8010674b:	e8 a7 ec ff ff       	call   801053f7 <strlen>
80106750:	01 45 f0             	add    %eax,-0x10(%ebp)
        if (path_offset == n - 1) {
80106753:	8b 45 0c             	mov    0xc(%ebp),%eax
80106756:	48                   	dec    %eax
80106757:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010675a:	75 10                	jne    8010676c <name_for_inode+0xfa>
            buf[path_offset] = '\0';
8010675c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010675f:	8b 45 08             	mov    0x8(%ebp),%eax
80106762:	01 d0                	add    %edx,%eax
80106764:	c6 00 00             	movb   $0x0,(%eax)
            return n;
80106767:	8b 45 0c             	mov    0xc(%ebp),%eax
8010676a:	eb 53                	jmp    801067bf <name_for_inode+0x14d>
        } else {
            buf[path_offset++] = '/';
8010676c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676f:	8d 50 01             	lea    0x1(%eax),%edx
80106772:	89 55 f0             	mov    %edx,-0x10(%ebp)
80106775:	89 c2                	mov    %eax,%edx
80106777:	8b 45 08             	mov    0x8(%ebp),%eax
8010677a:	01 d0                	add    %edx,%eax
8010677c:	c6 00 2f             	movb   $0x2f,(%eax)
        }
        iput(parent); //free
8010677f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106782:	89 04 24             	mov    %eax,(%esp)
80106785:	e8 d6 b4 ff ff       	call   80101c60 <iput>
        return path_offset;
8010678a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010678d:	eb 30                	jmp    801067bf <name_for_inode+0x14d>
    } else if (ip->type == T_DEV || ip->type == T_FILE) {
8010678f:	8b 45 10             	mov    0x10(%ebp),%eax
80106792:	8b 40 50             	mov    0x50(%eax),%eax
80106795:	66 83 f8 03          	cmp    $0x3,%ax
80106799:	74 0c                	je     801067a7 <name_for_inode+0x135>
8010679b:	8b 45 10             	mov    0x10(%ebp),%eax
8010679e:	8b 40 50             	mov    0x50(%eax),%eax
801067a1:	66 83 f8 02          	cmp    $0x2,%ax
801067a5:	75 0c                	jne    801067b3 <name_for_inode+0x141>
        panic("process cwd is a device node / file, not a directory!");
801067a7:	c7 04 24 0c 9a 10 80 	movl   $0x80109a0c,(%esp)
801067ae:	e8 a1 9d ff ff       	call   80100554 <panic>
    } else {
        panic("unknown inode type");
801067b3:	c7 04 24 42 9a 10 80 	movl   $0x80109a42,(%esp)
801067ba:	e8 95 9d ff ff       	call   80100554 <panic>
    }
}
801067bf:	83 c4 34             	add    $0x34,%esp
801067c2:	5b                   	pop    %ebx
801067c3:	5d                   	pop    %ebp
801067c4:	c3                   	ret    

801067c5 <sys_getcwd>:

int
sys_getcwd(void)
{
801067c5:	55                   	push   %ebp
801067c6:	89 e5                	mov    %esp,%ebp
801067c8:	83 ec 28             	sub    $0x28,%esp
    char *p;
    int n;
    if(argint(1, &n) < 0 || argptr(0, &p, n) < 0)
801067cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801067d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801067d9:	e8 4f ef ff ff       	call   8010572d <argint>
801067de:	85 c0                	test   %eax,%eax
801067e0:	78 1e                	js     80106800 <sys_getcwd+0x3b>
801067e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801067e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067f7:	e8 5e ef ff ff       	call   8010575a <argptr>
801067fc:	85 c0                	test   %eax,%eax
801067fe:	79 07                	jns    80106807 <sys_getcwd+0x42>
        return -1;
80106800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106805:	eb 1e                	jmp    80106825 <sys_getcwd+0x60>
    return name_for_inode(p, n, myproc()->cwd);
80106807:	e8 f7 da ff ff       	call   80104303 <myproc>
8010680c:	8b 48 68             	mov    0x68(%eax),%ecx
8010680f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106815:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106819:	89 54 24 04          	mov    %edx,0x4(%esp)
8010681d:	89 04 24             	mov    %eax,(%esp)
80106820:	e8 4d fe ff ff       	call   80106672 <name_for_inode>
}
80106825:	c9                   	leave  
80106826:	c3                   	ret    
	...

80106828 <sys_fork>:
#include "container.h"


int
sys_fork(void)
{
80106828:	55                   	push   %ebp
80106829:	89 e5                	mov    %esp,%ebp
8010682b:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010682e:	e8 cc dd ff ff       	call   801045ff <fork>
}
80106833:	c9                   	leave  
80106834:	c3                   	ret    

80106835 <sys_exit>:

int
sys_exit(void)
{
80106835:	55                   	push   %ebp
80106836:	89 e5                	mov    %esp,%ebp
80106838:	83 ec 08             	sub    $0x8,%esp
  exit();
8010683b:	e8 25 df ff ff       	call   80104765 <exit>
  return 0;  // not reached
80106840:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106845:	c9                   	leave  
80106846:	c3                   	ret    

80106847 <sys_wait>:

int
sys_wait(void)
{
80106847:	55                   	push   %ebp
80106848:	89 e5                	mov    %esp,%ebp
8010684a:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010684d:	e8 1c e0 ff ff       	call   8010486e <wait>
}
80106852:	c9                   	leave  
80106853:	c3                   	ret    

80106854 <sys_kill>:

int
sys_kill(void)
{
80106854:	55                   	push   %ebp
80106855:	89 e5                	mov    %esp,%ebp
80106857:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010685a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010685d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106868:	e8 c0 ee ff ff       	call   8010572d <argint>
8010686d:	85 c0                	test   %eax,%eax
8010686f:	79 07                	jns    80106878 <sys_kill+0x24>
    return -1;
80106871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106876:	eb 0b                	jmp    80106883 <sys_kill+0x2f>
  return kill(pid);
80106878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010687b:	89 04 24             	mov    %eax,(%esp)
8010687e:	e8 c0 e3 ff ff       	call   80104c43 <kill>
}
80106883:	c9                   	leave  
80106884:	c3                   	ret    

80106885 <sys_getpid>:

int
sys_getpid(void)
{
80106885:	55                   	push   %ebp
80106886:	89 e5                	mov    %esp,%ebp
80106888:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010688b:	e8 73 da ff ff       	call   80104303 <myproc>
80106890:	8b 40 10             	mov    0x10(%eax),%eax
}
80106893:	c9                   	leave  
80106894:	c3                   	ret    

80106895 <sys_sbrk>:

int
sys_sbrk(void)
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
80106898:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010689b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010689e:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068a9:	e8 7f ee ff ff       	call   8010572d <argint>
801068ae:	85 c0                	test   %eax,%eax
801068b0:	79 07                	jns    801068b9 <sys_sbrk+0x24>
    return -1;
801068b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b7:	eb 23                	jmp    801068dc <sys_sbrk+0x47>
  addr = myproc()->sz;
801068b9:	e8 45 da ff ff       	call   80104303 <myproc>
801068be:	8b 00                	mov    (%eax),%eax
801068c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801068c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068c6:	89 04 24             	mov    %eax,(%esp)
801068c9:	e8 93 dc ff ff       	call   80104561 <growproc>
801068ce:	85 c0                	test   %eax,%eax
801068d0:	79 07                	jns    801068d9 <sys_sbrk+0x44>
    return -1;
801068d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d7:	eb 03                	jmp    801068dc <sys_sbrk+0x47>
  return addr;
801068d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801068dc:	c9                   	leave  
801068dd:	c3                   	ret    

801068de <sys_sleep>:

int
sys_sleep(void)
{
801068de:	55                   	push   %ebp
801068df:	89 e5                	mov    %esp,%ebp
801068e1:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801068e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801068eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068f2:	e8 36 ee ff ff       	call   8010572d <argint>
801068f7:	85 c0                	test   %eax,%eax
801068f9:	79 07                	jns    80106902 <sys_sleep+0x24>
    return -1;
801068fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106900:	eb 6b                	jmp    8010696d <sys_sleep+0x8f>
  acquire(&tickslock);
80106902:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
80106909:	e8 05 e6 ff ff       	call   80104f13 <acquire>
  ticks0 = ticks;
8010690e:	a1 e0 7d 11 80       	mov    0x80117de0,%eax
80106913:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106916:	eb 33                	jmp    8010694b <sys_sleep+0x6d>
    if(myproc()->killed){
80106918:	e8 e6 d9 ff ff       	call   80104303 <myproc>
8010691d:	8b 40 24             	mov    0x24(%eax),%eax
80106920:	85 c0                	test   %eax,%eax
80106922:	74 13                	je     80106937 <sys_sleep+0x59>
      release(&tickslock);
80106924:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
8010692b:	e8 4d e6 ff ff       	call   80104f7d <release>
      return -1;
80106930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106935:	eb 36                	jmp    8010696d <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
80106937:	c7 44 24 04 a0 75 11 	movl   $0x801175a0,0x4(%esp)
8010693e:	80 
8010693f:	c7 04 24 e0 7d 11 80 	movl   $0x80117de0,(%esp)
80106946:	e8 f9 e1 ff ff       	call   80104b44 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010694b:	a1 e0 7d 11 80       	mov    0x80117de0,%eax
80106950:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106953:	89 c2                	mov    %eax,%edx
80106955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106958:	39 c2                	cmp    %eax,%edx
8010695a:	72 bc                	jb     80106918 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010695c:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
80106963:	e8 15 e6 ff ff       	call   80104f7d <release>
  return 0;
80106968:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010696d:	c9                   	leave  
8010696e:	c3                   	ret    

8010696f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010696f:	55                   	push   %ebp
80106970:	89 e5                	mov    %esp,%ebp
80106972:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106975:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
8010697c:	e8 92 e5 ff ff       	call   80104f13 <acquire>
  xticks = ticks;
80106981:	a1 e0 7d 11 80       	mov    0x80117de0,%eax
80106986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106989:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
80106990:	e8 e8 e5 ff ff       	call   80104f7d <release>
  return xticks;
80106995:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106998:	c9                   	leave  
80106999:	c3                   	ret    

8010699a <sys_getname>:

int
sys_getname(void)
{
8010699a:	55                   	push   %ebp
8010699b:	89 e5                	mov    %esp,%ebp
8010699d:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
801069a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801069a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069ae:	e8 7a ed ff ff       	call   8010572d <argint>
801069b3:	85 c0                	test   %eax,%eax
801069b5:	78 17                	js     801069ce <sys_getname+0x34>
801069b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801069be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801069c5:	e8 fa ed ff ff       	call   801057c4 <argstr>
801069ca:	85 c0                	test   %eax,%eax
801069cc:	79 07                	jns    801069d5 <sys_getname+0x3b>
    return -1;
801069ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d3:	eb 12                	jmp    801069e7 <sys_getname+0x4d>
  }

  return getname(index, name);
801069d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069db:	89 54 24 04          	mov    %edx,0x4(%esp)
801069df:	89 04 24             	mov    %eax,(%esp)
801069e2:	e8 79 23 00 00       	call   80108d60 <getname>
}
801069e7:	c9                   	leave  
801069e8:	c3                   	ret    

801069e9 <sys_setname>:

int
sys_setname(void)
{
801069e9:	55                   	push   %ebp
801069ea:	89 e5                	mov    %esp,%ebp
801069ec:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *name;

  if(argint(0, &index) < 0 || argstr(1, &name) < 0){
801069ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069fd:	e8 2b ed ff ff       	call   8010572d <argint>
80106a02:	85 c0                	test   %eax,%eax
80106a04:	78 17                	js     80106a1d <sys_setname+0x34>
80106a06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a14:	e8 ab ed ff ff       	call   801057c4 <argstr>
80106a19:	85 c0                	test   %eax,%eax
80106a1b:	79 07                	jns    80106a24 <sys_setname+0x3b>
    return -1;
80106a1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a22:	eb 12                	jmp    80106a36 <sys_setname+0x4d>
  }

  return setname(index, name);
80106a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a2e:	89 04 24             	mov    %eax,(%esp)
80106a31:	e8 78 23 00 00       	call   80108dae <setname>
}
80106a36:	c9                   	leave  
80106a37:	c3                   	ret    

80106a38 <sys_getmaxproc>:

int
sys_getmaxproc(void)
{
80106a38:	55                   	push   %ebp
80106a39:	89 e5                	mov    %esp,%ebp
80106a3b:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106a3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a4c:	e8 dc ec ff ff       	call   8010572d <argint>
80106a51:	85 c0                	test   %eax,%eax
80106a53:	79 07                	jns    80106a5c <sys_getmaxproc+0x24>
    return -1;
80106a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a5a:	eb 0b                	jmp    80106a67 <sys_getmaxproc+0x2f>
  }

  return getmaxproc(index);
80106a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a5f:	89 04 24             	mov    %eax,(%esp)
80106a62:	e8 ad 23 00 00       	call   80108e14 <getmaxproc>
}
80106a67:	c9                   	leave  
80106a68:	c3                   	ret    

80106a69 <sys_setmaxproc>:

int
sys_setmaxproc(void)
{
80106a69:	55                   	push   %ebp
80106a6a:	89 e5                	mov    %esp,%ebp
80106a6c:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a7d:	e8 ab ec ff ff       	call   8010572d <argint>
80106a82:	85 c0                	test   %eax,%eax
80106a84:	78 17                	js     80106a9d <sys_setmaxproc+0x34>
80106a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a94:	e8 94 ec ff ff       	call   8010572d <argint>
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	74 07                	je     80106aa4 <sys_setmaxproc+0x3b>
    return -1;
80106a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa2:	eb 12                	jmp    80106ab6 <sys_setmaxproc+0x4d>
  }

  return setmaxproc(index, max);
80106aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aaa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aae:	89 04 24             	mov    %eax,(%esp)
80106ab1:	e8 7c 23 00 00       	call   80108e32 <setmaxproc>
}
80106ab6:	c9                   	leave  
80106ab7:	c3                   	ret    

80106ab8 <sys_getmaxmem>:

int
sys_getmaxmem(void)
{
80106ab8:	55                   	push   %ebp
80106ab9:	89 e5                	mov    %esp,%ebp
80106abb:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106abe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ac5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106acc:	e8 5c ec ff ff       	call   8010572d <argint>
80106ad1:	85 c0                	test   %eax,%eax
80106ad3:	79 07                	jns    80106adc <sys_getmaxmem+0x24>
    return -1;
80106ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ada:	eb 0b                	jmp    80106ae7 <sys_getmaxmem+0x2f>
  }

  return getmaxmem(index);
80106adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106adf:	89 04 24             	mov    %eax,(%esp)
80106ae2:	e8 72 23 00 00       	call   80108e59 <getmaxmem>
}
80106ae7:	c9                   	leave  
80106ae8:	c3                   	ret    

80106ae9 <sys_setmaxmem>:

int
sys_setmaxmem(void)
{
80106ae9:	55                   	push   %ebp
80106aea:	89 e5                	mov    %esp,%ebp
80106aec:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106af2:	89 44 24 04          	mov    %eax,0x4(%esp)
80106af6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106afd:	e8 2b ec ff ff       	call   8010572d <argint>
80106b02:	85 c0                	test   %eax,%eax
80106b04:	78 17                	js     80106b1d <sys_setmaxmem+0x34>
80106b06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b14:	e8 14 ec ff ff       	call   8010572d <argint>
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	74 07                	je     80106b24 <sys_setmaxmem+0x3b>
    return -1;
80106b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b22:	eb 12                	jmp    80106b36 <sys_setmaxmem+0x4d>
  }

  return setmaxmem(index, max);
80106b24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b2e:	89 04 24             	mov    %eax,(%esp)
80106b31:	e8 41 23 00 00       	call   80108e77 <setmaxmem>
}
80106b36:	c9                   	leave  
80106b37:	c3                   	ret    

80106b38 <sys_getmaxdisk>:

int
sys_getmaxdisk(void)
{
80106b38:	55                   	push   %ebp
80106b39:	89 e5                	mov    %esp,%ebp
80106b3b:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106b3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b4c:	e8 dc eb ff ff       	call   8010572d <argint>
80106b51:	85 c0                	test   %eax,%eax
80106b53:	79 07                	jns    80106b5c <sys_getmaxdisk+0x24>
    return -1;
80106b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b5a:	eb 0b                	jmp    80106b67 <sys_getmaxdisk+0x2f>
  }

  return getmaxdisk(index);
80106b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b5f:	89 04 24             	mov    %eax,(%esp)
80106b62:	e8 37 23 00 00       	call   80108e9e <getmaxdisk>
}
80106b67:	c9                   	leave  
80106b68:	c3                   	ret    

80106b69 <sys_setmaxdisk>:

int
sys_setmaxdisk(void)
{
80106b69:	55                   	push   %ebp
80106b6a:	89 e5                	mov    %esp,%ebp
80106b6c:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106b6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b7d:	e8 ab eb ff ff       	call   8010572d <argint>
80106b82:	85 c0                	test   %eax,%eax
80106b84:	78 17                	js     80106b9d <sys_setmaxdisk+0x34>
80106b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b94:	e8 94 eb ff ff       	call   8010572d <argint>
80106b99:	85 c0                	test   %eax,%eax
80106b9b:	74 07                	je     80106ba4 <sys_setmaxdisk+0x3b>
    return -1;
80106b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba2:	eb 12                	jmp    80106bb6 <sys_setmaxdisk+0x4d>
  }

  return setmaxdisk(index, max);
80106ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106baa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bae:	89 04 24             	mov    %eax,(%esp)
80106bb1:	e8 05 23 00 00       	call   80108ebb <setmaxdisk>
}
80106bb6:	c9                   	leave  
80106bb7:	c3                   	ret    

80106bb8 <sys_getusedmem>:

int
sys_getusedmem(void)
{
80106bb8:	55                   	push   %ebp
80106bb9:	89 e5                	mov    %esp,%ebp
80106bbb:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106bbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bcc:	e8 5c eb ff ff       	call   8010572d <argint>
80106bd1:	85 c0                	test   %eax,%eax
80106bd3:	79 07                	jns    80106bdc <sys_getusedmem+0x24>
    return -1;
80106bd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bda:	eb 0b                	jmp    80106be7 <sys_getusedmem+0x2f>
  }

  return getusedmem(index);
80106bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bdf:	89 04 24             	mov    %eax,(%esp)
80106be2:	e8 fa 22 00 00       	call   80108ee1 <getusedmem>
}
80106be7:	c9                   	leave  
80106be8:	c3                   	ret    

80106be9 <sys_setusedmem>:

int
sys_setusedmem(void)
{
80106be9:	55                   	push   %ebp
80106bea:	89 e5                	mov    %esp,%ebp
80106bec:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bfd:	e8 2b eb ff ff       	call   8010572d <argint>
80106c02:	85 c0                	test   %eax,%eax
80106c04:	78 17                	js     80106c1d <sys_setusedmem+0x34>
80106c06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106c14:	e8 14 eb ff ff       	call   8010572d <argint>
80106c19:	85 c0                	test   %eax,%eax
80106c1b:	74 07                	je     80106c24 <sys_setusedmem+0x3b>
    return -1;
80106c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c22:	eb 12                	jmp    80106c36 <sys_setusedmem+0x4d>
  }

  return setusedmem(index, max);
80106c24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c2e:	89 04 24             	mov    %eax,(%esp)
80106c31:	e8 c9 22 00 00       	call   80108eff <setusedmem>
}
80106c36:	c9                   	leave  
80106c37:	c3                   	ret    

80106c38 <sys_getuseddisk>:

int
sys_getuseddisk(void)
{
80106c38:	55                   	push   %ebp
80106c39:	89 e5                	mov    %esp,%ebp
80106c3b:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106c3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c4c:	e8 dc ea ff ff       	call   8010572d <argint>
80106c51:	85 c0                	test   %eax,%eax
80106c53:	79 07                	jns    80106c5c <sys_getuseddisk+0x24>
    return -1;
80106c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c5a:	eb 0b                	jmp    80106c67 <sys_getuseddisk+0x2f>
  }

  return getuseddisk(index);
80106c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c5f:	89 04 24             	mov    %eax,(%esp)
80106c62:	e8 bf 22 00 00       	call   80108f26 <getuseddisk>
}
80106c67:	c9                   	leave  
80106c68:	c3                   	ret    

80106c69 <sys_setuseddisk>:

int
sys_setuseddisk(void)
{
80106c69:	55                   	push   %ebp
80106c6a:	89 e5                	mov    %esp,%ebp
80106c6c:	83 ec 28             	sub    $0x28,%esp
  int index, max;

  if(argint(0, &index) < 0 || argint(1, &max)){
80106c6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c7d:	e8 ab ea ff ff       	call   8010572d <argint>
80106c82:	85 c0                	test   %eax,%eax
80106c84:	78 17                	js     80106c9d <sys_setuseddisk+0x34>
80106c86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106c94:	e8 94 ea ff ff       	call   8010572d <argint>
80106c99:	85 c0                	test   %eax,%eax
80106c9b:	74 07                	je     80106ca4 <sys_setuseddisk+0x3b>
    return -1;
80106c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ca2:	eb 12                	jmp    80106cb6 <sys_setuseddisk+0x4d>
  }

  return setuseddisk(index, max);
80106ca4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106caa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106cae:	89 04 24             	mov    %eax,(%esp)
80106cb1:	e8 8e 22 00 00       	call   80108f44 <setuseddisk>
}
80106cb6:	c9                   	leave  
80106cb7:	c3                   	ret    

80106cb8 <sys_setvc>:


int
sys_setvc(void){
80106cb8:	55                   	push   %ebp
80106cb9:	89 e5                	mov    %esp,%ebp
80106cbb:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *vc;

  if(argint(0, &index) < 0 || argstr(1, &vc) < 0){
80106cbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ccc:	e8 5c ea ff ff       	call   8010572d <argint>
80106cd1:	85 c0                	test   %eax,%eax
80106cd3:	78 17                	js     80106cec <sys_setvc+0x34>
80106cd5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ce3:	e8 dc ea ff ff       	call   801057c4 <argstr>
80106ce8:	85 c0                	test   %eax,%eax
80106cea:	79 07                	jns    80106cf3 <sys_setvc+0x3b>
    return -1;
80106cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cf1:	eb 12                	jmp    80106d05 <sys_setvc+0x4d>
  }

  return setvc(index, vc);
80106cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106cfd:	89 04 24             	mov    %eax,(%esp)
80106d00:	e8 66 22 00 00       	call   80108f6b <setvc>
}
80106d05:	c9                   	leave  
80106d06:	c3                   	ret    

80106d07 <sys_setactivefs>:

int
sys_setactivefs(void){
80106d07:	55                   	push   %ebp
80106d08:	89 e5                	mov    %esp,%ebp
80106d0a:	83 ec 28             	sub    $0x28,%esp
  char *fs;

  if(argstr(0, &fs) < 0){
80106d0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d10:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d1b:	e8 a4 ea ff ff       	call   801057c4 <argstr>
80106d20:	85 c0                	test   %eax,%eax
80106d22:	79 07                	jns    80106d2b <sys_setactivefs+0x24>
    return -1;
80106d24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d29:	eb 0b                	jmp    80106d36 <sys_setactivefs+0x2f>
  }

  return setactivefs(fs);
80106d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d2e:	89 04 24             	mov    %eax,(%esp)
80106d31:	e8 28 23 00 00       	call   8010905e <setactivefs>
}
80106d36:	c9                   	leave  
80106d37:	c3                   	ret    

80106d38 <sys_getactivefs>:

int
sys_getactivefs(void){
80106d38:	55                   	push   %ebp
80106d39:	89 e5                	mov    %esp,%ebp
80106d3b:	83 ec 28             	sub    $0x28,%esp
  char *fs;

  if(argstr(0, &fs) < 0){
80106d3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d41:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d4c:	e8 73 ea ff ff       	call   801057c4 <argstr>
80106d51:	85 c0                	test   %eax,%eax
80106d53:	79 07                	jns    80106d5c <sys_getactivefs+0x24>
    return -1;
80106d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d5a:	eb 0b                	jmp    80106d67 <sys_getactivefs+0x2f>
  }

  return getactivefs(fs);
80106d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d5f:	89 04 24             	mov    %eax,(%esp)
80106d62:	e8 30 23 00 00       	call   80109097 <getactivefs>
}
80106d67:	c9                   	leave  
80106d68:	c3                   	ret    

80106d69 <sys_getvcfs>:


int
sys_getvcfs(void){
80106d69:	55                   	push   %ebp
80106d6a:	89 e5                	mov    %esp,%ebp
80106d6c:	83 ec 28             	sub    $0x28,%esp
  char *vc;
  char *fs;

  if(argstr(0, &vc) < 0 || argstr(1, &fs) < 0){
80106d6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d7d:	e8 42 ea ff ff       	call   801057c4 <argstr>
80106d82:	85 c0                	test   %eax,%eax
80106d84:	78 17                	js     80106d9d <sys_getvcfs+0x34>
80106d86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106d94:	e8 2b ea ff ff       	call   801057c4 <argstr>
80106d99:	85 c0                	test   %eax,%eax
80106d9b:	79 07                	jns    80106da4 <sys_getvcfs+0x3b>
    return -1;
80106d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106da2:	eb 12                	jmp    80106db6 <sys_getvcfs+0x4d>
  }

  return getvcfs(vc, fs);
80106da4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106daa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106dae:	89 04 24             	mov    %eax,(%esp)
80106db1:	e8 1b 22 00 00       	call   80108fd1 <getvcfs>
}
80106db6:	c9                   	leave  
80106db7:	c3                   	ret    

80106db8 <sys_tostring>:

int
sys_tostring(void){
80106db8:	55                   	push   %ebp
80106db9:	89 e5                	mov    %esp,%ebp
80106dbb:	83 ec 28             	sub    $0x28,%esp
  char *string;

  if(argstr(0, &string) < 0){
80106dbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106dcc:	e8 f3 e9 ff ff       	call   801057c4 <argstr>
80106dd1:	85 c0                	test   %eax,%eax
80106dd3:	79 07                	jns    80106ddc <sys_tostring+0x24>
    return -1;
80106dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dda:	eb 0b                	jmp    80106de7 <sys_tostring+0x2f>
  }

  return tostring(string);
80106ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ddf:	89 04 24             	mov    %eax,(%esp)
80106de2:	e8 5e 25 00 00       	call   80109345 <tostring>
}
80106de7:	c9                   	leave  
80106de8:	c3                   	ret    

80106de9 <sys_getactivefsindex>:


int
sys_getactivefsindex(void){
80106de9:	55                   	push   %ebp
80106dea:	89 e5                	mov    %esp,%ebp
80106dec:	83 ec 08             	sub    $0x8,%esp
    return getactivefsindex();
80106def:	e8 d8 22 00 00       	call   801090cc <getactivefsindex>
}
80106df4:	c9                   	leave  
80106df5:	c3                   	ret    

80106df6 <sys_setatroot>:

int
sys_setatroot(void){
80106df6:	55                   	push   %ebp
80106df7:	89 e5                	mov    %esp,%ebp
80106df9:	83 ec 28             	sub    $0x28,%esp
  int index, val;

  if(argint(0, &index) < 0 || argint(1, &val) < 0){
80106dfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e0a:	e8 1e e9 ff ff       	call   8010572d <argint>
80106e0f:	85 c0                	test   %eax,%eax
80106e11:	78 17                	js     80106e2a <sys_setatroot+0x34>
80106e13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106e21:	e8 07 e9 ff ff       	call   8010572d <argint>
80106e26:	85 c0                	test   %eax,%eax
80106e28:	79 07                	jns    80106e31 <sys_setatroot+0x3b>
    return -1;
80106e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e2f:	eb 12                	jmp    80106e43 <sys_setatroot+0x4d>
  }

  return setatroot(index, val);
80106e31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e37:	89 54 24 04          	mov    %edx,0x4(%esp)
80106e3b:	89 04 24             	mov    %eax,(%esp)
80106e3e:	e8 df 22 00 00       	call   80109122 <setatroot>
}
80106e43:	c9                   	leave  
80106e44:	c3                   	ret    

80106e45 <sys_getatroot>:

int
sys_getatroot(void){
80106e45:	55                   	push   %ebp
80106e46:	89 e5                	mov    %esp,%ebp
80106e48:	83 ec 28             	sub    $0x28,%esp
  int index;

  if(argint(0, &index) < 0){
80106e4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e59:	e8 cf e8 ff ff       	call   8010572d <argint>
80106e5e:	85 c0                	test   %eax,%eax
80106e60:	79 07                	jns    80106e69 <sys_getatroot+0x24>
    return -1;
80106e62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e67:	eb 0b                	jmp    80106e74 <sys_getatroot+0x2f>
  }

  return getatroot(index);
80106e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6c:	89 04 24             	mov    %eax,(%esp)
80106e6f:	e8 d5 22 00 00       	call   80109149 <getatroot>
}
80106e74:	c9                   	leave  
80106e75:	c3                   	ret    

80106e76 <sys_getpath>:

int
sys_getpath(void){
80106e76:	55                   	push   %ebp
80106e77:	89 e5                	mov    %esp,%ebp
80106e79:	83 ec 28             	sub    $0x28,%esp
  int index;
  char *path;

  if(argint(0, &index) < 0 || argstr(1, &path) < 0){
80106e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e8a:	e8 9e e8 ff ff       	call   8010572d <argint>
80106e8f:	85 c0                	test   %eax,%eax
80106e91:	78 17                	js     80106eaa <sys_getpath+0x34>
80106e93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e96:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ea1:	e8 1e e9 ff ff       	call   801057c4 <argstr>
80106ea6:	85 c0                	test   %eax,%eax
80106ea8:	79 07                	jns    80106eb1 <sys_getpath+0x3b>
    return -1;
80106eaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eaf:	eb 12                	jmp    80106ec3 <sys_getpath+0x4d>
  }

  return getpath(index, path);
80106eb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb7:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ebb:	89 04 24             	mov    %eax,(%esp)
80106ebe:	e8 a4 22 00 00       	call   80109167 <getpath>
}
80106ec3:	c9                   	leave  
80106ec4:	c3                   	ret    

80106ec5 <sys_setpath>:

int
sys_setpath(void){
80106ec5:	55                   	push   %ebp
80106ec6:	89 e5                	mov    %esp,%ebp
80106ec8:	83 ec 28             	sub    $0x28,%esp
  int index, remove;
  char *path;

  if(argint(0, &index) < 0 || argstr(1, &path) < 0 || argint(2, &remove) < 0){
80106ecb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ece:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ed2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ed9:	e8 4f e8 ff ff       	call   8010572d <argint>
80106ede:	85 c0                	test   %eax,%eax
80106ee0:	78 2e                	js     80106f10 <sys_setpath+0x4b>
80106ee2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ee9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ef0:	e8 cf e8 ff ff       	call   801057c4 <argstr>
80106ef5:	85 c0                	test   %eax,%eax
80106ef7:	78 17                	js     80106f10 <sys_setpath+0x4b>
80106ef9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106efc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f00:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106f07:	e8 21 e8 ff ff       	call   8010572d <argint>
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	79 07                	jns    80106f17 <sys_setpath+0x52>
    return -1;
80106f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f15:	eb 19                	jmp    80106f30 <sys_setpath+0x6b>
  }

  return setpath(index, path, remove);
80106f17:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106f1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f20:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106f24:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f28:	89 04 24             	mov    %eax,(%esp)
80106f2b:	e8 85 22 00 00       	call   801091b5 <setpath>
}
80106f30:	c9                   	leave  
80106f31:	c3                   	ret    
	...

80106f34 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106f34:	1e                   	push   %ds
  pushl %es
80106f35:	06                   	push   %es
  pushl %fs
80106f36:	0f a0                	push   %fs
  pushl %gs
80106f38:	0f a8                	push   %gs
  pushal
80106f3a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106f3b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106f3f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106f41:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106f43:	54                   	push   %esp
  call trap
80106f44:	e8 c0 01 00 00       	call   80107109 <trap>
  addl $4, %esp
80106f49:	83 c4 04             	add    $0x4,%esp

80106f4c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106f4c:	61                   	popa   
  popl %gs
80106f4d:	0f a9                	pop    %gs
  popl %fs
80106f4f:	0f a1                	pop    %fs
  popl %es
80106f51:	07                   	pop    %es
  popl %ds
80106f52:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106f53:	83 c4 08             	add    $0x8,%esp
  iret
80106f56:	cf                   	iret   
	...

80106f58 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106f58:	55                   	push   %ebp
80106f59:	89 e5                	mov    %esp,%ebp
80106f5b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f61:	48                   	dec    %eax
80106f62:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106f66:	8b 45 08             	mov    0x8(%ebp),%eax
80106f69:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f70:	c1 e8 10             	shr    $0x10,%eax
80106f73:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106f77:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106f7a:	0f 01 18             	lidtl  (%eax)
}
80106f7d:	c9                   	leave  
80106f7e:	c3                   	ret    

80106f7f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106f7f:	55                   	push   %ebp
80106f80:	89 e5                	mov    %esp,%ebp
80106f82:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106f85:	0f 20 d0             	mov    %cr2,%eax
80106f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106f8e:	c9                   	leave  
80106f8f:	c3                   	ret    

80106f90 <tvinit>:

uint ticks;

void
tvinit(void)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106f96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106f9d:	e9 b8 00 00 00       	jmp    8010705a <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fa5:	8b 04 85 d4 c0 10 80 	mov    -0x7fef3f2c(,%eax,4),%eax
80106fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106faf:	66 89 04 d5 e0 75 11 	mov    %ax,-0x7fee8a20(,%edx,8)
80106fb6:	80 
80106fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fba:	66 c7 04 c5 e2 75 11 	movw   $0x8,-0x7fee8a1e(,%eax,8)
80106fc1:	80 08 00 
80106fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fc7:	8a 14 c5 e4 75 11 80 	mov    -0x7fee8a1c(,%eax,8),%dl
80106fce:	83 e2 e0             	and    $0xffffffe0,%edx
80106fd1:	88 14 c5 e4 75 11 80 	mov    %dl,-0x7fee8a1c(,%eax,8)
80106fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fdb:	8a 14 c5 e4 75 11 80 	mov    -0x7fee8a1c(,%eax,8),%dl
80106fe2:	83 e2 1f             	and    $0x1f,%edx
80106fe5:	88 14 c5 e4 75 11 80 	mov    %dl,-0x7fee8a1c(,%eax,8)
80106fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fef:	8a 14 c5 e5 75 11 80 	mov    -0x7fee8a1b(,%eax,8),%dl
80106ff6:	83 e2 f0             	and    $0xfffffff0,%edx
80106ff9:	83 ca 0e             	or     $0xe,%edx
80106ffc:	88 14 c5 e5 75 11 80 	mov    %dl,-0x7fee8a1b(,%eax,8)
80107003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107006:	8a 14 c5 e5 75 11 80 	mov    -0x7fee8a1b(,%eax,8),%dl
8010700d:	83 e2 ef             	and    $0xffffffef,%edx
80107010:	88 14 c5 e5 75 11 80 	mov    %dl,-0x7fee8a1b(,%eax,8)
80107017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010701a:	8a 14 c5 e5 75 11 80 	mov    -0x7fee8a1b(,%eax,8),%dl
80107021:	83 e2 9f             	and    $0xffffff9f,%edx
80107024:	88 14 c5 e5 75 11 80 	mov    %dl,-0x7fee8a1b(,%eax,8)
8010702b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010702e:	8a 14 c5 e5 75 11 80 	mov    -0x7fee8a1b(,%eax,8),%dl
80107035:	83 ca 80             	or     $0xffffff80,%edx
80107038:	88 14 c5 e5 75 11 80 	mov    %dl,-0x7fee8a1b(,%eax,8)
8010703f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107042:	8b 04 85 d4 c0 10 80 	mov    -0x7fef3f2c(,%eax,4),%eax
80107049:	c1 e8 10             	shr    $0x10,%eax
8010704c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010704f:	66 89 04 d5 e6 75 11 	mov    %ax,-0x7fee8a1a(,%edx,8)
80107056:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107057:	ff 45 f4             	incl   -0xc(%ebp)
8010705a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80107061:	0f 8e 3b ff ff ff    	jle    80106fa2 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107067:	a1 d4 c1 10 80       	mov    0x8010c1d4,%eax
8010706c:	66 a3 e0 77 11 80    	mov    %ax,0x801177e0
80107072:	66 c7 05 e2 77 11 80 	movw   $0x8,0x801177e2
80107079:	08 00 
8010707b:	a0 e4 77 11 80       	mov    0x801177e4,%al
80107080:	83 e0 e0             	and    $0xffffffe0,%eax
80107083:	a2 e4 77 11 80       	mov    %al,0x801177e4
80107088:	a0 e4 77 11 80       	mov    0x801177e4,%al
8010708d:	83 e0 1f             	and    $0x1f,%eax
80107090:	a2 e4 77 11 80       	mov    %al,0x801177e4
80107095:	a0 e5 77 11 80       	mov    0x801177e5,%al
8010709a:	83 c8 0f             	or     $0xf,%eax
8010709d:	a2 e5 77 11 80       	mov    %al,0x801177e5
801070a2:	a0 e5 77 11 80       	mov    0x801177e5,%al
801070a7:	83 e0 ef             	and    $0xffffffef,%eax
801070aa:	a2 e5 77 11 80       	mov    %al,0x801177e5
801070af:	a0 e5 77 11 80       	mov    0x801177e5,%al
801070b4:	83 c8 60             	or     $0x60,%eax
801070b7:	a2 e5 77 11 80       	mov    %al,0x801177e5
801070bc:	a0 e5 77 11 80       	mov    0x801177e5,%al
801070c1:	83 c8 80             	or     $0xffffff80,%eax
801070c4:	a2 e5 77 11 80       	mov    %al,0x801177e5
801070c9:	a1 d4 c1 10 80       	mov    0x8010c1d4,%eax
801070ce:	c1 e8 10             	shr    $0x10,%eax
801070d1:	66 a3 e6 77 11 80    	mov    %ax,0x801177e6

  initlock(&tickslock, "time");
801070d7:	c7 44 24 04 58 9a 10 	movl   $0x80109a58,0x4(%esp)
801070de:	80 
801070df:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
801070e6:	e8 07 de ff ff       	call   80104ef2 <initlock>
}
801070eb:	c9                   	leave  
801070ec:	c3                   	ret    

801070ed <idtinit>:

void
idtinit(void)
{
801070ed:	55                   	push   %ebp
801070ee:	89 e5                	mov    %esp,%ebp
801070f0:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801070f3:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801070fa:	00 
801070fb:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
80107102:	e8 51 fe ff ff       	call   80106f58 <lidt>
}
80107107:	c9                   	leave  
80107108:	c3                   	ret    

80107109 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107109:	55                   	push   %ebp
8010710a:	89 e5                	mov    %esp,%ebp
8010710c:	57                   	push   %edi
8010710d:	56                   	push   %esi
8010710e:	53                   	push   %ebx
8010710f:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80107112:	8b 45 08             	mov    0x8(%ebp),%eax
80107115:	8b 40 30             	mov    0x30(%eax),%eax
80107118:	83 f8 40             	cmp    $0x40,%eax
8010711b:	75 3c                	jne    80107159 <trap+0x50>
    if(myproc()->killed)
8010711d:	e8 e1 d1 ff ff       	call   80104303 <myproc>
80107122:	8b 40 24             	mov    0x24(%eax),%eax
80107125:	85 c0                	test   %eax,%eax
80107127:	74 05                	je     8010712e <trap+0x25>
      exit();
80107129:	e8 37 d6 ff ff       	call   80104765 <exit>
    myproc()->tf = tf;
8010712e:	e8 d0 d1 ff ff       	call   80104303 <myproc>
80107133:	8b 55 08             	mov    0x8(%ebp),%edx
80107136:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107139:	e8 bd e6 ff ff       	call   801057fb <syscall>
    if(myproc()->killed)
8010713e:	e8 c0 d1 ff ff       	call   80104303 <myproc>
80107143:	8b 40 24             	mov    0x24(%eax),%eax
80107146:	85 c0                	test   %eax,%eax
80107148:	74 0a                	je     80107154 <trap+0x4b>
      exit();
8010714a:	e8 16 d6 ff ff       	call   80104765 <exit>
    return;
8010714f:	e9 13 02 00 00       	jmp    80107367 <trap+0x25e>
80107154:	e9 0e 02 00 00       	jmp    80107367 <trap+0x25e>
  }

  switch(tf->trapno){
80107159:	8b 45 08             	mov    0x8(%ebp),%eax
8010715c:	8b 40 30             	mov    0x30(%eax),%eax
8010715f:	83 e8 20             	sub    $0x20,%eax
80107162:	83 f8 1f             	cmp    $0x1f,%eax
80107165:	0f 87 ae 00 00 00    	ja     80107219 <trap+0x110>
8010716b:	8b 04 85 00 9b 10 80 	mov    -0x7fef6500(,%eax,4),%eax
80107172:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80107174:	e8 c1 d0 ff ff       	call   8010423a <cpuid>
80107179:	85 c0                	test   %eax,%eax
8010717b:	75 2f                	jne    801071ac <trap+0xa3>
      acquire(&tickslock);
8010717d:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
80107184:	e8 8a dd ff ff       	call   80104f13 <acquire>
      ticks++;
80107189:	a1 e0 7d 11 80       	mov    0x80117de0,%eax
8010718e:	40                   	inc    %eax
8010718f:	a3 e0 7d 11 80       	mov    %eax,0x80117de0
      // myproc()->ticks++;
      wakeup(&ticks);
80107194:	c7 04 24 e0 7d 11 80 	movl   $0x80117de0,(%esp)
8010719b:	e8 78 da ff ff       	call   80104c18 <wakeup>
      release(&tickslock);
801071a0:	c7 04 24 a0 75 11 80 	movl   $0x801175a0,(%esp)
801071a7:	e8 d1 dd ff ff       	call   80104f7d <release>
    }
    lapiceoi();
801071ac:	e8 32 bf ff ff       	call   801030e3 <lapiceoi>
    break;
801071b1:	e9 35 01 00 00       	jmp    801072eb <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801071b6:	e8 a7 b7 ff ff       	call   80102962 <ideintr>
    lapiceoi();
801071bb:	e8 23 bf ff ff       	call   801030e3 <lapiceoi>
    break;
801071c0:	e9 26 01 00 00       	jmp    801072eb <trap+0x1e2>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801071c5:	e8 30 bd ff ff       	call   80102efa <kbdintr>
    lapiceoi();
801071ca:	e8 14 bf ff ff       	call   801030e3 <lapiceoi>
    break;
801071cf:	e9 17 01 00 00       	jmp    801072eb <trap+0x1e2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801071d4:	e8 70 03 00 00       	call   80107549 <uartintr>
    lapiceoi();
801071d9:	e8 05 bf ff ff       	call   801030e3 <lapiceoi>
    break;
801071de:	e9 08 01 00 00       	jmp    801072eb <trap+0x1e2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071e3:	8b 45 08             	mov    0x8(%ebp),%eax
801071e6:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801071e9:	8b 45 08             	mov    0x8(%ebp),%eax
801071ec:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071ef:	0f b7 d8             	movzwl %ax,%ebx
801071f2:	e8 43 d0 ff ff       	call   8010423a <cpuid>
801071f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
801071fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801071ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80107203:	c7 04 24 60 9a 10 80 	movl   $0x80109a60,(%esp)
8010720a:	e8 b2 91 ff ff       	call   801003c1 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
8010720f:	e8 cf be ff ff       	call   801030e3 <lapiceoi>
    break;
80107214:	e9 d2 00 00 00       	jmp    801072eb <trap+0x1e2>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80107219:	e8 e5 d0 ff ff       	call   80104303 <myproc>
8010721e:	85 c0                	test   %eax,%eax
80107220:	74 10                	je     80107232 <trap+0x129>
80107222:	8b 45 08             	mov    0x8(%ebp),%eax
80107225:	8b 40 3c             	mov    0x3c(%eax),%eax
80107228:	0f b7 c0             	movzwl %ax,%eax
8010722b:	83 e0 03             	and    $0x3,%eax
8010722e:	85 c0                	test   %eax,%eax
80107230:	75 40                	jne    80107272 <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107232:	e8 48 fd ff ff       	call   80106f7f <rcr2>
80107237:	89 c3                	mov    %eax,%ebx
80107239:	8b 45 08             	mov    0x8(%ebp),%eax
8010723c:	8b 70 38             	mov    0x38(%eax),%esi
8010723f:	e8 f6 cf ff ff       	call   8010423a <cpuid>
80107244:	8b 55 08             	mov    0x8(%ebp),%edx
80107247:	8b 52 30             	mov    0x30(%edx),%edx
8010724a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010724e:	89 74 24 0c          	mov    %esi,0xc(%esp)
80107252:	89 44 24 08          	mov    %eax,0x8(%esp)
80107256:	89 54 24 04          	mov    %edx,0x4(%esp)
8010725a:	c7 04 24 84 9a 10 80 	movl   $0x80109a84,(%esp)
80107261:	e8 5b 91 ff ff       	call   801003c1 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80107266:	c7 04 24 b6 9a 10 80 	movl   $0x80109ab6,(%esp)
8010726d:	e8 e2 92 ff ff       	call   80100554 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107272:	e8 08 fd ff ff       	call   80106f7f <rcr2>
80107277:	89 c6                	mov    %eax,%esi
80107279:	8b 45 08             	mov    0x8(%ebp),%eax
8010727c:	8b 40 38             	mov    0x38(%eax),%eax
8010727f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107282:	e8 b3 cf ff ff       	call   8010423a <cpuid>
80107287:	89 c3                	mov    %eax,%ebx
80107289:	8b 45 08             	mov    0x8(%ebp),%eax
8010728c:	8b 78 34             	mov    0x34(%eax),%edi
8010728f:	89 7d e0             	mov    %edi,-0x20(%ebp)
80107292:	8b 45 08             	mov    0x8(%ebp),%eax
80107295:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80107298:	e8 66 d0 ff ff       	call   80104303 <myproc>
8010729d:	8d 50 6c             	lea    0x6c(%eax),%edx
801072a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801072a3:	e8 5b d0 ff ff       	call   80104303 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801072a8:	8b 40 10             	mov    0x10(%eax),%eax
801072ab:	89 74 24 1c          	mov    %esi,0x1c(%esp)
801072af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072b2:	89 4c 24 18          	mov    %ecx,0x18(%esp)
801072b6:	89 5c 24 14          	mov    %ebx,0x14(%esp)
801072ba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801072bd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801072c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801072c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801072c8:	89 54 24 08          	mov    %edx,0x8(%esp)
801072cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801072d0:	c7 04 24 bc 9a 10 80 	movl   $0x80109abc,(%esp)
801072d7:	e8 e5 90 ff ff       	call   801003c1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801072dc:	e8 22 d0 ff ff       	call   80104303 <myproc>
801072e1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801072e8:	eb 01                	jmp    801072eb <trap+0x1e2>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801072ea:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801072eb:	e8 13 d0 ff ff       	call   80104303 <myproc>
801072f0:	85 c0                	test   %eax,%eax
801072f2:	74 22                	je     80107316 <trap+0x20d>
801072f4:	e8 0a d0 ff ff       	call   80104303 <myproc>
801072f9:	8b 40 24             	mov    0x24(%eax),%eax
801072fc:	85 c0                	test   %eax,%eax
801072fe:	74 16                	je     80107316 <trap+0x20d>
80107300:	8b 45 08             	mov    0x8(%ebp),%eax
80107303:	8b 40 3c             	mov    0x3c(%eax),%eax
80107306:	0f b7 c0             	movzwl %ax,%eax
80107309:	83 e0 03             	and    $0x3,%eax
8010730c:	83 f8 03             	cmp    $0x3,%eax
8010730f:	75 05                	jne    80107316 <trap+0x20d>
    exit();
80107311:	e8 4f d4 ff ff       	call   80104765 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107316:	e8 e8 cf ff ff       	call   80104303 <myproc>
8010731b:	85 c0                	test   %eax,%eax
8010731d:	74 1d                	je     8010733c <trap+0x233>
8010731f:	e8 df cf ff ff       	call   80104303 <myproc>
80107324:	8b 40 0c             	mov    0xc(%eax),%eax
80107327:	83 f8 04             	cmp    $0x4,%eax
8010732a:	75 10                	jne    8010733c <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
8010732c:	8b 45 08             	mov    0x8(%ebp),%eax
8010732f:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107332:	83 f8 20             	cmp    $0x20,%eax
80107335:	75 05                	jne    8010733c <trap+0x233>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80107337:	e8 98 d7 ff ff       	call   80104ad4 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010733c:	e8 c2 cf ff ff       	call   80104303 <myproc>
80107341:	85 c0                	test   %eax,%eax
80107343:	74 22                	je     80107367 <trap+0x25e>
80107345:	e8 b9 cf ff ff       	call   80104303 <myproc>
8010734a:	8b 40 24             	mov    0x24(%eax),%eax
8010734d:	85 c0                	test   %eax,%eax
8010734f:	74 16                	je     80107367 <trap+0x25e>
80107351:	8b 45 08             	mov    0x8(%ebp),%eax
80107354:	8b 40 3c             	mov    0x3c(%eax),%eax
80107357:	0f b7 c0             	movzwl %ax,%eax
8010735a:	83 e0 03             	and    $0x3,%eax
8010735d:	83 f8 03             	cmp    $0x3,%eax
80107360:	75 05                	jne    80107367 <trap+0x25e>
    exit();
80107362:	e8 fe d3 ff ff       	call   80104765 <exit>
}
80107367:	83 c4 3c             	add    $0x3c,%esp
8010736a:	5b                   	pop    %ebx
8010736b:	5e                   	pop    %esi
8010736c:	5f                   	pop    %edi
8010736d:	5d                   	pop    %ebp
8010736e:	c3                   	ret    
	...

80107370 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	83 ec 14             	sub    $0x14,%esp
80107376:	8b 45 08             	mov    0x8(%ebp),%eax
80107379:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010737d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107380:	89 c2                	mov    %eax,%edx
80107382:	ec                   	in     (%dx),%al
80107383:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107386:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80107389:	c9                   	leave  
8010738a:	c3                   	ret    

8010738b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010738b:	55                   	push   %ebp
8010738c:	89 e5                	mov    %esp,%ebp
8010738e:	83 ec 08             	sub    $0x8,%esp
80107391:	8b 45 08             	mov    0x8(%ebp),%eax
80107394:	8b 55 0c             	mov    0xc(%ebp),%edx
80107397:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010739b:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010739e:	8a 45 f8             	mov    -0x8(%ebp),%al
801073a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801073a4:	ee                   	out    %al,(%dx)
}
801073a5:	c9                   	leave  
801073a6:	c3                   	ret    

801073a7 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801073a7:	55                   	push   %ebp
801073a8:	89 e5                	mov    %esp,%ebp
801073aa:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801073ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073b4:	00 
801073b5:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801073bc:	e8 ca ff ff ff       	call   8010738b <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801073c1:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801073c8:	00 
801073c9:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801073d0:	e8 b6 ff ff ff       	call   8010738b <outb>
  outb(COM1+0, 115200/9600);
801073d5:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801073dc:	00 
801073dd:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073e4:	e8 a2 ff ff ff       	call   8010738b <outb>
  outb(COM1+1, 0);
801073e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073f0:	00 
801073f1:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801073f8:	e8 8e ff ff ff       	call   8010738b <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801073fd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107404:	00 
80107405:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010740c:	e8 7a ff ff ff       	call   8010738b <outb>
  outb(COM1+4, 0);
80107411:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107418:	00 
80107419:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107420:	e8 66 ff ff ff       	call   8010738b <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107425:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010742c:	00 
8010742d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107434:	e8 52 ff ff ff       	call   8010738b <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107439:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107440:	e8 2b ff ff ff       	call   80107370 <inb>
80107445:	3c ff                	cmp    $0xff,%al
80107447:	75 02                	jne    8010744b <uartinit+0xa4>
    return;
80107449:	eb 5b                	jmp    801074a6 <uartinit+0xff>
  uart = 1;
8010744b:	c7 05 88 c6 10 80 01 	movl   $0x1,0x8010c688
80107452:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107455:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010745c:	e8 0f ff ff ff       	call   80107370 <inb>
  inb(COM1+0);
80107461:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107468:	e8 03 ff ff ff       	call   80107370 <inb>
  ioapicenable(IRQ_COM1, 0);
8010746d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107474:	00 
80107475:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010747c:	e8 56 b7 ff ff       	call   80102bd7 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107481:	c7 45 f4 80 9b 10 80 	movl   $0x80109b80,-0xc(%ebp)
80107488:	eb 13                	jmp    8010749d <uartinit+0xf6>
    uartputc(*p);
8010748a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748d:	8a 00                	mov    (%eax),%al
8010748f:	0f be c0             	movsbl %al,%eax
80107492:	89 04 24             	mov    %eax,(%esp)
80107495:	e8 0e 00 00 00       	call   801074a8 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010749a:	ff 45 f4             	incl   -0xc(%ebp)
8010749d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a0:	8a 00                	mov    (%eax),%al
801074a2:	84 c0                	test   %al,%al
801074a4:	75 e4                	jne    8010748a <uartinit+0xe3>
    uartputc(*p);
}
801074a6:	c9                   	leave  
801074a7:	c3                   	ret    

801074a8 <uartputc>:

void
uartputc(int c)
{
801074a8:	55                   	push   %ebp
801074a9:	89 e5                	mov    %esp,%ebp
801074ab:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801074ae:	a1 88 c6 10 80       	mov    0x8010c688,%eax
801074b3:	85 c0                	test   %eax,%eax
801074b5:	75 02                	jne    801074b9 <uartputc+0x11>
    return;
801074b7:	eb 4a                	jmp    80107503 <uartputc+0x5b>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801074b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801074c0:	eb 0f                	jmp    801074d1 <uartputc+0x29>
    microdelay(10);
801074c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801074c9:	e8 3a bc ff ff       	call   80103108 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801074ce:	ff 45 f4             	incl   -0xc(%ebp)
801074d1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801074d5:	7f 16                	jg     801074ed <uartputc+0x45>
801074d7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801074de:	e8 8d fe ff ff       	call   80107370 <inb>
801074e3:	0f b6 c0             	movzbl %al,%eax
801074e6:	83 e0 20             	and    $0x20,%eax
801074e9:	85 c0                	test   %eax,%eax
801074eb:	74 d5                	je     801074c2 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801074ed:	8b 45 08             	mov    0x8(%ebp),%eax
801074f0:	0f b6 c0             	movzbl %al,%eax
801074f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801074f7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801074fe:	e8 88 fe ff ff       	call   8010738b <outb>
}
80107503:	c9                   	leave  
80107504:	c3                   	ret    

80107505 <uartgetc>:

static int
uartgetc(void)
{
80107505:	55                   	push   %ebp
80107506:	89 e5                	mov    %esp,%ebp
80107508:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010750b:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80107510:	85 c0                	test   %eax,%eax
80107512:	75 07                	jne    8010751b <uartgetc+0x16>
    return -1;
80107514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107519:	eb 2c                	jmp    80107547 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010751b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107522:	e8 49 fe ff ff       	call   80107370 <inb>
80107527:	0f b6 c0             	movzbl %al,%eax
8010752a:	83 e0 01             	and    $0x1,%eax
8010752d:	85 c0                	test   %eax,%eax
8010752f:	75 07                	jne    80107538 <uartgetc+0x33>
    return -1;
80107531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107536:	eb 0f                	jmp    80107547 <uartgetc+0x42>
  return inb(COM1+0);
80107538:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010753f:	e8 2c fe ff ff       	call   80107370 <inb>
80107544:	0f b6 c0             	movzbl %al,%eax
}
80107547:	c9                   	leave  
80107548:	c3                   	ret    

80107549 <uartintr>:

void
uartintr(void)
{
80107549:	55                   	push   %ebp
8010754a:	89 e5                	mov    %esp,%ebp
8010754c:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010754f:	c7 04 24 05 75 10 80 	movl   $0x80107505,(%esp)
80107556:	e8 9a 92 ff ff       	call   801007f5 <consoleintr>
}
8010755b:	c9                   	leave  
8010755c:	c3                   	ret    
8010755d:	00 00                	add    %al,(%eax)
	...

80107560 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $0
80107562:	6a 00                	push   $0x0
  jmp alltraps
80107564:	e9 cb f9 ff ff       	jmp    80106f34 <alltraps>

80107569 <vector1>:
.globl vector1
vector1:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $1
8010756b:	6a 01                	push   $0x1
  jmp alltraps
8010756d:	e9 c2 f9 ff ff       	jmp    80106f34 <alltraps>

80107572 <vector2>:
.globl vector2
vector2:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $2
80107574:	6a 02                	push   $0x2
  jmp alltraps
80107576:	e9 b9 f9 ff ff       	jmp    80106f34 <alltraps>

8010757b <vector3>:
.globl vector3
vector3:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $3
8010757d:	6a 03                	push   $0x3
  jmp alltraps
8010757f:	e9 b0 f9 ff ff       	jmp    80106f34 <alltraps>

80107584 <vector4>:
.globl vector4
vector4:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $4
80107586:	6a 04                	push   $0x4
  jmp alltraps
80107588:	e9 a7 f9 ff ff       	jmp    80106f34 <alltraps>

8010758d <vector5>:
.globl vector5
vector5:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $5
8010758f:	6a 05                	push   $0x5
  jmp alltraps
80107591:	e9 9e f9 ff ff       	jmp    80106f34 <alltraps>

80107596 <vector6>:
.globl vector6
vector6:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $6
80107598:	6a 06                	push   $0x6
  jmp alltraps
8010759a:	e9 95 f9 ff ff       	jmp    80106f34 <alltraps>

8010759f <vector7>:
.globl vector7
vector7:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $7
801075a1:	6a 07                	push   $0x7
  jmp alltraps
801075a3:	e9 8c f9 ff ff       	jmp    80106f34 <alltraps>

801075a8 <vector8>:
.globl vector8
vector8:
  pushl $8
801075a8:	6a 08                	push   $0x8
  jmp alltraps
801075aa:	e9 85 f9 ff ff       	jmp    80106f34 <alltraps>

801075af <vector9>:
.globl vector9
vector9:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $9
801075b1:	6a 09                	push   $0x9
  jmp alltraps
801075b3:	e9 7c f9 ff ff       	jmp    80106f34 <alltraps>

801075b8 <vector10>:
.globl vector10
vector10:
  pushl $10
801075b8:	6a 0a                	push   $0xa
  jmp alltraps
801075ba:	e9 75 f9 ff ff       	jmp    80106f34 <alltraps>

801075bf <vector11>:
.globl vector11
vector11:
  pushl $11
801075bf:	6a 0b                	push   $0xb
  jmp alltraps
801075c1:	e9 6e f9 ff ff       	jmp    80106f34 <alltraps>

801075c6 <vector12>:
.globl vector12
vector12:
  pushl $12
801075c6:	6a 0c                	push   $0xc
  jmp alltraps
801075c8:	e9 67 f9 ff ff       	jmp    80106f34 <alltraps>

801075cd <vector13>:
.globl vector13
vector13:
  pushl $13
801075cd:	6a 0d                	push   $0xd
  jmp alltraps
801075cf:	e9 60 f9 ff ff       	jmp    80106f34 <alltraps>

801075d4 <vector14>:
.globl vector14
vector14:
  pushl $14
801075d4:	6a 0e                	push   $0xe
  jmp alltraps
801075d6:	e9 59 f9 ff ff       	jmp    80106f34 <alltraps>

801075db <vector15>:
.globl vector15
vector15:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $15
801075dd:	6a 0f                	push   $0xf
  jmp alltraps
801075df:	e9 50 f9 ff ff       	jmp    80106f34 <alltraps>

801075e4 <vector16>:
.globl vector16
vector16:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $16
801075e6:	6a 10                	push   $0x10
  jmp alltraps
801075e8:	e9 47 f9 ff ff       	jmp    80106f34 <alltraps>

801075ed <vector17>:
.globl vector17
vector17:
  pushl $17
801075ed:	6a 11                	push   $0x11
  jmp alltraps
801075ef:	e9 40 f9 ff ff       	jmp    80106f34 <alltraps>

801075f4 <vector18>:
.globl vector18
vector18:
  pushl $0
801075f4:	6a 00                	push   $0x0
  pushl $18
801075f6:	6a 12                	push   $0x12
  jmp alltraps
801075f8:	e9 37 f9 ff ff       	jmp    80106f34 <alltraps>

801075fd <vector19>:
.globl vector19
vector19:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $19
801075ff:	6a 13                	push   $0x13
  jmp alltraps
80107601:	e9 2e f9 ff ff       	jmp    80106f34 <alltraps>

80107606 <vector20>:
.globl vector20
vector20:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $20
80107608:	6a 14                	push   $0x14
  jmp alltraps
8010760a:	e9 25 f9 ff ff       	jmp    80106f34 <alltraps>

8010760f <vector21>:
.globl vector21
vector21:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $21
80107611:	6a 15                	push   $0x15
  jmp alltraps
80107613:	e9 1c f9 ff ff       	jmp    80106f34 <alltraps>

80107618 <vector22>:
.globl vector22
vector22:
  pushl $0
80107618:	6a 00                	push   $0x0
  pushl $22
8010761a:	6a 16                	push   $0x16
  jmp alltraps
8010761c:	e9 13 f9 ff ff       	jmp    80106f34 <alltraps>

80107621 <vector23>:
.globl vector23
vector23:
  pushl $0
80107621:	6a 00                	push   $0x0
  pushl $23
80107623:	6a 17                	push   $0x17
  jmp alltraps
80107625:	e9 0a f9 ff ff       	jmp    80106f34 <alltraps>

8010762a <vector24>:
.globl vector24
vector24:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $24
8010762c:	6a 18                	push   $0x18
  jmp alltraps
8010762e:	e9 01 f9 ff ff       	jmp    80106f34 <alltraps>

80107633 <vector25>:
.globl vector25
vector25:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $25
80107635:	6a 19                	push   $0x19
  jmp alltraps
80107637:	e9 f8 f8 ff ff       	jmp    80106f34 <alltraps>

8010763c <vector26>:
.globl vector26
vector26:
  pushl $0
8010763c:	6a 00                	push   $0x0
  pushl $26
8010763e:	6a 1a                	push   $0x1a
  jmp alltraps
80107640:	e9 ef f8 ff ff       	jmp    80106f34 <alltraps>

80107645 <vector27>:
.globl vector27
vector27:
  pushl $0
80107645:	6a 00                	push   $0x0
  pushl $27
80107647:	6a 1b                	push   $0x1b
  jmp alltraps
80107649:	e9 e6 f8 ff ff       	jmp    80106f34 <alltraps>

8010764e <vector28>:
.globl vector28
vector28:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $28
80107650:	6a 1c                	push   $0x1c
  jmp alltraps
80107652:	e9 dd f8 ff ff       	jmp    80106f34 <alltraps>

80107657 <vector29>:
.globl vector29
vector29:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $29
80107659:	6a 1d                	push   $0x1d
  jmp alltraps
8010765b:	e9 d4 f8 ff ff       	jmp    80106f34 <alltraps>

80107660 <vector30>:
.globl vector30
vector30:
  pushl $0
80107660:	6a 00                	push   $0x0
  pushl $30
80107662:	6a 1e                	push   $0x1e
  jmp alltraps
80107664:	e9 cb f8 ff ff       	jmp    80106f34 <alltraps>

80107669 <vector31>:
.globl vector31
vector31:
  pushl $0
80107669:	6a 00                	push   $0x0
  pushl $31
8010766b:	6a 1f                	push   $0x1f
  jmp alltraps
8010766d:	e9 c2 f8 ff ff       	jmp    80106f34 <alltraps>

80107672 <vector32>:
.globl vector32
vector32:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $32
80107674:	6a 20                	push   $0x20
  jmp alltraps
80107676:	e9 b9 f8 ff ff       	jmp    80106f34 <alltraps>

8010767b <vector33>:
.globl vector33
vector33:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $33
8010767d:	6a 21                	push   $0x21
  jmp alltraps
8010767f:	e9 b0 f8 ff ff       	jmp    80106f34 <alltraps>

80107684 <vector34>:
.globl vector34
vector34:
  pushl $0
80107684:	6a 00                	push   $0x0
  pushl $34
80107686:	6a 22                	push   $0x22
  jmp alltraps
80107688:	e9 a7 f8 ff ff       	jmp    80106f34 <alltraps>

8010768d <vector35>:
.globl vector35
vector35:
  pushl $0
8010768d:	6a 00                	push   $0x0
  pushl $35
8010768f:	6a 23                	push   $0x23
  jmp alltraps
80107691:	e9 9e f8 ff ff       	jmp    80106f34 <alltraps>

80107696 <vector36>:
.globl vector36
vector36:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $36
80107698:	6a 24                	push   $0x24
  jmp alltraps
8010769a:	e9 95 f8 ff ff       	jmp    80106f34 <alltraps>

8010769f <vector37>:
.globl vector37
vector37:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $37
801076a1:	6a 25                	push   $0x25
  jmp alltraps
801076a3:	e9 8c f8 ff ff       	jmp    80106f34 <alltraps>

801076a8 <vector38>:
.globl vector38
vector38:
  pushl $0
801076a8:	6a 00                	push   $0x0
  pushl $38
801076aa:	6a 26                	push   $0x26
  jmp alltraps
801076ac:	e9 83 f8 ff ff       	jmp    80106f34 <alltraps>

801076b1 <vector39>:
.globl vector39
vector39:
  pushl $0
801076b1:	6a 00                	push   $0x0
  pushl $39
801076b3:	6a 27                	push   $0x27
  jmp alltraps
801076b5:	e9 7a f8 ff ff       	jmp    80106f34 <alltraps>

801076ba <vector40>:
.globl vector40
vector40:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $40
801076bc:	6a 28                	push   $0x28
  jmp alltraps
801076be:	e9 71 f8 ff ff       	jmp    80106f34 <alltraps>

801076c3 <vector41>:
.globl vector41
vector41:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $41
801076c5:	6a 29                	push   $0x29
  jmp alltraps
801076c7:	e9 68 f8 ff ff       	jmp    80106f34 <alltraps>

801076cc <vector42>:
.globl vector42
vector42:
  pushl $0
801076cc:	6a 00                	push   $0x0
  pushl $42
801076ce:	6a 2a                	push   $0x2a
  jmp alltraps
801076d0:	e9 5f f8 ff ff       	jmp    80106f34 <alltraps>

801076d5 <vector43>:
.globl vector43
vector43:
  pushl $0
801076d5:	6a 00                	push   $0x0
  pushl $43
801076d7:	6a 2b                	push   $0x2b
  jmp alltraps
801076d9:	e9 56 f8 ff ff       	jmp    80106f34 <alltraps>

801076de <vector44>:
.globl vector44
vector44:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $44
801076e0:	6a 2c                	push   $0x2c
  jmp alltraps
801076e2:	e9 4d f8 ff ff       	jmp    80106f34 <alltraps>

801076e7 <vector45>:
.globl vector45
vector45:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $45
801076e9:	6a 2d                	push   $0x2d
  jmp alltraps
801076eb:	e9 44 f8 ff ff       	jmp    80106f34 <alltraps>

801076f0 <vector46>:
.globl vector46
vector46:
  pushl $0
801076f0:	6a 00                	push   $0x0
  pushl $46
801076f2:	6a 2e                	push   $0x2e
  jmp alltraps
801076f4:	e9 3b f8 ff ff       	jmp    80106f34 <alltraps>

801076f9 <vector47>:
.globl vector47
vector47:
  pushl $0
801076f9:	6a 00                	push   $0x0
  pushl $47
801076fb:	6a 2f                	push   $0x2f
  jmp alltraps
801076fd:	e9 32 f8 ff ff       	jmp    80106f34 <alltraps>

80107702 <vector48>:
.globl vector48
vector48:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $48
80107704:	6a 30                	push   $0x30
  jmp alltraps
80107706:	e9 29 f8 ff ff       	jmp    80106f34 <alltraps>

8010770b <vector49>:
.globl vector49
vector49:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $49
8010770d:	6a 31                	push   $0x31
  jmp alltraps
8010770f:	e9 20 f8 ff ff       	jmp    80106f34 <alltraps>

80107714 <vector50>:
.globl vector50
vector50:
  pushl $0
80107714:	6a 00                	push   $0x0
  pushl $50
80107716:	6a 32                	push   $0x32
  jmp alltraps
80107718:	e9 17 f8 ff ff       	jmp    80106f34 <alltraps>

8010771d <vector51>:
.globl vector51
vector51:
  pushl $0
8010771d:	6a 00                	push   $0x0
  pushl $51
8010771f:	6a 33                	push   $0x33
  jmp alltraps
80107721:	e9 0e f8 ff ff       	jmp    80106f34 <alltraps>

80107726 <vector52>:
.globl vector52
vector52:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $52
80107728:	6a 34                	push   $0x34
  jmp alltraps
8010772a:	e9 05 f8 ff ff       	jmp    80106f34 <alltraps>

8010772f <vector53>:
.globl vector53
vector53:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $53
80107731:	6a 35                	push   $0x35
  jmp alltraps
80107733:	e9 fc f7 ff ff       	jmp    80106f34 <alltraps>

80107738 <vector54>:
.globl vector54
vector54:
  pushl $0
80107738:	6a 00                	push   $0x0
  pushl $54
8010773a:	6a 36                	push   $0x36
  jmp alltraps
8010773c:	e9 f3 f7 ff ff       	jmp    80106f34 <alltraps>

80107741 <vector55>:
.globl vector55
vector55:
  pushl $0
80107741:	6a 00                	push   $0x0
  pushl $55
80107743:	6a 37                	push   $0x37
  jmp alltraps
80107745:	e9 ea f7 ff ff       	jmp    80106f34 <alltraps>

8010774a <vector56>:
.globl vector56
vector56:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $56
8010774c:	6a 38                	push   $0x38
  jmp alltraps
8010774e:	e9 e1 f7 ff ff       	jmp    80106f34 <alltraps>

80107753 <vector57>:
.globl vector57
vector57:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $57
80107755:	6a 39                	push   $0x39
  jmp alltraps
80107757:	e9 d8 f7 ff ff       	jmp    80106f34 <alltraps>

8010775c <vector58>:
.globl vector58
vector58:
  pushl $0
8010775c:	6a 00                	push   $0x0
  pushl $58
8010775e:	6a 3a                	push   $0x3a
  jmp alltraps
80107760:	e9 cf f7 ff ff       	jmp    80106f34 <alltraps>

80107765 <vector59>:
.globl vector59
vector59:
  pushl $0
80107765:	6a 00                	push   $0x0
  pushl $59
80107767:	6a 3b                	push   $0x3b
  jmp alltraps
80107769:	e9 c6 f7 ff ff       	jmp    80106f34 <alltraps>

8010776e <vector60>:
.globl vector60
vector60:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $60
80107770:	6a 3c                	push   $0x3c
  jmp alltraps
80107772:	e9 bd f7 ff ff       	jmp    80106f34 <alltraps>

80107777 <vector61>:
.globl vector61
vector61:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $61
80107779:	6a 3d                	push   $0x3d
  jmp alltraps
8010777b:	e9 b4 f7 ff ff       	jmp    80106f34 <alltraps>

80107780 <vector62>:
.globl vector62
vector62:
  pushl $0
80107780:	6a 00                	push   $0x0
  pushl $62
80107782:	6a 3e                	push   $0x3e
  jmp alltraps
80107784:	e9 ab f7 ff ff       	jmp    80106f34 <alltraps>

80107789 <vector63>:
.globl vector63
vector63:
  pushl $0
80107789:	6a 00                	push   $0x0
  pushl $63
8010778b:	6a 3f                	push   $0x3f
  jmp alltraps
8010778d:	e9 a2 f7 ff ff       	jmp    80106f34 <alltraps>

80107792 <vector64>:
.globl vector64
vector64:
  pushl $0
80107792:	6a 00                	push   $0x0
  pushl $64
80107794:	6a 40                	push   $0x40
  jmp alltraps
80107796:	e9 99 f7 ff ff       	jmp    80106f34 <alltraps>

8010779b <vector65>:
.globl vector65
vector65:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $65
8010779d:	6a 41                	push   $0x41
  jmp alltraps
8010779f:	e9 90 f7 ff ff       	jmp    80106f34 <alltraps>

801077a4 <vector66>:
.globl vector66
vector66:
  pushl $0
801077a4:	6a 00                	push   $0x0
  pushl $66
801077a6:	6a 42                	push   $0x42
  jmp alltraps
801077a8:	e9 87 f7 ff ff       	jmp    80106f34 <alltraps>

801077ad <vector67>:
.globl vector67
vector67:
  pushl $0
801077ad:	6a 00                	push   $0x0
  pushl $67
801077af:	6a 43                	push   $0x43
  jmp alltraps
801077b1:	e9 7e f7 ff ff       	jmp    80106f34 <alltraps>

801077b6 <vector68>:
.globl vector68
vector68:
  pushl $0
801077b6:	6a 00                	push   $0x0
  pushl $68
801077b8:	6a 44                	push   $0x44
  jmp alltraps
801077ba:	e9 75 f7 ff ff       	jmp    80106f34 <alltraps>

801077bf <vector69>:
.globl vector69
vector69:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $69
801077c1:	6a 45                	push   $0x45
  jmp alltraps
801077c3:	e9 6c f7 ff ff       	jmp    80106f34 <alltraps>

801077c8 <vector70>:
.globl vector70
vector70:
  pushl $0
801077c8:	6a 00                	push   $0x0
  pushl $70
801077ca:	6a 46                	push   $0x46
  jmp alltraps
801077cc:	e9 63 f7 ff ff       	jmp    80106f34 <alltraps>

801077d1 <vector71>:
.globl vector71
vector71:
  pushl $0
801077d1:	6a 00                	push   $0x0
  pushl $71
801077d3:	6a 47                	push   $0x47
  jmp alltraps
801077d5:	e9 5a f7 ff ff       	jmp    80106f34 <alltraps>

801077da <vector72>:
.globl vector72
vector72:
  pushl $0
801077da:	6a 00                	push   $0x0
  pushl $72
801077dc:	6a 48                	push   $0x48
  jmp alltraps
801077de:	e9 51 f7 ff ff       	jmp    80106f34 <alltraps>

801077e3 <vector73>:
.globl vector73
vector73:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $73
801077e5:	6a 49                	push   $0x49
  jmp alltraps
801077e7:	e9 48 f7 ff ff       	jmp    80106f34 <alltraps>

801077ec <vector74>:
.globl vector74
vector74:
  pushl $0
801077ec:	6a 00                	push   $0x0
  pushl $74
801077ee:	6a 4a                	push   $0x4a
  jmp alltraps
801077f0:	e9 3f f7 ff ff       	jmp    80106f34 <alltraps>

801077f5 <vector75>:
.globl vector75
vector75:
  pushl $0
801077f5:	6a 00                	push   $0x0
  pushl $75
801077f7:	6a 4b                	push   $0x4b
  jmp alltraps
801077f9:	e9 36 f7 ff ff       	jmp    80106f34 <alltraps>

801077fe <vector76>:
.globl vector76
vector76:
  pushl $0
801077fe:	6a 00                	push   $0x0
  pushl $76
80107800:	6a 4c                	push   $0x4c
  jmp alltraps
80107802:	e9 2d f7 ff ff       	jmp    80106f34 <alltraps>

80107807 <vector77>:
.globl vector77
vector77:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $77
80107809:	6a 4d                	push   $0x4d
  jmp alltraps
8010780b:	e9 24 f7 ff ff       	jmp    80106f34 <alltraps>

80107810 <vector78>:
.globl vector78
vector78:
  pushl $0
80107810:	6a 00                	push   $0x0
  pushl $78
80107812:	6a 4e                	push   $0x4e
  jmp alltraps
80107814:	e9 1b f7 ff ff       	jmp    80106f34 <alltraps>

80107819 <vector79>:
.globl vector79
vector79:
  pushl $0
80107819:	6a 00                	push   $0x0
  pushl $79
8010781b:	6a 4f                	push   $0x4f
  jmp alltraps
8010781d:	e9 12 f7 ff ff       	jmp    80106f34 <alltraps>

80107822 <vector80>:
.globl vector80
vector80:
  pushl $0
80107822:	6a 00                	push   $0x0
  pushl $80
80107824:	6a 50                	push   $0x50
  jmp alltraps
80107826:	e9 09 f7 ff ff       	jmp    80106f34 <alltraps>

8010782b <vector81>:
.globl vector81
vector81:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $81
8010782d:	6a 51                	push   $0x51
  jmp alltraps
8010782f:	e9 00 f7 ff ff       	jmp    80106f34 <alltraps>

80107834 <vector82>:
.globl vector82
vector82:
  pushl $0
80107834:	6a 00                	push   $0x0
  pushl $82
80107836:	6a 52                	push   $0x52
  jmp alltraps
80107838:	e9 f7 f6 ff ff       	jmp    80106f34 <alltraps>

8010783d <vector83>:
.globl vector83
vector83:
  pushl $0
8010783d:	6a 00                	push   $0x0
  pushl $83
8010783f:	6a 53                	push   $0x53
  jmp alltraps
80107841:	e9 ee f6 ff ff       	jmp    80106f34 <alltraps>

80107846 <vector84>:
.globl vector84
vector84:
  pushl $0
80107846:	6a 00                	push   $0x0
  pushl $84
80107848:	6a 54                	push   $0x54
  jmp alltraps
8010784a:	e9 e5 f6 ff ff       	jmp    80106f34 <alltraps>

8010784f <vector85>:
.globl vector85
vector85:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $85
80107851:	6a 55                	push   $0x55
  jmp alltraps
80107853:	e9 dc f6 ff ff       	jmp    80106f34 <alltraps>

80107858 <vector86>:
.globl vector86
vector86:
  pushl $0
80107858:	6a 00                	push   $0x0
  pushl $86
8010785a:	6a 56                	push   $0x56
  jmp alltraps
8010785c:	e9 d3 f6 ff ff       	jmp    80106f34 <alltraps>

80107861 <vector87>:
.globl vector87
vector87:
  pushl $0
80107861:	6a 00                	push   $0x0
  pushl $87
80107863:	6a 57                	push   $0x57
  jmp alltraps
80107865:	e9 ca f6 ff ff       	jmp    80106f34 <alltraps>

8010786a <vector88>:
.globl vector88
vector88:
  pushl $0
8010786a:	6a 00                	push   $0x0
  pushl $88
8010786c:	6a 58                	push   $0x58
  jmp alltraps
8010786e:	e9 c1 f6 ff ff       	jmp    80106f34 <alltraps>

80107873 <vector89>:
.globl vector89
vector89:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $89
80107875:	6a 59                	push   $0x59
  jmp alltraps
80107877:	e9 b8 f6 ff ff       	jmp    80106f34 <alltraps>

8010787c <vector90>:
.globl vector90
vector90:
  pushl $0
8010787c:	6a 00                	push   $0x0
  pushl $90
8010787e:	6a 5a                	push   $0x5a
  jmp alltraps
80107880:	e9 af f6 ff ff       	jmp    80106f34 <alltraps>

80107885 <vector91>:
.globl vector91
vector91:
  pushl $0
80107885:	6a 00                	push   $0x0
  pushl $91
80107887:	6a 5b                	push   $0x5b
  jmp alltraps
80107889:	e9 a6 f6 ff ff       	jmp    80106f34 <alltraps>

8010788e <vector92>:
.globl vector92
vector92:
  pushl $0
8010788e:	6a 00                	push   $0x0
  pushl $92
80107890:	6a 5c                	push   $0x5c
  jmp alltraps
80107892:	e9 9d f6 ff ff       	jmp    80106f34 <alltraps>

80107897 <vector93>:
.globl vector93
vector93:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $93
80107899:	6a 5d                	push   $0x5d
  jmp alltraps
8010789b:	e9 94 f6 ff ff       	jmp    80106f34 <alltraps>

801078a0 <vector94>:
.globl vector94
vector94:
  pushl $0
801078a0:	6a 00                	push   $0x0
  pushl $94
801078a2:	6a 5e                	push   $0x5e
  jmp alltraps
801078a4:	e9 8b f6 ff ff       	jmp    80106f34 <alltraps>

801078a9 <vector95>:
.globl vector95
vector95:
  pushl $0
801078a9:	6a 00                	push   $0x0
  pushl $95
801078ab:	6a 5f                	push   $0x5f
  jmp alltraps
801078ad:	e9 82 f6 ff ff       	jmp    80106f34 <alltraps>

801078b2 <vector96>:
.globl vector96
vector96:
  pushl $0
801078b2:	6a 00                	push   $0x0
  pushl $96
801078b4:	6a 60                	push   $0x60
  jmp alltraps
801078b6:	e9 79 f6 ff ff       	jmp    80106f34 <alltraps>

801078bb <vector97>:
.globl vector97
vector97:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $97
801078bd:	6a 61                	push   $0x61
  jmp alltraps
801078bf:	e9 70 f6 ff ff       	jmp    80106f34 <alltraps>

801078c4 <vector98>:
.globl vector98
vector98:
  pushl $0
801078c4:	6a 00                	push   $0x0
  pushl $98
801078c6:	6a 62                	push   $0x62
  jmp alltraps
801078c8:	e9 67 f6 ff ff       	jmp    80106f34 <alltraps>

801078cd <vector99>:
.globl vector99
vector99:
  pushl $0
801078cd:	6a 00                	push   $0x0
  pushl $99
801078cf:	6a 63                	push   $0x63
  jmp alltraps
801078d1:	e9 5e f6 ff ff       	jmp    80106f34 <alltraps>

801078d6 <vector100>:
.globl vector100
vector100:
  pushl $0
801078d6:	6a 00                	push   $0x0
  pushl $100
801078d8:	6a 64                	push   $0x64
  jmp alltraps
801078da:	e9 55 f6 ff ff       	jmp    80106f34 <alltraps>

801078df <vector101>:
.globl vector101
vector101:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $101
801078e1:	6a 65                	push   $0x65
  jmp alltraps
801078e3:	e9 4c f6 ff ff       	jmp    80106f34 <alltraps>

801078e8 <vector102>:
.globl vector102
vector102:
  pushl $0
801078e8:	6a 00                	push   $0x0
  pushl $102
801078ea:	6a 66                	push   $0x66
  jmp alltraps
801078ec:	e9 43 f6 ff ff       	jmp    80106f34 <alltraps>

801078f1 <vector103>:
.globl vector103
vector103:
  pushl $0
801078f1:	6a 00                	push   $0x0
  pushl $103
801078f3:	6a 67                	push   $0x67
  jmp alltraps
801078f5:	e9 3a f6 ff ff       	jmp    80106f34 <alltraps>

801078fa <vector104>:
.globl vector104
vector104:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $104
801078fc:	6a 68                	push   $0x68
  jmp alltraps
801078fe:	e9 31 f6 ff ff       	jmp    80106f34 <alltraps>

80107903 <vector105>:
.globl vector105
vector105:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $105
80107905:	6a 69                	push   $0x69
  jmp alltraps
80107907:	e9 28 f6 ff ff       	jmp    80106f34 <alltraps>

8010790c <vector106>:
.globl vector106
vector106:
  pushl $0
8010790c:	6a 00                	push   $0x0
  pushl $106
8010790e:	6a 6a                	push   $0x6a
  jmp alltraps
80107910:	e9 1f f6 ff ff       	jmp    80106f34 <alltraps>

80107915 <vector107>:
.globl vector107
vector107:
  pushl $0
80107915:	6a 00                	push   $0x0
  pushl $107
80107917:	6a 6b                	push   $0x6b
  jmp alltraps
80107919:	e9 16 f6 ff ff       	jmp    80106f34 <alltraps>

8010791e <vector108>:
.globl vector108
vector108:
  pushl $0
8010791e:	6a 00                	push   $0x0
  pushl $108
80107920:	6a 6c                	push   $0x6c
  jmp alltraps
80107922:	e9 0d f6 ff ff       	jmp    80106f34 <alltraps>

80107927 <vector109>:
.globl vector109
vector109:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $109
80107929:	6a 6d                	push   $0x6d
  jmp alltraps
8010792b:	e9 04 f6 ff ff       	jmp    80106f34 <alltraps>

80107930 <vector110>:
.globl vector110
vector110:
  pushl $0
80107930:	6a 00                	push   $0x0
  pushl $110
80107932:	6a 6e                	push   $0x6e
  jmp alltraps
80107934:	e9 fb f5 ff ff       	jmp    80106f34 <alltraps>

80107939 <vector111>:
.globl vector111
vector111:
  pushl $0
80107939:	6a 00                	push   $0x0
  pushl $111
8010793b:	6a 6f                	push   $0x6f
  jmp alltraps
8010793d:	e9 f2 f5 ff ff       	jmp    80106f34 <alltraps>

80107942 <vector112>:
.globl vector112
vector112:
  pushl $0
80107942:	6a 00                	push   $0x0
  pushl $112
80107944:	6a 70                	push   $0x70
  jmp alltraps
80107946:	e9 e9 f5 ff ff       	jmp    80106f34 <alltraps>

8010794b <vector113>:
.globl vector113
vector113:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $113
8010794d:	6a 71                	push   $0x71
  jmp alltraps
8010794f:	e9 e0 f5 ff ff       	jmp    80106f34 <alltraps>

80107954 <vector114>:
.globl vector114
vector114:
  pushl $0
80107954:	6a 00                	push   $0x0
  pushl $114
80107956:	6a 72                	push   $0x72
  jmp alltraps
80107958:	e9 d7 f5 ff ff       	jmp    80106f34 <alltraps>

8010795d <vector115>:
.globl vector115
vector115:
  pushl $0
8010795d:	6a 00                	push   $0x0
  pushl $115
8010795f:	6a 73                	push   $0x73
  jmp alltraps
80107961:	e9 ce f5 ff ff       	jmp    80106f34 <alltraps>

80107966 <vector116>:
.globl vector116
vector116:
  pushl $0
80107966:	6a 00                	push   $0x0
  pushl $116
80107968:	6a 74                	push   $0x74
  jmp alltraps
8010796a:	e9 c5 f5 ff ff       	jmp    80106f34 <alltraps>

8010796f <vector117>:
.globl vector117
vector117:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $117
80107971:	6a 75                	push   $0x75
  jmp alltraps
80107973:	e9 bc f5 ff ff       	jmp    80106f34 <alltraps>

80107978 <vector118>:
.globl vector118
vector118:
  pushl $0
80107978:	6a 00                	push   $0x0
  pushl $118
8010797a:	6a 76                	push   $0x76
  jmp alltraps
8010797c:	e9 b3 f5 ff ff       	jmp    80106f34 <alltraps>

80107981 <vector119>:
.globl vector119
vector119:
  pushl $0
80107981:	6a 00                	push   $0x0
  pushl $119
80107983:	6a 77                	push   $0x77
  jmp alltraps
80107985:	e9 aa f5 ff ff       	jmp    80106f34 <alltraps>

8010798a <vector120>:
.globl vector120
vector120:
  pushl $0
8010798a:	6a 00                	push   $0x0
  pushl $120
8010798c:	6a 78                	push   $0x78
  jmp alltraps
8010798e:	e9 a1 f5 ff ff       	jmp    80106f34 <alltraps>

80107993 <vector121>:
.globl vector121
vector121:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $121
80107995:	6a 79                	push   $0x79
  jmp alltraps
80107997:	e9 98 f5 ff ff       	jmp    80106f34 <alltraps>

8010799c <vector122>:
.globl vector122
vector122:
  pushl $0
8010799c:	6a 00                	push   $0x0
  pushl $122
8010799e:	6a 7a                	push   $0x7a
  jmp alltraps
801079a0:	e9 8f f5 ff ff       	jmp    80106f34 <alltraps>

801079a5 <vector123>:
.globl vector123
vector123:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $123
801079a7:	6a 7b                	push   $0x7b
  jmp alltraps
801079a9:	e9 86 f5 ff ff       	jmp    80106f34 <alltraps>

801079ae <vector124>:
.globl vector124
vector124:
  pushl $0
801079ae:	6a 00                	push   $0x0
  pushl $124
801079b0:	6a 7c                	push   $0x7c
  jmp alltraps
801079b2:	e9 7d f5 ff ff       	jmp    80106f34 <alltraps>

801079b7 <vector125>:
.globl vector125
vector125:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $125
801079b9:	6a 7d                	push   $0x7d
  jmp alltraps
801079bb:	e9 74 f5 ff ff       	jmp    80106f34 <alltraps>

801079c0 <vector126>:
.globl vector126
vector126:
  pushl $0
801079c0:	6a 00                	push   $0x0
  pushl $126
801079c2:	6a 7e                	push   $0x7e
  jmp alltraps
801079c4:	e9 6b f5 ff ff       	jmp    80106f34 <alltraps>

801079c9 <vector127>:
.globl vector127
vector127:
  pushl $0
801079c9:	6a 00                	push   $0x0
  pushl $127
801079cb:	6a 7f                	push   $0x7f
  jmp alltraps
801079cd:	e9 62 f5 ff ff       	jmp    80106f34 <alltraps>

801079d2 <vector128>:
.globl vector128
vector128:
  pushl $0
801079d2:	6a 00                	push   $0x0
  pushl $128
801079d4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801079d9:	e9 56 f5 ff ff       	jmp    80106f34 <alltraps>

801079de <vector129>:
.globl vector129
vector129:
  pushl $0
801079de:	6a 00                	push   $0x0
  pushl $129
801079e0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801079e5:	e9 4a f5 ff ff       	jmp    80106f34 <alltraps>

801079ea <vector130>:
.globl vector130
vector130:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $130
801079ec:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801079f1:	e9 3e f5 ff ff       	jmp    80106f34 <alltraps>

801079f6 <vector131>:
.globl vector131
vector131:
  pushl $0
801079f6:	6a 00                	push   $0x0
  pushl $131
801079f8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801079fd:	e9 32 f5 ff ff       	jmp    80106f34 <alltraps>

80107a02 <vector132>:
.globl vector132
vector132:
  pushl $0
80107a02:	6a 00                	push   $0x0
  pushl $132
80107a04:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107a09:	e9 26 f5 ff ff       	jmp    80106f34 <alltraps>

80107a0e <vector133>:
.globl vector133
vector133:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $133
80107a10:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107a15:	e9 1a f5 ff ff       	jmp    80106f34 <alltraps>

80107a1a <vector134>:
.globl vector134
vector134:
  pushl $0
80107a1a:	6a 00                	push   $0x0
  pushl $134
80107a1c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107a21:	e9 0e f5 ff ff       	jmp    80106f34 <alltraps>

80107a26 <vector135>:
.globl vector135
vector135:
  pushl $0
80107a26:	6a 00                	push   $0x0
  pushl $135
80107a28:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107a2d:	e9 02 f5 ff ff       	jmp    80106f34 <alltraps>

80107a32 <vector136>:
.globl vector136
vector136:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $136
80107a34:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107a39:	e9 f6 f4 ff ff       	jmp    80106f34 <alltraps>

80107a3e <vector137>:
.globl vector137
vector137:
  pushl $0
80107a3e:	6a 00                	push   $0x0
  pushl $137
80107a40:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107a45:	e9 ea f4 ff ff       	jmp    80106f34 <alltraps>

80107a4a <vector138>:
.globl vector138
vector138:
  pushl $0
80107a4a:	6a 00                	push   $0x0
  pushl $138
80107a4c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107a51:	e9 de f4 ff ff       	jmp    80106f34 <alltraps>

80107a56 <vector139>:
.globl vector139
vector139:
  pushl $0
80107a56:	6a 00                	push   $0x0
  pushl $139
80107a58:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107a5d:	e9 d2 f4 ff ff       	jmp    80106f34 <alltraps>

80107a62 <vector140>:
.globl vector140
vector140:
  pushl $0
80107a62:	6a 00                	push   $0x0
  pushl $140
80107a64:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107a69:	e9 c6 f4 ff ff       	jmp    80106f34 <alltraps>

80107a6e <vector141>:
.globl vector141
vector141:
  pushl $0
80107a6e:	6a 00                	push   $0x0
  pushl $141
80107a70:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107a75:	e9 ba f4 ff ff       	jmp    80106f34 <alltraps>

80107a7a <vector142>:
.globl vector142
vector142:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $142
80107a7c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107a81:	e9 ae f4 ff ff       	jmp    80106f34 <alltraps>

80107a86 <vector143>:
.globl vector143
vector143:
  pushl $0
80107a86:	6a 00                	push   $0x0
  pushl $143
80107a88:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107a8d:	e9 a2 f4 ff ff       	jmp    80106f34 <alltraps>

80107a92 <vector144>:
.globl vector144
vector144:
  pushl $0
80107a92:	6a 00                	push   $0x0
  pushl $144
80107a94:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107a99:	e9 96 f4 ff ff       	jmp    80106f34 <alltraps>

80107a9e <vector145>:
.globl vector145
vector145:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $145
80107aa0:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107aa5:	e9 8a f4 ff ff       	jmp    80106f34 <alltraps>

80107aaa <vector146>:
.globl vector146
vector146:
  pushl $0
80107aaa:	6a 00                	push   $0x0
  pushl $146
80107aac:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107ab1:	e9 7e f4 ff ff       	jmp    80106f34 <alltraps>

80107ab6 <vector147>:
.globl vector147
vector147:
  pushl $0
80107ab6:	6a 00                	push   $0x0
  pushl $147
80107ab8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107abd:	e9 72 f4 ff ff       	jmp    80106f34 <alltraps>

80107ac2 <vector148>:
.globl vector148
vector148:
  pushl $0
80107ac2:	6a 00                	push   $0x0
  pushl $148
80107ac4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107ac9:	e9 66 f4 ff ff       	jmp    80106f34 <alltraps>

80107ace <vector149>:
.globl vector149
vector149:
  pushl $0
80107ace:	6a 00                	push   $0x0
  pushl $149
80107ad0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107ad5:	e9 5a f4 ff ff       	jmp    80106f34 <alltraps>

80107ada <vector150>:
.globl vector150
vector150:
  pushl $0
80107ada:	6a 00                	push   $0x0
  pushl $150
80107adc:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107ae1:	e9 4e f4 ff ff       	jmp    80106f34 <alltraps>

80107ae6 <vector151>:
.globl vector151
vector151:
  pushl $0
80107ae6:	6a 00                	push   $0x0
  pushl $151
80107ae8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107aed:	e9 42 f4 ff ff       	jmp    80106f34 <alltraps>

80107af2 <vector152>:
.globl vector152
vector152:
  pushl $0
80107af2:	6a 00                	push   $0x0
  pushl $152
80107af4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107af9:	e9 36 f4 ff ff       	jmp    80106f34 <alltraps>

80107afe <vector153>:
.globl vector153
vector153:
  pushl $0
80107afe:	6a 00                	push   $0x0
  pushl $153
80107b00:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107b05:	e9 2a f4 ff ff       	jmp    80106f34 <alltraps>

80107b0a <vector154>:
.globl vector154
vector154:
  pushl $0
80107b0a:	6a 00                	push   $0x0
  pushl $154
80107b0c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107b11:	e9 1e f4 ff ff       	jmp    80106f34 <alltraps>

80107b16 <vector155>:
.globl vector155
vector155:
  pushl $0
80107b16:	6a 00                	push   $0x0
  pushl $155
80107b18:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107b1d:	e9 12 f4 ff ff       	jmp    80106f34 <alltraps>

80107b22 <vector156>:
.globl vector156
vector156:
  pushl $0
80107b22:	6a 00                	push   $0x0
  pushl $156
80107b24:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107b29:	e9 06 f4 ff ff       	jmp    80106f34 <alltraps>

80107b2e <vector157>:
.globl vector157
vector157:
  pushl $0
80107b2e:	6a 00                	push   $0x0
  pushl $157
80107b30:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107b35:	e9 fa f3 ff ff       	jmp    80106f34 <alltraps>

80107b3a <vector158>:
.globl vector158
vector158:
  pushl $0
80107b3a:	6a 00                	push   $0x0
  pushl $158
80107b3c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107b41:	e9 ee f3 ff ff       	jmp    80106f34 <alltraps>

80107b46 <vector159>:
.globl vector159
vector159:
  pushl $0
80107b46:	6a 00                	push   $0x0
  pushl $159
80107b48:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107b4d:	e9 e2 f3 ff ff       	jmp    80106f34 <alltraps>

80107b52 <vector160>:
.globl vector160
vector160:
  pushl $0
80107b52:	6a 00                	push   $0x0
  pushl $160
80107b54:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107b59:	e9 d6 f3 ff ff       	jmp    80106f34 <alltraps>

80107b5e <vector161>:
.globl vector161
vector161:
  pushl $0
80107b5e:	6a 00                	push   $0x0
  pushl $161
80107b60:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107b65:	e9 ca f3 ff ff       	jmp    80106f34 <alltraps>

80107b6a <vector162>:
.globl vector162
vector162:
  pushl $0
80107b6a:	6a 00                	push   $0x0
  pushl $162
80107b6c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107b71:	e9 be f3 ff ff       	jmp    80106f34 <alltraps>

80107b76 <vector163>:
.globl vector163
vector163:
  pushl $0
80107b76:	6a 00                	push   $0x0
  pushl $163
80107b78:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107b7d:	e9 b2 f3 ff ff       	jmp    80106f34 <alltraps>

80107b82 <vector164>:
.globl vector164
vector164:
  pushl $0
80107b82:	6a 00                	push   $0x0
  pushl $164
80107b84:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107b89:	e9 a6 f3 ff ff       	jmp    80106f34 <alltraps>

80107b8e <vector165>:
.globl vector165
vector165:
  pushl $0
80107b8e:	6a 00                	push   $0x0
  pushl $165
80107b90:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107b95:	e9 9a f3 ff ff       	jmp    80106f34 <alltraps>

80107b9a <vector166>:
.globl vector166
vector166:
  pushl $0
80107b9a:	6a 00                	push   $0x0
  pushl $166
80107b9c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107ba1:	e9 8e f3 ff ff       	jmp    80106f34 <alltraps>

80107ba6 <vector167>:
.globl vector167
vector167:
  pushl $0
80107ba6:	6a 00                	push   $0x0
  pushl $167
80107ba8:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107bad:	e9 82 f3 ff ff       	jmp    80106f34 <alltraps>

80107bb2 <vector168>:
.globl vector168
vector168:
  pushl $0
80107bb2:	6a 00                	push   $0x0
  pushl $168
80107bb4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107bb9:	e9 76 f3 ff ff       	jmp    80106f34 <alltraps>

80107bbe <vector169>:
.globl vector169
vector169:
  pushl $0
80107bbe:	6a 00                	push   $0x0
  pushl $169
80107bc0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107bc5:	e9 6a f3 ff ff       	jmp    80106f34 <alltraps>

80107bca <vector170>:
.globl vector170
vector170:
  pushl $0
80107bca:	6a 00                	push   $0x0
  pushl $170
80107bcc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107bd1:	e9 5e f3 ff ff       	jmp    80106f34 <alltraps>

80107bd6 <vector171>:
.globl vector171
vector171:
  pushl $0
80107bd6:	6a 00                	push   $0x0
  pushl $171
80107bd8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107bdd:	e9 52 f3 ff ff       	jmp    80106f34 <alltraps>

80107be2 <vector172>:
.globl vector172
vector172:
  pushl $0
80107be2:	6a 00                	push   $0x0
  pushl $172
80107be4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107be9:	e9 46 f3 ff ff       	jmp    80106f34 <alltraps>

80107bee <vector173>:
.globl vector173
vector173:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $173
80107bf0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107bf5:	e9 3a f3 ff ff       	jmp    80106f34 <alltraps>

80107bfa <vector174>:
.globl vector174
vector174:
  pushl $0
80107bfa:	6a 00                	push   $0x0
  pushl $174
80107bfc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107c01:	e9 2e f3 ff ff       	jmp    80106f34 <alltraps>

80107c06 <vector175>:
.globl vector175
vector175:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $175
80107c08:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107c0d:	e9 22 f3 ff ff       	jmp    80106f34 <alltraps>

80107c12 <vector176>:
.globl vector176
vector176:
  pushl $0
80107c12:	6a 00                	push   $0x0
  pushl $176
80107c14:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107c19:	e9 16 f3 ff ff       	jmp    80106f34 <alltraps>

80107c1e <vector177>:
.globl vector177
vector177:
  pushl $0
80107c1e:	6a 00                	push   $0x0
  pushl $177
80107c20:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107c25:	e9 0a f3 ff ff       	jmp    80106f34 <alltraps>

80107c2a <vector178>:
.globl vector178
vector178:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $178
80107c2c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107c31:	e9 fe f2 ff ff       	jmp    80106f34 <alltraps>

80107c36 <vector179>:
.globl vector179
vector179:
  pushl $0
80107c36:	6a 00                	push   $0x0
  pushl $179
80107c38:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107c3d:	e9 f2 f2 ff ff       	jmp    80106f34 <alltraps>

80107c42 <vector180>:
.globl vector180
vector180:
  pushl $0
80107c42:	6a 00                	push   $0x0
  pushl $180
80107c44:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107c49:	e9 e6 f2 ff ff       	jmp    80106f34 <alltraps>

80107c4e <vector181>:
.globl vector181
vector181:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $181
80107c50:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107c55:	e9 da f2 ff ff       	jmp    80106f34 <alltraps>

80107c5a <vector182>:
.globl vector182
vector182:
  pushl $0
80107c5a:	6a 00                	push   $0x0
  pushl $182
80107c5c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107c61:	e9 ce f2 ff ff       	jmp    80106f34 <alltraps>

80107c66 <vector183>:
.globl vector183
vector183:
  pushl $0
80107c66:	6a 00                	push   $0x0
  pushl $183
80107c68:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107c6d:	e9 c2 f2 ff ff       	jmp    80106f34 <alltraps>

80107c72 <vector184>:
.globl vector184
vector184:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $184
80107c74:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107c79:	e9 b6 f2 ff ff       	jmp    80106f34 <alltraps>

80107c7e <vector185>:
.globl vector185
vector185:
  pushl $0
80107c7e:	6a 00                	push   $0x0
  pushl $185
80107c80:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107c85:	e9 aa f2 ff ff       	jmp    80106f34 <alltraps>

80107c8a <vector186>:
.globl vector186
vector186:
  pushl $0
80107c8a:	6a 00                	push   $0x0
  pushl $186
80107c8c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107c91:	e9 9e f2 ff ff       	jmp    80106f34 <alltraps>

80107c96 <vector187>:
.globl vector187
vector187:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $187
80107c98:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107c9d:	e9 92 f2 ff ff       	jmp    80106f34 <alltraps>

80107ca2 <vector188>:
.globl vector188
vector188:
  pushl $0
80107ca2:	6a 00                	push   $0x0
  pushl $188
80107ca4:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107ca9:	e9 86 f2 ff ff       	jmp    80106f34 <alltraps>

80107cae <vector189>:
.globl vector189
vector189:
  pushl $0
80107cae:	6a 00                	push   $0x0
  pushl $189
80107cb0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107cb5:	e9 7a f2 ff ff       	jmp    80106f34 <alltraps>

80107cba <vector190>:
.globl vector190
vector190:
  pushl $0
80107cba:	6a 00                	push   $0x0
  pushl $190
80107cbc:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107cc1:	e9 6e f2 ff ff       	jmp    80106f34 <alltraps>

80107cc6 <vector191>:
.globl vector191
vector191:
  pushl $0
80107cc6:	6a 00                	push   $0x0
  pushl $191
80107cc8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107ccd:	e9 62 f2 ff ff       	jmp    80106f34 <alltraps>

80107cd2 <vector192>:
.globl vector192
vector192:
  pushl $0
80107cd2:	6a 00                	push   $0x0
  pushl $192
80107cd4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107cd9:	e9 56 f2 ff ff       	jmp    80106f34 <alltraps>

80107cde <vector193>:
.globl vector193
vector193:
  pushl $0
80107cde:	6a 00                	push   $0x0
  pushl $193
80107ce0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107ce5:	e9 4a f2 ff ff       	jmp    80106f34 <alltraps>

80107cea <vector194>:
.globl vector194
vector194:
  pushl $0
80107cea:	6a 00                	push   $0x0
  pushl $194
80107cec:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107cf1:	e9 3e f2 ff ff       	jmp    80106f34 <alltraps>

80107cf6 <vector195>:
.globl vector195
vector195:
  pushl $0
80107cf6:	6a 00                	push   $0x0
  pushl $195
80107cf8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107cfd:	e9 32 f2 ff ff       	jmp    80106f34 <alltraps>

80107d02 <vector196>:
.globl vector196
vector196:
  pushl $0
80107d02:	6a 00                	push   $0x0
  pushl $196
80107d04:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107d09:	e9 26 f2 ff ff       	jmp    80106f34 <alltraps>

80107d0e <vector197>:
.globl vector197
vector197:
  pushl $0
80107d0e:	6a 00                	push   $0x0
  pushl $197
80107d10:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107d15:	e9 1a f2 ff ff       	jmp    80106f34 <alltraps>

80107d1a <vector198>:
.globl vector198
vector198:
  pushl $0
80107d1a:	6a 00                	push   $0x0
  pushl $198
80107d1c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107d21:	e9 0e f2 ff ff       	jmp    80106f34 <alltraps>

80107d26 <vector199>:
.globl vector199
vector199:
  pushl $0
80107d26:	6a 00                	push   $0x0
  pushl $199
80107d28:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107d2d:	e9 02 f2 ff ff       	jmp    80106f34 <alltraps>

80107d32 <vector200>:
.globl vector200
vector200:
  pushl $0
80107d32:	6a 00                	push   $0x0
  pushl $200
80107d34:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107d39:	e9 f6 f1 ff ff       	jmp    80106f34 <alltraps>

80107d3e <vector201>:
.globl vector201
vector201:
  pushl $0
80107d3e:	6a 00                	push   $0x0
  pushl $201
80107d40:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107d45:	e9 ea f1 ff ff       	jmp    80106f34 <alltraps>

80107d4a <vector202>:
.globl vector202
vector202:
  pushl $0
80107d4a:	6a 00                	push   $0x0
  pushl $202
80107d4c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107d51:	e9 de f1 ff ff       	jmp    80106f34 <alltraps>

80107d56 <vector203>:
.globl vector203
vector203:
  pushl $0
80107d56:	6a 00                	push   $0x0
  pushl $203
80107d58:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107d5d:	e9 d2 f1 ff ff       	jmp    80106f34 <alltraps>

80107d62 <vector204>:
.globl vector204
vector204:
  pushl $0
80107d62:	6a 00                	push   $0x0
  pushl $204
80107d64:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107d69:	e9 c6 f1 ff ff       	jmp    80106f34 <alltraps>

80107d6e <vector205>:
.globl vector205
vector205:
  pushl $0
80107d6e:	6a 00                	push   $0x0
  pushl $205
80107d70:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107d75:	e9 ba f1 ff ff       	jmp    80106f34 <alltraps>

80107d7a <vector206>:
.globl vector206
vector206:
  pushl $0
80107d7a:	6a 00                	push   $0x0
  pushl $206
80107d7c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107d81:	e9 ae f1 ff ff       	jmp    80106f34 <alltraps>

80107d86 <vector207>:
.globl vector207
vector207:
  pushl $0
80107d86:	6a 00                	push   $0x0
  pushl $207
80107d88:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107d8d:	e9 a2 f1 ff ff       	jmp    80106f34 <alltraps>

80107d92 <vector208>:
.globl vector208
vector208:
  pushl $0
80107d92:	6a 00                	push   $0x0
  pushl $208
80107d94:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107d99:	e9 96 f1 ff ff       	jmp    80106f34 <alltraps>

80107d9e <vector209>:
.globl vector209
vector209:
  pushl $0
80107d9e:	6a 00                	push   $0x0
  pushl $209
80107da0:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107da5:	e9 8a f1 ff ff       	jmp    80106f34 <alltraps>

80107daa <vector210>:
.globl vector210
vector210:
  pushl $0
80107daa:	6a 00                	push   $0x0
  pushl $210
80107dac:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107db1:	e9 7e f1 ff ff       	jmp    80106f34 <alltraps>

80107db6 <vector211>:
.globl vector211
vector211:
  pushl $0
80107db6:	6a 00                	push   $0x0
  pushl $211
80107db8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107dbd:	e9 72 f1 ff ff       	jmp    80106f34 <alltraps>

80107dc2 <vector212>:
.globl vector212
vector212:
  pushl $0
80107dc2:	6a 00                	push   $0x0
  pushl $212
80107dc4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107dc9:	e9 66 f1 ff ff       	jmp    80106f34 <alltraps>

80107dce <vector213>:
.globl vector213
vector213:
  pushl $0
80107dce:	6a 00                	push   $0x0
  pushl $213
80107dd0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107dd5:	e9 5a f1 ff ff       	jmp    80106f34 <alltraps>

80107dda <vector214>:
.globl vector214
vector214:
  pushl $0
80107dda:	6a 00                	push   $0x0
  pushl $214
80107ddc:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107de1:	e9 4e f1 ff ff       	jmp    80106f34 <alltraps>

80107de6 <vector215>:
.globl vector215
vector215:
  pushl $0
80107de6:	6a 00                	push   $0x0
  pushl $215
80107de8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107ded:	e9 42 f1 ff ff       	jmp    80106f34 <alltraps>

80107df2 <vector216>:
.globl vector216
vector216:
  pushl $0
80107df2:	6a 00                	push   $0x0
  pushl $216
80107df4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107df9:	e9 36 f1 ff ff       	jmp    80106f34 <alltraps>

80107dfe <vector217>:
.globl vector217
vector217:
  pushl $0
80107dfe:	6a 00                	push   $0x0
  pushl $217
80107e00:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107e05:	e9 2a f1 ff ff       	jmp    80106f34 <alltraps>

80107e0a <vector218>:
.globl vector218
vector218:
  pushl $0
80107e0a:	6a 00                	push   $0x0
  pushl $218
80107e0c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107e11:	e9 1e f1 ff ff       	jmp    80106f34 <alltraps>

80107e16 <vector219>:
.globl vector219
vector219:
  pushl $0
80107e16:	6a 00                	push   $0x0
  pushl $219
80107e18:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107e1d:	e9 12 f1 ff ff       	jmp    80106f34 <alltraps>

80107e22 <vector220>:
.globl vector220
vector220:
  pushl $0
80107e22:	6a 00                	push   $0x0
  pushl $220
80107e24:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107e29:	e9 06 f1 ff ff       	jmp    80106f34 <alltraps>

80107e2e <vector221>:
.globl vector221
vector221:
  pushl $0
80107e2e:	6a 00                	push   $0x0
  pushl $221
80107e30:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107e35:	e9 fa f0 ff ff       	jmp    80106f34 <alltraps>

80107e3a <vector222>:
.globl vector222
vector222:
  pushl $0
80107e3a:	6a 00                	push   $0x0
  pushl $222
80107e3c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107e41:	e9 ee f0 ff ff       	jmp    80106f34 <alltraps>

80107e46 <vector223>:
.globl vector223
vector223:
  pushl $0
80107e46:	6a 00                	push   $0x0
  pushl $223
80107e48:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107e4d:	e9 e2 f0 ff ff       	jmp    80106f34 <alltraps>

80107e52 <vector224>:
.globl vector224
vector224:
  pushl $0
80107e52:	6a 00                	push   $0x0
  pushl $224
80107e54:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107e59:	e9 d6 f0 ff ff       	jmp    80106f34 <alltraps>

80107e5e <vector225>:
.globl vector225
vector225:
  pushl $0
80107e5e:	6a 00                	push   $0x0
  pushl $225
80107e60:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107e65:	e9 ca f0 ff ff       	jmp    80106f34 <alltraps>

80107e6a <vector226>:
.globl vector226
vector226:
  pushl $0
80107e6a:	6a 00                	push   $0x0
  pushl $226
80107e6c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107e71:	e9 be f0 ff ff       	jmp    80106f34 <alltraps>

80107e76 <vector227>:
.globl vector227
vector227:
  pushl $0
80107e76:	6a 00                	push   $0x0
  pushl $227
80107e78:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107e7d:	e9 b2 f0 ff ff       	jmp    80106f34 <alltraps>

80107e82 <vector228>:
.globl vector228
vector228:
  pushl $0
80107e82:	6a 00                	push   $0x0
  pushl $228
80107e84:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107e89:	e9 a6 f0 ff ff       	jmp    80106f34 <alltraps>

80107e8e <vector229>:
.globl vector229
vector229:
  pushl $0
80107e8e:	6a 00                	push   $0x0
  pushl $229
80107e90:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107e95:	e9 9a f0 ff ff       	jmp    80106f34 <alltraps>

80107e9a <vector230>:
.globl vector230
vector230:
  pushl $0
80107e9a:	6a 00                	push   $0x0
  pushl $230
80107e9c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ea1:	e9 8e f0 ff ff       	jmp    80106f34 <alltraps>

80107ea6 <vector231>:
.globl vector231
vector231:
  pushl $0
80107ea6:	6a 00                	push   $0x0
  pushl $231
80107ea8:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107ead:	e9 82 f0 ff ff       	jmp    80106f34 <alltraps>

80107eb2 <vector232>:
.globl vector232
vector232:
  pushl $0
80107eb2:	6a 00                	push   $0x0
  pushl $232
80107eb4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107eb9:	e9 76 f0 ff ff       	jmp    80106f34 <alltraps>

80107ebe <vector233>:
.globl vector233
vector233:
  pushl $0
80107ebe:	6a 00                	push   $0x0
  pushl $233
80107ec0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107ec5:	e9 6a f0 ff ff       	jmp    80106f34 <alltraps>

80107eca <vector234>:
.globl vector234
vector234:
  pushl $0
80107eca:	6a 00                	push   $0x0
  pushl $234
80107ecc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107ed1:	e9 5e f0 ff ff       	jmp    80106f34 <alltraps>

80107ed6 <vector235>:
.globl vector235
vector235:
  pushl $0
80107ed6:	6a 00                	push   $0x0
  pushl $235
80107ed8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107edd:	e9 52 f0 ff ff       	jmp    80106f34 <alltraps>

80107ee2 <vector236>:
.globl vector236
vector236:
  pushl $0
80107ee2:	6a 00                	push   $0x0
  pushl $236
80107ee4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107ee9:	e9 46 f0 ff ff       	jmp    80106f34 <alltraps>

80107eee <vector237>:
.globl vector237
vector237:
  pushl $0
80107eee:	6a 00                	push   $0x0
  pushl $237
80107ef0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107ef5:	e9 3a f0 ff ff       	jmp    80106f34 <alltraps>

80107efa <vector238>:
.globl vector238
vector238:
  pushl $0
80107efa:	6a 00                	push   $0x0
  pushl $238
80107efc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107f01:	e9 2e f0 ff ff       	jmp    80106f34 <alltraps>

80107f06 <vector239>:
.globl vector239
vector239:
  pushl $0
80107f06:	6a 00                	push   $0x0
  pushl $239
80107f08:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107f0d:	e9 22 f0 ff ff       	jmp    80106f34 <alltraps>

80107f12 <vector240>:
.globl vector240
vector240:
  pushl $0
80107f12:	6a 00                	push   $0x0
  pushl $240
80107f14:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107f19:	e9 16 f0 ff ff       	jmp    80106f34 <alltraps>

80107f1e <vector241>:
.globl vector241
vector241:
  pushl $0
80107f1e:	6a 00                	push   $0x0
  pushl $241
80107f20:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107f25:	e9 0a f0 ff ff       	jmp    80106f34 <alltraps>

80107f2a <vector242>:
.globl vector242
vector242:
  pushl $0
80107f2a:	6a 00                	push   $0x0
  pushl $242
80107f2c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107f31:	e9 fe ef ff ff       	jmp    80106f34 <alltraps>

80107f36 <vector243>:
.globl vector243
vector243:
  pushl $0
80107f36:	6a 00                	push   $0x0
  pushl $243
80107f38:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107f3d:	e9 f2 ef ff ff       	jmp    80106f34 <alltraps>

80107f42 <vector244>:
.globl vector244
vector244:
  pushl $0
80107f42:	6a 00                	push   $0x0
  pushl $244
80107f44:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107f49:	e9 e6 ef ff ff       	jmp    80106f34 <alltraps>

80107f4e <vector245>:
.globl vector245
vector245:
  pushl $0
80107f4e:	6a 00                	push   $0x0
  pushl $245
80107f50:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107f55:	e9 da ef ff ff       	jmp    80106f34 <alltraps>

80107f5a <vector246>:
.globl vector246
vector246:
  pushl $0
80107f5a:	6a 00                	push   $0x0
  pushl $246
80107f5c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107f61:	e9 ce ef ff ff       	jmp    80106f34 <alltraps>

80107f66 <vector247>:
.globl vector247
vector247:
  pushl $0
80107f66:	6a 00                	push   $0x0
  pushl $247
80107f68:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107f6d:	e9 c2 ef ff ff       	jmp    80106f34 <alltraps>

80107f72 <vector248>:
.globl vector248
vector248:
  pushl $0
80107f72:	6a 00                	push   $0x0
  pushl $248
80107f74:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107f79:	e9 b6 ef ff ff       	jmp    80106f34 <alltraps>

80107f7e <vector249>:
.globl vector249
vector249:
  pushl $0
80107f7e:	6a 00                	push   $0x0
  pushl $249
80107f80:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107f85:	e9 aa ef ff ff       	jmp    80106f34 <alltraps>

80107f8a <vector250>:
.globl vector250
vector250:
  pushl $0
80107f8a:	6a 00                	push   $0x0
  pushl $250
80107f8c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107f91:	e9 9e ef ff ff       	jmp    80106f34 <alltraps>

80107f96 <vector251>:
.globl vector251
vector251:
  pushl $0
80107f96:	6a 00                	push   $0x0
  pushl $251
80107f98:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107f9d:	e9 92 ef ff ff       	jmp    80106f34 <alltraps>

80107fa2 <vector252>:
.globl vector252
vector252:
  pushl $0
80107fa2:	6a 00                	push   $0x0
  pushl $252
80107fa4:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107fa9:	e9 86 ef ff ff       	jmp    80106f34 <alltraps>

80107fae <vector253>:
.globl vector253
vector253:
  pushl $0
80107fae:	6a 00                	push   $0x0
  pushl $253
80107fb0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107fb5:	e9 7a ef ff ff       	jmp    80106f34 <alltraps>

80107fba <vector254>:
.globl vector254
vector254:
  pushl $0
80107fba:	6a 00                	push   $0x0
  pushl $254
80107fbc:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107fc1:	e9 6e ef ff ff       	jmp    80106f34 <alltraps>

80107fc6 <vector255>:
.globl vector255
vector255:
  pushl $0
80107fc6:	6a 00                	push   $0x0
  pushl $255
80107fc8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107fcd:	e9 62 ef ff ff       	jmp    80106f34 <alltraps>
	...

80107fd4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107fd4:	55                   	push   %ebp
80107fd5:	89 e5                	mov    %esp,%ebp
80107fd7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107fda:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fdd:	48                   	dec    %eax
80107fde:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80107fec:	c1 e8 10             	shr    $0x10,%eax
80107fef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ff3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ff6:	0f 01 10             	lgdtl  (%eax)
}
80107ff9:	c9                   	leave  
80107ffa:	c3                   	ret    

80107ffb <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ffb:	55                   	push   %ebp
80107ffc:	89 e5                	mov    %esp,%ebp
80107ffe:	83 ec 04             	sub    $0x4,%esp
80108001:	8b 45 08             	mov    0x8(%ebp),%eax
80108004:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108008:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010800b:	0f 00 d8             	ltr    %ax
}
8010800e:	c9                   	leave  
8010800f:	c3                   	ret    

80108010 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80108010:	55                   	push   %ebp
80108011:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108013:	8b 45 08             	mov    0x8(%ebp),%eax
80108016:	0f 22 d8             	mov    %eax,%cr3
}
80108019:	5d                   	pop    %ebp
8010801a:	c3                   	ret    

8010801b <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010801b:	55                   	push   %ebp
8010801c:	89 e5                	mov    %esp,%ebp
8010801e:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80108021:	e8 14 c2 ff ff       	call   8010423a <cpuid>
80108026:	89 c2                	mov    %eax,%edx
80108028:	89 d0                	mov    %edx,%eax
8010802a:	c1 e0 02             	shl    $0x2,%eax
8010802d:	01 d0                	add    %edx,%eax
8010802f:	01 c0                	add    %eax,%eax
80108031:	01 d0                	add    %edx,%eax
80108033:	c1 e0 04             	shl    $0x4,%eax
80108036:	05 c0 50 11 80       	add    $0x801150c0,%eax
8010803b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010803e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108041:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805a:	8a 50 7d             	mov    0x7d(%eax),%dl
8010805d:	83 e2 f0             	and    $0xfffffff0,%edx
80108060:	83 ca 0a             	or     $0xa,%edx
80108063:	88 50 7d             	mov    %dl,0x7d(%eax)
80108066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108069:	8a 50 7d             	mov    0x7d(%eax),%dl
8010806c:	83 ca 10             	or     $0x10,%edx
8010806f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108075:	8a 50 7d             	mov    0x7d(%eax),%dl
80108078:	83 e2 9f             	and    $0xffffff9f,%edx
8010807b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108081:	8a 50 7d             	mov    0x7d(%eax),%dl
80108084:	83 ca 80             	or     $0xffffff80,%edx
80108087:	88 50 7d             	mov    %dl,0x7d(%eax)
8010808a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808d:	8a 50 7e             	mov    0x7e(%eax),%dl
80108090:	83 ca 0f             	or     $0xf,%edx
80108093:	88 50 7e             	mov    %dl,0x7e(%eax)
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	8a 50 7e             	mov    0x7e(%eax),%dl
8010809c:	83 e2 ef             	and    $0xffffffef,%edx
8010809f:	88 50 7e             	mov    %dl,0x7e(%eax)
801080a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a5:	8a 50 7e             	mov    0x7e(%eax),%dl
801080a8:	83 e2 df             	and    $0xffffffdf,%edx
801080ab:	88 50 7e             	mov    %dl,0x7e(%eax)
801080ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b1:	8a 50 7e             	mov    0x7e(%eax),%dl
801080b4:	83 ca 40             	or     $0x40,%edx
801080b7:	88 50 7e             	mov    %dl,0x7e(%eax)
801080ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bd:	8a 50 7e             	mov    0x7e(%eax),%dl
801080c0:	83 ca 80             	or     $0xffffff80,%edx
801080c3:	88 50 7e             	mov    %dl,0x7e(%eax)
801080c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c9:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801080cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d0:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801080d7:	ff ff 
801080d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dc:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801080e3:	00 00 
801080e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e8:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801080ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f2:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080f8:	83 e2 f0             	and    $0xfffffff0,%edx
801080fb:	83 ca 02             	or     $0x2,%edx
801080fe:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108107:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010810d:	83 ca 10             	or     $0x10,%edx
80108110:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108119:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010811f:	83 e2 9f             	and    $0xffffff9f,%edx
80108122:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812b:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108131:	83 ca 80             	or     $0xffffff80,%edx
80108134:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108143:	83 ca 0f             	or     $0xf,%edx
80108146:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010814c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814f:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108155:	83 e2 ef             	and    $0xffffffef,%edx
80108158:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010815e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108161:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108167:	83 e2 df             	and    $0xffffffdf,%edx
8010816a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108173:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108179:	83 ca 40             	or     $0x40,%edx
8010817c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108185:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010818b:	83 ca 80             	or     $0xffffff80,%edx
8010818e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108197:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010819e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a1:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801081a8:	ff ff 
801081aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ad:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801081b4:	00 00 
801081b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b9:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801081c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c3:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801081c9:	83 e2 f0             	and    $0xfffffff0,%edx
801081cc:	83 ca 0a             	or     $0xa,%edx
801081cf:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801081d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d8:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801081de:	83 ca 10             	or     $0x10,%edx
801081e1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801081e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ea:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
801081f0:	83 ca 60             	or     $0x60,%edx
801081f3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801081f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fc:	8a 90 8d 00 00 00    	mov    0x8d(%eax),%dl
80108202:	83 ca 80             	or     $0xffffff80,%edx
80108205:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010820b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820e:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80108214:	83 ca 0f             	or     $0xf,%edx
80108217:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010821d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108220:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80108226:	83 e2 ef             	and    $0xffffffef,%edx
80108229:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010822f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108232:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
80108238:	83 e2 df             	and    $0xffffffdf,%edx
8010823b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108244:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010824a:	83 ca 40             	or     $0x40,%edx
8010824d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108253:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108256:	8a 90 8e 00 00 00    	mov    0x8e(%eax),%dl
8010825c:	83 ca 80             	or     $0xffffff80,%edx
8010825f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108268:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010826f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108272:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108279:	ff ff 
8010827b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827e:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108285:	00 00 
80108287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828a:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108291:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108294:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010829a:	83 e2 f0             	and    $0xfffffff0,%edx
8010829d:	83 ca 02             	or     $0x2,%edx
801082a0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801082a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a9:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801082af:	83 ca 10             	or     $0x10,%edx
801082b2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801082b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bb:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801082c1:	83 ca 60             	or     $0x60,%edx
801082c4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801082ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cd:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801082d3:	83 ca 80             	or     $0xffffff80,%edx
801082d6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801082dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082df:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801082e5:	83 ca 0f             	or     $0xf,%edx
801082e8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801082ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801082f7:	83 e2 ef             	and    $0xffffffef,%edx
801082fa:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108303:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108309:	83 e2 df             	and    $0xffffffdf,%edx
8010830c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108315:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010831b:	83 ca 40             	or     $0x40,%edx
8010831e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108327:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010832d:	83 ca 80             	or     $0xffffff80,%edx
80108330:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108339:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80108340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108343:	83 c0 70             	add    $0x70,%eax
80108346:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010834d:	00 
8010834e:	89 04 24             	mov    %eax,(%esp)
80108351:	e8 7e fc ff ff       	call   80107fd4 <lgdt>
}
80108356:	c9                   	leave  
80108357:	c3                   	ret    

80108358 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108358:	55                   	push   %ebp
80108359:	89 e5                	mov    %esp,%ebp
8010835b:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010835e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108361:	c1 e8 16             	shr    $0x16,%eax
80108364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010836b:	8b 45 08             	mov    0x8(%ebp),%eax
8010836e:	01 d0                	add    %edx,%eax
80108370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108376:	8b 00                	mov    (%eax),%eax
80108378:	83 e0 01             	and    $0x1,%eax
8010837b:	85 c0                	test   %eax,%eax
8010837d:	74 14                	je     80108393 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010837f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108382:	8b 00                	mov    (%eax),%eax
80108384:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108389:	05 00 00 00 80       	add    $0x80000000,%eax
8010838e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108391:	eb 48                	jmp    801083db <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108397:	74 0e                	je     801083a7 <walkpgdir+0x4f>
80108399:	e8 a5 a9 ff ff       	call   80102d43 <kalloc>
8010839e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083a5:	75 07                	jne    801083ae <walkpgdir+0x56>
      return 0;
801083a7:	b8 00 00 00 00       	mov    $0x0,%eax
801083ac:	eb 44                	jmp    801083f2 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801083ae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083b5:	00 
801083b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083bd:	00 
801083be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c1:	89 04 24             	mov    %eax,(%esp)
801083c4:	e8 ad cd ff ff       	call   80105176 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801083c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cc:	05 00 00 00 80       	add    $0x80000000,%eax
801083d1:	83 c8 07             	or     $0x7,%eax
801083d4:	89 c2                	mov    %eax,%edx
801083d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083d9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801083db:	8b 45 0c             	mov    0xc(%ebp),%eax
801083de:	c1 e8 0c             	shr    $0xc,%eax
801083e1:	25 ff 03 00 00       	and    $0x3ff,%eax
801083e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f0:	01 d0                	add    %edx,%eax
}
801083f2:	c9                   	leave  
801083f3:	c3                   	ret    

801083f4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801083f4:	55                   	push   %ebp
801083f5:	89 e5                	mov    %esp,%ebp
801083f7:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801083fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801083fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108402:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108405:	8b 55 0c             	mov    0xc(%ebp),%edx
80108408:	8b 45 10             	mov    0x10(%ebp),%eax
8010840b:	01 d0                	add    %edx,%eax
8010840d:	48                   	dec    %eax
8010840e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108413:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108416:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010841d:	00 
8010841e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108421:	89 44 24 04          	mov    %eax,0x4(%esp)
80108425:	8b 45 08             	mov    0x8(%ebp),%eax
80108428:	89 04 24             	mov    %eax,(%esp)
8010842b:	e8 28 ff ff ff       	call   80108358 <walkpgdir>
80108430:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108437:	75 07                	jne    80108440 <mappages+0x4c>
      return -1;
80108439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010843e:	eb 48                	jmp    80108488 <mappages+0x94>
    if(*pte & PTE_P)
80108440:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108443:	8b 00                	mov    (%eax),%eax
80108445:	83 e0 01             	and    $0x1,%eax
80108448:	85 c0                	test   %eax,%eax
8010844a:	74 0c                	je     80108458 <mappages+0x64>
      panic("remap");
8010844c:	c7 04 24 88 9b 10 80 	movl   $0x80109b88,(%esp)
80108453:	e8 fc 80 ff ff       	call   80100554 <panic>
    *pte = pa | perm | PTE_P;
80108458:	8b 45 18             	mov    0x18(%ebp),%eax
8010845b:	0b 45 14             	or     0x14(%ebp),%eax
8010845e:	83 c8 01             	or     $0x1,%eax
80108461:	89 c2                	mov    %eax,%edx
80108463:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108466:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010846b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010846e:	75 08                	jne    80108478 <mappages+0x84>
      break;
80108470:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108471:	b8 00 00 00 00       	mov    $0x0,%eax
80108476:	eb 10                	jmp    80108488 <mappages+0x94>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108478:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010847f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108486:	eb 8e                	jmp    80108416 <mappages+0x22>
  return 0;
}
80108488:	c9                   	leave  
80108489:	c3                   	ret    

8010848a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010848a:	55                   	push   %ebp
8010848b:	89 e5                	mov    %esp,%ebp
8010848d:	53                   	push   %ebx
8010848e:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108491:	e8 ad a8 ff ff       	call   80102d43 <kalloc>
80108496:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108499:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010849d:	75 0a                	jne    801084a9 <setupkvm+0x1f>
    return 0;
8010849f:	b8 00 00 00 00       	mov    $0x0,%eax
801084a4:	e9 84 00 00 00       	jmp    8010852d <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
801084a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084b0:	00 
801084b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084b8:	00 
801084b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084bc:	89 04 24             	mov    %eax,(%esp)
801084bf:	e8 b2 cc ff ff       	call   80105176 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801084c4:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
801084cb:	eb 54                	jmp    80108521 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801084cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d0:	8b 48 0c             	mov    0xc(%eax),%ecx
801084d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d6:	8b 50 04             	mov    0x4(%eax),%edx
801084d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084dc:	8b 58 08             	mov    0x8(%eax),%ebx
801084df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e2:	8b 40 04             	mov    0x4(%eax),%eax
801084e5:	29 c3                	sub    %eax,%ebx
801084e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ea:	8b 00                	mov    (%eax),%eax
801084ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801084f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
801084f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801084f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801084fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ff:	89 04 24             	mov    %eax,(%esp)
80108502:	e8 ed fe ff ff       	call   801083f4 <mappages>
80108507:	85 c0                	test   %eax,%eax
80108509:	79 12                	jns    8010851d <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
8010850b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010850e:	89 04 24             	mov    %eax,(%esp)
80108511:	e8 1a 05 00 00       	call   80108a30 <freevm>
      return 0;
80108516:	b8 00 00 00 00       	mov    $0x0,%eax
8010851b:	eb 10                	jmp    8010852d <setupkvm+0xa3>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010851d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108521:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
80108528:	72 a3                	jb     801084cd <setupkvm+0x43>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
8010852a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010852d:	83 c4 34             	add    $0x34,%esp
80108530:	5b                   	pop    %ebx
80108531:	5d                   	pop    %ebp
80108532:	c3                   	ret    

80108533 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108533:	55                   	push   %ebp
80108534:	89 e5                	mov    %esp,%ebp
80108536:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108539:	e8 4c ff ff ff       	call   8010848a <setupkvm>
8010853e:	a3 e4 7d 11 80       	mov    %eax,0x80117de4
  switchkvm();
80108543:	e8 02 00 00 00       	call   8010854a <switchkvm>
}
80108548:	c9                   	leave  
80108549:	c3                   	ret    

8010854a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010854a:	55                   	push   %ebp
8010854b:	89 e5                	mov    %esp,%ebp
8010854d:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108550:	a1 e4 7d 11 80       	mov    0x80117de4,%eax
80108555:	05 00 00 00 80       	add    $0x80000000,%eax
8010855a:	89 04 24             	mov    %eax,(%esp)
8010855d:	e8 ae fa ff ff       	call   80108010 <lcr3>
}
80108562:	c9                   	leave  
80108563:	c3                   	ret    

80108564 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108564:	55                   	push   %ebp
80108565:	89 e5                	mov    %esp,%ebp
80108567:	57                   	push   %edi
80108568:	56                   	push   %esi
80108569:	53                   	push   %ebx
8010856a:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
8010856d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108571:	75 0c                	jne    8010857f <switchuvm+0x1b>
    panic("switchuvm: no process");
80108573:	c7 04 24 8e 9b 10 80 	movl   $0x80109b8e,(%esp)
8010857a:	e8 d5 7f ff ff       	call   80100554 <panic>
  if(p->kstack == 0)
8010857f:	8b 45 08             	mov    0x8(%ebp),%eax
80108582:	8b 40 08             	mov    0x8(%eax),%eax
80108585:	85 c0                	test   %eax,%eax
80108587:	75 0c                	jne    80108595 <switchuvm+0x31>
    panic("switchuvm: no kstack");
80108589:	c7 04 24 a4 9b 10 80 	movl   $0x80109ba4,(%esp)
80108590:	e8 bf 7f ff ff       	call   80100554 <panic>
  if(p->pgdir == 0)
80108595:	8b 45 08             	mov    0x8(%ebp),%eax
80108598:	8b 40 04             	mov    0x4(%eax),%eax
8010859b:	85 c0                	test   %eax,%eax
8010859d:	75 0c                	jne    801085ab <switchuvm+0x47>
    panic("switchuvm: no pgdir");
8010859f:	c7 04 24 b9 9b 10 80 	movl   $0x80109bb9,(%esp)
801085a6:	e8 a9 7f ff ff       	call   80100554 <panic>

  pushcli();
801085ab:	e8 c2 ca ff ff       	call   80105072 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801085b0:	e8 ca bc ff ff       	call   8010427f <mycpu>
801085b5:	89 c3                	mov    %eax,%ebx
801085b7:	e8 c3 bc ff ff       	call   8010427f <mycpu>
801085bc:	83 c0 08             	add    $0x8,%eax
801085bf:	89 c6                	mov    %eax,%esi
801085c1:	e8 b9 bc ff ff       	call   8010427f <mycpu>
801085c6:	83 c0 08             	add    $0x8,%eax
801085c9:	c1 e8 10             	shr    $0x10,%eax
801085cc:	89 c7                	mov    %eax,%edi
801085ce:	e8 ac bc ff ff       	call   8010427f <mycpu>
801085d3:	83 c0 08             	add    $0x8,%eax
801085d6:	c1 e8 18             	shr    $0x18,%eax
801085d9:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801085e0:	67 00 
801085e2:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801085e9:	89 f9                	mov    %edi,%ecx
801085eb:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801085f1:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801085f7:	83 e2 f0             	and    $0xfffffff0,%edx
801085fa:	83 ca 09             	or     $0x9,%edx
801085fd:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108603:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80108609:	83 ca 10             	or     $0x10,%edx
8010860c:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108612:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80108618:	83 e2 9f             	and    $0xffffff9f,%edx
8010861b:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108621:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80108627:	83 ca 80             	or     $0xffffff80,%edx
8010862a:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80108630:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108636:	83 e2 f0             	and    $0xfffffff0,%edx
80108639:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010863f:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108645:	83 e2 ef             	and    $0xffffffef,%edx
80108648:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010864e:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108654:	83 e2 df             	and    $0xffffffdf,%edx
80108657:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010865d:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108663:	83 ca 40             	or     $0x40,%edx
80108666:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010866c:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80108672:	83 e2 7f             	and    $0x7f,%edx
80108675:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010867b:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80108681:	e8 f9 bb ff ff       	call   8010427f <mycpu>
80108686:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010868c:	83 e2 ef             	and    $0xffffffef,%edx
8010868f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108695:	e8 e5 bb ff ff       	call   8010427f <mycpu>
8010869a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801086a0:	e8 da bb ff ff       	call   8010427f <mycpu>
801086a5:	8b 55 08             	mov    0x8(%ebp),%edx
801086a8:	8b 52 08             	mov    0x8(%edx),%edx
801086ab:	81 c2 00 10 00 00    	add    $0x1000,%edx
801086b1:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801086b4:	e8 c6 bb ff ff       	call   8010427f <mycpu>
801086b9:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801086bf:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
801086c6:	e8 30 f9 ff ff       	call   80107ffb <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
801086cb:	8b 45 08             	mov    0x8(%ebp),%eax
801086ce:	8b 40 04             	mov    0x4(%eax),%eax
801086d1:	05 00 00 00 80       	add    $0x80000000,%eax
801086d6:	89 04 24             	mov    %eax,(%esp)
801086d9:	e8 32 f9 ff ff       	call   80108010 <lcr3>
  popcli();
801086de:	e8 d9 c9 ff ff       	call   801050bc <popcli>
}
801086e3:	83 c4 1c             	add    $0x1c,%esp
801086e6:	5b                   	pop    %ebx
801086e7:	5e                   	pop    %esi
801086e8:	5f                   	pop    %edi
801086e9:	5d                   	pop    %ebp
801086ea:	c3                   	ret    

801086eb <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801086eb:	55                   	push   %ebp
801086ec:	89 e5                	mov    %esp,%ebp
801086ee:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
801086f1:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801086f8:	76 0c                	jbe    80108706 <inituvm+0x1b>
    panic("inituvm: more than a page");
801086fa:	c7 04 24 cd 9b 10 80 	movl   $0x80109bcd,(%esp)
80108701:	e8 4e 7e ff ff       	call   80100554 <panic>
  mem = kalloc();
80108706:	e8 38 a6 ff ff       	call   80102d43 <kalloc>
8010870b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010870e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108715:	00 
80108716:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010871d:	00 
8010871e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108721:	89 04 24             	mov    %eax,(%esp)
80108724:	e8 4d ca ff ff       	call   80105176 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010872c:	05 00 00 00 80       	add    $0x80000000,%eax
80108731:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108738:	00 
80108739:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010873d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108744:	00 
80108745:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010874c:	00 
8010874d:	8b 45 08             	mov    0x8(%ebp),%eax
80108750:	89 04 24             	mov    %eax,(%esp)
80108753:	e8 9c fc ff ff       	call   801083f4 <mappages>
  memmove(mem, init, sz);
80108758:	8b 45 10             	mov    0x10(%ebp),%eax
8010875b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010875f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108762:	89 44 24 04          	mov    %eax,0x4(%esp)
80108766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108769:	89 04 24             	mov    %eax,(%esp)
8010876c:	e8 ce ca ff ff       	call   8010523f <memmove>
}
80108771:	c9                   	leave  
80108772:	c3                   	ret    

80108773 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108773:	55                   	push   %ebp
80108774:	89 e5                	mov    %esp,%ebp
80108776:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108779:	8b 45 0c             	mov    0xc(%ebp),%eax
8010877c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108781:	85 c0                	test   %eax,%eax
80108783:	74 0c                	je     80108791 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80108785:	c7 04 24 e8 9b 10 80 	movl   $0x80109be8,(%esp)
8010878c:	e8 c3 7d ff ff       	call   80100554 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108798:	e9 a6 00 00 00       	jmp    80108843 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010879d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801087a3:	01 d0                	add    %edx,%eax
801087a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087ac:	00 
801087ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b1:	8b 45 08             	mov    0x8(%ebp),%eax
801087b4:	89 04 24             	mov    %eax,(%esp)
801087b7:	e8 9c fb ff ff       	call   80108358 <walkpgdir>
801087bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087c3:	75 0c                	jne    801087d1 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
801087c5:	c7 04 24 0b 9c 10 80 	movl   $0x80109c0b,(%esp)
801087cc:	e8 83 7d ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
801087d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087d4:	8b 00                	mov    (%eax),%eax
801087d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087db:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801087de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e1:	8b 55 18             	mov    0x18(%ebp),%edx
801087e4:	29 c2                	sub    %eax,%edx
801087e6:	89 d0                	mov    %edx,%eax
801087e8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801087ed:	77 0f                	ja     801087fe <loaduvm+0x8b>
      n = sz - i;
801087ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f2:	8b 55 18             	mov    0x18(%ebp),%edx
801087f5:	29 c2                	sub    %eax,%edx
801087f7:	89 d0                	mov    %edx,%eax
801087f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087fc:	eb 07                	jmp    80108805 <loaduvm+0x92>
    else
      n = PGSIZE;
801087fe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108808:	8b 55 14             	mov    0x14(%ebp),%edx
8010880b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010880e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108811:	05 00 00 00 80       	add    $0x80000000,%eax
80108816:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108819:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010881d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80108821:	89 44 24 04          	mov    %eax,0x4(%esp)
80108825:	8b 45 10             	mov    0x10(%ebp),%eax
80108828:	89 04 24             	mov    %eax,(%esp)
8010882b:	e8 79 97 ff ff       	call   80101fa9 <readi>
80108830:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108833:	74 07                	je     8010883c <loaduvm+0xc9>
      return -1;
80108835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010883a:	eb 18                	jmp    80108854 <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010883c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108846:	3b 45 18             	cmp    0x18(%ebp),%eax
80108849:	0f 82 4e ff ff ff    	jb     8010879d <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010884f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108854:	c9                   	leave  
80108855:	c3                   	ret    

80108856 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108856:	55                   	push   %ebp
80108857:	89 e5                	mov    %esp,%ebp
80108859:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010885c:	8b 45 10             	mov    0x10(%ebp),%eax
8010885f:	85 c0                	test   %eax,%eax
80108861:	79 0a                	jns    8010886d <allocuvm+0x17>
    return 0;
80108863:	b8 00 00 00 00       	mov    $0x0,%eax
80108868:	e9 fd 00 00 00       	jmp    8010896a <allocuvm+0x114>
  if(newsz < oldsz)
8010886d:	8b 45 10             	mov    0x10(%ebp),%eax
80108870:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108873:	73 08                	jae    8010887d <allocuvm+0x27>
    return oldsz;
80108875:	8b 45 0c             	mov    0xc(%ebp),%eax
80108878:	e9 ed 00 00 00       	jmp    8010896a <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
8010887d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108880:	05 ff 0f 00 00       	add    $0xfff,%eax
80108885:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010888a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010888d:	e9 c9 00 00 00       	jmp    8010895b <allocuvm+0x105>
    mem = kalloc();
80108892:	e8 ac a4 ff ff       	call   80102d43 <kalloc>
80108897:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010889a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010889e:	75 2f                	jne    801088cf <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
801088a0:	c7 04 24 29 9c 10 80 	movl   $0x80109c29,(%esp)
801088a7:	e8 15 7b ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801088ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801088af:	89 44 24 08          	mov    %eax,0x8(%esp)
801088b3:	8b 45 10             	mov    0x10(%ebp),%eax
801088b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801088ba:	8b 45 08             	mov    0x8(%ebp),%eax
801088bd:	89 04 24             	mov    %eax,(%esp)
801088c0:	e8 a7 00 00 00       	call   8010896c <deallocuvm>
      return 0;
801088c5:	b8 00 00 00 00       	mov    $0x0,%eax
801088ca:	e9 9b 00 00 00       	jmp    8010896a <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
801088cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088d6:	00 
801088d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801088de:	00 
801088df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088e2:	89 04 24             	mov    %eax,(%esp)
801088e5:	e8 8c c8 ff ff       	call   80105176 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801088ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ed:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801088f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f6:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801088fd:	00 
801088fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108902:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108909:	00 
8010890a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010890e:	8b 45 08             	mov    0x8(%ebp),%eax
80108911:	89 04 24             	mov    %eax,(%esp)
80108914:	e8 db fa ff ff       	call   801083f4 <mappages>
80108919:	85 c0                	test   %eax,%eax
8010891b:	79 37                	jns    80108954 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
8010891d:	c7 04 24 41 9c 10 80 	movl   $0x80109c41,(%esp)
80108924:	e8 98 7a ff ff       	call   801003c1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108929:	8b 45 0c             	mov    0xc(%ebp),%eax
8010892c:	89 44 24 08          	mov    %eax,0x8(%esp)
80108930:	8b 45 10             	mov    0x10(%ebp),%eax
80108933:	89 44 24 04          	mov    %eax,0x4(%esp)
80108937:	8b 45 08             	mov    0x8(%ebp),%eax
8010893a:	89 04 24             	mov    %eax,(%esp)
8010893d:	e8 2a 00 00 00       	call   8010896c <deallocuvm>
      kfree(mem);
80108942:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108945:	89 04 24             	mov    %eax,(%esp)
80108948:	e8 60 a3 ff ff       	call   80102cad <kfree>
      return 0;
8010894d:	b8 00 00 00 00       	mov    $0x0,%eax
80108952:	eb 16                	jmp    8010896a <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108954:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010895b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895e:	3b 45 10             	cmp    0x10(%ebp),%eax
80108961:	0f 82 2b ff ff ff    	jb     80108892 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80108967:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010896a:	c9                   	leave  
8010896b:	c3                   	ret    

8010896c <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010896c:	55                   	push   %ebp
8010896d:	89 e5                	mov    %esp,%ebp
8010896f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108972:	8b 45 10             	mov    0x10(%ebp),%eax
80108975:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108978:	72 08                	jb     80108982 <deallocuvm+0x16>
    return oldsz;
8010897a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010897d:	e9 ac 00 00 00       	jmp    80108a2e <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80108982:	8b 45 10             	mov    0x10(%ebp),%eax
80108985:	05 ff 0f 00 00       	add    $0xfff,%eax
8010898a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010898f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108992:	e9 88 00 00 00       	jmp    80108a1f <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010899a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089a1:	00 
801089a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801089a6:	8b 45 08             	mov    0x8(%ebp),%eax
801089a9:	89 04 24             	mov    %eax,(%esp)
801089ac:	e8 a7 f9 ff ff       	call   80108358 <walkpgdir>
801089b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801089b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089b8:	75 14                	jne    801089ce <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801089ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089bd:	c1 e8 16             	shr    $0x16,%eax
801089c0:	40                   	inc    %eax
801089c1:	c1 e0 16             	shl    $0x16,%eax
801089c4:	2d 00 10 00 00       	sub    $0x1000,%eax
801089c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801089cc:	eb 4a                	jmp    80108a18 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
801089ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089d1:	8b 00                	mov    (%eax),%eax
801089d3:	83 e0 01             	and    $0x1,%eax
801089d6:	85 c0                	test   %eax,%eax
801089d8:	74 3e                	je     80108a18 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
801089da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089dd:	8b 00                	mov    (%eax),%eax
801089df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801089e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089eb:	75 0c                	jne    801089f9 <deallocuvm+0x8d>
        panic("kfree");
801089ed:	c7 04 24 5d 9c 10 80 	movl   $0x80109c5d,(%esp)
801089f4:	e8 5b 7b ff ff       	call   80100554 <panic>
      char *v = P2V(pa);
801089f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089fc:	05 00 00 00 80       	add    $0x80000000,%eax
80108a01:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a07:	89 04 24             	mov    %eax,(%esp)
80108a0a:	e8 9e a2 ff ff       	call   80102cad <kfree>
      *pte = 0;
80108a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108a18:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a22:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a25:	0f 82 6c ff ff ff    	jb     80108997 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108a2b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a2e:	c9                   	leave  
80108a2f:	c3                   	ret    

80108a30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108a30:	55                   	push   %ebp
80108a31:	89 e5                	mov    %esp,%ebp
80108a33:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108a36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a3a:	75 0c                	jne    80108a48 <freevm+0x18>
    panic("freevm: no pgdir");
80108a3c:	c7 04 24 63 9c 10 80 	movl   $0x80109c63,(%esp)
80108a43:	e8 0c 7b ff ff       	call   80100554 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a4f:	00 
80108a50:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108a57:	80 
80108a58:	8b 45 08             	mov    0x8(%ebp),%eax
80108a5b:	89 04 24             	mov    %eax,(%esp)
80108a5e:	e8 09 ff ff ff       	call   8010896c <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a6a:	eb 44                	jmp    80108ab0 <freevm+0x80>
    if(pgdir[i] & PTE_P){
80108a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a76:	8b 45 08             	mov    0x8(%ebp),%eax
80108a79:	01 d0                	add    %edx,%eax
80108a7b:	8b 00                	mov    (%eax),%eax
80108a7d:	83 e0 01             	and    $0x1,%eax
80108a80:	85 c0                	test   %eax,%eax
80108a82:	74 29                	je     80108aad <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80108a91:	01 d0                	add    %edx,%eax
80108a93:	8b 00                	mov    (%eax),%eax
80108a95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a9a:	05 00 00 00 80       	add    $0x80000000,%eax
80108a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aa5:	89 04 24             	mov    %eax,(%esp)
80108aa8:	e8 00 a2 ff ff       	call   80102cad <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108aad:	ff 45 f4             	incl   -0xc(%ebp)
80108ab0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108ab7:	76 b3                	jbe    80108a6c <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80108abc:	89 04 24             	mov    %eax,(%esp)
80108abf:	e8 e9 a1 ff ff       	call   80102cad <kfree>
}
80108ac4:	c9                   	leave  
80108ac5:	c3                   	ret    

80108ac6 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108ac6:	55                   	push   %ebp
80108ac7:	89 e5                	mov    %esp,%ebp
80108ac9:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108acc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108ad3:	00 
80108ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80108adb:	8b 45 08             	mov    0x8(%ebp),%eax
80108ade:	89 04 24             	mov    %eax,(%esp)
80108ae1:	e8 72 f8 ff ff       	call   80108358 <walkpgdir>
80108ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108aed:	75 0c                	jne    80108afb <clearpteu+0x35>
    panic("clearpteu");
80108aef:	c7 04 24 74 9c 10 80 	movl   $0x80109c74,(%esp)
80108af6:	e8 59 7a ff ff       	call   80100554 <panic>
  *pte &= ~PTE_U;
80108afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afe:	8b 00                	mov    (%eax),%eax
80108b00:	83 e0 fb             	and    $0xfffffffb,%eax
80108b03:	89 c2                	mov    %eax,%edx
80108b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b08:	89 10                	mov    %edx,(%eax)
}
80108b0a:	c9                   	leave  
80108b0b:	c3                   	ret    

80108b0c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b0c:	55                   	push   %ebp
80108b0d:	89 e5                	mov    %esp,%ebp
80108b0f:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b12:	e8 73 f9 ff ff       	call   8010848a <setupkvm>
80108b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b1e:	75 0a                	jne    80108b2a <copyuvm+0x1e>
    return 0;
80108b20:	b8 00 00 00 00       	mov    $0x0,%eax
80108b25:	e9 f8 00 00 00       	jmp    80108c22 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80108b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b31:	e9 cb 00 00 00       	jmp    80108c01 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b39:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b40:	00 
80108b41:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b45:	8b 45 08             	mov    0x8(%ebp),%eax
80108b48:	89 04 24             	mov    %eax,(%esp)
80108b4b:	e8 08 f8 ff ff       	call   80108358 <walkpgdir>
80108b50:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b57:	75 0c                	jne    80108b65 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108b59:	c7 04 24 7e 9c 10 80 	movl   $0x80109c7e,(%esp)
80108b60:	e8 ef 79 ff ff       	call   80100554 <panic>
    if(!(*pte & PTE_P))
80108b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b68:	8b 00                	mov    (%eax),%eax
80108b6a:	83 e0 01             	and    $0x1,%eax
80108b6d:	85 c0                	test   %eax,%eax
80108b6f:	75 0c                	jne    80108b7d <copyuvm+0x71>
      panic("copyuvm: page not present");
80108b71:	c7 04 24 98 9c 10 80 	movl   $0x80109c98,(%esp)
80108b78:	e8 d7 79 ff ff       	call   80100554 <panic>
    pa = PTE_ADDR(*pte);
80108b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b80:	8b 00                	mov    (%eax),%eax
80108b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b87:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b8d:	8b 00                	mov    (%eax),%eax
80108b8f:	25 ff 0f 00 00       	and    $0xfff,%eax
80108b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108b97:	e8 a7 a1 ff ff       	call   80102d43 <kalloc>
80108b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108b9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108ba3:	75 02                	jne    80108ba7 <copyuvm+0x9b>
      goto bad;
80108ba5:	eb 6b                	jmp    80108c12 <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108baa:	05 00 00 00 80       	add    $0x80000000,%eax
80108baf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108bb6:	00 
80108bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bbe:	89 04 24             	mov    %eax,(%esp)
80108bc1:	e8 79 c6 ff ff       	call   8010523f <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108bc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108bc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bcc:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd5:	89 54 24 10          	mov    %edx,0x10(%esp)
80108bd9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108bdd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108be4:	00 
80108be5:	89 44 24 04          	mov    %eax,0x4(%esp)
80108be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bec:	89 04 24             	mov    %eax,(%esp)
80108bef:	e8 00 f8 ff ff       	call   801083f4 <mappages>
80108bf4:	85 c0                	test   %eax,%eax
80108bf6:	79 02                	jns    80108bfa <copyuvm+0xee>
      goto bad;
80108bf8:	eb 18                	jmp    80108c12 <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108bfa:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c04:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c07:	0f 82 29 ff ff ff    	jb     80108b36 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80108c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c10:	eb 10                	jmp    80108c22 <copyuvm+0x116>

bad:
  freevm(d);
80108c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c15:	89 04 24             	mov    %eax,(%esp)
80108c18:	e8 13 fe ff ff       	call   80108a30 <freevm>
  return 0;
80108c1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c22:	c9                   	leave  
80108c23:	c3                   	ret    

80108c24 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108c24:	55                   	push   %ebp
80108c25:	89 e5                	mov    %esp,%ebp
80108c27:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108c2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108c31:	00 
80108c32:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c39:	8b 45 08             	mov    0x8(%ebp),%eax
80108c3c:	89 04 24             	mov    %eax,(%esp)
80108c3f:	e8 14 f7 ff ff       	call   80108358 <walkpgdir>
80108c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4a:	8b 00                	mov    (%eax),%eax
80108c4c:	83 e0 01             	and    $0x1,%eax
80108c4f:	85 c0                	test   %eax,%eax
80108c51:	75 07                	jne    80108c5a <uva2ka+0x36>
    return 0;
80108c53:	b8 00 00 00 00       	mov    $0x0,%eax
80108c58:	eb 22                	jmp    80108c7c <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5d:	8b 00                	mov    (%eax),%eax
80108c5f:	83 e0 04             	and    $0x4,%eax
80108c62:	85 c0                	test   %eax,%eax
80108c64:	75 07                	jne    80108c6d <uva2ka+0x49>
    return 0;
80108c66:	b8 00 00 00 00       	mov    $0x0,%eax
80108c6b:	eb 0f                	jmp    80108c7c <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80108c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c70:	8b 00                	mov    (%eax),%eax
80108c72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c77:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108c7c:	c9                   	leave  
80108c7d:	c3                   	ret    

80108c7e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c7e:	55                   	push   %ebp
80108c7f:	89 e5                	mov    %esp,%ebp
80108c81:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c84:	8b 45 10             	mov    0x10(%ebp),%eax
80108c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c8a:	e9 87 00 00 00       	jmp    80108d16 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80108ca4:	89 04 24             	mov    %eax,(%esp)
80108ca7:	e8 78 ff ff ff       	call   80108c24 <uva2ka>
80108cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108caf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108cb3:	75 07                	jne    80108cbc <copyout+0x3e>
      return -1;
80108cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108cba:	eb 69                	jmp    80108d25 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108cc2:	29 c2                	sub    %eax,%edx
80108cc4:	89 d0                	mov    %edx,%eax
80108cc6:	05 00 10 00 00       	add    $0x1000,%eax
80108ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd1:	3b 45 14             	cmp    0x14(%ebp),%eax
80108cd4:	76 06                	jbe    80108cdc <copyout+0x5e>
      n = len;
80108cd6:	8b 45 14             	mov    0x14(%ebp),%eax
80108cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80108ce2:	29 c2                	sub    %eax,%edx
80108ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ce7:	01 c2                	add    %eax,%edx
80108ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cec:	89 44 24 08          	mov    %eax,0x8(%esp)
80108cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cf7:	89 14 24             	mov    %edx,(%esp)
80108cfa:	e8 40 c5 ff ff       	call   8010523f <memmove>
    len -= n;
80108cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d02:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d08:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d0e:	05 00 10 00 00       	add    $0x1000,%eax
80108d13:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d16:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108d1a:	0f 85 6f ff ff ff    	jne    80108c8f <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d25:	c9                   	leave  
80108d26:	c3                   	ret    
	...

80108d28 <strcmp>:

#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
80108d28:	55                   	push   %ebp
80108d29:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
80108d2b:	eb 06                	jmp    80108d33 <strcmp+0xb>
    p++, q++;
80108d2d:	ff 45 08             	incl   0x8(%ebp)
80108d30:	ff 45 0c             	incl   0xc(%ebp)
#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
80108d33:	8b 45 08             	mov    0x8(%ebp),%eax
80108d36:	8a 00                	mov    (%eax),%al
80108d38:	84 c0                	test   %al,%al
80108d3a:	74 0e                	je     80108d4a <strcmp+0x22>
80108d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80108d3f:	8a 10                	mov    (%eax),%dl
80108d41:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d44:	8a 00                	mov    (%eax),%al
80108d46:	38 c2                	cmp    %al,%dl
80108d48:	74 e3                	je     80108d2d <strcmp+0x5>
    p++, q++;
  return (char)*p - (char)*q;
80108d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80108d4d:	8a 00                	mov    (%eax),%al
80108d4f:	0f be d0             	movsbl %al,%edx
80108d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d55:	8a 00                	mov    (%eax),%al
80108d57:	0f be c0             	movsbl %al,%eax
80108d5a:	29 c2                	sub    %eax,%edx
80108d5c:	89 d0                	mov    %edx,%eax
}
80108d5e:	5d                   	pop    %ebp
80108d5f:	c3                   	ret    

80108d60 <getname>:

int getname(int index, char* name){
80108d60:	55                   	push   %ebp
80108d61:	89 e5                	mov    %esp,%ebp
80108d63:	53                   	push   %ebx
80108d64:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108d67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((*name++ = cabinet.tuperwares[index].name[i++]) != 0);
80108d6e:	90                   	nop
80108d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d72:	8d 42 01             	lea    0x1(%edx),%eax
80108d75:	89 45 0c             	mov    %eax,0xc(%ebp)
80108d78:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80108d7b:	8d 43 01             	lea    0x1(%ebx),%eax
80108d7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108d81:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108d84:	89 c8                	mov    %ecx,%eax
80108d86:	c1 e0 02             	shl    $0x2,%eax
80108d89:	01 c8                	add    %ecx,%eax
80108d8b:	01 c0                	add    %eax,%eax
80108d8d:	01 c8                	add    %ecx,%eax
80108d8f:	c1 e0 05             	shl    $0x5,%eax
80108d92:	01 d8                	add    %ebx,%eax
80108d94:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108d99:	8a 00                	mov    (%eax),%al
80108d9b:	88 02                	mov    %al,(%edx)
80108d9d:	8a 02                	mov    (%edx),%al
80108d9f:	84 c0                	test   %al,%al
80108da1:	75 cc                	jne    80108d6f <getname+0xf>

    return 0;
80108da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108da8:	83 c4 10             	add    $0x10,%esp
80108dab:	5b                   	pop    %ebx
80108dac:	5d                   	pop    %ebp
80108dad:	c3                   	ret    

80108dae <setname>:

int setname(int index, char* name){
80108dae:	55                   	push   %ebp
80108daf:	89 e5                	mov    %esp,%ebp
80108db1:	53                   	push   %ebx
80108db2:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108db5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((cabinet.tuperwares[index].name[i++] = *name++) != 0);
80108dbc:	90                   	nop
80108dbd:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108dc0:	8d 42 01             	lea    0x1(%edx),%eax
80108dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dc9:	8d 48 01             	lea    0x1(%eax),%ecx
80108dcc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108dcf:	8a 18                	mov    (%eax),%bl
80108dd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108dd4:	89 c8                	mov    %ecx,%eax
80108dd6:	c1 e0 02             	shl    $0x2,%eax
80108dd9:	01 c8                	add    %ecx,%eax
80108ddb:	01 c0                	add    %eax,%eax
80108ddd:	01 c8                	add    %ecx,%eax
80108ddf:	c1 e0 05             	shl    $0x5,%eax
80108de2:	01 d0                	add    %edx,%eax
80108de4:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108de9:	88 18                	mov    %bl,(%eax)
80108deb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108dee:	89 c8                	mov    %ecx,%eax
80108df0:	c1 e0 02             	shl    $0x2,%eax
80108df3:	01 c8                	add    %ecx,%eax
80108df5:	01 c0                	add    %eax,%eax
80108df7:	01 c8                	add    %ecx,%eax
80108df9:	c1 e0 05             	shl    $0x5,%eax
80108dfc:	01 d0                	add    %edx,%eax
80108dfe:	05 a0 20 11 80       	add    $0x801120a0,%eax
80108e03:	8a 00                	mov    (%eax),%al
80108e05:	84 c0                	test   %al,%al
80108e07:	75 b4                	jne    80108dbd <setname+0xf>

    return 0;
80108e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e0e:	83 c4 10             	add    $0x10,%esp
80108e11:	5b                   	pop    %ebx
80108e12:	5d                   	pop    %ebp
80108e13:	c3                   	ret    

80108e14 <getmaxproc>:

int getmaxproc(int index){
80108e14:	55                   	push   %ebp
80108e15:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_proc;
80108e17:	8b 55 08             	mov    0x8(%ebp),%edx
80108e1a:	89 d0                	mov    %edx,%eax
80108e1c:	c1 e0 02             	shl    $0x2,%eax
80108e1f:	01 d0                	add    %edx,%eax
80108e21:	01 c0                	add    %eax,%eax
80108e23:	01 d0                	add    %edx,%eax
80108e25:	c1 e0 05             	shl    $0x5,%eax
80108e28:	05 e0 21 11 80       	add    $0x801121e0,%eax
80108e2d:	8b 40 08             	mov    0x8(%eax),%eax
}
80108e30:	5d                   	pop    %ebp
80108e31:	c3                   	ret    

80108e32 <setmaxproc>:

int setmaxproc(int index, int max_proc){
80108e32:	55                   	push   %ebp
80108e33:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_proc = max_proc;
80108e35:	8b 55 08             	mov    0x8(%ebp),%edx
80108e38:	89 d0                	mov    %edx,%eax
80108e3a:	c1 e0 02             	shl    $0x2,%eax
80108e3d:	01 d0                	add    %edx,%eax
80108e3f:	01 c0                	add    %eax,%eax
80108e41:	01 d0                	add    %edx,%eax
80108e43:	c1 e0 05             	shl    $0x5,%eax
80108e46:	8d 90 e0 21 11 80    	lea    -0x7feede20(%eax),%edx
80108e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e4f:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e57:	5d                   	pop    %ebp
80108e58:	c3                   	ret    

80108e59 <getmaxmem>:

int getmaxmem(int index){
80108e59:	55                   	push   %ebp
80108e5a:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_mem;
80108e5c:	8b 55 08             	mov    0x8(%ebp),%edx
80108e5f:	89 d0                	mov    %edx,%eax
80108e61:	c1 e0 02             	shl    $0x2,%eax
80108e64:	01 d0                	add    %edx,%eax
80108e66:	01 c0                	add    %eax,%eax
80108e68:	01 d0                	add    %edx,%eax
80108e6a:	c1 e0 05             	shl    $0x5,%eax
80108e6d:	05 e0 21 11 80       	add    $0x801121e0,%eax
80108e72:	8b 40 0c             	mov    0xc(%eax),%eax
}
80108e75:	5d                   	pop    %ebp
80108e76:	c3                   	ret    

80108e77 <setmaxmem>:

int setmaxmem(int index, int max_mem){
80108e77:	55                   	push   %ebp
80108e78:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_mem = max_mem;
80108e7a:	8b 55 08             	mov    0x8(%ebp),%edx
80108e7d:	89 d0                	mov    %edx,%eax
80108e7f:	c1 e0 02             	shl    $0x2,%eax
80108e82:	01 d0                	add    %edx,%eax
80108e84:	01 c0                	add    %eax,%eax
80108e86:	01 d0                	add    %edx,%eax
80108e88:	c1 e0 05             	shl    $0x5,%eax
80108e8b:	8d 90 e0 21 11 80    	lea    -0x7feede20(%eax),%edx
80108e91:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e94:	89 42 0c             	mov    %eax,0xc(%edx)
    return 0;
80108e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e9c:	5d                   	pop    %ebp
80108e9d:	c3                   	ret    

80108e9e <getmaxdisk>:

int getmaxdisk(int index){
80108e9e:	55                   	push   %ebp
80108e9f:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].max_disk;
80108ea1:	8b 55 08             	mov    0x8(%ebp),%edx
80108ea4:	89 d0                	mov    %edx,%eax
80108ea6:	c1 e0 02             	shl    $0x2,%eax
80108ea9:	01 d0                	add    %edx,%eax
80108eab:	01 c0                	add    %eax,%eax
80108ead:	01 d0                	add    %edx,%eax
80108eaf:	c1 e0 05             	shl    $0x5,%eax
80108eb2:	05 f0 21 11 80       	add    $0x801121f0,%eax
80108eb7:	8b 00                	mov    (%eax),%eax
}
80108eb9:	5d                   	pop    %ebp
80108eba:	c3                   	ret    

80108ebb <setmaxdisk>:

int setmaxdisk(int index, int max_disk){
80108ebb:	55                   	push   %ebp
80108ebc:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].max_disk = max_disk;
80108ebe:	8b 55 08             	mov    0x8(%ebp),%edx
80108ec1:	89 d0                	mov    %edx,%eax
80108ec3:	c1 e0 02             	shl    $0x2,%eax
80108ec6:	01 d0                	add    %edx,%eax
80108ec8:	01 c0                	add    %eax,%eax
80108eca:	01 d0                	add    %edx,%eax
80108ecc:	c1 e0 05             	shl    $0x5,%eax
80108ecf:	8d 90 f0 21 11 80    	lea    -0x7feede10(%eax),%edx
80108ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ed8:	89 02                	mov    %eax,(%edx)
    return 0;
80108eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108edf:	5d                   	pop    %ebp
80108ee0:	c3                   	ret    

80108ee1 <getusedmem>:

int getusedmem(int index){
80108ee1:	55                   	push   %ebp
80108ee2:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].used_mem;
80108ee4:	8b 55 08             	mov    0x8(%ebp),%edx
80108ee7:	89 d0                	mov    %edx,%eax
80108ee9:	c1 e0 02             	shl    $0x2,%eax
80108eec:	01 d0                	add    %edx,%eax
80108eee:	01 c0                	add    %eax,%eax
80108ef0:	01 d0                	add    %edx,%eax
80108ef2:	c1 e0 05             	shl    $0x5,%eax
80108ef5:	05 f0 21 11 80       	add    $0x801121f0,%eax
80108efa:	8b 40 04             	mov    0x4(%eax),%eax
}
80108efd:	5d                   	pop    %ebp
80108efe:	c3                   	ret    

80108eff <setusedmem>:

int setusedmem(int index, int used_mem){
80108eff:	55                   	push   %ebp
80108f00:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].used_mem = used_mem;
80108f02:	8b 55 08             	mov    0x8(%ebp),%edx
80108f05:	89 d0                	mov    %edx,%eax
80108f07:	c1 e0 02             	shl    $0x2,%eax
80108f0a:	01 d0                	add    %edx,%eax
80108f0c:	01 c0                	add    %eax,%eax
80108f0e:	01 d0                	add    %edx,%eax
80108f10:	c1 e0 05             	shl    $0x5,%eax
80108f13:	8d 90 f0 21 11 80    	lea    -0x7feede10(%eax),%edx
80108f19:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f1c:	89 42 04             	mov    %eax,0x4(%edx)
    return 0;
80108f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f24:	5d                   	pop    %ebp
80108f25:	c3                   	ret    

80108f26 <getuseddisk>:

int getuseddisk(int index){
80108f26:	55                   	push   %ebp
80108f27:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].used_disk;
80108f29:	8b 55 08             	mov    0x8(%ebp),%edx
80108f2c:	89 d0                	mov    %edx,%eax
80108f2e:	c1 e0 02             	shl    $0x2,%eax
80108f31:	01 d0                	add    %edx,%eax
80108f33:	01 c0                	add    %eax,%eax
80108f35:	01 d0                	add    %edx,%eax
80108f37:	c1 e0 05             	shl    $0x5,%eax
80108f3a:	05 f0 21 11 80       	add    $0x801121f0,%eax
80108f3f:	8b 40 08             	mov    0x8(%eax),%eax
}
80108f42:	5d                   	pop    %ebp
80108f43:	c3                   	ret    

80108f44 <setuseddisk>:

int setuseddisk(int index, int used_disk){
80108f44:	55                   	push   %ebp
80108f45:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].used_disk = used_disk;
80108f47:	8b 55 08             	mov    0x8(%ebp),%edx
80108f4a:	89 d0                	mov    %edx,%eax
80108f4c:	c1 e0 02             	shl    $0x2,%eax
80108f4f:	01 d0                	add    %edx,%eax
80108f51:	01 c0                	add    %eax,%eax
80108f53:	01 d0                	add    %edx,%eax
80108f55:	c1 e0 05             	shl    $0x5,%eax
80108f58:	8d 90 f0 21 11 80    	lea    -0x7feede10(%eax),%edx
80108f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f61:	89 42 08             	mov    %eax,0x8(%edx)
    return 0;
80108f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f69:	5d                   	pop    %ebp
80108f6a:	c3                   	ret    

80108f6b <setvc>:

int setvc(int index, char* vc){
80108f6b:	55                   	push   %ebp
80108f6c:	89 e5                	mov    %esp,%ebp
80108f6e:	53                   	push   %ebx
80108f6f:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80108f72:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((cabinet.tuperwares[index].vc[i++] = *vc++) != 0);
80108f79:	90                   	nop
80108f7a:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108f7d:	8d 42 01             	lea    0x1(%edx),%eax
80108f80:	89 45 f8             	mov    %eax,-0x8(%ebp)
80108f83:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f86:	8d 48 01             	lea    0x1(%eax),%ecx
80108f89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80108f8c:	8a 18                	mov    (%eax),%bl
80108f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108f91:	89 c8                	mov    %ecx,%eax
80108f93:	c1 e0 02             	shl    $0x2,%eax
80108f96:	01 c8                	add    %ecx,%eax
80108f98:	01 c0                	add    %eax,%eax
80108f9a:	01 c8                	add    %ecx,%eax
80108f9c:	c1 e0 05             	shl    $0x5,%eax
80108f9f:	01 d0                	add    %edx,%eax
80108fa1:	05 c0 20 11 80       	add    $0x801120c0,%eax
80108fa6:	88 18                	mov    %bl,(%eax)
80108fa8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108fab:	89 c8                	mov    %ecx,%eax
80108fad:	c1 e0 02             	shl    $0x2,%eax
80108fb0:	01 c8                	add    %ecx,%eax
80108fb2:	01 c0                	add    %eax,%eax
80108fb4:	01 c8                	add    %ecx,%eax
80108fb6:	c1 e0 05             	shl    $0x5,%eax
80108fb9:	01 d0                	add    %edx,%eax
80108fbb:	05 c0 20 11 80       	add    $0x801120c0,%eax
80108fc0:	8a 00                	mov    (%eax),%al
80108fc2:	84 c0                	test   %al,%al
80108fc4:	75 b4                	jne    80108f7a <setvc+0xf>

    return 0;
80108fc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108fcb:	83 c4 10             	add    $0x10,%esp
80108fce:	5b                   	pop    %ebx
80108fcf:	5d                   	pop    %ebp
80108fd0:	c3                   	ret    

80108fd1 <getvcfs>:

int getvcfs(char *vc, char *fs){
80108fd1:	55                   	push   %ebp
80108fd2:	89 e5                	mov    %esp,%ebp
80108fd4:	53                   	push   %ebx
80108fd5:	83 ec 18             	sub    $0x18,%esp
    int i, j = 0;
80108fd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(i = 0; i < NUM_VCS; i++){
80108fdf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80108fe6:	eb 65                	jmp    8010904d <getvcfs+0x7c>
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
80108fe8:	8b 55 f8             	mov    -0x8(%ebp),%edx
80108feb:	89 d0                	mov    %edx,%eax
80108fed:	c1 e0 02             	shl    $0x2,%eax
80108ff0:	01 d0                	add    %edx,%eax
80108ff2:	01 c0                	add    %eax,%eax
80108ff4:	01 d0                	add    %edx,%eax
80108ff6:	c1 e0 05             	shl    $0x5,%eax
80108ff9:	83 c0 20             	add    $0x20,%eax
80108ffc:	8d 90 a0 20 11 80    	lea    -0x7feedf60(%eax),%edx
80109002:	8b 45 08             	mov    0x8(%ebp),%eax
80109005:	89 44 24 04          	mov    %eax,0x4(%esp)
80109009:	89 14 24             	mov    %edx,(%esp)
8010900c:	e8 17 fd ff ff       	call   80108d28 <strcmp>
80109011:	85 c0                	test   %eax,%eax
80109013:	75 35                	jne    8010904a <getvcfs+0x79>
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
80109015:	90                   	nop
80109016:	8b 55 0c             	mov    0xc(%ebp),%edx
80109019:	8d 42 01             	lea    0x1(%edx),%eax
8010901c:	89 45 0c             	mov    %eax,0xc(%ebp)
8010901f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80109022:	8d 43 01             	lea    0x1(%ebx),%eax
80109025:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109028:	8b 4d f8             	mov    -0x8(%ebp),%ecx
8010902b:	89 c8                	mov    %ecx,%eax
8010902d:	c1 e0 02             	shl    $0x2,%eax
80109030:	01 c8                	add    %ecx,%eax
80109032:	01 c0                	add    %eax,%eax
80109034:	01 c8                	add    %ecx,%eax
80109036:	c1 e0 05             	shl    $0x5,%eax
80109039:	01 d8                	add    %ebx,%eax
8010903b:	05 a0 20 11 80       	add    $0x801120a0,%eax
80109040:	8a 00                	mov    (%eax),%al
80109042:	88 02                	mov    %al,(%edx)
80109044:	8a 02                	mov    (%edx),%al
80109046:	84 c0                	test   %al,%al
80109048:	75 cc                	jne    80109016 <getvcfs+0x45>
    return 0;
}

int getvcfs(char *vc, char *fs){
    int i, j = 0;
    for(i = 0; i < NUM_VCS; i++){
8010904a:	ff 45 f8             	incl   -0x8(%ebp)
8010904d:	83 7d f8 03          	cmpl   $0x3,-0x8(%ebp)
80109051:	7e 95                	jle    80108fe8 <getvcfs+0x17>
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
        }
    }return 0;
80109053:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109058:	83 c4 18             	add    $0x18,%esp
8010905b:	5b                   	pop    %ebx
8010905c:	5d                   	pop    %ebp
8010905d:	c3                   	ret    

8010905e <setactivefs>:

int setactivefs(char *fs){
8010905e:	55                   	push   %ebp
8010905f:	89 e5                	mov    %esp,%ebp
80109061:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
80109064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while((cabinet.active_fs[i++] = *fs++) != 0);
8010906b:	90                   	nop
8010906c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010906f:	8d 50 01             	lea    0x1(%eax),%edx
80109072:	89 55 fc             	mov    %edx,-0x4(%ebp)
80109075:	8b 55 08             	mov    0x8(%ebp),%edx
80109078:	8d 4a 01             	lea    0x1(%edx),%ecx
8010907b:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010907e:	8a 12                	mov    (%edx),%dl
80109080:	88 90 20 26 11 80    	mov    %dl,-0x7feed9e0(%eax)
80109086:	8a 80 20 26 11 80    	mov    -0x7feed9e0(%eax),%al
8010908c:	84 c0                	test   %al,%al
8010908e:	75 dc                	jne    8010906c <setactivefs+0xe>

    return 0;
80109090:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109095:	c9                   	leave  
80109096:	c3                   	ret    

80109097 <getactivefs>:

int getactivefs(char *fs){
80109097:	55                   	push   %ebp
80109098:	89 e5                	mov    %esp,%ebp
8010909a:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
8010909d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while((*fs++ = cabinet.active_fs[i++]) != 0);
801090a4:	90                   	nop
801090a5:	8b 45 08             	mov    0x8(%ebp),%eax
801090a8:	8d 50 01             	lea    0x1(%eax),%edx
801090ab:	89 55 08             	mov    %edx,0x8(%ebp)
801090ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
801090b1:	8d 4a 01             	lea    0x1(%edx),%ecx
801090b4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801090b7:	8a 92 20 26 11 80    	mov    -0x7feed9e0(%edx),%dl
801090bd:	88 10                	mov    %dl,(%eax)
801090bf:	8a 00                	mov    (%eax),%al
801090c1:	84 c0                	test   %al,%al
801090c3:	75 e0                	jne    801090a5 <getactivefs+0xe>

    return 0;
801090c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801090ca:	c9                   	leave  
801090cb:	c3                   	ret    

801090cc <getactivefsindex>:

int getactivefsindex(void){
801090cc:	55                   	push   %ebp
801090cd:	89 e5                	mov    %esp,%ebp
801090cf:	83 ec 18             	sub    $0x18,%esp
    int i, index = -1;
801090d2:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%ebp)
    for(i = 0; i < NUM_VCS; i++){
801090d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801090e0:	eb 35                	jmp    80109117 <getactivefsindex+0x4b>
        if(strcmp(&cabinet.active_fs[1], cabinet.tuperwares[i].name) == 0){
801090e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801090e5:	89 d0                	mov    %edx,%eax
801090e7:	c1 e0 02             	shl    $0x2,%eax
801090ea:	01 d0                	add    %edx,%eax
801090ec:	01 c0                	add    %eax,%eax
801090ee:	01 d0                	add    %edx,%eax
801090f0:	c1 e0 05             	shl    $0x5,%eax
801090f3:	05 a0 20 11 80       	add    $0x801120a0,%eax
801090f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801090fc:	c7 04 24 21 26 11 80 	movl   $0x80112621,(%esp)
80109103:	e8 20 fc ff ff       	call   80108d28 <strcmp>
80109108:	85 c0                	test   %eax,%eax
8010910a:	75 08                	jne    80109114 <getactivefsindex+0x48>
            index = i;
8010910c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010910f:	89 45 f8             	mov    %eax,-0x8(%ebp)
            break;
80109112:	eb 09                	jmp    8010911d <getactivefsindex+0x51>
    return 0;
}

int getactivefsindex(void){
    int i, index = -1;
    for(i = 0; i < NUM_VCS; i++){
80109114:	ff 45 fc             	incl   -0x4(%ebp)
80109117:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
8010911b:	7e c5                	jle    801090e2 <getactivefsindex+0x16>
        if(strcmp(&cabinet.active_fs[1], cabinet.tuperwares[i].name) == 0){
            index = i;
            break;
        }
    }return index;
8010911d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80109120:	c9                   	leave  
80109121:	c3                   	ret    

80109122 <setatroot>:

int setatroot(int index, int val){
80109122:	55                   	push   %ebp
80109123:	89 e5                	mov    %esp,%ebp
    cabinet.tuperwares[index].atroot = val;
80109125:	8b 55 08             	mov    0x8(%ebp),%edx
80109128:	89 d0                	mov    %edx,%eax
8010912a:	c1 e0 02             	shl    $0x2,%eax
8010912d:	01 d0                	add    %edx,%eax
8010912f:	01 c0                	add    %eax,%eax
80109131:	01 d0                	add    %edx,%eax
80109133:	c1 e0 05             	shl    $0x5,%eax
80109136:	8d 90 f0 21 11 80    	lea    -0x7feede10(%eax),%edx
8010913c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010913f:	89 42 0c             	mov    %eax,0xc(%edx)

    return 0;
80109142:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109147:	5d                   	pop    %ebp
80109148:	c3                   	ret    

80109149 <getatroot>:

int getatroot(int index){
80109149:	55                   	push   %ebp
8010914a:	89 e5                	mov    %esp,%ebp
    return cabinet.tuperwares[index].atroot;
8010914c:	8b 55 08             	mov    0x8(%ebp),%edx
8010914f:	89 d0                	mov    %edx,%eax
80109151:	c1 e0 02             	shl    $0x2,%eax
80109154:	01 d0                	add    %edx,%eax
80109156:	01 c0                	add    %eax,%eax
80109158:	01 d0                	add    %edx,%eax
8010915a:	c1 e0 05             	shl    $0x5,%eax
8010915d:	05 f0 21 11 80       	add    $0x801121f0,%eax
80109162:	8b 40 0c             	mov    0xc(%eax),%eax
}
80109165:	5d                   	pop    %ebp
80109166:	c3                   	ret    

80109167 <getpath>:

int getpath(int index, char *path){
80109167:	55                   	push   %ebp
80109168:	89 e5                	mov    %esp,%ebp
8010916a:	53                   	push   %ebx
8010916b:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
8010916e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((*path++ = cabinet.tuperwares[index].path[i++]) != 0);
80109175:	90                   	nop
80109176:	8b 55 0c             	mov    0xc(%ebp),%edx
80109179:	8d 42 01             	lea    0x1(%edx),%eax
8010917c:	89 45 0c             	mov    %eax,0xc(%ebp)
8010917f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80109182:	8d 43 01             	lea    0x1(%ebx),%eax
80109185:	89 45 f8             	mov    %eax,-0x8(%ebp)
80109188:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010918b:	89 c8                	mov    %ecx,%eax
8010918d:	c1 e0 02             	shl    $0x2,%eax
80109190:	01 c8                	add    %ecx,%eax
80109192:	01 c0                	add    %eax,%eax
80109194:	01 c8                	add    %ecx,%eax
80109196:	c1 e0 05             	shl    $0x5,%eax
80109199:	01 d8                	add    %ebx,%eax
8010919b:	05 e0 20 11 80       	add    $0x801120e0,%eax
801091a0:	8a 00                	mov    (%eax),%al
801091a2:	88 02                	mov    %al,(%edx)
801091a4:	8a 02                	mov    (%edx),%al
801091a6:	84 c0                	test   %al,%al
801091a8:	75 cc                	jne    80109176 <getpath+0xf>

    return 0;
801091aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801091af:	83 c4 10             	add    $0x10,%esp
801091b2:	5b                   	pop    %ebx
801091b3:	5d                   	pop    %ebp
801091b4:	c3                   	ret    

801091b5 <setpath>:

int setpath(int index, char *path, int remove){
801091b5:	55                   	push   %ebp
801091b6:	89 e5                	mov    %esp,%ebp
801091b8:	81 ec 28 02 00 00    	sub    $0x228,%esp
    int i = 0, j;
801091be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char *token_cab, *token_path;
    char *path_arr[128];

    if(remove == 1){
801091c5:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
801091c9:	0f 85 d9 00 00 00    	jne    801092a8 <setpath+0xf3>
        token_cab = strtok(cabinet.tuperwares[index].path, "/");
801091cf:	8b 55 08             	mov    0x8(%ebp),%edx
801091d2:	89 d0                	mov    %edx,%eax
801091d4:	c1 e0 02             	shl    $0x2,%eax
801091d7:	01 d0                	add    %edx,%eax
801091d9:	01 c0                	add    %eax,%eax
801091db:	01 d0                	add    %edx,%eax
801091dd:	c1 e0 05             	shl    $0x5,%eax
801091e0:	83 c0 40             	add    $0x40,%eax
801091e3:	05 a0 20 11 80       	add    $0x801120a0,%eax
801091e8:	c7 44 24 04 b2 9c 10 	movl   $0x80109cb2,0x4(%esp)
801091ef:	80 
801091f0:	89 04 24             	mov    %eax,(%esp)
801091f3:	e8 03 c3 ff ff       	call   801054fb <strtok>
801091f8:	89 45 ec             	mov    %eax,-0x14(%ebp)

        path_arr[0] = token_cab; // c0
801091fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091fe:	89 85 e8 fd ff ff    	mov    %eax,-0x218(%ebp)

        while(token_cab != 0){
80109204:	eb 2a                	jmp    80109230 <setpath+0x7b>
            token_cab = strtok(0, "/");
80109206:	c7 44 24 04 b2 9c 10 	movl   $0x80109cb2,0x4(%esp)
8010920d:	80 
8010920e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80109215:	e8 e1 c2 ff ff       	call   801054fb <strtok>
8010921a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            path_arr[i++] = token_cab;
8010921d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109220:	8d 50 01             	lea    0x1(%eax),%edx
80109223:	89 55 f4             	mov    %edx,-0xc(%ebp)
80109226:	8b 55 ec             	mov    -0x14(%ebp),%edx
80109229:	89 94 85 e8 fd ff ff 	mov    %edx,-0x218(%ebp,%eax,4)
    if(remove == 1){
        token_cab = strtok(cabinet.tuperwares[index].path, "/");

        path_arr[0] = token_cab; // c0

        while(token_cab != 0){
80109230:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109234:	75 d0                	jne    80109206 <setpath+0x51>
            token_cab = strtok(0, "/");
            path_arr[i++] = token_cab;
        }
        // path_arr = [c0, test, v2]

        token_path = strtok(path, "/");
80109236:	c7 44 24 04 b2 9c 10 	movl   $0x80109cb2,0x4(%esp)
8010923d:	80 
8010923e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109241:	89 04 24             	mov    %eax,(%esp)
80109244:	e8 b2 c2 ff ff       	call   801054fb <strtok>
80109249:	89 45 e8             	mov    %eax,-0x18(%ebp)
        while(token_path != 0){
8010924c:	eb 54                	jmp    801092a2 <setpath+0xed>
            token_path = strtok(0, "/");
8010924e:	c7 44 24 04 b2 9c 10 	movl   $0x80109cb2,0x4(%esp)
80109255:	80 
80109256:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010925d:	e8 99 c2 ff ff       	call   801054fb <strtok>
80109262:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if(strcmp(token_path, "..") == 0){
80109265:	c7 44 24 04 b4 9c 10 	movl   $0x80109cb4,0x4(%esp)
8010926c:	80 
8010926d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109270:	89 04 24             	mov    %eax,(%esp)
80109273:	e8 b0 fa ff ff       	call   80108d28 <strcmp>
80109278:	85 c0                	test   %eax,%eax
8010927a:	75 13                	jne    8010928f <setpath+0xda>
                path_arr[--i] = 0;
8010927c:	ff 4d f4             	decl   -0xc(%ebp)
8010927f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109282:	c7 84 85 e8 fd ff ff 	movl   $0x0,-0x218(%ebp,%eax,4)
80109289:	00 00 00 00 
8010928d:	eb 13                	jmp    801092a2 <setpath+0xed>
            }
            else{
                path_arr[i++] = token_path;
8010928f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109292:	8d 50 01             	lea    0x1(%eax),%edx
80109295:	89 55 f4             	mov    %edx,-0xc(%ebp)
80109298:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010929b:	89 94 85 e8 fd ff ff 	mov    %edx,-0x218(%ebp,%eax,4)
            path_arr[i++] = token_cab;
        }
        // path_arr = [c0, test, v2]

        token_path = strtok(path, "/");
        while(token_path != 0){
801092a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801092a6:	75 a6                	jne    8010924e <setpath+0x99>
                path_arr[i++] = token_path;
            }
        }
    }

    strcpy(cabinet.tuperwares[index].path, path_arr[0]);
801092a8:	8b 8d e8 fd ff ff    	mov    -0x218(%ebp),%ecx
801092ae:	8b 55 08             	mov    0x8(%ebp),%edx
801092b1:	89 d0                	mov    %edx,%eax
801092b3:	c1 e0 02             	shl    $0x2,%eax
801092b6:	01 d0                	add    %edx,%eax
801092b8:	01 c0                	add    %eax,%eax
801092ba:	01 d0                	add    %edx,%eax
801092bc:	c1 e0 05             	shl    $0x5,%eax
801092bf:	83 c0 40             	add    $0x40,%eax
801092c2:	05 a0 20 11 80       	add    $0x801120a0,%eax
801092c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801092cb:	89 04 24             	mov    %eax,(%esp)
801092ce:	e8 59 c0 ff ff       	call   8010532c <strcpy>
    for(j = 1; j < i; j++){
801092d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801092da:	eb 32                	jmp    8010930e <setpath+0x159>
        strcat(cabinet.tuperwares[index].path, path_arr[j]);
801092dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092df:	8b 8c 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%ecx
801092e6:	8b 55 08             	mov    0x8(%ebp),%edx
801092e9:	89 d0                	mov    %edx,%eax
801092eb:	c1 e0 02             	shl    $0x2,%eax
801092ee:	01 d0                	add    %edx,%eax
801092f0:	01 c0                	add    %eax,%eax
801092f2:	01 d0                	add    %edx,%eax
801092f4:	c1 e0 05             	shl    $0x5,%eax
801092f7:	83 c0 40             	add    $0x40,%eax
801092fa:	05 a0 20 11 80       	add    $0x801120a0,%eax
801092ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80109303:	89 04 24             	mov    %eax,(%esp)
80109306:	e8 11 c1 ff ff       	call   8010541c <strcat>
            }
        }
    }

    strcpy(cabinet.tuperwares[index].path, path_arr[0]);
    for(j = 1; j < i; j++){
8010930b:	ff 45 f0             	incl   -0x10(%ebp)
8010930e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109311:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80109314:	7c c6                	jl     801092dc <setpath+0x127>
        strcat(cabinet.tuperwares[index].path, path_arr[j]);
    }

    strcpy(path, cabinet.tuperwares[index].path);
80109316:	8b 55 08             	mov    0x8(%ebp),%edx
80109319:	89 d0                	mov    %edx,%eax
8010931b:	c1 e0 02             	shl    $0x2,%eax
8010931e:	01 d0                	add    %edx,%eax
80109320:	01 c0                	add    %eax,%eax
80109322:	01 d0                	add    %edx,%eax
80109324:	c1 e0 05             	shl    $0x5,%eax
80109327:	83 c0 40             	add    $0x40,%eax
8010932a:	05 a0 20 11 80       	add    $0x801120a0,%eax
8010932f:	89 44 24 04          	mov    %eax,0x4(%esp)
80109333:	8b 45 0c             	mov    0xc(%ebp),%eax
80109336:	89 04 24             	mov    %eax,(%esp)
80109339:	e8 ee bf ff ff       	call   8010532c <strcpy>
    return 0;
8010933e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109343:	c9                   	leave  
80109344:	c3                   	ret    

80109345 <tostring>:

int tostring(char *string){
80109345:	55                   	push   %ebp
80109346:	89 e5                	mov    %esp,%ebp
80109348:	83 ec 48             	sub    $0x48,%esp
    int i;
    strncpy(string, "Active FS: ", 11);
8010934b:	c7 44 24 08 0b 00 00 	movl   $0xb,0x8(%esp)
80109352:	00 
80109353:	c7 44 24 04 b7 9c 10 	movl   $0x80109cb7,0x4(%esp)
8010935a:	80 
8010935b:	8b 45 08             	mov    0x8(%ebp),%eax
8010935e:	89 04 24             	mov    %eax,(%esp)
80109361:	e8 f4 bf ff ff       	call   8010535a <strncpy>
    strcat(string, cabinet.active_fs);
80109366:	c7 44 24 04 20 26 11 	movl   $0x80112620,0x4(%esp)
8010936d:	80 
8010936e:	8b 45 08             	mov    0x8(%ebp),%eax
80109371:	89 04 24             	mov    %eax,(%esp)
80109374:	e8 a3 c0 ff ff       	call   8010541c <strcat>
    strcat(string, "\n\n");
80109379:	c7 44 24 04 c3 9c 10 	movl   $0x80109cc3,0x4(%esp)
80109380:	80 
80109381:	8b 45 08             	mov    0x8(%ebp),%eax
80109384:	89 04 24             	mov    %eax,(%esp)
80109387:	e8 90 c0 ff ff       	call   8010541c <strcat>
    for(i = 0; i < NUM_VCS; i++){
8010938c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109393:	e9 ee 00 00 00       	jmp    80109486 <tostring+0x141>
        if(cabinet.tuperwares[i].name != 0){
            strcat(string, "Name: ");
80109398:	c7 44 24 04 c6 9c 10 	movl   $0x80109cc6,0x4(%esp)
8010939f:	80 
801093a0:	8b 45 08             	mov    0x8(%ebp),%eax
801093a3:	89 04 24             	mov    %eax,(%esp)
801093a6:	e8 71 c0 ff ff       	call   8010541c <strcat>
            strcat(string, cabinet.tuperwares[i].name);
801093ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801093ae:	89 d0                	mov    %edx,%eax
801093b0:	c1 e0 02             	shl    $0x2,%eax
801093b3:	01 d0                	add    %edx,%eax
801093b5:	01 c0                	add    %eax,%eax
801093b7:	01 d0                	add    %edx,%eax
801093b9:	c1 e0 05             	shl    $0x5,%eax
801093bc:	05 a0 20 11 80       	add    $0x801120a0,%eax
801093c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801093c5:	8b 45 08             	mov    0x8(%ebp),%eax
801093c8:	89 04 24             	mov    %eax,(%esp)
801093cb:	e8 4c c0 ff ff       	call   8010541c <strcat>
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
801093d0:	c7 44 24 04 cd 9c 10 	movl   $0x80109ccd,0x4(%esp)
801093d7:	80 
801093d8:	8b 45 08             	mov    0x8(%ebp),%eax
801093db:	89 04 24             	mov    %eax,(%esp)
801093de:	e8 39 c0 ff ff       	call   8010541c <strcat>
        if(cabinet.tuperwares[i].vc != 0){
            strcat(string, "VC: ");
801093e3:	c7 44 24 04 cf 9c 10 	movl   $0x80109ccf,0x4(%esp)
801093ea:	80 
801093eb:	8b 45 08             	mov    0x8(%ebp),%eax
801093ee:	89 04 24             	mov    %eax,(%esp)
801093f1:	e8 26 c0 ff ff       	call   8010541c <strcat>
            strcat(string, cabinet.tuperwares[i].vc);
801093f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801093f9:	89 d0                	mov    %edx,%eax
801093fb:	c1 e0 02             	shl    $0x2,%eax
801093fe:	01 d0                	add    %edx,%eax
80109400:	01 c0                	add    %eax,%eax
80109402:	01 d0                	add    %edx,%eax
80109404:	c1 e0 05             	shl    $0x5,%eax
80109407:	83 c0 20             	add    $0x20,%eax
8010940a:	05 a0 20 11 80       	add    $0x801120a0,%eax
8010940f:	89 44 24 04          	mov    %eax,0x4(%esp)
80109413:	8b 45 08             	mov    0x8(%ebp),%eax
80109416:	89 04 24             	mov    %eax,(%esp)
80109419:	e8 fe bf ff ff       	call   8010541c <strcat>
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
8010941e:	c7 44 24 04 cd 9c 10 	movl   $0x80109ccd,0x4(%esp)
80109425:	80 
80109426:	8b 45 08             	mov    0x8(%ebp),%eax
80109429:	89 04 24             	mov    %eax,(%esp)
8010942c:	e8 eb bf ff ff       	call   8010541c <strcat>
        strcat(string, "Index: ");
80109431:	c7 44 24 04 d4 9c 10 	movl   $0x80109cd4,0x4(%esp)
80109438:	80 
80109439:	8b 45 08             	mov    0x8(%ebp),%eax
8010943c:	89 04 24             	mov    %eax,(%esp)
8010943f:	e8 d8 bf ff ff       	call   8010541c <strcat>
        char num_string[32];
        itoa(i, num_string, 10);
80109444:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
8010944b:	00 
8010944c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010944f:	89 44 24 04          	mov    %eax,0x4(%esp)
80109453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109456:	89 04 24             	mov    %eax,(%esp)
80109459:	e8 29 c1 ff ff       	call   80105587 <itoa>
        strcat(string, num_string);
8010945e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109461:	89 44 24 04          	mov    %eax,0x4(%esp)
80109465:	8b 45 08             	mov    0x8(%ebp),%eax
80109468:	89 04 24             	mov    %eax,(%esp)
8010946b:	e8 ac bf ff ff       	call   8010541c <strcat>
        strcat(string, "\n\n");
80109470:	c7 44 24 04 c3 9c 10 	movl   $0x80109cc3,0x4(%esp)
80109477:	80 
80109478:	8b 45 08             	mov    0x8(%ebp),%eax
8010947b:	89 04 24             	mov    %eax,(%esp)
8010947e:	e8 99 bf ff ff       	call   8010541c <strcat>
int tostring(char *string){
    int i;
    strncpy(string, "Active FS: ", 11);
    strcat(string, cabinet.active_fs);
    strcat(string, "\n\n");
    for(i = 0; i < NUM_VCS; i++){
80109483:	ff 45 f4             	incl   -0xc(%ebp)
80109486:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
8010948a:	0f 8e 08 ff ff ff    	jle    80109398 <tostring+0x53>
        char num_string[32];
        itoa(i, num_string, 10);
        strcat(string, num_string);
        strcat(string, "\n\n");
    }
    strcat(string, "\0");
80109490:	c7 44 24 04 dc 9c 10 	movl   $0x80109cdc,0x4(%esp)
80109497:	80 
80109498:	8b 45 08             	mov    0x8(%ebp),%eax
8010949b:	89 04 24             	mov    %eax,(%esp)
8010949e:	e8 79 bf ff ff       	call   8010541c <strcat>
    return 0;
801094a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801094a8:	c9                   	leave  
801094a9:	c3                   	ret    
