// RUN: %swift -prespecialize-generic-metadata -target %module-target-future -emit-ir %s | %FileCheck %s -DINT=i%target-ptrsize -DALIGNMENT=%target-alignment

// REQUIRES: VENDOR=apple || OS=linux-gnu
// UNSUPPORTED: CPU=i386 && OS=ios
// UNSUPPORTED: CPU=armv7 && OS=ios
// UNSUPPORTED: CPU=armv7s && OS=ios

// CHECK: @"$s4main9NamespaceC5ValueOySi_GMf" = linkonce_odr hidden constant <{
// CHECk-SAME:    i8**,
// CHECK-SAME:    [[INT]],
// CHECK-SAME:    %swift.type_descriptor*,
// CHECK-SAME:    %swift.type*,
// CHECK-SAME: }> <{
//                i8** getelementptr inbounds (
//                  %swift.enum_vwtable, 
//                  %swift.enum_vwtable* @"$s4main9NamespaceC5ValueOySi_GWV", 
//                  i32 0, 
//                  i32 0
//                ),
// CHECK-SAME:    [[INT]] 513,
// CHECK-SAME:    %swift.type_descriptor* bitcast ({{.*}}$s4main9NamespaceC5ValueOMn{{.*}} to %swift.type_descriptor*),
// CHECK-SAME:    %swift.type* @"$sSiN",
// CHECK-SAME:    i64 3
// CHECK-SAME: }>, align [[ALIGNMENT]]


final class Namespace<First> {
  enum Value {
    case first(First)
  }
}

@inline(never)
func consume<T>(_ t: T) {
  withExtendedLifetime(t) { t in
  }
}

// CHECK: define hidden swiftcc void @"$s4main4doityyF"() #{{[0-9]+}} {
// CHECK:   call swiftcc void @"$s4main7consumeyyxlF"(
// CHECK-SAME:     %swift.opaque* noalias nocapture %{{[0-9]+}}, 
// CHECK-SAME:     %swift.type* getelementptr inbounds (
// CHECK-SAME:       %swift.full_type, 
// CHECK-SAME:       %swift.full_type* bitcast (
// CHECK-SAME:         <{ 
// CHECK-SAME:           i8**, 
// CHECK-SAME:           [[INT]], 
// CHECK-SAME:           %swift.type_descriptor*, 
// CHECK-SAME:           %swift.type*, 
// CHECK-SAME:           i64 
// CHECK-SAME:         }>* @"$s4main9NamespaceC5ValueOySi_GMf" 
// CHECK-SAME:         to %swift.full_type*
// CHECK-SAME:       ), 
// CHECK-SAME:       i32 0, 
// CHECK-SAME:       i32 1
// CHECK-SAME:     )
// CHECK-SAME:   )
// CHECK: }
func doit() {
  consume( Namespace.Value.first(13) )
}
doit()

// CHECK: ; Function Attrs: noinline nounwind readnone
// CHECK: define hidden swiftcc %swift.metadata_response @"$s4main9NamespaceC5ValueOMa"([[INT]] %0, %swift.type* %1) #{{[0-9]+}} {{(section)?.*}}{
// CHECK: entry:
// CHECK:   [[ERASED_TYPE_1:%[0-9]+]] = bitcast %swift.type* %1 to i8*
// CHECK:   {{%[0-9]+}} = call swiftcc %swift.metadata_response @__swift_instantiateCanonicalPrespecializedGenericMetadata(
// CHECK-SAME:     [[INT]] %0, 
// CHECK-SAME:     i8* [[ERASED_TYPE_1]], 
// CHECK-SAME:     i8* undef, 
// CHECK-SAME:     i8* undef, 
// CHECK-SAME:     %swift.type_descriptor* bitcast (
// CHECK-SAME:       {{.*}}$s4main9NamespaceC5ValueOMn{{.*}} to %swift.type_descriptor*
// CHECK-SAME:     )
// CHECK-SAME:   ) #{{[0-9]+}}
// CHECK:   ret %swift.metadata_response {{%[0-9]+}}
// CHECK: }
