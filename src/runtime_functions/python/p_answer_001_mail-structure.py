# Basic function libraries
import numpy as np

# Evaluating the politeness of a provided mail text
def p_answer_001_mail_politeness (mail_text, verbose):
  
    if verbose>0:
        print("using p_answer_001_mail_politeness...", flush=True)

    import tensorflow as tf

    ###  
    # Hugging Face transformer logging status codes
    # transformers.logging.CRITICAL or transformers.logging.FATAL (int value, 50): only report the most critical errors.
    # transformers.logging.ERROR (int value, 40): only report errors.
    # transformers.logging.WARNING or transformers.logging.WARN (int value, 30): only reports error and warnings. This the default level used by the library.
    # transformers.logging.INFO (int value, 20): reports error, warnings and basic information.
    # transformers.logging.DEBUG (int value, 10): report all information.
    ###
    # tensorflow loggin status codes  
    # 0 = all messages are logged (default behavior)
    # 1 = INFO messages are not printed
    # 2 = INFO and WARNING messages are not printed
    # 3 = INFO, WARNING, and ERROR messages are not printed
    from transformers import logging
    if verbose<2:
        logging.set_verbosity(40)
        tf.get_logger().setLevel("ERROR")
    else :
        logging.set_verbosity(30)
        tf.get_logger().setLevel(0)

    # The below model import model was fine-tuned using the following checkpoint from the huggingface library
    #checkpoint = "deepset/gbert-base"
    # Since at production time Internet will not be accessible, the Tokenizer and Model are downloaded locally.

    # Getting the tokenizer for the defined model
    from transformers import AutoTokenizer
    #tokenizer = AutoTokenizer.from_pretrained(checkpoint)
    #tokenizer.save_pretrained("src/runtime_functions/python/hf_tokenizer_deepset-gbert-base")
    tokenizer = AutoTokenizer.from_pretrained("runtime_functions/python/hf_tokenizer_deepset-gbert-base")

    # Getting the encodings (as tensors for tensorflow) for the texts for training, validation, and testing
    text_encodings = dict(tokenizer(mail_text, padding=True, truncation=True, return_tensors='np'))

    # Loading the model architecture and the pretrained weights
    from transformers import TFAutoModelForSequenceClassification
    #model = TFAutoModelForSequenceClassification.from_pretrained(checkpoint)
    #model.save_pretrained("src/runtime_functions/python/hf_model_a4s_i2b.tf")
    model = TFAutoModelForSequenceClassification.from_pretrained("runtime_functions/python/hf_model_a4s_i2b.tf")

    # Calculation of the probabilities for each class
    # There is no softmax layer at the top of the models in Hugging Face, therefore
    # the probabilities have to be calculated here using the softmax function
    text_pred_prob = tf.nn.softmax(model.predict(dict(text_encodings))['logits'])

    # Extraction of the class number with the highest probability
    text_pred_class = np.argmax(text_pred_prob, axis=1)

    answer = {
        "score": text_pred_class[0],
        "category": text_pred_class[0],
        "probability": tf.get_static_value(text_pred_prob[0,text_pred_class[0]])
    }
    if verbose>0:
        print("...Result: ",answer, flush=True)
        
    return(answer)
