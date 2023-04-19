# An LLVM Pass for path profiling.

## Usage
### Generate Pass

```
./build_pass.sh
```
- You will find `libpathProfilePass.so` under `LLVM_path_profiling_pass/build/lib/instrument` and `libpathProfileRt.so` under `LLVM_path_profiling_pass/build/lib/runtime` 



### Run test
- Add the path of `libpathProfileRt.so` to `LD_LIBRARY_PATH`

  ```
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:YOUR_PATH
  ```

- Run `build.sh` under each test file

  ```
  ./build.sh
  ```



### Decode Path

- Run `path_decode.py` , remember to modify `path_prefix` to the corresponding path.

  ```
  python3 path_decode.py
  ```