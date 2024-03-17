#include <cstring>
#include <iostream>
#include <fstream>
using namespace std;
#define PREFIX_FILENAME ""
#define SUFFIX_FILENAME ".SDE"
#define DEFREPL_STR "[***]"

int FileStringReplace(string FileName, string strFind, string strRepl = DEFREPL_STR,

                      string OutFileName = "") {
	if (OutFileName.empty())
		OutFileName = PREFIX_FILENAME + FileName + SUFFIX_FILENAME;
	ifstream isFile(FileName);
	ofstream osFile(OutFileName);
	if (!isFile.is_open()) {
		cerr << "[ERROR] Error opening file(in)!" << endl;
		return -1;
	}
	if (!osFile.is_open()) {
		cerr << "[ERROR] Error opening file(out)!" << endl;
		return -1;
	}
	int cnt = 0;
	string str;
	size_t pos = 0;
	while (getline(isFile, str)) {
		pos = str.find(strFind);
		if (pos != string::npos) {
			str = str.replace(pos, strlen(strFind.c_str()), strRepl);
			osFile << str << endl;
			cnt++;
			continue;
		}
		osFile << str << endl;
	}
	isFile.close();
	osFile.close();
	return cnt;
}

int main(int argc, char **argv) {

	if (argc == 3) {
		int rtn = FileStringReplace(argv[2], argv[1]);
		cout << "[INFO] Function return value:" << rtn << endl;
		return 0;
	}

	if (argc == 4) {
		int rtn = FileStringReplace(argv[2], argv[1], argv[3]);
		cout << "[DEBUG] Function return value:" << rtn << endl;
		return 0;
	}

	if (argc == 5 && argv[2] != argv[4]) {
		int rtn = FileStringReplace(argv[2], argv[1], argv[3], argv[4]);
		cout << "[DEBUG] Function return value:" << rtn << endl;
		return 0;
	}
	cerr << "[ERROR] Invalid Input!" << endl;
	return 1;
}