package config

import (
	"fmt"

	"github.com/spf13/viper"
)

type Config struct {
	App      `mapstructure:"app"`
	Server   `mapstructure:"server"`
	Database `mapstructure:"database"`
}

type App struct {
	Name    string `mapstructure:"name"`
	Version string `mapstructure:"version"`
}

type Server struct {
	Port string `mapstructure:"port"`
}

type Database struct {
	URL string `mapstructure:"url"`
}

func InitConfig(path string) (*Config, error) {
	viper.SetConfigName("app-config")
	viper.SetConfigType("toml")
	viper.AddConfigPath(path)
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		return nil, fmt.Errorf("failed to read the configuration file: %s", err)
	}

	var config Config
	if err := viper.Unmarshal(&config); err != nil {
		return nil, fmt.Errorf("failed to decode viper configuration into struct %s", err)
	}
	return &config, nil
}
