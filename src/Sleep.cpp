#include <iostream>
#include <chrono>
#ifdef _WIN32
    #include <windows.h>
	#define CP_sleep(iMs) Sleep(iMs)
#else
    #include <unistd.h>
	#define CP_sleep(iMs) usleep(iMs * 1000)
#endif
using namespace std;

int main(int argc, char **argv) {

	if (argc == 2) {
		int msTime = atol(argv[1]);
		cout << "Requested Sleep time in ms:" <<msTime<<endl;
		auto t0 = chrono::high_resolution_clock::now();
		CP_sleep(msTime);
		auto t1 = chrono::high_resolution_clock::now();
		cout << "Time taken in ms:" <<chrono::duration_cast<chrono::milliseconds>(t1 - t0).count()<<endl;
		return 0;
	} else {
		cerr << "Invalid Arguments!" << endl;
		return 1;
	}
	return 2;
}