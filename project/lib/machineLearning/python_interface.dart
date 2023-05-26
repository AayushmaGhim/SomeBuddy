import 'dart:ffi' as ffi;
import 'dart:io';

const pythonLib = 'https://colab.research.google.com/drive/1syfuDzdNJbl0mijTtk9PYZpkBbbFAbLG#scrollTo=9Dh_YQ8Un8VJ';

typedef myPythonFunctionType = ffi.Int32 Function();

final python = ffi.DynamicLibrary.open(pythonLib);

final myPythonFunction =
    python.lookupFunction(
        'my_python_function');

void callPythonFunction() {
  final result = myPythonFunction();
  print('Result from Python: $result');
}
