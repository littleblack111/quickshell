pragma Singleton
// pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property double memoryTotal: 1
    property double memoryFree: 1
    property double memoryUsed: memoryTotal - memoryFree
    property double memoryUsedPercentage: memoryUsed / memoryTotal
    property double swapTotal: 1
    property double swapFree: 1
    property double swapUsed: swapTotal - swapFree
    property double swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0

    property double cpuUsage: 0
    property double cpuTemp: 0
    property double cpuFreq: 0
    property var previousCpuStats

    property int gpuUsage: 0
    property int gpuTemp: 0

    Timer {
        interval: General.resourceUpdateInterval
        running: true
        repeat: true
        onTriggered: {
            fileMeminfo.reload();
            fileStat.reload();
            fileCpuThermal.reload();
            fileCpuInfo.reload();

            const textMeminfo = fileMeminfo.text();
            memoryTotal = Number(textMeminfo.match(/MemTotal:\s*(\d+)/)[1] ?? 1);
            memoryFree = Number(textMeminfo.match(/MemAvailable:\s*(\d+)/)[1] ?? 0);
            memoryUsed = memoryTotal - memoryFree;
            memoryUsedPercentage = memoryUsed / memoryTotal;
            swapTotal = Number(textMeminfo.match(/SwapTotal:\s*(\d+)/)[1] ?? 1);
            swapFree = Number(textMeminfo.match(/SwapFree:\s*(\d+)/)[1] ?? 0);

            const textStat = fileStat.text();
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number);
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3];
                if (root.previousCpuStats) {
                    const td = total - root.previousCpuStats.total;
                    const id = idle - root.previousCpuStats.idle;
                    cpuUsage = td > 0 ? (1 - id / td) : 0;
                }
                root.previousCpuStats = {
                    total,
                    idle
                };
            }

            const cpuTempText = fileCpuThermal.text();
            cpuTemp = cpuTempText ? parseInt(cpuTempText.trim()) / 100000 : 0;

            const textCpuInfo = fileCpuInfo.text();
            let sum = 0, cnt = 0;
            const re = /^cpu MHz\s*:\s*([\d.]+)/mg;
            let m;
            while ((m = re.exec(textCpuInfo)) !== null) {
                sum += Number(m[1]);
                cnt++;
            }
            cpuFreq = cnt ? sum / cnt : 0;

            gpuUsageProc.running = true;
            gpuTempProc.running = true;
            interval = General.resourceUpdateInterval * cpuUsage > 0.7 || memoryUsedPercentage > 0.7 || cpuTemp > 0.7 ? 100 : 1000;
        }
    }

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }
    FileView {
        id: fileStat
        path: "/proc/stat"
    }
    FileView {
        id: fileCpuThermal
        path: General.cpuThermalPath
    }
    FileView {
        id: fileCpuInfo
        path: "/proc/cpuinfo"
    }

    Process {
        id: gpuUsageProc
        running: true
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.gpuUsage = parseInt(this.text.trim());
            }
        }
    }
    Process {
        id: gpuTempProc
        running: true
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.gpuTemp = parseInt(this.text.trim());
            }
        }
    }
}
