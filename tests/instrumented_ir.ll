; ModuleID = 'test.ll'
source_filename = "test1.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__Z4add4i_counter_array = private global ptr null, align 8
@0 = private unnamed_addr constant [9 x i8] c"_Z4add4i\00", align 1
@_main_counter_array = private global ptr null, align 8
@1 = private unnamed_addr constant [5 x i8] c"main\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @_Z4add4i(i32 noundef %0) #0 {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %1 = load ptr, ptr @__Z4add4i_counter_array, align 8
  %2 = ptrtoint ptr %1 to i64
  %3 = sub i64 %2, 0
  %4 = sdiv exact i64 %3, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %block_init, label %_Z4add4i_block_1

_Z4add4i_block_1:                                 ; preds = %block_init, %block_judge
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, ptr %7, align 4
  %8 = load i32, ptr %7, align 4
  %9 = icmp sle i32 %8, 0
  br i1 %9, label %_Z4add4i_block_2, label %_Z4add4i_block_3

_Z4add4i_block_2:                                 ; preds = %_Z4add4i_block_1
  store i32 0, ptr %6, align 4
  br label %_Z4add4i_block_4

_Z4add4i_block_3:                                 ; preds = %_Z4add4i_block_1
  %10 = load i32, ptr %7, align 4
  %11 = add nsw i32 %10, 4
  store i32 %11, ptr %6, align 4
  br label %_Z4add4i_block_4

_Z4add4i_block_4:                                 ; preds = %_Z4add4i_block_3, %_Z4add4i_block_2
  %12 = load i32, ptr %6, align 4
  %13 = load ptr, ptr %r_ptr, align 8
  %14 = load i32, ptr @__Z4add4i_counter_array, align 4
  call void @updateCounter(ptr %13, i32 %14)
  ret i32 %12

block_init:                                       ; preds = %block_judge
  %15 = call ptr @initCounter(i32 0, ptr @0)
  store ptr %15, ptr @__Z4add4i_counter_array, align 8
  br label %_Z4add4i_block_1
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #1 {
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
  store i32 0, ptr %5, align 4
  %6 = call noundef i32 @_Z4add4i(i32 noundef -4)
  %7 = call noundef i32 @_Z4add4i(i32 noundef 5)
  %8 = call noundef i32 @_Z4add4i(i32 noundef 10)
  %9 = load ptr, ptr %r_ptr, align 8
  %10 = load i32, ptr @_main_counter_array, align 4
  call void @updateCounter(ptr %9, i32 %10)
  ret i32 %8

block_init:                                       ; preds = %block_judge
  %11 = call ptr @initCounter(i32 0, ptr @1)
  store ptr %11, ptr @_main_counter_array, align 8
  br label %main_block_1
}

declare ptr @initCounter(i32, ptr)

declare void @updateCounter(ptr, i32)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 15.0.7"}
