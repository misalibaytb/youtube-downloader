(async () => {
    const { exec, spawn } = require('child_process');
    var allowedChars = "\"'`abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZěščřžýáíéĚŠČŘŽÝÁÍÉ0123456789 ";
    var specialChars = "ěščřžýáíéĚŠČŘŽÝÁÍÉ";
    var normalChars = "escrzyaieESCRZYAIE";
    specialChars = specialChars.split('');
    normalChars = normalChars.split('');
    const version = '1.0.2';
    const downloadFolder = `C:/Users/${require('os').userInfo().username}/Documents/Youtube Downloader/`
    console.log(`Youtube Downloader v${version}`);
    console.log('By: misaliba');
    console.log('Github: https://github.com/misalibaytb/')
    console.log('Discord: misaliba');
    console.log('Discord Server: https://michlip.eu/discord/');
    console.log('Youtube: https://www.youtube.com/channel/UCCH7eYzqQsQPVMGZKa8Imtw');
    console.log('Instagram: https://www.instagram.com/__misaliba__/');
    console.log('Twitter: https://twitter.com/misalibaytb');
    console.log('TikTok: https://www.tiktok.com/@misaliba');
    console.log('\n\n');
    console.log('Report any issues on github');
    console.log('https://github.com/misalibaytb/youtube-downloader ');
    console.log('\n\n');
    console.log('Checking for updates...');
    const fetch = require('node-fetch');
    const download = require('download');
    var updateCheckFailed = false;
    const res = await fetch('https://raw.githubusercontent.com/misalibaytb/youtube-downloader/main/version').catch((err) => {
        console.log('Failed to check for updates');
        console.log(err);
        console.log('\n\n');
        updateCheckFailed = true;
    });
    if (updateCheckFailed) return process.exit();
    var data = await res.json();
    console.log('Current version: ' + version);
    console.log('Latest version: ' + data.version);
    console.log('\n\n');
    if (data.version != version) {
        console.log(`New version available: ${data}`);
        // download it to temp folder
        download('https://raw.githubusercontent.com/misalibaytb/youtube-downloader/main/Dependencies/Update.cmd', 'C:/Users/' + require('os').userInfo().username + '/AppData/Local/Temp').then(() => {
            console.log('Update downloaded');
            // make it visible
            spawn('start cmd.exe /c C:/Users/' + require('os').userInfo().username + '/AppData/Local/Temp/Update.cmd', {
                shell: true,
                detached: true
            });
            process.exit();
        });
    } else {
        console.log('No updates available');
        console.log('\n\n');


        const ytdl = require('ytdl-core');
        const ytpl = require('ytpl');
        const ytsr = require('ytsr');
        const yts = require('yt-search');
        const fs = require('fs');
        const path = require('path');
        fs.mkdirSync(path.join(downloadFolder), { recursive: true });
        const ffmpegPath = require('@ffmpeg-installer/ffmpeg').path;
        const ffmpeg = require('fluent-ffmpeg');
        ffmpeg.setFfmpegPath(ffmpegPath);
        const readline = require('readline');
        const tempFile = path.join(`C:/Users/${require('os').userInfo().username}/AppData/Local/Temp/`, 'youtube-downloader-temp.json');
        const temp = []
        const queue = [];
        if (fs.existsSync(tempFile)) {
            const data = JSON.parse(fs.readFileSync(tempFile, 'utf8'));
            data.forEach((item) => {
                temp.push(item);
                queue.push(item);
            });
        }
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
        var total = 0;
        const QueueRunner = async () => {
            if (queue.length > 0) {
                const item = queue.shift();
                const video = await ytdl.getInfo(item.url);
                var title = video.videoDetails.title;
                specialChars.forEach((char, index) => {
                    title = title.replaceAll(char, normalChars[index]);
                });
                console.log(`Downloading ${title}`);
                const typeMap = {
                    '1': 'audio',
                    '2': 'video'
                };
                const qualityMap = {
                    '1': 'highest',
                    '2': 'lowest'
                };
                const type = typeMap[item.type];
                const quality = qualityMap[item.quality];
                var filename = item.filename
                const ext = type == 'audio' ? 'mp3' : 'mp4';
                fs.mkdirSync(path.join(downloadFolder), { recursive: true });
                const file = path.join(downloadFolder, `/${filename}.${ext}`);
                if (type == 'audio') {
                    const stream = ytdl(item.url, {
                        filter: 'audioonly',
                        quality: quality,
                        highWaterMark: 1 << 25
                    });
                    ffmpeg(stream)
                        .audioBitrate(128)
                        .save(file)
                        .on('progress', (progress) => {
                            process.stdout.write(`\rDownloading ${title} (${(progress.timemark.split(':')[0] * 60) + parseInt(progress.timemark.split(':')[1])}/${(video.videoDetails.lengthSeconds / 60).toFixed(0)}m)`);
                        })
                        .on('end', () => {
                            console.log(`Downloaded ${title} (${(total - queue.length)}/${total} | ${(100 - (queue.length / total * 100)).toFixed(2)}%)`);
                            QueueRunner();
                            // remove it from temp
                            temp.forEach((itemTemp, index) => {
                                if (itemTemp.id == item.id) {
                                    temp.splice(index, 1);
                                }
                                fs.writeFileSync(tempFile, JSON.stringify(temp, null, 2));
                            })
                        }).on('error', (err) => {
                            console.log(`Error downloading ${title}`);
                            console.log(err);
                            // return item back to queue
                            queue.push(item);
                            QueueRunner();
                        });
                } else {
                    const video = await ytdl.getInfo(item.url);
                    const heigestQualityWithAudio = video.formats.filter((format) => format.hasAudio && format.hasVideo)[0];
                    const lowestQualityWithAudio = video.formats.filter((format) => format.hasAudio && format.hasVideo)[video.formats.filter((format) => format.hasAudio && format.hasVideo).length - 1];
                    const currentQuality = quality == 'highest' ? heigestQualityWithAudio : lowestQualityWithAudio
                    const audioSrc = path.join(downloadFolder, `/${video.videoDetails.videoId}/${filename}tmp.mp3`);
                    const videoSrc = path.join(downloadFolder, `/${video.videoDetails.videoId}/${filename}tmp.mp4`);
                    const outputSrc = path.join(downloadFolder, `/${video.videoDetails.videoId}/${filename}.mp4`);
                    const streamAudio = ytdl(item.url, {
                        filter: 'audioonly',
                        highWaterMark: 1 << 25,
                        format: currentQuality
                    });
                    fs.mkdirSync(path.join(downloadFolder, video.videoDetails.videoId), { recursive: true });
                    ffmpeg(streamAudio)
                        .save(audioSrc)
                        .on('progress', (progress) => {
                            process.stdout.write(`\rDownloading ${title} (${(progress.timemark.split(':')[0] * 60) + parseInt(progress.timemark.split(':')[1])}/${(video.videoDetails.lengthSeconds / 60).toFixed(0)}m)`);
                        })
                        .on('end', () => {
                            console.log(`Downloaded ${title} (${(total - queue.length)}/${total} | ${(100 - (queue.length / total * 100)).toFixed(2)}%)`);
                            const streamVideo = ytdl(item.url, {
                                filter: 'videoonly',
                                highWaterMark: 1 << 25,
                                format: currentQuality
                            });
                            ffmpeg(streamVideo)
                                .save(videoSrc)
                                .on('progress', (progress) => {
                                    process.stdout.write(`\rDownloading ${title} (${(progress.timemark.split(':')[0] * 60) + parseInt(progress.timemark.split(':')[1])}/${(video.videoDetails.lengthSeconds / 60).toFixed(0)}m)`);
                                })
                                .on('end', () => {
                                    console.log(`Downloaded ${title} (${(total - queue.length)}/${total} | ${(100 - (queue.length / total * 100)).toFixed(2)}%)`);
                                    // add audio to video
                                    ffmpeg()
                                        .input(videoSrc)
                                        .input(audioSrc)
                                        .save(outputSrc)
                                        .on('progress', (progress) => {
                                            process.stdout.write(`\rDownloading ${title} (${(progress.timemark.split(':')[0] * 60) + parseInt(progress.timemark.split(':')[1])}/${(video.videoDetails.lengthSeconds / 60).toFixed(0)}m)`);
                                        })
                                        .on('end', () => {
                                            console.log(`Downloaded ${title} (${(total - queue.length)}/${total} | ${(100 - (queue.length / total * 100)).toFixed(2)}%)`);
                                            // remove tmp files
                                            fs.unlinkSync(audioSrc);
                                            fs.unlinkSync(videoSrc);
                                            QueueRunner();
                                            // remove it from temp
                                            temp.forEach((itemTemp, index) => {
                                                if (itemTemp.id == item.id) {
                                                    temp.splice(index, 1);
                                                }
                                                fs.writeFileSync(tempFile, JSON.stringify(temp, null, 2));
                                            })
                                        })
                                        .on('error', (err) => {
                                            console.log(`Error downloading ${title}`);
                                            console.log(err);
                                            // return item back to queue
                                            queue.push(item);
                                            QueueRunner();
                                        })
                                }).on('error', (err) => {
                                    console.log(`Error downloading ${title}`);
                                    console.log(err);
                                    // return item back to queue
                                    queue.push(item);
                                    QueueRunner();
                                });
                        }).on('error', (err) => {
                            console.log(`Error downloading ${title}`);
                            console.log(err);
                            // return item back to queue
                            queue.push(item);
                            QueueRunner();
                        });
                }
            } else {
                console.log('All videos downloaded');
                cli();
            }
        };
        const ask = (question) => new Promise((resolve, reject) => {
            rl.question(question, (answer) => {
                resolve(answer);
            });
        });
        const cli = async () => {
            if (temp.length > 0) console.log(`Program detected ${temp.length} unfinished download${temp.length > 1 ? 's' : ''}`);
            console.log('Select a mode:')
            console.log('1. Download a video')
            console.log('2. Download a playlist')
            if (queue.length > 0) {
                console.log('3. Start queue download')
            }
            const mode = await ask('Mode: ');
            if (mode != '1' && mode != '2' && mode != '3') {
                console.log('Invalid mode');
                cli();
            }
            if (mode == '3') {
                total = queue.length;
                QueueRunner();
                return;
            }
            console.log('Select Type:')
            console.log('1. Audio')
            console.log('2. Video')
            const type = await ask('Type: ');
            if (type != '1' && type != '2') {
                console.log('Invalid type');
                cli();
            }
            console.log('Select Quality:')
            console.log('1. Highest')
            console.log('2. Lowest')
            const quality = await ask('Quality: ');
            if (quality != '1' && quality != '2') {
                console.log('Invalid quality');
                cli();
            }
            const url = await ask('URL: ');
            if (mode == '1') {
                const video = await ytdl.getInfo(url);
                console.log(`Found ${video.videoDetails.title}`);
                const jsonty = {
                    url: url,
                    type: type,
                    quality: quality,
                    filename: video.videoDetails.title.replaceAll(/[^a-zA-Z0-9 ]/g, " ").replaceAll(/ /g, ' '),
                    id: new Date().getTime() + video.videoDetails.title.replaceAll(/[^a-zA-Z0-9 ]/g, " ").replaceAll(/ /g, ' ') + quality + type + url
                }
                temp.push(jsonty);
                queue.push(jsonty);
                fs.writeFileSync(tempFile, JSON.stringify(temp, null, 2));
            } else {
                const playlist = await ytpl(url, {
                    limit: Infinity
                });
                playlist.items.forEach((item, i) => {
                    const jsonty = {
                        url: item.url,
                        type: type,
                        quality: quality,
                        filename: `0${i + 1}. ${item.title.replaceAll(/[^a-zA-Z0-9 ]/g, " ").replaceAll(/ /g, ' ')}`,
                        id: new Date().getTime() + i + `0${i + 1}. ${item.title.replaceAll(/[^a-zA-Z0-9 ]/g, " ").replaceAll(/ /g, ' ')}` + quality + type + item.url
                    }
                    temp.push(jsonty);
                    queue.push(jsonty);
                    fs.writeFileSync(tempFile, JSON.stringify(temp, null, 2));
                });
                console.log(`Loaded ${playlist.items.length} item from playlist`);
            }
            cli();
        };
        cli();
    }
})();
