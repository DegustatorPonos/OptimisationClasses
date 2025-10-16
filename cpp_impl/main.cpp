#include <cmath>
#include <cstdlib>
#include <iostream>

class FOV {
    public:
        float(*fp)(float); // *f(x)

        // Initialization constructior
        FOV (float(*_fp)(float)) {
            fp = _fp;
        }

        float df_right(float x0, float step = 1e-10);
    private:
};

// Method defenition outside of a class (ideally in another file)
float FOV::df_right(float x0, float step) {
    return (fp(x0+step) - fp(x0))/step;
}

float BasicFunction(float x) {
    return std::sin(x);
}

// tests
void test(float x) {
    FOV fov(BasicFunction);
    float result = fov.df_right(x, 1e-4);
    float expected = std::cos(x);
    if (std::abs(result - expected) > 1e-3) {
        std::cout << "ERROR" << std::endl;
    }
}

int main() {
    test(1);
    return 0;
}
