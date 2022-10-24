import 'dart:io';
import 'dart:math';

class Utils {
  static void writeRandomListInt(int count, int from, int to) {
    var file = File("./text.txt");
    for(int i=0;i<count;++i) {
      file.writeAsStringSync("${nextInt(from, to)},", mode: FileMode.append);
    }
  }

  static int nextInt(int from, int to) {
    return from + Random().nextInt(to - from);
  }
}

void main() {
  Utils.writeRandomListInt(500, -1000, 1000);
}

class Solution {
  int threeSumClosest(List<int> nums, int target) {
    int ans = 0;
    int ansAbs = 100000000000000000;
    nums.sort();
    for (int i = 0; i < nums.length - 2; ++i) {
      int j = i + 1;
      int k = nums.length - 1;
      while (j < k) {
        int sum = nums[i] + nums[j] + nums[k];
        int abs = (target - sum).abs();
        if (abs < ansAbs) {
          ansAbs = abs;
          ans = sum;
        }
        if (sum > target) {
          --k;
        } else if (sum < target) {
          ++j;
        } else {
          return target;
        }
      }
    }
    return ans;
  }
}