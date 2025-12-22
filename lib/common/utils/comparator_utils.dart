int compareNums<T extends num>(T a, T b) {
  if (a < b) {
    return -1;
  } else if (a > b) {
    return 1;
  } else {
    return 0;
  }
}

int compareNumsDesc<T extends num>(T a, T b) {
  if (a > b) {
    return -1;
  } else if (a < b) {
    return 1;
  } else {
    return 0;
  }
}

class NumComparable<T extends num> implements Comparable<T> {
  const NumComparable(this.value);

  final T value;

  @override
  int compareTo(T other) {
    if (value < other) {
      return -1;
    } else if (value > other) {
      return 1;
    } else {
      return 0;
    }
  }
}
