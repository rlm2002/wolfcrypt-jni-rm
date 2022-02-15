/* Sha.java
 *
 * Copyright (C) 2006-2022 wolfSSL Inc.
 *
 * This file is part of wolfSSL. (formerly known as CyaSSL)
 *
 * wolfSSL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfSSL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
 */

package com.wolfssl.wolfcrypt;

import java.nio.ByteBuffer;

/**
 * Wrapper for the native WolfCrypt SHA-1 implementation
 */
public class Sha extends MessageDigest {

    /** SHA-1 hash type */
    public static final int TYPE = 1; /* hash type unique */
    /** SHA-1 digest size */
    public static final int DIGEST_SIZE = 20;

    /**
     * Malloc native JNI Sha structure
     *
     * @return native allocated pointer
     *
     * @throws OutOfMemoryError when malloc fails with memory error
     */
    protected native long mallocNativeStruct() throws OutOfMemoryError;

    /**
     * Initialize Sha object
     */
    protected native void native_init();

    /**
     * Native SHA-1 update
     *
     * @param data input data
     * @param offset offset into input data
     * @param len length of input data
     *
     * @throws WolfCryptException if native operation fails
     */
    protected native void native_update(ByteBuffer data, int offset, int len);

    /**
     * Native SHA-1 update
     *
     * @param data input data
     * @param offset offset into input data
     * @param len length of input data
     *
     * @throws WolfCryptException if native operation fails
     */
    protected native void native_update(byte[] data, int offset, int len);

    /**
     * Native SHA-1 final, calculate final digest
     *
     * @param hash output buffer to place digest
     * @param offset offset into output buffer to write digest
     *
     * @throws WolfCryptException if native operation fails
     */
    protected native void native_final(ByteBuffer hash, int offset);

    /**
     * Native SHA-1 final, calculate final digest
     *
     * @param hash output buffer to place digest
     *
     * @throws WolfCryptException if native operation fails
     */
    protected native void native_final(byte[] hash);

    /**
     * Create new SHA-1 object
     */
    public Sha() {
        init();
    }

    /**
     * Create new SHA-1 object
     *
     * @param data input data to hash
     */
    public Sha(byte[] data) {
        init();
        update(data);
    }

    /**
     * Get SHA-1 digest size
     *
     * @return SHA-1 digest size
     */
    public int digestSize() {
        return DIGEST_SIZE;
    }
}

