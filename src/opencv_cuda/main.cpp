/** @brief Returns the number of installed CUDA-enabled devices.
Use this function before any other CUDA functions calls. If OpenCV is compiled without CUDA support,
this function returns 0. If the CUDA driver is not installed, or is incompatible, this function
returns -1.
 */
#include <iostream>
#include "opencv2/core.hpp"
#include "opencv2/cudaarithm.hpp"
#include<opencv2/cudaimgproc.hpp>
using namespace std;
using namespace cv;
using namespace cv::cuda;
int main()
{
    int num_devices = getCudaEnabledDeviceCount();
    if (num_devices == 0 )
    {
        std::cout << "OpenCV is compiled without CUDA support" << endl;
        return -1;
    }
    else if (num_devices == -1)
    {
        std::cout << "CUDA driver is not installed" << endl;
        return -1;
    }
    else if (num_devices >= 1)
    {
        std::cout << "CUDA-Opencv can be used and the number of GPU is :" << num_devices << endl;
        return -1;
    }
    return 0;
}