package com.rfid.rfid_flutter_android.utils;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.SoundPool;

import com.rfid.rfid_flutter_android.R;

import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * 播音辅助类：串行播放短音效；队列上限 2，超出丢弃，避免积压拖尾。
 * 首次 {@link #play(int)} 时懒加载 SoundPool 与消费线程，空闲时线程在 wait 上阻塞。
 */
public class PlaySoundHelper {
    private final Context context;

    private final Object playSoundLock = new Object();
    private SoundPool soundPool;
    private int successSoundId;
    private int failSoundId;
    private volatile boolean soundReady = false;
    private PlaySoundThread playSoundThread;

    public PlaySoundHelper(Context context) {
        this.context = context.getApplicationContext();
    }

    /**
     * 播放声音。仅入队后立即返回，不阻塞调用方。
     *
     * @param soundType 1 为成功音，其它为失败音
     */
    public void play(int soundType) {
        ensureReady();
        playSoundThread.play(soundType);
    }

    /**
     * 懒加载 SoundPool 与播音线程。
     */
    private void ensureReady() {
        if (soundReady) {
            return;
        }
        synchronized (playSoundLock) {
            if (soundReady) {
                return;
            }
            // 使用媒体音量流，播音跟随系统媒体音量
            AudioAttributes attributes = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build();
            soundPool = new SoundPool.Builder()
                    .setMaxStreams(1)
                    .setAudioAttributes(attributes)
                    .build();
            successSoundId = soundPool.load(context, R.raw.barcodebeep, 1);
            failSoundId = soundPool.load(context, R.raw.fail, 1);

            playSoundThread = new PlaySoundThread();
            playSoundThread.start();
            soundReady = true;
        }
    }

    private void playInternal(int soundType) {
        if (soundPool == null) {
            return;
        }
        // 1 播放成功音，其余播放失败音
        int soundId = soundType == 1 ? successSoundId : failSoundId;
        soundPool.play(soundId, 1f, 1f, 1, 0, 1f);
    }

    /**
     * 播音消费线程：串行播放；入队上限 2，超出直接丢弃。
     */
    private class PlaySoundThread extends Thread {
        private static final int MAX_QUEUE_SIZE = 2;
        private final ConcurrentLinkedQueue<Integer> queue = new ConcurrentLinkedQueue<>();

        PlaySoundThread() {
            setName("PlaySoundHelper");
            setDaemon(true);
        }

        @Override
        public void run() {
            while (!isInterrupted()) {
                if (queue.isEmpty()) {
                    synchronized (playSoundLock) {
                        try {
                            // 队列仍空时再 wait，避免虚假唤醒后空转
                            if (queue.isEmpty()) {
                                playSoundLock.wait();
                            }
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                            break;
                        }
                    }
                    continue;
                }

                Integer soundType = queue.poll();
                if (soundType != null) {
                    playInternal(soundType);
                    // SoundPool.play 立即返回，短暂间隔保证最短播音间隔约 40ms
                    try {
                        Thread.sleep(40);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        break;
                    }
                }
            }
        }

        public void play(int soundType) {
            // 队列已满则丢弃，防止积压导致外部停调后仍响很久
            if (queue.size() >= MAX_QUEUE_SIZE) {
                return;
            }
            queue.offer(soundType);
            synchronized (playSoundLock) {
                playSoundLock.notifyAll();
            }
        }
    }
}
