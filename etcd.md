


# IOPS vs latency

However, focusing on IOPS alone as a performance metric can be misleading. While it does describe the number of data transactions a system can sustain each second, it doesn’t specify the amount of data each transaction delivers, which can vary widely with block size.

Conclusion
Performance in storage devices can be a difficult thing to accurately compare, since the way they are measured can vary with the application or the environment. In some use cases, moving large amounts of data quickly (high throughput) makes up good performance; for others it’s supporting a high number of relatively short processes (high IOPS). To further confuse the issue, factors like block size, queue depth and degree of parallelism can increase throughput and IOPS in an environment without benefitting overall application performance.

A more consistent performance metric is latency. As a primary factor in both IOPS and throughput calculations, it’s impact on storage performance is fundamental. This means that reducing latency will universally improve performance, making latency the first metric to look at when evaluating storage performance.