export default function Home() {
  return (
    <div className="flex gap-4 w-full overflow-hidden">

      <div className="w-full p-4 h-screen overflow-auto h-fit">
        {/* User */}
        <section>
          <div className="space-y-2 border w-fit mx-auto p-2 px-3 rounded-md border-gray-300 relative">
            <div className="flex justify-center">
              <img src="images/user.png" alt="User" className="w-8" />
            </div>
            <p className="text-center text-sm">Reqests</p>

            <p className="text-center text-sm absolute w-[300px] left-0 top-8 font-bold">6.7 M Req / Sec</p>
          </div>
        </section>

        <div className="flex justify-center py-2">
          <div className="w-[1px] bg-black h-[100px]">
          </div>
        </div>

        {/* CloudFront */}
        <section>
          <div className="space-y-2 border w-fit mx-auto p-2 rounded-md border-gray-300 relative">
            <div className="flex justify-center">
              <img src="images/cloudfront.webp" alt="User" className="w-14" />
            </div>
            <p className="text-center text-sm">CloudFront</p>

            <div className="w-[100px] bg-black h-[1px] absolute left-[100px] top-[50px]"></div>

            <div className="space-y-2 border w-fit mx-auto p-2 rounded-md border-gray-300 absolute left-[220px] top-0">
              <div className="flex justify-center">
                <img src="images/waf.jpeg" alt="waf" className="w-14" />
              </div>
              <p className="text-center text-sm w-[80px]">AWS WAF</p>
            </div>
          </div>
        </section>

        <div className="flex justify-center py-2 pb-0">
          <div className="w-[1px] bg-black h-[100px]">
          </div>
        </div>

        {/* VPC */}

        <div className="border min-h-[300px] border-purple-600 relative">
          {/* VPC icon */}
          <div className="absolute top-0 left-0 flex gap-2">
            <img src="images/vpc.webp" alt="VPC" className="w-8 h-8" />
            <div>
              <p className="text-sm">VPC</p>
              <p className="text-xs">10.0.0.0/16</p>
            </div>
          </div>

          {/* <div className="flex justify-center">
            <div className="w-[1px] bg-black h-[50px]">
            </div>
          </div> */}

          {/* Application Load Balancer */}
          {/* <section>
            <div className="space-y-2 border w-fit mx-auto p-2 rounded-md border-gray-300">
              <div className="flex justify-center">
                <img src="images/vpc.webp" alt="User" className="w-14" />
              </div>
              <p className="text-center text-sm">Application Load Balancer</p>
            </div>
          </section> */}

          <div className="flex justify-center">
            <div className="w-[1px] bg-black h-[50px]">
            </div>
          </div>

          <div className="flex justify-center">
            <div className="w-[50%] bg-black h-[1px] relative">
              <div className="w-[1px] bg-black h-[40px] absolute top-0 left-0 z-99"></div>
              <div className="w-[1px] bg-black h-[40px] absolute top-0 right-0 z-99"></div>
            </div>
          </div>

          {/* Availability Zones */}
          <div className="flex gap-32 p-4 pb-0 pt-[40px]">

            {/* Availability Zone A */}
            <div className="border min-h-[300px] border-green-600 relative w-full p-4 pt-0">
              <p className="text-center text-base py-2 pb-3">Availability Zone A</p>
              <div className="bg-green-600/10 min-h-[100px] relative">
                <div className="absolute top-0 left-0 flex gap-2">
                  <img src="images/subnet.png" alt="Subnet" className="w-8 h-8 object-cover" />
                  <div>
                    <p className="text-sm">Public Subnet 1</p>
                    <p className="text-xs">10.0.0.0/24</p>
                  </div>
                </div>

                <section className="pt-10 pb-4">
                  <div className="space-y-2 w-fit mx-auto p-2 rounded-md border-gray-300">
                    <div className="flex justify-center">
                      <img src="images/vpc.webp" alt="User" className="w-14" />
                    </div>
                    <p className="text-center text-sm">Application Load Balancer</p>
                  </div>
                </section>

              </div>

              <div className="flex justify-center">
                <div className="w-[1px] bg-black h-[100px]">
                  {/* dot */}
                  <div className="bg-red-500 w-3 h-3 rounded-full -ml-1.5 mt-1.5 duration-300"></div>
                </div>
              </div>

              <div className="bg-blue-600/10 min-h-[200px] relative p-4">
                <div className="absolute top-0 left-0 flex gap-2">
                  <img src="images/subnet.png" alt="Subnet" className="w-8 h-8 object-cover" />
                  <div>
                    <p className="text-sm">Private Subnet 1</p>
                    <p className="text-xs">10.0.0.0/24</p>
                  </div>
                </div>

                <div className="bg-[#FEF6EC] relative mt-8 p-4">
                  <div className="absolute top-0 left-0 flex gap-2 items-center">
                    <img src="images/eks.webp" alt="eks" className="w-8 h-8 object-cover" />
                    <div>
                      <p className="text-sm">Amazon EKS Cluster</p>
                    </div>
                  </div>

                  <div className="pt-8 grid grid-cols-2 gap-4">

                    {/* Worker Nodes */}
                    <div className="border border-orange-600 p-2 rounded space-y-2">
                      <div className="flex gap-2 items-center justify-center">
                        <img src="images/chip.png" alt="processor" className="w-8 h-8 object-cover text-red-500" />
                        <p className="text-sm">Node</p>
                      </div>

                      {/* Pods */}
                      <div className="border border-gray-300 p-2 rounded grid grid-cols-3 gap-2">
                        <div>
                          <img src="images/pod.png" alt="processor" className="w-8 h-8 object-cover text-red-500" />
                        </div>

                        <div>
                          <img src="images/pod.png" alt="processor" className="w-8 h-8 object-cover text-red-500" />
                        </div>

                        <div>
                          <img src="images/pod.png" alt="processor" className="w-8 h-8 object-cover text-red-500" />
                        </div>
                      </div>
                    </div>

                    {/* Creating Worker Node  */}
                    <div className="border border-orange-600 flex justify-center items-center p-2 rounded">
                      <div className="flex gap-2 items-center">
                        <img src="images/chip.png" alt="processor" className="w-8 h-8 object-cover text-red-500" />
                        <p className="text-sm">Creating Node</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Availability Zone B */}
            <div className="border min-h-[300px] border-blue-600 relative w-full p-4 pt-0">
              <p className="text-center text-base py-2">Availability Zone B</p>
            </div>
          </div>

          {/* Database and storage */}
          <div className="p-4 relative">
            <div className="flex justify-center absolute top-0 left-60">
              <div className="w-[1px] bg-black h-[48px]">
              </div>
            </div>

            <div className="flex justify-center absolute top-0 right-60">
              <div className="w-[1px] bg-black h-[48px]">
              </div>
            </div>

            <div className="border rounded min-h-[100px] flex justify-center items-center p-4 gap-8 mt-8">

              <section>
                <div className="space-y-2 border w-fit mx-auto p-2 px-4 rounded-md border-gray-300">
                  <div className="flex justify-center">
                    <img src="images/dynamodb.jpeg" alt="dynamo" className="w-14" />
                  </div>
                  <p className="text-center text-sm">DynamoDB</p>
                </div>
              </section>

              <section>
                <div className="space-y-2 border w-fit mx-auto p-2 px-4 rounded-md border-gray-300">
                  <div className="flex justify-center">
                    <img src="images/s3.webp" alt="s3" className="w-14" />
                  </div>
                  <p className="text-center text-sm">S3</p>
                </div>
              </section>

              <section>
                <div className="space-y-2 border w-fit mx-auto p-2 px-4 rounded-md border-gray-300">
                  <div className="flex justify-center">
                    <img src="images/backups.jpeg" alt="backups" className="w-14" />
                  </div>
                  <p className="text-center text-sm">Backups</p>
                </div>
              </section>

            </div>
          </div>
        </div>
      </div>

      <div className="w-[500px] border-l border-gray-300 py-2">
        <div className="flex justify-between border-b pb-2 border-gray-300 px-2 text-sm">
          <p>All Requests</p>
          <p className="font-bold">3.4 M</p>
        </div>

        <div className="flex justify-between border-b border-gray-300 p-2 text-sm">
          <p>Requests Per Second</p>
          <p className="font-bold">300</p>
        </div>

        <div className="flex justify-between border-b border-gray-300 p-2 text-sm">
          <p>Nodes</p>
          <p className="font-bold">2</p>
        </div>

        <div className="flex justify-between border-b border-gray-300 p-2 text-sm">
          <p>Pods</p>
          <p className="font-bold">20</p>
        </div>

        <div className="flex justify-between border-b border-gray-300 p-2 text-sm">
          <p>CloudFront Data Transfer</p>
          <p className="font-bold">20.4 GB</p>
        </div>

        <div className="flex justify-between border-b border-gray-300 p-2 text-sm">
          <p>Failed Requests</p>
          <p className="font-bold">90,876</p>
        </div>

        <div className="flex justify-between border-b border-gray-300 p-2 text-sm">
          <p>Requests Reached Server</p>
          <p className="font-bold">60%</p>
        </div>
      </div>

    </div>
  );
}
