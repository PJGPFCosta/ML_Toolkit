import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import LabelEncoder



class FeatureSelector:

    def __init__(self):
        """
        Methods for Feature Selection
        """
        self=self



    @staticmethod
    def return_columns_by_type(df,list_to_not_include=[],cat_col_forced=[],max_value_for_categorical=20):


        """
        Returns the column names of the numerical and categorical columns.
        You can pass the names of the categorical columns that are like "1,2,3,4,.." and it represents levels 

        Args:
            df: Input DataFrame.
            list_to_not_include: Input if need, its a list of columns to not include in the split 
            cat_col_forced: Input list of the categorical columns.
            max_value_for_categorical: Input Number of values in the column that can be considerer categorical and not numeric
            

        Returns:
            list: List of categorical and numerical columns and text_cols. [binary_cols,categorical_cols,numerical_cols,text_cols]
        """
        # Separate categorical and numerical columns
        # Check if the values of the column are "free text" and the number of unique values is bigger than the max for categorical
        text_cols= [col for col in df.columns if df[col].dtype == 'object' and col not in cat_col_forced and df[col].nunique() > max_value_for_categorical and col not in list_to_not_include]
        binary_cols=[col for col in df.columns if col not in cat_col_forced and df[col].nunique()==2 and col not in list_to_not_include]
        numerical_cols= [col for col in df.columns if df[col].dtype in ["int64", "float64"] and col not in binary_cols and col not in cat_col_forced and df[col].nunique() > max_value_for_categorical and col not in list_to_not_include]
        categorical_cols = [col for col in df.columns if col not in numerical_cols and col not in binary_cols and col not in text_cols and col not in list_to_not_include]

        return binary_cols,categorical_cols,numerical_cols,text_cols
    
    @staticmethod
    def most_importante_features_correlation(df,target,num_features,list_to_drop, method='pearson'):
        """
        Returns the column names of the N most important variables in a DataFrame.
        By ensembling the results of correlation analysis .

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            num_features: Input Number most importante features 
            list_to_drop: List of columns names that are not necessary for ex: Ids,...
            method: Correlation method ('pearson' or 'spearman'): Person for linear and spearman for non linear

        Returns:
            list: List of the most important features and the df of this features with the corresponding importance.
        """


        df=df.drop(columns=list_to_drop)
        # Correlation
        try:
            if method == 'pearson':
                correlation = df.corr(method='pearson')
            elif method == 'spearman':
                correlation = df.corr(method='spearman')
            else:
                raise ValueError("Invalid correlation method. Use 'pearson' or 'spearman'.")
        except Exception as correlation_error:
            print(f"Error in correlation analysis: {correlation_error}")
            print("Don't forget to label encode the features before trying to extract the most important features.")
            return [], pd.DataFrame()  # Set correlation to an empty DataFrame
        
        try:
            if target in correlation.columns:
                target_correlation = correlation[target].abs().sort_values(ascending=False)
                top_features_correlation = target_correlation[1:num_features + 1].index.tolist()
                top_features_correlation_values = target_correlation[1:num_features + 1].reset_index()
                print(top_features_correlation, top_features_correlation_values)
            else:
                print(f"Error: Target column '{target}' not found in correlation analysis.")
        except Exception as target_correlation_error:
            print(f"Error in correlation analysis: {target_correlation_error}")
        return top_features_correlation,top_features_correlation_values

    @staticmethod
    def most_importante_features_treebased(df,target,num_features,list_to_drop):
        """
        Returns the column names of the N most important variables in a DataFrame.
        By ensembling the results of correlation analysis and TreeBased feature importance.

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            num_features: Input Number most importante features 
            list_to_drop: List of columns names that are not necessary for ex: Ids,...

        Returns:
            list: List of the most important features and the df of this features with the corresponding importance.
        """

        # Check if the categorical features already suffer encoding
        embeding_cat_flag=False
        for col in df.columns:
            if df[col].dtype == 'object':
                embeding_cat_flag=True


        if  embeding_cat_flag==True:
            categorical_cols,numerical_cols,text_columns=FeatureSelector.return_columns_by_type(df,[target])
            #drop variavels like Id,... and the text columns like Names, ticket names
            list_to_drop.extend(text_columns)
            
            # Assuming categorical_cols is a list of categorical column names
            label_encoder = LabelEncoder()
            df_encoded=df
            for col in categorical_cols:
                df_encoded[col] = label_encoder.fit_transform(df_encoded[col])
        else:
            df_encoded=df

        # drop list that doesnt add anything
        df_encoded=df_encoded.drop(columns=list_to_drop)

        # Fill Nan values
        df_encoded = df_encoded.fillna(df_encoded.median())

        # Assuming 'target_variable' is the column you're trying to predict
        X = df_encoded.drop(columns=[target])
        y = df_encoded[target]

        # Initialize a Random Forest Regressor
        rf = RandomForestRegressor(n_estimators=100, random_state=42)
        rf.fit(X, y)

        # Get feature importances
        feature_importances = rf.feature_importances_

        # Create a DataFrame to store feature names and their importance scores
        feature_importance_df = pd.DataFrame({'Feature': X.columns, 'Importance': feature_importances})

        # Sort by importance
        feature_importance_df = feature_importance_df.sort_values(by='Importance', ascending=False)

        # Select the top N features
        top_features_treebased = feature_importance_df.head(num_features)['Feature'].to_list()

        top_feautres_df=feature_importance_df.head(num_features)

        #print("Top Features: ", top_features_treebased)
        return top_features_treebased,top_feautres_df
    
    @staticmethod
    def most_important_features(df,target,num_features,list_to_drop,list_to_not_include,cat_col_forced,max_value_for_categorical=20,all_features=False):
        
        """
        Returns the column names of the N most important variables in a DataFrame.
        By ensembling the results of correlation analysis and TreeBased feature importance.

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            num_features: Input Number most importante features 
            list_to_drop: List of columns names that are not necessary for ex: Ids,...

        Returns:
            list: List of the most important features and the df of this features with the corresponding importance.
        """



        from scipy.stats import chi2_contingency, pointbiserialr, f_oneway
        import numpy as np
        df_aux = df.copy()

        # Encode features if needed
        label_encoder = LabelEncoder()
        binary_cols, cat_cols, num_cols, text_cols = FeatureSelector.return_columns_by_type(df_aux, list_to_not_include, cat_col_forced)
        if target in binary_cols and  df_aux[target].dtype == 'object':
            #transform target to value if target
            df_aux[target] = label_encoder.fit_transform(df_aux[target])

        #print("binary_cols: ",binary_cols)
        #print("cat_cols: ",cat_cols)
        #print("num_cols: ",num_cols)
        #print("text_cols: ",text_cols)
            
        # Correlation Analysis
        # Check if there are categorical features and the type of correlation we want to analyze
        if len(cat_cols) > 0 and all_features:
            # For each categorical column, do label encoding
            for col in cat_cols:
                df_aux[col] = label_encoder.fit_transform(df_aux[col])

            # Apply ANOVA (Analysis of Variance) for numerical features
            for col in num_cols:
                try:
                    anova_result = f_oneway(*[df_aux[df_aux[col] == value][target] for value in df_aux[col].unique()])
                    print(f'ANOVA p-value for {col}: {anova_result.pvalue}')
                    # You can further analyze the results as needed
                except Exception as anova_error:
                    print(f"Error in ANOVA for {col}: {anova_error}")

            # Apply Cramér's V for categorical features
            for col in cat_cols:
                try:
                    contingency_table = pd.crosstab(df_aux[col], df_aux[target])
                    chi2, _, _, _ = chi2_contingency(contingency_table)
                    n = contingency_table.sum().sum()
                    cramers_v = np.sqrt(chi2 / (n * (min(contingency_table.shape) - 1)))
                    print(f'Cramér\'s V for {col}: {cramers_v}')
                    # You can further analyze the results as needed
                except Exception as cramers_error:
                    print(f"Error in Cramér's V for {col}: {cramers_error}")

            # Apply Point-Biserial Correlation (for binary cols)
            if len(binary_cols)>0:
                # For each categorical column, do label encoding
                for col in binary_cols:
                    if target!=col:
                        df_aux[col] = label_encoder.fit_transform(df_aux[col])
                    else:
                        print(f"Passed target on binary because it was already encoded: {target}")
                        pass
                for col in binary_cols:
                    try:
                        point_biserial_result = pointbiserialr(df_aux[col], df_aux[target])
                        print(f'Point-Biserial Correlation for {col}: {point_biserial_result.correlation}, p-value: {point_biserial_result.pvalue}')
                        # You can further analyze the results as needed
                    except Exception as point_biserial_error:
                        print(f"Error in Point-Biserial Correlation for {col}: {point_biserial_error}")
        else:
            for col in cat_cols:
                        df_aux[col] = label_encoder.fit_transform(df_aux[col])
            
            for col in binary_cols:
                        df_aux[col] = label_encoder.fit_transform(df_aux[col])

        
        try:
            #correlation
            top_features_correlation,df_features_correlation=FeatureSelector.most_importante_features_correlation(df_aux,target,num_features,list_to_drop)
        except Exception as correlation_error:
            print(f"Error in correlation analysis: {correlation_error}")
            
            
        try:
            # tree based
            top_features_treebased,df_features_treebased=FeatureSelector.most_importante_features_treebased(df_aux,target,num_features,list_to_drop)
        except Exception as treebased_error:
            print(f"Error in TreeBased feature importance analysis: {treebased_error}")


        try:
            # Get column names from df1
            new_column_names = df_features_treebased.columns.tolist()

            # Rename columns of df2
            df_features_correlation.columns = new_column_names

            concatenated_df = pd.concat([df_features_treebased, df_features_correlation], axis=0)
            concatenated_df = concatenated_df.drop_duplicates(subset=[concatenated_df.columns[0]])

            common_values_list=concatenated_df.iloc[:, 0].to_list()


            return common_values_list,concatenated_df

        except Exception as concat_error:
            print(f"Error in concatenating DataFrames: {concat_error}")
            return [], pd.DataFrame()
    


class ModelEvaluation:

    def __init__(self):
        """
        Methods for Model Evaluation
        """
        self=self

    @staticmethod
    def evaluate_regression_model(y_test, y_pred, plot_residuals=False):
        """
        Evaluate a regression model and return common evaluation metrics.

        Parameters:
        - y_true: True labels
        - y_pred: Predicted labels
        - plot_residuals: Whether to plot residuals (default is False)

        Returns:
        - metrics_dict: Dictionary containing evaluation metrics
        """
        from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
        import matplotlib.pyplot as plt
        import numpy as np
        metrics_dict = {}

        # Mean Squared Error (MSE)
        mse = mean_squared_error(y_test, y_pred)
        metrics_dict['Mean Squared Error'] = mse

        # Mean Absolute Error (MAE)
        mae = mean_absolute_error(y_test, y_pred)
        metrics_dict['Mean Absolute Error'] = mae

        # R-squared (R2)
        r2 = r2_score(y_test, y_pred)
        metrics_dict['R-squared (R2)'] = r2

        # Mean Percentage Error (MPE)
        errors = (y_test - y_pred) / y_test
        percentage_errors = np.abs(errors) * 100
        mpe = np.mean(percentage_errors)
        metrics_dict['Mean Percentage Error (MPE)'] = mpe



        # Plot Residuals
        if plot_residuals:
            residuals = y_test - y_pred
            plt.figure(figsize=(8, 6))
            plt.scatter(y_pred, residuals, color='blue', alpha=0.6)
            plt.axhline(y=0, color='red', linestyle='--', linewidth=2)
            plt.title('Residuals Plot')
            plt.xlabel('Predicted Values')
            plt.ylabel('Residuals')
            plt.show()

        return metrics_dict
    
    @staticmethod
    def evaluate_binary_model(y_test, y_pred, plot_confusion_matrix=False):
        """
        Evaluate a binary model and return common evaluation metrics.

        Parameters:
        - y_true: True labels
        - y_pred: Predicted labels
        - plot_confusion_matrix: Whether to plot confusion Matrix
        Returns:
        - metrics_dict: Dictionary containing evaluation metrics
        """
        from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score, roc_curve, confusion_matrix
        import matplotlib.pyplot as plt
        import seaborn as sns


        metrics_dict = {}

        # F1 Score
        f1 = f1_score(y_test, y_pred)
        metrics_dict['F1 Score'] = f1
        
        # ROC-AUC
        roc_auc = roc_auc_score(y_test, y_pred)
        metrics_dict['ROC-AUC'] = roc_auc

        # Accuracy
        accuracy = accuracy_score(y_test, y_pred)
        metrics_dict['Accuracy'] = accuracy

        # Precision
        precision = precision_score(y_test, y_pred)
        metrics_dict['Precision'] = precision

        # Recall
        recall = recall_score(y_test, y_pred)
        metrics_dict['Recall'] = recall

        
        # Confusion Matrix
        if plot_confusion_matrix:
            cm = confusion_matrix(y_test, y_pred)
            sns.heatmap(cm, annot=True, fmt='g', cmap='Blues', cbar=False)
            plt.title('Confusion Matrix')
            plt.xlabel('Predicted labels')
            plt.ylabel('True labels')
            plt.show()

       
        return metrics_dict

    @staticmethod
    def evaluate_data_drift(original_dataset, new_dataset, threshold=0.05):
        """
        Evaluate a binary model and return common evaluation metrics.

        Parameters:
        - original_dataset: original dataset
        - new_dataset: new dataset to check
        - threshold: threshold to consider data drift
        Returns:
        - tuple: as_data_drift - true or false
                 statistic - the larger the more dissimilar the two distributions are
                 p_value - Null hypotesis is confirmed if below the threshold, else it is rejected and we can assume that the distribution is different
        """
        from scipy.stats import ks_2samp

        statistic, p_value = ks_2samp(original_dataset, new_dataset)

        as_data_drift=p_value < threshold # True or false

        return as_data_drift,statistic,p_value


class FeatureEngineering:

    def __init__(self):
        """
        Methods for Feature Engineering
        """
        self=self

    def pca_features():
        """
        Methods for Feature Engineering
        """
        pca_features=1
        return pca_features


class Visualization:
    def __init__(self):
            """
            Methods for ploting and visualize the data
            """
            self=self

    @staticmethod
    def plot_correlation(df,target,list_of_features):

        """
        Plots Correlation Matrix all the variables passed with the target.
        Should Be used with only the most important features.

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            list_of_features: List of features that want to be ploted agains the target column. 

        Returns:
            Nothing, it plots
        """

        import matplotlib.pyplot as plt
        import seaborn as sns
        
        # Concatenate the target column with the top features
        selected_columns = [target] + list_of_features
        selected_df = df[selected_columns]
        
        # Calculate the correlation matrix
        correlation_matrix = selected_df.corr()
    
        size=len(selected_columns)
        
        # Create a heatmap
        plt.figure(figsize=(int(size*2), int(size*1.5)))
        sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt=".2f")
        plt.title('Correlation Heatmap of Top Features')
        plt.show()

    @staticmethod
    def plot_relationship_cagorical_target_continuous(df,target,cat_cols):
        """
        Plots BoxPlot all the variables passed with the target type continuous.
        Should Be used with only the most important features and only categorical features

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            cat_cols: List of features that want to be ploted agains the target column. 

        Returns:
            Nothing, it plots
        """
        import matplotlib.pyplot as plt
        import seaborn as sns
        # Create a grid of subplots
        fig, axes = plt.subplots(nrows=1, ncols=len(cat_cols), figsize=(6*len(cat_cols), 5))

        # Iterate through the categorical columns
        for i, var in enumerate(cat_cols):
            data = pd.concat([df[target], df[var]], axis=1)
            
            # Create a box plot
            sns.boxplot(x=var, y=target, data=data, ax=axes[i])
            #axes[i].set_ylim(0, 800000)  # Set y-axis limits

        # Adjust layout
        plt.tight_layout()

        # Show the plots
        plt.show()


    @staticmethod
    def plot_relationship_numerical_target_continuous(df,target,num_cols):

        """
        Plots ScatterPlot all the variables passed with the target type continuous.
        Should Be used with only the most important features and only continuous features

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            num_cols: List of features that want to be ploted agains the target column. 

        Returns:
            Nothing, it plots
        """

        import matplotlib.pyplot as plt
        import seaborn as sns
        # Create a grid of subplots
        fig, axes = plt.subplots(nrows=1, ncols=len(num_cols), figsize=(6*len(num_cols), 5))

        # Iterate through the categorical columns
        for i, var in enumerate(num_cols):
            data = pd.concat([df[target], df[var]], axis=1)
            
            # Create a box plot
            sns.scatterplot(x=var, y=target, data=data, ax=axes[i])
            #axes[i].set_ylim(0, 800000)  # Set y-axis limits

        # Adjust layout
        plt.tight_layout()

        # Show the plots
        plt.show()


    @staticmethod
    def plot_relationship_categorical_target_binary(df, target, cat_cols):

        """
        Plots Barplot all the variables passed with the target type binary.
        Should Be used with only the most important features and only categorical features

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            cat_cols: List of features that want to be ploted agains the target column. 

        Returns:
            Nothing, it plots
        """

        import matplotlib.pyplot as plt
        import seaborn as sns

        # Create a grid of subplots
        fig, axes = plt.subplots(nrows=len(cat_cols), ncols=1, figsize=(8, 6*len(cat_cols)))

        # Iterate through the categorical columns
        for i, var in enumerate(cat_cols):
            data = pd.concat([df[target], df[var]], axis=1)

            # Calculate the count of each category for each target class
            count_data = data.groupby([var, target]).size().reset_index(name='count')

            # Create a grouped bar plot
            sns.barplot(x=var, y='count', hue=target, data=count_data, ax=axes[i])
            axes[i].set_title(f'Relationship between {var} and {target}')

        # Adjust layout
        plt.tight_layout()

        # Show the plots
        plt.show()

    @staticmethod
    def plot_relationship_numerical_target_binary(df, target, num_cols):
        
        """
        Plots BoxPlot all the variables passed with the target type binary.
        Should Be used with only the most important features and only continuous features

        Args:
            df: Input DataFrame.
            targe: Input Targe column.
            cat_cols: List of features that want to be ploted agains the target column. 

        Returns:
            Nothing, it plots
        """

        import matplotlib.pyplot as plt
        import seaborn as sns

        # Create a grid of subplots
        fig, axes = plt.subplots(nrows=1, ncols=len(num_cols), figsize=(6*len(num_cols), 5))

        # Iterate through the numerical columns
        for i, var in enumerate(num_cols):
            data = pd.concat([df[target], df[var]], axis=1)

            # Create a box plot or violin plot
            sns.boxplot(x=target, y=var, data=data, ax=axes[i])

        # Adjust layout
        plt.tight_layout()

        # Show the plots
        plt.show()

    @staticmethod
    def plot_distribution(df, num_cols, cat_cols):
        """
        Plots distplot for each column.

        Args:
            df: Input DataFrame.
            num_cols: List of numerical features to be plotted.
            cat_cols: List of categorical features to be plotted.

        Returns:
            Nothing, it plots.
        """
        import matplotlib.pyplot as plt
        import seaborn as sns
        # Set a new color palette
        sns.set_palette("viridis")
        # Plot numerical columns
        if len(num_cols) == 1:
            sns.distplot(df[num_cols[0]])
            plt.title(f'Distribution Plot for {num_cols[0]}')
            plt.show()
        else:
            n_cols = len(num_cols)
            fig, axes = plt.subplots(nrows=1, ncols=n_cols, figsize=(5 * n_cols, 5))
            fig.tight_layout(pad=3.0)

            for i, col in enumerate(num_cols):
                sns.distplot(df[col], ax=axes[i])
                axes[i].set_title(f'Distribution Plot for {col}')

            plt.show()


        # Plot categorical columns
        if len(cat_cols) == 1:
            sns.countplot(data=df, x=col)
            plt.title(f'Distribution Plot for {col}')
            plt.show()
        else:
            
            n_cols = len(cat_cols)
            fig, axes = plt.subplots(nrows=1, ncols=n_cols, figsize=(5 * n_cols, 5))
            fig.tight_layout(pad=3.0)

            for i, col in enumerate(cat_cols):
                unique_values = df[col].nunique()
                #size_factor = min(max(unique_values / 5, 1), 3)  # Adjust the size factor based on the number of unique values
                sns.countplot(data=df, x=col, ax=axes[i], palette='viridis')
                axes[i].set_title(f'Distribution Plot for {col}')
                
            plt.show()
    
class Transformations:
    def __init__(self):
            """
            Methods for transforming data to deal with Skewness and Kurtosis
            """
            self=self

    @staticmethod
    def understand_tranformation_lambda(variable_name,transformed_data, lambda_value):
        
        import numpy as np
        print(f"Transformed Data (with lambda={lambda_value}): {transformed_data}")

        if lambda_value<0:
            lambda_value=int(lambda_value)

        if lambda_value == 0:
            explanation = f"The '{variable_name}' variable was log-transformed."
        elif lambda_value == 1:
            explanation = f"No significant transformation was applied to the '{variable_name}' variable."
        elif lambda_value > 1:
            explanation = f"The '{variable_name}' variable was positively transformed with a lambda value of {lambda_value:.2f}."
        elif 0 < lambda_value < 1:
            explanation = f"The '{variable_name}' variable was negatively transformed with a lambda value of {lambda_value:.2f}."
        else:
            explanation = f"The transformation of the '{variable_name}' variable cannot be easily interpreted."

        print(explanation)

    @staticmethod
    def transform_skewness(df,var,num=True,flag_prints=False):        
        """
        Decide and deal with skewness
                
        Positive Skewness:
        - Log Transformation:
            - Works well for data with positive skewness.
            - Reduces the effect of extreme values.
            - Helps in stabilizing variance.
        - Square Root Transformation:
            - Similar to log transformation, it reduces the impact of extreme values.
            - Useful for right-skewed data.

        Negative Skewness:
        - Cube Root Transformation:
            - Works well for data with negative skewness.
            - It's a milder transformation compared to the square root.
        - Square Transformation:
            - Similar to cube root transformation, it can be used to reduce negative skewness.


        Kurtosis:
        Kurtosis measures the tailedness of a probability distribution. It tells you about the shape of the distribution's tails in relation to its peak.

        - Positive Kurtosis (Leptokurtic): The distribution has heavy tails and a high peak. It indicates more outliers than a normal distribution.
        - Negative Kurtosis (Platykurtic): The distribution has lighter tails and a lower peak. It indicates fewer outliers than a normal distribution.

        Args:
            df: Input DataFrame.
            var: Input Targe column.
            flag_prints: Input boolean to print or not

        Returns:
            which transformation is best
        """

        import numpy as np
        from scipy.stats import boxcox,yeojohnson,ks_2samp
        
        # Define a metric based on skewness and kurtosis differences
        def metric(skew, kurt,flag_prints=False,skew_standart=0.5,kurt_stabdart=3):

            skewnewss=skew_standart-abs(skew)
            kurtosis=kurt_stabdart-abs(kurt)
            # Kolmogorov-Smirnov statistic
            if flag_prints:
                print("skew: ",skew, " - skewnewss: ",skewnewss)
                print("kurt: ",kurt, " - kurtosis: ",kurtosis)

            
            return skewnewss,kurtosis

        # if values are continuous and have 0 as values
        if num:
            df[var]=df[var]+0.0001 ## remover 0
        
        #original var skewness and kurstosis
        positive_skewness=df[var].skew()
        print("Original Skew: ",positive_skewness)
        print("Original Kurtosis: ",df[var].kurt())

        if positive_skewness>0:
            print("Skewness is to the Left")

            # Log Transformation 
            transformed_data_log = np.log(df[var])
            log_skew=transformed_data_log.skew()
            log_kurt=transformed_data_log.kurt()
            # Sqrt Transformation 
            transformed_data_sqrt = np.sqrt(df[var])
            sqrt_skew=transformed_data_sqrt.skew()
            sqrt_kurt=transformed_data_sqrt.kurt()
            # Calculate metrics for each transformation
            if flag_prints:
                print("log_metric:")
                log_metric = metric(log_skew, log_kurt,flag_prints)
                print("log_metric: ",log_metric)
                print("sqrt_metric:")
                sqrt_metric = metric(sqrt_skew, sqrt_kurt,flag_prints)
                print("sqrt_metric: ",sqrt_metric)
            else:
                log_metric = metric(log_skew, log_kurt,flag_prints)
                sqrt_metric = metric(sqrt_skew, sqrt_kurt,flag_prints)
            # Choose the transformation with the smallest metric
            best_transformation = min([
                ('Log', abs(log_metric[0])+abs(log_metric[1]),transformed_data_log,log_skew, log_kurt),
                ('Sqrt', abs(sqrt_metric[0])+abs(sqrt_metric[1]),transformed_data_sqrt,sqrt_skew, sqrt_kurt)
            ], key=lambda x: x[1])
            return best_transformation
        
        else:
            print("Skewness is to the Right")
            # cube root Transformation 
            transformed_data_cube_root = np.cbrt(df[var])
            cube_root_skew=transformed_data_cube_root.skew()
            cube_root_kurt=transformed_data_cube_root.kurt()
            # Square Transformation 
            square_transformed_data = np.square(df[var])
            square_skew=square_transformed_data.skew()
            square_kurt=square_transformed_data.kurt()
            # Calculate metrics for each transformation
            if flag_prints:
                print("cube_root_metric:")
                cube_root_metric = metric(cube_root_skew, cube_root_kurt,flag_prints)
                print("cube_root_metric: ",cube_root_metric)
                print("square_metric:")
                square_metric = metric(square_skew,square_kurt,flag_prints)
                print("square_metric: ",square_metric)
            else:
                cube_root_metric = metric(cube_root_skew, cube_root_kurt,flag_prints)
                square_metric = metric(square_skew, square_kurt,flag_prints)
            # Choose the transformation with the smallest metric
            best_transformation = min([
                ('Cube_Root', abs(cube_root_metric[0])+abs(cube_root_metric[1]),transformed_data_cube_root,cube_root_skew, cube_root_kurt),
                ('Square', abs(square_metric[0])+abs(square_metric[1]),square_transformed_data,square_skew, square_kurt)
            ], key=lambda x: x[1])
            return best_transformation
    
class DataQuality:
    def __init__(self):
            """
            Methods for data quality assistances.
            
            Data quality refers to the degree to which data is accurate, complete, reliable, and relevant for the intended purpose.
            """
            self=self
    

    @staticmethod
    def modified_z_score(column_values):
        '''
        Calculates the Z-Score for the column values

        Z-score is how many Standart deviations are between the value and the mean

        If the values are <-3 or >3 they are considered anomalies.


        Args:
            column_values (pd.Series): Input Column values .
        Returns:
            df column with the z_scores 
           
        '''
        import numpy as np
        median = np.median(column_values)
        mad = np.median(np.abs(column_values - median))
        modified_z_scores = 0.6745 * (column_values - median) / mad
        return modified_z_scores



    @staticmethod
    def data_profiling(data,num_cols,cat_cols,text_cols):
        """
        Data Profiling:
        - Summary statistics, distributions, and identifying missing or anomalous values.

        Args:
            data (pd.DataFrame): Input DataFrame for profiling.
        Returns:
            profiling_results.keys: keys for searching in the dictionary
            profiling_results (dict): Dictionary containing profiling results.

        """
        # Get basic information about the DataFrame
        num_rows, num_columns = data.shape
        column_names = data.columns.tolist()

        # Get summary statistics for numeric columns
        numeric_summary = data[num_cols].describe()

        # Get z_scores for the numeric columns
        z_scores = pd.DataFrame()
        for col in num_cols:
            results_z_score=DataQuality.modified_z_score(data[col])
            z_scores[col+'_z_scores']=results_z_score

        # Get summary statistics for categorical columns
        categorical_summary = data[cat_cols].describe(include='object')

        # Get summary statistics for free text columns
        text_summary = data[text_cols].describe(include='object')

        # Identify unique values and their frequencies for categorical columns
        unique_values = {}
        for column in data[cat_cols].select_dtypes(include='object'):
            unique_values[column] = data[column].value_counts().to_dict()

        # Identify missing values
        missing_values = data.isnull().sum()

        # Identify data types of columns
        data_types = data.dtypes

        # Create a dictionary to store profiling results
        profiling_results = {
            'num_rows': num_rows,
            'num_columns': num_columns,
            'column_names': column_names,
            'numeric_summary': numeric_summary,
            'categorical_summary': categorical_summary,
            'text_summary':text_summary,
            'unique_values': unique_values,
            'missing_values': missing_values,
            'data_types': data_types,
            'z_scores':z_scores
        }

        return profiling_results.keys(),profiling_results


    
    @staticmethod
    def validate_date_range(data,cols, start_date, end_date):
        """
        Validate if the dates in datetime columns fall within a specified range.

        Args:
            data (pd.DataFrame): Input DataFrame.
            cols(list): List of columns to validate
            start_date (str): Start date of the acceptable range (format: 'YYYY-MM-DD').
            end_date (str): End date of the acceptable range (format: 'YYYY-MM-DD').

        Returns:
            invalid_dates (pd.DataFrame): DataFrame containing rows with invalid dates.
        """
        import pandas as pd

        #cast 
        for col in cols:
            try:
                data[col] = pd.to_datetime(data[col])
            except ValueError as e:
                print(f"Error: {e} occurred while converting column '{col}' to datetime.")
                pass  # If casting to datetime fails, it will raise a ValueError


        invalid_dates = pd.DataFrame()
        valid_dates = pd.DataFrame()
        # Iterate through datetime columns
        for column in cols:
            valid_date_range = (pd.to_datetime(start_date), pd.to_datetime(end_date))
            invalid_dates = pd.concat([invalid_dates, data[(data[column] < valid_date_range[0]) | (data[column] > valid_date_range[1])]])
            valid_dates=pd.concat([valid_dates, data[(data[column] > valid_date_range[0]) & (data[column] < valid_date_range[1])]])
        return invalid_dates,valid_dates