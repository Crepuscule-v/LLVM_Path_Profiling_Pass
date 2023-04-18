; ModuleID = 'test.ll'
source_filename = "loop_test.cpp"
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
@.str = private unnamed_addr constant [6 x i8] c"pos 1\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"pos 2\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"pos 3\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"pos 4\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @_GLOBAL__sub_I_loop_test.cpp, ptr null }]
@__Z9easy_loopii_counter_array = private global ptr null, align 8
@0 = private unnamed_addr constant [15 x i8] c"_Z9easy_loopii\00", align 1
@_main_counter_array = private global ptr null, align 8
@1 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@__GLOBAL__sub_I_loop_test.cpp_counter_array = private global ptr null, align 8
@2 = private unnamed_addr constant [29 x i8] c"_GLOBAL__sub_I_loop_test.cpp\00", align 1

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
define dso_local void @_Z9easy_loopii(i32 noundef %0, i32 noundef %1) #4 {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %2 = load ptr, ptr @__Z9easy_loopii_counter_array, align 8
  %3 = ptrtoint ptr %2 to i64
  %4 = sub i64 %3, 0
  %5 = sdiv exact i64 %4, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %block_init, label %_Z9easy_loopii_block_1

_Z9easy_loopii_block_1:                           ; preds = %block_init, %block_judge
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %0, ptr %7, align 4
  store i32 %1, ptr %8, align 4
  %10 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str)
  %11 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %10, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %12 = load i32, ptr %7, align 4
  %13 = icmp sgt i32 %12, 5
  br i1 %13, label %_Z9easy_loopii_block_2, label %28

_Z9easy_loopii_block_2:                           ; preds = %_Z9easy_loopii_block_1
  %14 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.1)
  %15 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %14, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  store i32 0, ptr %9, align 4
  br label %_Z9easy_loopii_block_3

16:                                               ; preds = %_Z9easy_loopii_block_5
  %17 = load i32, ptr %r_ptr, align 4
  %18 = add i32 %17, 0
  store i32 %18, ptr %r_ptr, align 4
  %19 = load ptr, ptr @__Z9easy_loopii_counter_array, align 8
  %20 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %20, ptr %19)
  store i32 3, ptr %r_ptr, align 4
  br label %_Z9easy_loopii_block_3

_Z9easy_loopii_block_3:                           ; preds = %16, %_Z9easy_loopii_block_2
  %21 = load i32, ptr %9, align 4
  %22 = load i32, ptr %8, align 4
  %23 = icmp slt i32 %21, %22
  br i1 %23, label %_Z9easy_loopii_block_4, label %_Z9easy_loopii_block_6

_Z9easy_loopii_block_4:                           ; preds = %_Z9easy_loopii_block_3
  %24 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.2)
  %25 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %24, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  br label %_Z9easy_loopii_block_5

_Z9easy_loopii_block_5:                           ; preds = %_Z9easy_loopii_block_4
  %26 = load i32, ptr %9, align 4
  %27 = add nsw i32 %26, 1
  store i32 %27, ptr %9, align 4
  br label %16, !llvm.loop !6

_Z9easy_loopii_block_6:                           ; preds = %_Z9easy_loopii_block_3
  br label %31

28:                                               ; preds = %_Z9easy_loopii_block_1
  %29 = load i32, ptr %r_ptr, align 4
  %30 = add i32 %29, 2
  store i32 %30, ptr %r_ptr, align 4
  br label %_Z9easy_loopii_block_7

31:                                               ; preds = %_Z9easy_loopii_block_6
  %32 = load i32, ptr %r_ptr, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %r_ptr, align 4
  br label %_Z9easy_loopii_block_7

_Z9easy_loopii_block_7:                           ; preds = %31, %28
  %34 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.3)
  %35 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %34, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  %36 = load ptr, ptr @__Z9easy_loopii_counter_array, align 8
  %37 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %37, ptr %36)
  ret void

block_init:                                       ; preds = %block_judge
  %38 = call ptr @initCounter(i32 5, ptr @0)
  store ptr %38, ptr @__Z9easy_loopii_counter_array, align 8
  br label %_Z9easy_loopii_block_1
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
  %5 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef @.str.4)
  %6 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %5, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  call void @_Z9easy_loopii(i32 noundef 10, i32 noundef 4)
  call void @_Z9easy_loopii(i32 noundef 4, i32 noundef 4)
  call void @_Z9easy_loopii(i32 noundef 6, i32 noundef 0)
  %7 = load ptr, ptr @_main_counter_array, align 8
  %8 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %8, ptr %7)
  call void @print_result()
  ret i32 0

block_init:                                       ; preds = %block_judge
  %9 = call ptr @initCounter(i32 1, ptr @1)
  store ptr %9, ptr @_main_counter_array, align 8
  br label %main_block_1
}

; Function Attrs: noinline uwtable
define internal void @_GLOBAL__sub_I_loop_test.cpp() #0 section ".text.startup" {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %0 = load ptr, ptr @__GLOBAL__sub_I_loop_test.cpp_counter_array, align 8
  %1 = ptrtoint ptr %0 to i64
  %2 = sub i64 %1, 0
  %3 = sdiv exact i64 %2, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %4 = icmp eq i64 %3, 0
  br i1 %4, label %block_init, label %_GLOBAL__sub_I_loop_test.cpp_block_1

_GLOBAL__sub_I_loop_test.cpp_block_1:             ; preds = %block_init, %block_judge
  call void @__cxx_global_var_init()
  %5 = load ptr, ptr @__GLOBAL__sub_I_loop_test.cpp_counter_array, align 8
  %6 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %6, ptr %5)
  ret void

block_init:                                       ; preds = %block_judge
  %7 = call ptr @initCounter(i32 1, ptr @2)
  store ptr %7, ptr @__GLOBAL__sub_I_loop_test.cpp_counter_array, align 8
  br label %_GLOBAL__sub_I_loop_test.cpp_block_1
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
