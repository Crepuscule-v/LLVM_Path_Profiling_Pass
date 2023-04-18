; ModuleID = 'test.ll'
source_filename = "basic.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%"class.std::basic_ostream" = type { ptr, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", ptr, i8, i8, ptr, ptr, ptr, ptr }
%"class.std::ios_base" = type { ptr, i64, i64, i32, i32, i32, ptr, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, ptr, %"class.std::locale" }
%"struct.std::ios_base::_Words" = type { ptr, i64 }
%"class.std::locale" = type { ptr }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external hidden global i8
@_ZSt4cout = external global %"class.std::basic_ostream", align 8
@.str = private unnamed_addr constant [8 x i8] c"Block A\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"Block B\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"Block C\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"Block D\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@.str.5 = private unnamed_addr constant [14 x i8] c"hello world 1\00", align 1
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @_GLOBAL__sub_I_basic.cpp, ptr null }]
@__Z15exampleFunctioni_counter_array = private global ptr null, align 8
@0 = private unnamed_addr constant [21 x i8] c"_Z15exampleFunctioni\00", align 1
@_main_counter_array = private global ptr null, align 8
@1 = private unnamed_addr constant [5 x i8] c"main\00", align 1

; Function Attrs: noinline uwtable
define internal void @__cxx_global_var_init() #0 section ".text.startup" {
  call void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1) @_ZStL8__ioinit)
  %1 = call i32 @__cxa_atexit(ptr @_ZNSt8ios_base4InitD1Ev, ptr @_ZStL8__ioinit, ptr @__dso_handle) #3
  ret void
}

declare void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #1

; Function Attrs: nounwind
declare void @_ZNSt8ios_base4InitD1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #2

; Function Attrs: nounwind
declare i32 @__cxa_atexit(ptr, ptr, ptr) #3

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z15exampleFunctioni(i32 noundef %0) #4 {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %1 = load ptr, ptr @__Z15exampleFunctioni_counter_array, align 8
  %2 = ptrtoint ptr %1 to i64
  %3 = sub i64 %2, 0
  %4 = sdiv exact i64 %3, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %block_init, label %_Z15exampleFunctioni_block_1

_Z15exampleFunctioni_block_1:                     ; preds = %block_init, %block_judge
  %6 = alloca i32, align 4
  store i32 %0, ptr %6, align 4
  %7 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str)
  %8 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %7, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %9 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.1)
  %10 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %9, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %11 = load i32, ptr %6, align 4
  %12 = icmp sgt i32 %11, 0
  br i1 %12, label %_Z15exampleFunctioni_block_2, label %15

_Z15exampleFunctioni_block_2:                     ; preds = %_Z15exampleFunctioni_block_1
  %13 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.2)
  %14 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %13, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  br label %_Z15exampleFunctioni_block_3

15:                                               ; preds = %_Z15exampleFunctioni_block_1
  %16 = load i32, ptr %r_ptr, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %r_ptr, align 4
  br label %_Z15exampleFunctioni_block_3

_Z15exampleFunctioni_block_3:                     ; preds = %15, %_Z15exampleFunctioni_block_2
  %18 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.3)
  %19 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %18, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %20 = load ptr, ptr @__Z15exampleFunctioni_counter_array, align 8
  %21 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %21, ptr %20)
  ret void

block_init:                                       ; preds = %block_judge
  %22 = call ptr @initCounter(i32 2, ptr @0)
  store ptr %22, ptr @__Z15exampleFunctioni_counter_array, align 8
  br label %_Z15exampleFunctioni_block_1
}

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef) #1

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef) #1

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(ptr noundef nonnull align 8 dereferenceable(8)) #1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #5 {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %0 = load ptr, ptr @_main_counter_array, align 8
  %1 = ptrtoint ptr %0 to i64
  %2 = sub i64 %1, 0
  %3 = sdiv exact i64 %2, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %block_init, label %main_block_1

main_block_1:                                     ; preds = %block_init, %block_judge
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, ptr %5, align 4
  %7 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.4)
  %8 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %7, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  store i32 0, ptr %6, align 4
  br label %main_block_2

main_block_2:                                     ; preds = %main_block_4, %main_block_1
  %9 = load i32, ptr %6, align 4
  %10 = icmp slt i32 %9, 10
  br i1 %10, label %main_block_3, label %main_block_5

main_block_3:                                     ; preds = %main_block_2
  %11 = load i32, ptr %6, align 4
  %12 = srem i32 %11, 2
  call void @_Z15exampleFunctioni(i32 noundef %12)
  br label %main_block_4

main_block_4:                                     ; preds = %main_block_3
  %13 = load i32, ptr %6, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr %6, align 4
  br label %main_block_2, !llvm.loop !6

main_block_5:                                     ; preds = %main_block_2
  %15 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.5)
  %16 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %15, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %17 = load ptr, ptr @_main_counter_array, align 8
  %18 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %18, ptr %17)
  call void @print_result()
  ret i32 0

block_init:                                       ; preds = %block_judge
  %19 = call ptr @initCounter(i32 0, ptr @1)
  store ptr %19, ptr @_main_counter_array, align 8
  br label %main_block_1
}

; Function Attrs: noinline uwtable
define internal void @_GLOBAL__sub_I_basic.cpp() #0 section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

declare ptr @initCounter(i32, ptr)

declare void @updateCounter(i32, ptr)

declare void @print_result()

attributes #0 = { noinline uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 15.0.7"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
