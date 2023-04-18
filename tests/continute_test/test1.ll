; ModuleID = 'test.ll'
source_filename = "continute_test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@_myfunc_counter_array = private global ptr null, align 8
@0 = private unnamed_addr constant [7 x i8] c"myfunc\00", align 1
@_main_counter_array = private global ptr null, align 8
@1 = private unnamed_addr constant [5 x i8] c"main\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local i32 @myfunc(i32 noundef %0) #0 {
block_judge:
  %r_ptr = alloca i32, align 4
  store i32 0, ptr %r_ptr, align 4
  %1 = load ptr, ptr @_myfunc_counter_array, align 8
  %2 = ptrtoint ptr %1 to i64
  %3 = sub i64 %2, 0
  %4 = sdiv exact i64 %3, ptrtoint (ptr getelementptr (ptr, ptr null, i32 1) to i64)
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %block_init, label %myfunc_block_1

myfunc_block_1:                                   ; preds = %block_init, %block_judge
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, ptr %6, align 4
  store i32 0, ptr %7, align 4
  store i32 0, ptr %8, align 4
  store i32 0, ptr %7, align 4
  br label %myfunc_block_2

9:                                                ; preds = %myfunc_block_6
  %10 = load i32, ptr %r_ptr, align 4
  %11 = add i32 %10, 0
  store i32 %11, ptr %r_ptr, align 4
  %12 = load ptr, ptr @_myfunc_counter_array, align 8
  %13 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %13, ptr %12)
  store i32 3, ptr %r_ptr, align 4
  br label %myfunc_block_2

myfunc_block_2:                                   ; preds = %9, %myfunc_block_1
  %14 = load i32, ptr %7, align 4
  %15 = load i32, ptr %6, align 4
  %16 = icmp slt i32 %14, %15
  br i1 %16, label %myfunc_block_3, label %27

myfunc_block_3:                                   ; preds = %myfunc_block_2
  %17 = load i32, ptr %7, align 4
  %18 = icmp eq i32 %17, 4
  br i1 %18, label %myfunc_block_4, label %myfunc_block_5

myfunc_block_4:                                   ; preds = %myfunc_block_3
  br label %myfunc_block_6

myfunc_block_5:                                   ; preds = %myfunc_block_3
  %19 = load i32, ptr %7, align 4
  %20 = load i32, ptr %8, align 4
  %21 = add nsw i32 %20, %19
  store i32 %21, ptr %8, align 4
  br label %22

22:                                               ; preds = %myfunc_block_5
  %23 = load i32, ptr %r_ptr, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %r_ptr, align 4
  br label %myfunc_block_6

myfunc_block_6:                                   ; preds = %22, %myfunc_block_4
  %25 = load i32, ptr %7, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, ptr %7, align 4
  br label %9, !llvm.loop !6

27:                                               ; preds = %myfunc_block_2
  %28 = load i32, ptr %r_ptr, align 4
  %29 = add i32 %28, 2
  store i32 %29, ptr %r_ptr, align 4
  br label %myfunc_block_7

myfunc_block_7:                                   ; preds = %27
  %30 = load i32, ptr %8, align 4
  %31 = load ptr, ptr @_myfunc_counter_array, align 8
  %32 = load i32, ptr %r_ptr, align 4
  call void @updateCounter(i32 %32, ptr %31)
  ret i32 %30

block_init:                                       ; preds = %block_judge
  %33 = call ptr @initCounter(i32 6, ptr @0)
  store ptr %33, ptr @_myfunc_counter_array, align 8
  br label %myfunc_block_1
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local i32 @main() #1 {
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
  %7 = call i32 @myfunc(i32 noundef 10)
  %8 = load i32, ptr %6, align 4
  %9 = add nsw i32 %8, %7
  store i32 %9, ptr %6, align 4
  %10 = call i32 @myfunc(i32 noundef -10)
  %11 = load i32, ptr %6, align 4
  %12 = add nsw i32 %11, %10
  store i32 %12, ptr %6, align 4
  %13 = call i32 @myfunc(i32 noundef 0)
  %14 = load i32, ptr %6, align 4
  %15 = add nsw i32 %14, %13
  store i32 %15, ptr %6, align 4
  %16 = call i32 @myfunc(i32 noundef 4)
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
