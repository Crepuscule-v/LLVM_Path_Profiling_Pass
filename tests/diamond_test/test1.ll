; ModuleID = 'test.ll'
source_filename = "complex_test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__Z8somefunci_counter_array = private global ptr null, align 8
@0 = private unnamed_addr constant [13 x i8] c"_Z8somefunci\00", align 1
@_main_counter_array = private global ptr null, align 8
@1 = private unnamed_addr constant [5 x i8] c"main\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @_Z8somefunci(i32 noundef %0) #0 {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %1 = load ptr, ptr @__Z8somefunci_counter_array, align 8
  %2 = ptrtoint ptr %1 to i64
  %3 = sub i64 %2, 0
  %4 = sdiv exact i64 %3, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %block_init, label %_Z8somefunci_block_1

_Z8somefunci_block_1:                             ; preds = %block_init, %block_judge
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, ptr %6, align 4
  store i32 0, ptr %7, align 4
  %8 = load i32, ptr %6, align 4
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %_Z8somefunci_block_2, label %_Z8somefunci_block_3

_Z8somefunci_block_2:                             ; preds = %_Z8somefunci_block_1
  store i32 5, ptr %7, align 4
  br label %10

10:                                               ; preds = %_Z8somefunci_block_2
  %11 = load i32, ptr %r_ptr, align 4
  %12 = add i32 %11, -4
  store i32 %12, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_3

_Z8somefunci_block_3:                             ; preds = %10, %_Z8somefunci_block_1
  %13 = load i32, ptr %6, align 4
  %14 = icmp sle i32 %13, 0
  br i1 %14, label %_Z8somefunci_block_4, label %_Z8somefunci_block_5

_Z8somefunci_block_4:                             ; preds = %_Z8somefunci_block_3
  %15 = load i32, ptr %7, align 4
  %16 = add nsw i32 %15, -12
  store i32 %16, ptr %7, align 4
  br label %_Z8somefunci_block_6

_Z8somefunci_block_5:                             ; preds = %_Z8somefunci_block_3
  %17 = load i32, ptr %6, align 4
  %18 = mul nsw i32 %17, 2
  %19 = load i32, ptr %7, align 4
  %20 = add nsw i32 %19, %18
  store i32 %20, ptr %7, align 4
  br label %21

21:                                               ; preds = %_Z8somefunci_block_5
  %22 = load i32, ptr %r_ptr, align 4
  %23 = add i32 %22, 2
  store i32 %23, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_6

_Z8somefunci_block_6:                             ; preds = %21, %_Z8somefunci_block_4
  %24 = load i32, ptr %7, align 4
  %25 = mul nsw i32 %24, 3
  store i32 %25, ptr %7, align 4
  %26 = load i32, ptr %6, align 4
  %27 = icmp eq i32 %26, 5
  br i1 %27, label %_Z8somefunci_block_7, label %30

_Z8somefunci_block_7:                             ; preds = %_Z8somefunci_block_6
  %28 = load i32, ptr %7, align 4
  %29 = add nsw i32 %28, 4
  store i32 %29, ptr %7, align 4
  br label %33

30:                                               ; preds = %_Z8somefunci_block_6
  %31 = load i32, ptr %r_ptr, align 4
  %32 = add i32 %31, 5
  store i32 %32, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_8

33:                                               ; preds = %_Z8somefunci_block_7
  %34 = load i32, ptr %r_ptr, align 4
  %35 = add i32 %34, 4
  store i32 %35, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_8

_Z8somefunci_block_8:                             ; preds = %33, %30
  %36 = load i32, ptr %7, align 4
  %37 = add nsw i32 %36, 4
  %38 = load ptr, ptr @__Z8somefunci_counter_array, align 8
  %39 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %39, ptr %38)
  ret i32 %37

block_init:                                       ; preds = %block_judge
  %40 = call ptr @initCounter(i32 8, ptr @0)
  store ptr %40, ptr @__Z8somefunci_counter_array, align 8
  br label %_Z8somefunci_block_1
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
  %6 = alloca i32, align 4
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  %7 = call noundef i32 @_Z8somefunci(i32 noundef 10)
  %8 = load i32, ptr %6, align 4
  %9 = add nsw i32 %8, %7
  store i32 %9, ptr %6, align 4
  %10 = call noundef i32 @_Z8somefunci(i32 noundef -10)
  %11 = load i32, ptr %6, align 4
  %12 = add nsw i32 %11, %10
  store i32 %12, ptr %6, align 4
  %13 = call noundef i32 @_Z8somefunci(i32 noundef 0)
  %14 = load i32, ptr %6, align 4
  %15 = add nsw i32 %14, %13
  store i32 %15, ptr %6, align 4
  %16 = call noundef i32 @_Z8somefunci(i32 noundef 4)
  %17 = load i32, ptr %6, align 4
  %18 = add nsw i32 %17, %16
  store i32 %18, ptr %6, align 4
  %19 = load i32, ptr %6, align 4
  %20 = load ptr, ptr @_main_counter_array, align 8
  %21 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %21, ptr %20)
  call void @print_result()
  ret i32 %19

block_init:                                       ; preds = %block_judge
  %22 = call ptr @initCounter(i32 1, ptr @1)
  store ptr %22, ptr @_main_counter_array, align 8
  br label %main_block_1
}

declare ptr @initCounter(i32, ptr)

declare void @updateCounter(i32, ptr)

declare void @print_result()

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
