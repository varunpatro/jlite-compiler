class Main123 {
	Void main () {
		return null;
	}
}

class Vector {
	Int x;
	Int y;

	Void addVector(Vector that) {
		this.x = this.x + that.x;
		this.y = this.y + that.y;
	}

	Void scaleVector(Int x) {
		this.x = this.x * x;
		this.y = this.y * x;
	}

	Int dotVector(Vector that) {
		// Declaration and assignment is not allowed!
		Int a = this.x * that.x;
		Int b = this.y * that.y;
		Int c = a + b;
		return c;
	}
}
