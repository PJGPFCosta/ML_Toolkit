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
    def return_categorical_numerical_columns(df,list_to_not_include=[],cat_col_forced=[],max_value_for_categorical=20):


        """
        Returns the column names of the numerical and categorical columns.
        You can pass the names of the categorical columns that are like "1,2,3,4,.." and it represents levels 

        Args:
            df: Input DataFrame.
            list_to_not_include: Input if need, its a list of columns to not include in the split 
            cat_col_forced: Input list of the categorical columns.
            max_value_for_categorical: Input Number of values in the column that can be considerer categorical and not numeric
            

        Returns:
            list: List of categorical and numerical columns and text_cols. [categorical_cols,numerical_cols,text_cols]
        """
        # Separate categorical and numerical columns
        # Check if the values of the column are "free text" and the number of unique values is bigger than the max for categorical
        text_cols= [col for col in df.columns if df[col].dtype == 'object' and col not in cat_col_forced and df[col].nunique() > max_value_for_categorical and col not in list_to_not_include]
        numerical_cols= [col for col in df.columns if df[col].dtype in ["int64", "float64"] and col not in cat_col_forced and df[col].nunique() > max_value_for_categorical and col not in list_to_not_include]
        categorical_cols = [col for col in df.columns if col not in numerical_cols and col not in text_cols and col not in list_to_not_include]

        return categorical_cols,numerical_cols,text_cols
    
    @staticmethod
    def most_importante_features_correlation(df,target,num_features,list_to_drop):
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

        df=df.drop(columns=list_to_drop)
        #correlation
        correlation = df.corr()
        target_correlation = correlation[target].abs().sort_values(ascending=False)
        top_features_correlation = target_correlation[1:num_features+1].index.tolist()  # Drop target and get the N variables with higher corr
        top_features_correlation_values = target_correlation[1:num_features+1].reset_index() # get all values order
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
        categorical_cols,numerical_cols,text_columns=FeatureSelector.return_categorical_numerical_columns(df,[target])

        #drop variavels like Id,... and the text columns like Names, ticket names
        list_to_drop.extend(text_columns)
        df=df.drop(columns=list_to_drop)

        # Assuming categorical_cols is a list of categorical column names
        label_encoder = LabelEncoder()
        df_encoded=df
        for col in categorical_cols:
            df_encoded[col] = label_encoder.fit_transform(df_encoded[col])
       
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

        return top_features_treebased,top_feautres_df
    
    @staticmethod
    def most_important_features(df,target,num_features,list_to_drop):
        
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
        

        #correlation
        top_features_correlation,df_features_correlation=FeatureSelector.most_importante_features_correlation(df,target,num_features,list_to_drop)
        # tree based
        top_features_treebased,df_features_treebased=FeatureSelector.most_importante_features_treebased(df,target,num_features,list_to_drop)


        # Get column names from df1
        new_column_names = df_features_treebased.columns.tolist()

        # Rename columns of df2
        df_features_correlation.columns = new_column_names

        concatenated_df = pd.concat([df_features_treebased, df_features_correlation], axis=0)
        concatenated_df = concatenated_df.drop_duplicates(subset=[concatenated_df.columns[0]])

        common_values_list=concatenated_df.iloc[:, 0].to_list()


        return common_values_list,concatenated_df

class Visualization:
    def __init__(self):
            """
            Methods for ploting and visualize the data
            """
            self=self


    def plot_distribution(df,list_of_features=[]):
        pass


