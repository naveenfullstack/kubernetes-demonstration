"use client";

import { useEffect, useRef, useState } from "react";

export default function Home() {
  const svgRef = useRef<SVGSVGElement>(null);
  const [paused, setPaused] = useState(false);
  const [bDown, setBDown] = useState(false);

  const DUR = 4.8;
  const podX = [833, 955, 1077];

  const podsA = [
    { x: 778, name: "web-7c9d-4kq2x", ip: "10.0.1.21:8080" },
    { x: 900, name: "web-7c9d-9mfzt", ip: "10.0.1.34:8080" },
    { x: 1022, name: "web-7c9d-jx8bw", ip: "10.0.1.57:8080" },
  ];

  const podsB = [
    { x: 778, name: "web-7c9d-2hpvn", ip: "10.0.2.18:8080" },
    { x: 900, name: "web-7c9d-r6c5d", ip: "10.0.2.43:8080" },
    { x: 1022, name: "web-7c9d-wd7lq", ip: "10.0.2.62:8080" },
  ];

  const routes = Array.from({ length: 6 }, (_, i) => ({
    az: i < 3 ? "a" : "b",
    d: `M110 320 H725 V${i < 3 ? 165 : 425} H${podX[i % 3]} V${i < 3 ? 185 : 445}`,
  }));

  // Respect reduced-motion on first mount
  useEffect(() => {
    if (window.matchMedia?.("(prefers-reduced-motion: reduce)").matches) {
      try {
        svgRef.current?.setCurrentTime(2.4);
      } catch { }
      setPaused(true);
    }
  }, []);

  // Sync SMIL animations with the paused state
  useEffect(() => {
    if (paused) svgRef.current?.pauseAnimations();
    else svgRef.current?.unpauseAnimations();
  }, [paused]);

  return (
    <div className="eks-root">
      <style
        dangerouslySetInnerHTML={{
          __html: `
@import url('https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600;12..96,700&family=Instrument+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap');

.eks-root {
  --bg: #f2f4f7;
  --panel: #e7ebf0;
  --surface: #ffffff;
  --fg: #0e1a2b;
  --muted: #566579;
  --line: #c5cfdb;
  --req: #d9620b;
  --res: #0b8a96;
  --az-a: #0b8a96;
  --az-b: #5b4fc7;
  --bad: #c62f3b;
  --good: #1f8a4c;
  --font-display: 'Bricolage Grotesque', 'Instrument Sans', system-ui, sans-serif;
  --font-body: 'Instrument Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, 'SF Mono', Menlo, monospace;
  background: var(--bg);
  color: var(--fg);
  font-family: var(--font-body);
  font-size: 15px;
  min-height: 100vh;
  padding-block: 28px 40px;
  padding-left: max(16px, env(safe-area-inset-left, 0px));
  padding-right: max(16px, env(safe-area-inset-right, 0px));
}
@media (prefers-color-scheme: dark) {
  .eks-root {
    --bg: #09101c; --panel: #0d1626; --surface: #111b2c; --fg: #e7edf6; --muted: #93a3b9;
    --line: #27364d; --req: #ff9a3d; --res: #3cc7d3; --az-a: #3cc7d3; --az-b: #a095ff;
    --bad: #ff6b76; --good: #4fcf86; color-scheme: dark;
  }
}
.eks-root h1 { font-family: var(--font-display); text-wrap: balance; }
.eks-root .mono { font-family: var(--font-mono); }
.eks-root .card { background: var(--surface); border: 1px solid var(--line); }
.eks-root .btn {
  background: var(--surface); color: var(--fg); border: 1px solid var(--line);
  font-weight: 500; font-size: 14px; padding: 8px 14px; border-radius: 6px; cursor: pointer;
}
.eks-root .btn:hover { border-color: var(--muted); }
.eks-root .btn:focus-visible { outline: 2px solid var(--req); outline-offset: 2px; }
.eks-root .btn[aria-pressed="true"] { background: var(--fg); color: var(--bg); border-color: var(--fg); }

.eks-root .diagram { overflow-x: auto; }
.eks-root .diagram svg { display: block; min-width: 880px; width: 100%; height: auto; }
.eks-root .bx { fill: var(--surface); stroke: var(--line); stroke-width: 1.5; }
.eks-root .vpc { fill: var(--panel); stroke: var(--line); stroke-width: 1.5; stroke-dasharray: 3 5; }
.eks-root .edge { fill: none; stroke: var(--line); stroke-width: 1.5; stroke-dasharray: 3 5; }
.eks-root .az-a-box { fill: var(--surface); stroke: var(--az-a); stroke-width: 1.5; stroke-dasharray: 7 5; }
.eks-root .az-b-box { fill: var(--surface); stroke: var(--az-b); stroke-width: 1.5; stroke-dasharray: 7 5; }
.eks-root .node { fill: var(--panel); stroke: var(--line); stroke-width: 1.2; }
.eks-root .pod { fill: var(--surface); stroke: var(--line); stroke-width: 1.5; }
.eks-root .pod-a { stroke: var(--az-a); }
.eks-root .pod-b { stroke: var(--az-b); }
.eks-root .t { fill: var(--fg); font: 600 14px var(--font-body); }
.eks-root .t-sm { fill: var(--fg); font: 600 12px var(--font-body); }
.eks-root .s { fill: var(--muted); font: 400 11px var(--font-mono); }
.eks-root .s-az-a { fill: var(--az-a); font: 500 11.5px var(--font-mono); letter-spacing: .04em; }
.eks-root .s-az-b { fill: var(--az-b); font: 500 11.5px var(--font-mono); letter-spacing: .04em; }
.eks-root .ico { fill: none; stroke: var(--fg); stroke-width: 1.6; stroke-linecap: round; stroke-linejoin: round; }
.eks-root .wire { fill: none; stroke: var(--line); stroke-width: 2; }
.eks-root .flow { fill: none; stroke: var(--req); stroke-width: 2; stroke-dasharray: 5 9; opacity: .75; animation: eks-dash 1.1s linear infinite; }
@keyframes eks-dash { to { stroke-dashoffset: -28; } }
.eks-root .dot { fill: var(--good); }
.eks-root .req { fill: var(--req); }
.eks-root .res { fill: var(--res); }
.eks-root .b-down .flow-b { display: none; }
.eks-root .b-down .pod-b { stroke: var(--bad); stroke-dasharray: 4 4; }
.eks-root .b-down .dot-b { fill: var(--bad); }
.eks-root .b-down .az-b-box { stroke: var(--bad); }
.eks-root .b-down .s-az-b { fill: var(--bad); }
.eks-root .paused .flow { animation-play-state: paused; }
@media (prefers-reduced-motion: reduce) { .eks-root .flow { animation: none; } }
`,
        }}
      />
      <main className="mx-auto w-full" style={{ maxWidth: 1120 }}>
        <header className="flex flex-col gap-2 pb-6">
          <p
            className="mono text-xs uppercase"
            style={{ color: "var(--muted)", letterSpacing: ".12em" }}
          >
            Amazon EKS · Application Load Balancer · two AZs
          </p>
          <h1 className="text-3xl sm:text-4xl font-bold leading-tight">
            Request path from CloudFront to pods
          </h1>
          <p
            className="max-w-2xl"
            style={{ color: "var(--muted)", lineHeight: 1.55 }}
          >
            Each orange packet is a viewer request. Teal packets are the
            responses coming back along the same route. Take AZ-b offline to
            see how the target group keeps serving from AZ-a.
          </p>
        </header>

        <section
          className="flex flex-wrap items-center gap-3 pb-4"
          aria-label="Controls"
        >
          <button
            className="btn"
            type="button"
            aria-pressed={paused}
            onClick={() => setPaused((p) => !p)}
          >
            {paused ? "Resume traffic" : "Pause traffic"}
          </button>
          <button
            className="btn"
            type="button"
            aria-pressed={bDown}
            onClick={() => setBDown((d) => !d)}
          >
            {bDown ? "Restore AZ-b" : "Simulate AZ-b outage"}
          </button>
          <p
            className="mono text-xs sm:ml-auto"
            style={{ color: "var(--muted)" }}
            aria-live="polite"
          >
            tg-web healthy targets:{" "}
            <span style={{ color: "var(--fg)", fontWeight: 500 }}>
              {bDown ? "3 / 6" : "6 / 6"}
            </span>
          </p>
        </section>

        <section className="card rounded-md diagram" aria-label="Architecture diagram">
          <svg
            ref={svgRef}
            className={`${bDown ? "b-down" : ""} ${paused ? "paused" : ""}`}
            viewBox="0 0 1200 640"
            xmlns="http://www.w3.org/2000/svg"
            role="img"
            aria-labelledby="arch-title arch-desc"
          >
            <title id="arch-title">CloudFront to EKS request path</title>
            <desc id="arch-desc">
              Viewers reach CloudFront, which forwards to an Application Load
              Balancer. The load balancer sends traffic to a target group, which
              spreads it across three pods in availability zone A and three
              pods in availability zone B.
            </desc>

            {/* VPC */}
            <rect className="vpc" x="360" y="30" width="830" height="580" rx="10" />
            <text className="s" x="378" y="56">VPC 10.0.0.0/16</text>
            <text className="s" x="1172" y="56" textAnchor="end">EKS cluster prod-web</text>

            {/* AZ panels */}
            <rect className="az-a-box" x="740" y="70" width="430" height="240" rx="8" />
            <text className="s-az-a" x="758" y="92">AZ-a · private subnet 10.0.1.0/24</text>
            <rect className="az-b-box" x="740" y="330" width="430" height="240" rx="8" />
            <text className="s-az-b" x="758" y="352">AZ-b · private subnet 10.0.2.0/24</text>

            {/* Nodes */}
            <rect className="node" x="758" y="106" width="394" height="188" rx="6" />
            <text className="t-sm" x="772" y="128">Managed node</text>
            <text className="s" x="1138" y="128" textAnchor="end">m6i.large</text>
            <rect className="node" x="758" y="366" width="394" height="188" rx="6" />
            <text className="t-sm" x="772" y="388">Managed node</text>
            <text className="s" x="1138" y="388" textAnchor="end">m6i.large</text>

            {/* Wires */}
            <g>
              <path className="wire" d="M110 320 H170" />
              <path className="wire" d="M320 320 H390" />
              <path className="wire" d="M520 320 H570" />
              <path className="wire" d="M690 320 H725" />
              <path className="wire" d="M725 165 V425" />
              <path className="wire" d="M725 165 H1077 M833 165 V185 M955 165 V185 M1077 165 V185" />
              <path className="wire" d="M725 425 H1077 M833 425 V445 M955 425 V445 M1077 425 V445" />
            </g>
            <g className="flow-a">
              <path className="flow" d="M110 320 H725 V165 H1077 M833 165 V185 M955 165 V185 M1077 165 V185" />
            </g>
            <g className="flow-b">
              <path className="flow" d="M725 320 V425 H1077 M833 425 V445 M955 425 V445 M1077 425 V445" />
            </g>

            {/* Viewers */}
            <rect className="bx" x="20" y="280" width="90" height="80" rx="8" />
            <rect className="ico" x="46" y="296" width="38" height="26" rx="3" />
            <path className="ico" d="M40 332 H90" />
            <text className="t-sm" x="65" y="350" textAnchor="middle">Viewers</text>
            <text className="s" x="65" y="268" textAnchor="middle">HTTPS</text>

            {/* CloudFront */}
            <rect className="edge" x="150" y="220" width="190" height="200" rx="10" />
            <text className="s" x="245" y="208" textAnchor="middle">Edge location</text>
            <rect className="bx" x="170" y="270" width="150" height="100" rx="8" />
            <circle className="ico" cx="195" cy="302" r="11" />
            <ellipse className="ico" cx="195" cy="302" rx="4.5" ry="11" />
            <path className="ico" d="M184 302 H206" />
            <text className="t" x="215" y="307">CloudFront</text>
            <text className="s" x="182" y="334">TLS, cache, WAF</text>
            <text className="s" x="182" y="352">origin: ALB :443</text>

            {/* ALB */}
            <rect className="bx" x="390" y="270" width="130" height="100" rx="8" />
            <path
              className="ico"
              d="M404 302 H418 M418 302 L430 292 H442 M418 302 L430 312 H442 M436 288 L442 292 L436 296 M436 308 L442 312 L436 316"
            />
            <text className="t" x="454" y="297">ALB</text>
            <text className="s" x="402" y="334">listener :443</text>
            <text className="s" x="402" y="352">subnets a + b</text>
            <text className="s" x="455" y="394" textAnchor="middle">public subnets</text>

            {/* Target group */}
            <rect className="bx" x="570" y="260" width="120" height="120" rx="8" />
            <text className="t" x="582" y="286">Target group</text>
            <text className="s" x="582" y="308">tg-web</text>
            <text className="s" x="582" y="326">type: ip</text>
            <text className="s" x="582" y="344">:8080 /healthz</text>
            <circle className="dot" cx="588" cy="362" r="4" />
            <text className="s" x="598" y="366">{bDown ? "3 healthy" : "6 healthy"}</text>

            {/* Pods AZ-a */}
            <g>
              {podsA.map((p) => (
                <g key={p.name}>
                  <rect className="pod pod-a" x={p.x} y="185" width="110" height="70" rx="6" />
                  <circle className="dot" cx={p.x + 14} cy="201" r="4" />
                  <text className="t-sm" x={p.x + 24} y="205">pod</text>
                  <text className="s" x={p.x + 12} y="226">{p.name}</text>
                  <text className="s" x={p.x + 12} y="243">{p.ip}</text>
                </g>
              ))}
            </g>

            {/* Pods AZ-b */}
            <g>
              {podsB.map((p) => (
                <g key={p.name}>
                  <rect className="pod pod-b" x={p.x} y="445" width="110" height="70" rx="6" />
                  <circle className="dot dot-b" cx={p.x + 14} cy="461" r="4" />
                  <text className="t-sm" x={p.x + 24} y="465">pod</text>
                  <text className="s" x={p.x + 12} y="486">{p.name}</text>
                  <text className="s" x={p.x + 12} y="503">{p.ip}</text>
                </g>
              ))}
            </g>

            {/* Animated packets */}
            <g>
              {routes.map((r, idx) => (
                <g key={idx}>
                  {[
                    { cls: "req", begin: idx * 0.8, reverse: false },
                    { cls: "res", begin: idx * 0.8 + DUR / 2, reverse: true },
                  ].map((pk) => (
                    <g key={pk.cls} className={`flow-${r.az}`}>
                      <circle r="5.5" className={pk.cls} opacity="0">
                        <animateMotion
                          path={r.d}
                          dur={`${DUR}s`}
                          begin={`${pk.begin}s`}
                          repeatCount="indefinite"
                          calcMode="linear"
                          {...(pk.reverse
                            ? { keyPoints: "1;0", keyTimes: "0;1" }
                            : {})}
                        />
                        <animate
                          attributeName="opacity"
                          values="0;1;1;0"
                          keyTimes="0;0.04;0.94;1"
                          dur={`${DUR}s`}
                          begin={`${pk.begin}s`}
                          repeatCount="indefinite"
                        />
                      </circle>
                    </g>
                  ))}
                </g>
              ))}
            </g>
          </svg>
        </section>

        <section
          className="flex flex-wrap gap-x-6 gap-y-2 pt-3 mono text-xs"
          style={{ color: "var(--muted)" }}
          aria-label="Legend"
        >
          <span className="inline-flex items-center gap-2">
            <svg width="12" height="12" aria-hidden="true"><circle cx="6" cy="6" r="5" className="req" /></svg>
            Request
          </span>
          <span className="inline-flex items-center gap-2">
            <svg width="12" height="12" aria-hidden="true"><circle cx="6" cy="6" r="5" className="res" /></svg>
            Response
          </span>
          <span className="inline-flex items-center gap-2">
            <svg width="12" height="12" aria-hidden="true"><circle cx="6" cy="6" r="5" className="dot" /></svg>
            Healthy target
          </span>
          <span className="inline-flex items-center gap-2">
            <svg width="12" height="12" aria-hidden="true"><circle cx="6" cy="6" r="5" style={{ fill: "var(--bad)" }} /></svg>
            Unhealthy target
          </span>
          <span className="sm:ml-auto">Names and IPs are example values.</span>
        </section>
      </main>
    </div>
  );
}