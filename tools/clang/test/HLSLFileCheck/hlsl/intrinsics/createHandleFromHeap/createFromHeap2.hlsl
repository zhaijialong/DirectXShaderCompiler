// RUN: %dxc -T ps_6_6 %s | %FileCheck %s

// Make sure snorm/unorm and globallycoherent works.
// CHECK:call %dx.types.Handle @dx.op.createHandleFromHeap(i32 218
// CHECK:call %dx.types.Handle @dx.op.createHandleFromHeap(i32 218
// CHECK:call %dx.types.Handle @dx.op.createHandleFromHeap(i32 218
// CHECK:call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %{{.*}}, %dx.types.ResourceProperties { i32 4106, i32 270 })  ; AnnotateHandle(res,props)  resource: RWTypedBuffer<UNormF32>
// CHECK:call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %{{.*}}, %dx.types.ResourceProperties { i32 20490, i32 269 })  ; AnnotateHandle(res,props)  resource: globallycoherent RWTypedBuffer<SNormF32>
// CHECK:call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %{{.*}}, %dx.types.ResourceProperties { i32 20490, i32 269 })  ; AnnotateHandle(res,props)  resource: globallycoherent RWTypedBuffer<SNormF32>


struct S {
RWBuffer<unorm float> buf;
globallycoherent RWBuffer<snorm float> buf1[2];
};

uint ID;
float main(uint i:I): SV_Target {
  S s;
  s.buf = ResourceDescriptorHeap[ID];
  s.buf1[0] = ResourceDescriptorHeap[ID+1];
  s.buf1[1] = ResourceDescriptorHeap[ID+2];
  return s.buf[i] + s.buf1[0][i] + s.buf1[1][i];
}