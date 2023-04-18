; ModuleID = 'test.ll'
source_filename = "self_cycle_test.cpp"
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
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %0, ptr %6, align 4
  store i32 0, ptr %7, align 4
  store i32 0, ptr %8, align 4
  store i32 0, ptr %9, align 4
  store i32 1, ptr %7, align 4
  br label %_Z8somefunci_block_2

10:                                               ; preds = %_Z8somefunci_block_4
  %11 = load i32, ptr %r_ptr, align 4
  %12 = add i32 %11, 0
  store i32 %12, ptr %r_ptr, align 4
  %13 = load ptr, ptr @__Z8somefunci_counter_array, align 8
  %14 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %14, ptr %13)
  store i32 3, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_2

_Z8somefunci_block_2:                             ; preds = %10, %_Z8somefunci_block_1
  %15 = load i32, ptr %7, align 4
  %16 = load i32, ptr %6, align 4
  %17 = icmp slt i32 %15, %16
  br i1 %17, label %_Z8somefunci_block_3, label %_Z8somefunci_block_5

_Z8somefunci_block_3:                             ; preds = %_Z8somefunci_block_2
  %18 = load i32, ptr %6, align 4
  %19 = load i32, ptr %7, align 4
  %20 = sdiv i32 %18, %19
  %21 = load i32, ptr %9, align 4
  %22 = add nsw i32 %21, %20
  store i32 %22, ptr %9, align 4
  br label %_Z8somefunci_block_4

_Z8somefunci_block_4:                             ; preds = %_Z8somefunci_block_3
  %23 = load i32, ptr %7, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, ptr %7, align 4
  br label %10, !llvm.loop !6

_Z8somefunci_block_5:                             ; preds = %_Z8somefunci_block_2
  store i32 0, ptr %8, align 4
  br label %_Z8somefunci_block_6

25:                                               ; preds = %_Z8somefunci_block_8
  %26 = load i32, ptr %r_ptr, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %r_ptr, align 4
  %28 = load ptr, ptr @__Z8somefunci_counter_array, align 8
  %29 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %29, ptr %28)
  store i32 5, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_6

_Z8somefunci_block_6:                             ; preds = %25, %_Z8somefunci_block_5
  %30 = load i32, ptr %8, align 4
  %31 = load i32, ptr %6, align 4
  %32 = icmp slt i32 %30, %31
  br i1 %32, label %_Z8somefunci_block_7, label %40

_Z8somefunci_block_7:                             ; preds = %_Z8somefunci_block_6
  %33 = load i32, ptr %6, align 4
  %34 = load i32, ptr %8, align 4
  %35 = mul nsw i32 %33, %34
  %36 = load i32, ptr %9, align 4
  %37 = add nsw i32 %36, %35
  store i32 %37, ptr %9, align 4
  br label %_Z8somefunci_block_8

_Z8somefunci_block_8:                             ; preds = %_Z8somefunci_block_7
  %38 = load i32, ptr %8, align 4
  %39 = add nsw i32 %38, 2
  store i32 %39, ptr %8, align 4
  br label %25, !llvm.loop !8

40:                                               ; preds = %_Z8somefunci_block_6
  %41 = load i32, ptr %r_ptr, align 4
  %42 = add i32 %41, 2
  store i32 %42, ptr %r_ptr, align 4
  br label %_Z8somefunci_block_9

_Z8somefunci_block_9:                             ; preds = %40
  %43 = load i32, ptr %9, align 4
  %44 = load ptr, ptr @__Z8somefunci_counter_array, align 8
  %45 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %45, ptr %44)
  ret i32 %43

block_init:                                       ; preds = %block_judge
  %46 = call ptr @initCounter(i32 8, ptr @0)
  store ptr %46, ptr @__Z8somefunci_counter_array, align 8
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
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
