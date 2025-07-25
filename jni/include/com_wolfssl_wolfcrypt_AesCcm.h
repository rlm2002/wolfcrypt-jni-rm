/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class com_wolfssl_wolfcrypt_AesCcm */

#ifndef _Included_com_wolfssl_wolfcrypt_AesCcm
#define _Included_com_wolfssl_wolfcrypt_AesCcm
#ifdef __cplusplus
extern "C" {
#endif
#undef com_wolfssl_wolfcrypt_AesCcm_NULL
#define com_wolfssl_wolfcrypt_AesCcm_NULL 0LL
/*
 * Class:     com_wolfssl_wolfcrypt_AesCcm
 * Method:    mallocNativeStruct_internal
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_com_wolfssl_wolfcrypt_AesCcm_mallocNativeStruct_1internal
  (JNIEnv *, jobject);

/*
 * Class:     com_wolfssl_wolfcrypt_AesCcm
 * Method:    wc_AesInit
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_wolfssl_wolfcrypt_AesCcm_wc_1AesInit
  (JNIEnv *, jobject);

/*
 * Class:     com_wolfssl_wolfcrypt_AesCcm
 * Method:    wc_AesFree
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_wolfssl_wolfcrypt_AesCcm_wc_1AesFree
  (JNIEnv *, jobject);

/*
 * Class:     com_wolfssl_wolfcrypt_AesCcm
 * Method:    wc_AesCcmSetKey
 * Signature: ([B)V
 */
JNIEXPORT void JNICALL Java_com_wolfssl_wolfcrypt_AesCcm_wc_1AesCcmSetKey
  (JNIEnv *, jobject, jbyteArray);

/*
 * Class:     com_wolfssl_wolfcrypt_AesCcm
 * Method:    wc_AesCcmEncrypt
 * Signature: ([B[B[B[B)[B
 */
JNIEXPORT jbyteArray JNICALL Java_com_wolfssl_wolfcrypt_AesCcm_wc_1AesCcmEncrypt
  (JNIEnv *, jobject, jbyteArray, jbyteArray, jbyteArray, jbyteArray);

/*
 * Class:     com_wolfssl_wolfcrypt_AesCcm
 * Method:    wc_AesCcmDecrypt
 * Signature: ([B[B[B[B)[B
 */
JNIEXPORT jbyteArray JNICALL Java_com_wolfssl_wolfcrypt_AesCcm_wc_1AesCcmDecrypt
  (JNIEnv *, jobject, jbyteArray, jbyteArray, jbyteArray, jbyteArray);

#ifdef __cplusplus
}
#endif
#endif
